package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.models.ContenidoLeccion;
import com.epn.redsaberesweb.models.ImagenLeccion;
import com.epn.redsaberesweb.models.Leccion;
import com.epn.redsaberesweb.repository.ContenidoLeccionRepository;
import com.epn.redsaberesweb.repository.LeccionRepository;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ContenidoLeccionService {

    private static final Logger logger = Logger.getLogger(ContenidoLeccionService.class.getName());

    // ── Constantes de negocio ──────────────────────────────────────────────────
    public static final int    MAX_CARACTERES_TEXTO   = 5_000;
    public static final int    MAX_IMAGENES           = 5;
    static final long   MAX_TAMANIO_IMAGEN     = 5_242_880L; // 5 MB
    private static final List<String> TIPOS_MIME_PERMITIDOS = List.of(
            "image/jpeg", "image/png", "image/gif"
    );

    private final ContenidoLeccionRepository contenidoRepo;
    private final LeccionRepository          leccionRepo;
    private final AlmacenamientoService      almacenamiento;

    public ContenidoLeccionService(ContenidoLeccionRepository contenidoRepo,
                                   LeccionRepository leccionRepo,
                                   AlmacenamientoService almacenamiento) {
        this.contenidoRepo = contenidoRepo;
        this.leccionRepo = leccionRepo;
        this.almacenamiento = almacenamiento;
    }

    // Constructor de conveniencia para producción
    public ContenidoLeccionService(ContenidoLeccionRepository contenidoRepo, LeccionRepository leccionRepo) {
        this(contenidoRepo, leccionRepo, new AlmacenamientoService());
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // CONSULTA
    // ═══════════════════════════════════════════════════════════════════════════

    /**
     * Recupera el contenido textual y la lista de imágenes de una lección.
     * Si la lección no tiene contenido aún, devuelve null para el texto
     * y lista vacía para imágenes — nunca lanza excepción.
     */
    public ContenidoDTO obtenerContenido(Long leccionId) {
        if (leccionId == null) throw new IllegalArgumentException("El ID de lección es obligatorio.");

        Optional<ContenidoLeccion> contenido = contenidoRepo.obtenerPorLeccion(leccionId);
        List<ImagenLeccion>        imagenes  = contenidoRepo.listarImagenes(leccionId);

        return new ContenidoDTO(contenido.orElse(null), imagenes);
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // GUARDAR — texto + imágenes en una sola operación
    // ═══════════════════════════════════════════════════════════════════════════

    /**
     * Guarda el texto y/o imágenes de una lección.
     *
     * Reglas de negocio:
     *  - El texto no puede superar {@value #MAX_CARACTERES_TEXTO} caracteres.
     *  - El número total de imágenes (existentes + nuevas) no puede superar {@value #MAX_IMAGENES}.
     *  - Cada imagen debe ser JPG/PNG/GIF y pesar menos de 5 MB.
     *  - La lección debe tener al menos texto o al menos una imagen tras guardar.
     *  - Si el guardado es exitoso actualiza tiene_contenido = true en la tabla lecciones.
     *
     * @param leccionId ID de la lección.
     * @param texto     Texto a guardar (puede ser null o vacío si hay imágenes).
     * @param partes    Parts de archivo recibidos desde el multipart request.
     * @throws IllegalArgumentException Si alguna validación de negocio falla.
     * @throws IOException              Si falla el almacenamiento físico de archivos.
     */
    public void guardarContenido(Long leccionId, String texto, Collection<Part> partes)
            throws IOException {

        validarLeccionId(leccionId);

        // 1. Filtrar Parts que realmente tienen archivo (el input puede venir vacío)
        List<Part> archivos = filtrarPartesConArchivo(partes);

        // 2. Validar texto
        String textoNormalizado = normalizar(texto);
        if (textoNormalizado.length() > MAX_CARACTERES_TEXTO) {
            throw new IllegalArgumentException(
                    "El texto no puede superar " + MAX_CARACTERES_TEXTO + " caracteres. " +
                            "Actualmente tiene " + textoNormalizado.length() + ".");
        }

        // 3. Validar cantidad total de imágenes
        int imagenesExistentes = contenidoRepo.contarImagenes(leccionId);
        int imagenesNuevas     = archivos.size();
        if (imagenesExistentes + imagenesNuevas > MAX_IMAGENES) {
            throw new IllegalArgumentException(
                    "La lección ya tiene " + imagenesExistentes + " imagen(es). " +
                            "No se pueden agregar " + imagenesNuevas + " más (límite: " + MAX_IMAGENES + ").");
        }

        // 4. Validar cada imagen antes de guardar cualquiera
        for (Part parte : archivos) {
            validarImagen(parte);
        }

        // 5. Verificar que al menos habrá texto o imagen después de guardar
        boolean tendraTexto    = !textoNormalizado.isEmpty();
        boolean tendraImagenes = imagenesExistentes + imagenesNuevas > 0;
        if (!tendraTexto && !tendraImagenes) {
            throw new IllegalArgumentException(
                    "Debes proporcionar al menos un texto o una imagen para guardar el contenido.");
        }

        // 6. Guardar archivos en disco (rollback manual si BD falla)
        List<String> rutasGuardadas = new ArrayList<>();
        try {
            for (Part parte : archivos) {
                String ruta = almacenamiento.guardarArchivo(parte, leccionId);
                rutasGuardadas.add(ruta);
            }

            // 7. Persistir texto (upsert)
            if (tendraTexto) {
                contenidoRepo.guardarTexto(leccionId, textoNormalizado);
            }

            // 8. Persistir cada imagen en BD
            int siguienteOrden = contenidoRepo.obtenerSiguienteOrden(leccionId);
            for (int i = 0; i < archivos.size(); i++) {
                Part   parte  = archivos.get(i);
                String ruta   = rutasGuardadas.get(i);

                Leccion leccion = new Leccion();
                leccion.setId(leccionId);

                ImagenLeccion imagen = new ImagenLeccion();
                imagen.setLeccion(leccion);
                imagen.setNombreArchivo(parte.getSubmittedFileName());
                imagen.setRuta(ruta);
                imagen.setTamanioBytes(parte.getSize());
                imagen.setOrden(siguienteOrden++);

                contenidoRepo.guardarImagen(imagen);
            }

            // 9. Actualizar flag tiene_contenido = true
            leccionRepo.actualizarEstadoContenido(leccionId, true);
            logger.info("Contenido guardado exitosamente para lección ID: " + leccionId);

        } catch (Exception e) {
            // Rollback físico: eliminar archivos subidos si la BD falló
            logger.log(Level.SEVERE, "Error al persistir contenido. Eliminando archivos subidos.", e);
            almacenamiento.eliminarArchivosDeRollback(rutasGuardadas);
            if (e instanceof IOException)    throw (IOException) e;
            if (e instanceof RuntimeException) throw (RuntimeException) e;
            throw new RuntimeException("Error inesperado al guardar el contenido.", e);
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // ELIMINAR IMAGEN
    // ═══════════════════════════════════════════════════════════════════════════

    /**
     * Elimina una imagen: primero elimina el registro en BD y luego el archivo físico.
     * Si tras eliminar no quedan imágenes y el texto está vacío, actualiza
     * tiene_contenido = false en la tabla lecciones.
     *
     * @param imagenId  ID de la imagen a eliminar.
     * @param leccionId ID de la lección a la que pertenece (para validar ownership).
     */
    public void eliminarImagen(Long imagenId, Long leccionId) {
        validarLeccionId(leccionId);
        if (imagenId == null) throw new IllegalArgumentException("El ID de imagen es obligatorio.");

        // 1. Eliminar de BD y obtener ruta física
        String rutaFisica = contenidoRepo.eliminarImagen(imagenId);

        // 2. Eliminar archivo físico (no lanza excepción si ya no existe)
        almacenamiento.eliminarArchivo(rutaFisica);

        // 3. Verificar si la lección sigue teniendo contenido
        int imagenesRestantes = contenidoRepo.contarImagenes(leccionId);
        Optional<ContenidoLeccion> contenido = contenidoRepo.obtenerPorLeccion(leccionId);
        boolean tieneTexto     = contenido.map(ContenidoLeccion::isTieneTexto).orElse(false);
        boolean tieneContenido = tieneTexto || imagenesRestantes > 0;

        // 4. Actualizar flag solo si el estado cambia a false
        if (!tieneContenido) {
            leccionRepo.actualizarEstadoContenido(leccionId, false);
            logger.info("Lección ID " + leccionId + " marcada como sin contenido.");
        }

        logger.info("Imagen ID " + imagenId + " eliminada de lección ID " + leccionId);
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // VALIDACIONES
    // ═══════════════════════════════════════════════════════════════════════════

    /**
     * Valida un archivo de imagen antes de procesarlo.
     * Verifica tipo MIME (JPG/PNG/GIF) y tamaño máximo (5 MB).
     *
     * @throws IllegalArgumentException Si el archivo no cumple las restricciones.
     */
    public void validarImagen(Part parte) {
        if (parte == null) throw new IllegalArgumentException("El archivo no puede ser nulo.");

        String nombre = parte.getSubmittedFileName();
        if (nombre == null || nombre.isBlank()) {
            throw new IllegalArgumentException("El archivo debe tener un nombre.");
        }

        // Validar tipo MIME
        String contentType = parte.getContentType();
        if (contentType == null || !TIPOS_MIME_PERMITIDOS.contains(contentType.toLowerCase())) {
            throw new IllegalArgumentException(
                    "Formato de imagen no permitido: '" + contentType + "'. " +
                            "Solo se aceptan JPG, PNG y GIF.");
        }

        // Validar tamaño
        if (parte.getSize() > MAX_TAMANIO_IMAGEN) {
            throw new IllegalArgumentException(
                    "El archivo '" + nombre + "' supera el tamaño máximo de 5 MB " +
                            "(tamaño actual: " + String.format("%.1f", parte.getSize() / 1_048_576.0) + " MB).");
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // DTO interno
    // ═══════════════════════════════════════════════════════════════════════════

    public static class ContenidoDTO {
        private final ContenidoLeccion    contenido;
        private final List<ImagenLeccion> imagenes;

        public ContenidoDTO(ContenidoLeccion contenido, List<ImagenLeccion> imagenes) {
            this.contenido = contenido;
            this.imagenes  = imagenes != null ? imagenes : List.of();
        }

        public ContenidoLeccion    getContenido() { return contenido; }
        public List<ImagenLeccion> getImagenes()  { return imagenes; }
        public boolean             isTieneContenido() {
            return (contenido != null && contenido.isTieneTexto()) || !imagenes.isEmpty();
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // Privados
    // ═══════════════════════════════════════════════════════════════════════════

    private void validarLeccionId(Long leccionId) {
        if (leccionId == null) throw new IllegalArgumentException("El ID de lección es obligatorio.");
    }

    private String normalizar(String texto) {
        return texto != null ? texto.trim() : "";
    }

    private List<Part> filtrarPartesConArchivo(Collection<Part> partes) {
        if (partes == null) return List.of();
        return partes.stream()
                .filter(p -> p.getSubmittedFileName() != null
                        && !p.getSubmittedFileName().isBlank()
                        && p.getSize() > 0)
                .toList();
    }
}