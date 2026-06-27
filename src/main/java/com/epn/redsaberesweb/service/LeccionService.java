package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.models.Leccion;
import com.epn.redsaberesweb.models.Modulo;
import com.epn.redsaberesweb.repository.LeccionRepository;
import com.epn.redsaberesweb.repository.ModuloRepository;

import java.util.List;
import java.util.Locale;

public class LeccionService {
    private final LeccionRepository leccionRepository;
    private final ModuloRepository moduloRepository;

    public LeccionService(LeccionRepository leccionRepository, ModuloRepository moduloRepository) {
        this.leccionRepository = leccionRepository;
        this.moduloRepository = moduloRepository;
    }

    /**
     * Crea una nueva lección con validaciones.
     * Método simplificado que valida longitud (3-100) y establece tiene_contenido = false.
     */
    public void crear(int moduloId, String titulo) {
        String tituloNormalizado = validarYNormalizarTitulo(titulo);
        Modulo modulo = obtenerModulo((long) moduloId);

        Leccion nuevaLeccion = new Leccion();
        nuevaLeccion.setModulo(modulo);
        nuevaLeccion.setTitulo(tituloNormalizado);
        nuevaLeccion.setTieneContenido(false);
        nuevaLeccion.setOrden(1);

        leccionRepository.save(nuevaLeccion);
    }

    /**
     * Crea una nueva lección con validaciones.
     */
    public void crearLeccion(Leccion nuevaLeccion) {
        validarDatosLeccion(nuevaLeccion);
        leccionRepository.save(nuevaLeccion);
    }

    /**
     * Lista todas las lecciones de un módulo ordenadas por 'orden'.
     * Método simplificado con int como parámetro.
     */
    public List<Leccion> listar(int moduloId) {
        return listarLeccionesPorModulo((long) moduloId);
    }

    /**
     * Lista todas las lecciones de un módulo ordenadas por 'orden'.
     */
    public List<Leccion> listarLeccionesPorModulo(Long moduloId) {
        if (moduloId == null) {
            throw new IllegalArgumentException("El ID del módulo es obligatorio para listar lecciones.");
        }
        if (moduloRepository.findById(moduloId).isEmpty()) {
            throw new IllegalArgumentException("El módulo especificado no existe.");
        }
        return leccionRepository.listarPorModulo(moduloId);
    }

    /**
     * Obtiene una lección por su ID.
     */
    public Leccion obtenerLeccion(Long leccionId) {
        if (leccionId == null) {
            throw new IllegalArgumentException("El ID de la lección es obligatorio.");
        }
        return leccionRepository.findById(leccionId)
                .orElseThrow(() -> new IllegalArgumentException("La lección con ID " + leccionId + " no existe."));
    }

    public Modulo obtenerModulo(Long moduloId) {
        if (moduloId == null) {
            throw new IllegalArgumentException("El ID del módulo es obligatorio.");
        }
        return moduloRepository.findById(moduloId)
                .orElseThrow(() -> new IllegalArgumentException("El módulo especificado no existe."));
    }

    /**
     * Edita una lección existente con validaciones.
     * Método simplificado.
     */
    public void editar(int leccionId, String titulo) {
        String tituloNormalizado = validarYNormalizarTitulo(titulo);

        Leccion leccion = obtenerLeccion((long) leccionId);
        leccion.setTitulo(tituloNormalizado);
        leccionRepository.update(leccion);
    }

    /**
     * Edita una lección existente con validaciones.
     */
    public void editarLeccion(Leccion leccionActualizada) {
        if (leccionActualizada == null || leccionActualizada.getId() == null) {
            throw new IllegalArgumentException("La lección a editar es obligatoria.");
        }
        if (leccionRepository.findById(leccionActualizada.getId()).isEmpty()) {
            throw new IllegalArgumentException("La lección a editar no existe.");
        }
        validarDatosLeccion(leccionActualizada);
        leccionRepository.update(leccionActualizada);
    }

    /**
     * Elimina una lección por su ID.
     * Elimina en cascada el contenido asociado antes de eliminar la lección.
     * Método simplificado.
     */
    public void eliminar(int leccionId) {
        eliminarLeccion((long) leccionId);
    }

    /**
     * Elimina una lección por su ID.
     */
    public void eliminarLeccion(Long leccionId) {
        if (leccionId == null) {
            throw new IllegalArgumentException("El ID de la lección a eliminar es obligatorio.");
        }
        if (leccionRepository.findById(leccionId).isEmpty()) {
            throw new IllegalArgumentException("La lección a eliminar no existe.");
        }
        leccionRepository.delete(leccionId);
    }

    /**
     * Reordena una lección dentro de su módulo
     */
    public void reordenar(int leccionId, String direccion) {
        if (direccion == null || (!"arriba".equalsIgnoreCase(direccion) && !"abajo".equalsIgnoreCase(direccion))) {
            throw new IllegalArgumentException("La dirección debe ser 'arriba' o 'abajo'.");
        }

        reordenarLeccion((long) leccionId, "arriba".equalsIgnoreCase(direccion) ? "SUBIR" : "BAJAR");
    }

    /**
     * Reordena una lección dentro de su módulo.
     */
    public void reordenarLeccion(Long leccionId, int nuevoOrden) {
        if (leccionId == null) {
            throw new IllegalArgumentException("El ID de la lección es obligatorio para reordenar.");
        }
        if (nuevoOrden <= 0) {
            throw new IllegalArgumentException("El nuevo orden debe ser un número positivo.");
        }

        Leccion leccionActual = obtenerLeccion(leccionId);
        List<Leccion> leccionesDelModulo = obtenerLeccionesOrdenadasDelModulo(leccionActual.getModulo().getId());
        int indiceActual = obtenerIndiceLeccion(leccionesDelModulo, leccionId);
        int indiceDestino = nuevoOrden - 1;

        if (indiceDestino < 0) {
            throw new IllegalStateException("No se puede mover la lección por encima de la primera posición.");
        }
        if (indiceDestino >= leccionesDelModulo.size()) {
            throw new IllegalStateException("No se puede mover la lección por debajo de la última posición.");
        }
        if (indiceActual == indiceDestino) {
            return;
        }

        Leccion leccionVecina = leccionesDelModulo.get(indiceDestino);
        leccionRepository.intercambiarOrdenes(leccionActual.getId(), leccionVecina.getId());
    }

    /**
     * Reordena una lección hacia arriba o hacia abajo usando el patrón de swap.
     */
    public void reordenarLeccion(Long leccionId, String direccion) {
        if (leccionId == null) {
            throw new IllegalArgumentException("El ID de la lección es obligatorio para reordenar.");
        }
        if (direccion == null) {
            throw new IllegalArgumentException("La dirección de reordenamiento es obligatoria.");
        }

        String direccionNormalizada = direccion.trim().toUpperCase(Locale.ROOT);
        if (!"SUBIR".equals(direccionNormalizada) && !"BAJAR".equals(direccionNormalizada)) {
            throw new IllegalArgumentException("La dirección debe ser 'SUBIR' o 'BAJAR'.");
        }

        Leccion leccionActual = obtenerLeccion(leccionId);
        List<Leccion> leccionesDelModulo = obtenerLeccionesOrdenadasDelModulo(leccionActual.getModulo().getId());
        int indiceActual = obtenerIndiceLeccion(leccionesDelModulo, leccionId);

        if ("SUBIR".equals(direccionNormalizada)) {
            if (indiceActual <= 0) {
                throw new IllegalStateException("No se puede subir la primera lección.");
            }
            Leccion leccionVecina = leccionesDelModulo.get(indiceActual - 1);
            leccionRepository.intercambiarOrdenes(leccionActual.getId(), leccionVecina.getId());
            return;
        }

        if (indiceActual >= leccionesDelModulo.size() - 1) {
            throw new IllegalStateException("No se puede bajar la última lección.");
        }
        Leccion leccionVecina = leccionesDelModulo.get(indiceActual + 1);
        leccionRepository.intercambiarOrdenes(leccionActual.getId(), leccionVecina.getId());
    }

    /**
     * Actualiza el estado de contenido de una lección.
     */
    public void actualizarEstadoContenido(Long leccionId, boolean tieneContenido) {
        if (leccionId == null) {
            throw new IllegalArgumentException("El ID de la lección es obligatorio.");
        }
        if (leccionRepository.findById(leccionId).isEmpty()) {
            throw new IllegalArgumentException("La lección especificada no existe.");
        }
        leccionRepository.actualizarEstadoContenido(leccionId, tieneContenido);
    }

    /**
     * Valida los datos básicos de una lección.
     */
    private void validarDatosLeccion(Leccion leccion) {
        if (leccion == null) {
            throw new IllegalArgumentException("La lección es obligatoria.");
        }
        if (leccion.getModulo() == null || leccion.getModulo().getId() == null) {
            throw new IllegalArgumentException("El módulo asociado a la lección es obligatorio.");
        }
        if (moduloRepository.findById(leccion.getModulo().getId()).isEmpty()) {
            throw new IllegalArgumentException("El módulo asociado a la lección no existe.");
        }
        leccion.setTitulo(validarYNormalizarTitulo(leccion.getTitulo()));
        if (leccion.getOrden() <= 0) {
            throw new IllegalArgumentException("El orden de la lección debe ser un número positivo.");
        }
    }

    private String validarYNormalizarTitulo(String titulo) {
        if (titulo == null) {
            throw new IllegalArgumentException("El título de la lección no puede ser nulo.");
        }
        String tituloNormalizado = titulo.trim();
        if (tituloNormalizado.isEmpty()) {
            throw new IllegalArgumentException("El título de la lección no puede estar vacío.");
        }
        if (tituloNormalizado.length() < 3 || tituloNormalizado.length() > 100) {
            throw new IllegalArgumentException("El título de la lección debe tener entre 3 y 100 caracteres.");
        }
        return tituloNormalizado;
    }

    private List<Leccion> obtenerLeccionesOrdenadasDelModulo(Long moduloId) {
        List<Leccion> lecciones = leccionRepository.listarPorModulo(moduloId);
        if (lecciones == null || lecciones.isEmpty()) {
            throw new IllegalStateException("No existen lecciones para reordenar en este módulo.");
        }
        return lecciones;
    }

    private int obtenerIndiceLeccion(List<Leccion> lecciones, Long leccionId) {
        for (int i = 0; i < lecciones.size(); i++) {
            if (lecciones.get(i).getId() != null && lecciones.get(i).getId().equals(leccionId)) {
                return i;
            }
        }
        throw new IllegalStateException("La lección no pertenece al listado ordenado del módulo.");
    }
}
