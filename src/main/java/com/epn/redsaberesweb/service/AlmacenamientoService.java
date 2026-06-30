package com.epn.redsaberesweb.service;

import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Gestiona el almacenamiento físico de archivos usando java.nio.file.
 *
 * Directorio base configurable mediante la propiedad de sistema:
 *   -Dredsaberes.uploads.dir=/ruta/absoluta/uploads
 *
 * Si la propiedad no está definida, usa el directorio por defecto.
 * Documentar en README la variable de entorno para Azure App Service.
 */
public class AlmacenamientoService {

    private static final Logger logger = Logger.getLogger(AlmacenamientoService.class.getName());

    /** Propiedad de sistema para configurar el directorio de uploads. */
    private static final String PROP_UPLOADS_DIR = "redsaberes.uploads.dir";

    /** Subdirectorio relativo dentro del directorio de uploads para imágenes de lecciones. */
    private static final String SUBDIR_IMAGENES = "imagenes-lecciones";

    /** Ruta base de almacenamiento — resolverse una vez al inicio. */
    private final Path directorioBase;

    public AlmacenamientoService() {
        String baseDir = System.getProperty(PROP_UPLOADS_DIR);
        if (baseDir == null || baseDir.isBlank()) {
            // Fallback: directorio del usuario que ejecuta el proceso (Tomcat)
            baseDir = System.getProperty("user.home") + "/redsaberes-uploads";
            logger.warning("Propiedad '" + PROP_UPLOADS_DIR + "' no configurada. " +
                    "Usando directorio por defecto: " + baseDir);
        }
        this.directorioBase = Paths.get(baseDir, SUBDIR_IMAGENES);
        logger.info("Directorio de imágenes: " + directorioBase.toAbsolutePath());
    }

    // ─── API pública ──────────────────────────────────────────────────────────

    /**
     * Guarda el archivo recibido en el Part y retorna la ruta relativa
     * a almacenar en la base de datos.
     *
     * Estructura del directorio:
     *   {directorioBase}/imagenes-lecciones/{leccionId}/{uuid}.{ext}
     *
     * @param part      Part del multipart request que contiene el archivo.
     * @param leccionId ID de la lección (para aislar archivos por lección).
     * @return Ruta relativa al directorio base — guardar en imagen_leccion.ruta
     * @throws IOException Si no se puede crear el directorio o escribir el archivo.
     */
    public String guardarArchivo(Part part, Long leccionId) throws IOException {
        String extension    = extraerExtension(part.getSubmittedFileName());
        String nombreUnico  = UUID.randomUUID().toString() + "." + extension;

        // Crear subdirectorio por lección si no existe
        Path dirLeccion = directorioBase.resolve(String.valueOf(leccionId));
        Files.createDirectories(dirLeccion);

        Path destino = dirLeccion.resolve(nombreUnico);

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, destino, StandardCopyOption.REPLACE_EXISTING);
        }

        // Ruta relativa para la BD: "imagenes-lecciones/{leccionId}/{uuid}.ext"
        String rutaRelativa = SUBDIR_IMAGENES + "/" + leccionId + "/" + nombreUnico;
        logger.info("Archivo guardado: " + destino.toAbsolutePath() + " → BD: " + rutaRelativa);
        return rutaRelativa;
    }

    /**
     * Elimina un archivo físico dado su ruta relativa almacenada en la BD.
     * Si el archivo no existe, no lanza excepción (idempotente).
     *
     * @param rutaRelativa Ruta relativa almacenada en imagen_leccion.ruta
     */
    public void eliminarArchivo(String rutaRelativa) {
        if (rutaRelativa == null || rutaRelativa.isBlank()) return;
        try {
            Path archivo = directorioBase.getParent().resolve(rutaRelativa);
            boolean eliminado = Files.deleteIfExists(archivo);
            if (eliminado) {
                logger.info("Archivo físico eliminado: " + archivo.toAbsolutePath());
            } else {
                logger.warning("Archivo físico no encontrado (ya eliminado?): " + archivo.toAbsolutePath());
            }
        } catch (IOException e) {
            // Error no crítico: el registro de BD ya fue eliminado; loguear y continuar.
            logger.log(Level.WARNING, "No se pudo eliminar el archivo físico: " + rutaRelativa, e);
        }
    }

    /**
     * Elimina todos los archivos físicos de una lección.
     * Usado como rollback cuando la transacción de BD falla.
     *
     * @param rutasGuardadas Rutas relativas de archivos ya guardados en disco.
     */
    public void eliminarArchivosDeRollback(Iterable<String> rutasGuardadas) {
        for (String ruta : rutasGuardadas) {
            eliminarArchivo(ruta);
        }
    }

    // ─── Privados ─────────────────────────────────────────────────────────────

    private String extraerExtension(String nombreArchivo) {
        if (nombreArchivo == null || !nombreArchivo.contains(".")) return "bin";
        return nombreArchivo.substring(nombreArchivo.lastIndexOf('.') + 1).toLowerCase();
    }
}