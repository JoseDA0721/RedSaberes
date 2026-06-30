package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.domain.EstadoCurso;
import com.epn.redsaberesweb.dto.*;
import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.repository.CursoRepository;


import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class CursoService {
    private final CursoRepository cursoRepository;

    public CursoService(CursoRepository cursoRepository) {
        this.cursoRepository = cursoRepository;
    }

    public Curso crearCurso(Curso curso) {
        // Validaciones
        if (curso.getTitulo() == null || curso.getTitulo().trim().isEmpty()) {
            throw new IllegalArgumentException("El título del curso es obligatorio.");
        }
        // Validación: Longitud mínima del título
        if (curso.getTitulo().trim().length() < 5) {
            throw new IllegalArgumentException("El título del curso debe tener al menos 5 caracteres.");
        }
        if (curso.getDescripcion() == null || curso.getDescripcion().trim().isEmpty()) {
            throw new IllegalArgumentException("La descripción del curso es obligatoria.");
        }
        if (curso.getCategoria() == null || curso.getCategoria().trim().isEmpty()) {
            throw new IllegalArgumentException("La categoría del curso es obligatoria.");
        }
        // Asumiendo que el creador no puede ser nulo por la relación JPA
        if (curso.getCreador() == null || curso.getCreador().getId() == null) {
            throw new IllegalArgumentException("El creador del curso es obligatorio.");
        }

        cursoRepository.save(curso);

        return curso;
    }

    public Optional<Curso> obtenerCurso(Long id) {
        return cursoRepository.findById(id);
    }

    // En CursoService
    public Optional<CourseDetailDTO> obtenerDetallesCurso(Long id) {
        return cursoRepository.findDetailById(id); // ← delega directo al repo
    }

    public List<Curso> listarCursosPorCreador(Long creadorId) {
        if (creadorId == null) {
            throw new IllegalArgumentException("El ID del creador es obligatorio para listar cursos.");
        }
        return cursoRepository.findByCreator(creadorId);
    }

    /**
     * Obtiene la estructura de solo lectura usada por el preview del curso.
     * Incluye datos generales, modulos, lecciones y sus totales, sin cargar
     * el contenido educativo ni sus imagenes.
     */
    public Optional<CursoEstructuraDTO> obtenerEstructuraCompleta(Long cursoId) {
        if (cursoId == null) {
            throw new IllegalArgumentException("El ID del curso es obligatorio.");
        }

        List<CursoEstructuraFilaDTO> filas = cursoRepository.findEstructuraCompleta(cursoId);
        if (filas.isEmpty()) {
            return Optional.empty();
        }

        CursoEstructuraFilaDTO primeraFila = filas.get(0);
        Map<Long, ModuloAcumulador> modulos = new LinkedHashMap<>();
        int totalLecciones = 0;

        for (CursoEstructuraFilaDTO fila : filas) {
            Long moduloId = fila.moduloId();
            if (moduloId == null) {
                continue;
            }

            ModuloAcumulador modulo = modulos.computeIfAbsent(
                    moduloId,
                    id -> new ModuloAcumulador(id, fila.moduloTitulo(), fila.moduloOrden())
            );

            Long leccionId = fila.leccionId();
            if (leccionId != null) {
                modulo.lecciones.add(new LeccionEstructuraDTO(
                        leccionId,
                        fila.leccionTitulo(),
                        fila.leccionOrden(),
                        fila.leccionTipo(),
                        Boolean.TRUE.equals(fila.leccionTieneContenido())
                ));
                totalLecciones++;
            }
        }

        List<ModuloEstructuraDTO> modulosDTO = modulos.values().stream()
                .map(modulo -> new ModuloEstructuraDTO(
                        modulo.id,
                        modulo.titulo,
                        modulo.orden,
                        modulo.lecciones
                ))
                .toList();

        return Optional.of(new CursoEstructuraDTO(
                primeraFila.cursoId(),
                primeraFila.cursoTitulo(),
                primeraFila.cursoDescripcion(),
                primeraFila.cursoCategoria(),
                primeraFila.cursoEstado(),
                primeraFila.cursoFechaCreacion(),
                primeraFila.creadorNombres(),
                primeraFila.creadorApellidos(),
                primeraFila.creadorId(),
                modulosDTO,
                modulosDTO.size(),
                totalLecciones
        ));
    }

    private static final class ModuloAcumulador {
        private final Long id;
        private final String titulo;
        private final int orden;
        private final List<LeccionEstructuraDTO> lecciones = new ArrayList<>();

        private ModuloAcumulador(Long id, String titulo, int orden) {
            this.id = id;
            this.titulo = titulo;
            this.orden = orden;
        }
    }

    /**
     * Publica un curso tras validar:
     * 1. Curso tiene >= 1 módulo
     * 2. Cada módulo tiene >= 1 lección
     * 3. Todas las lecciones tienen contenido
     *
     * Ejecuta dentro de una transacción Hibernate.
     * Si alguna validación falla, lanza IllegalStateException y la transacción hace rollback.
     */
    public void publicar(Long cursoId) {
        if (cursoId == null) {
            throw new IllegalArgumentException("El ID del curso es obligatorio.");
        }

        // Cargar el curso con módulos y lecciones
        var cursoOpt = cursoRepository.findCursoWithModulosAndLecciones(cursoId);
        if (cursoOpt.isEmpty()) {
            throw new IllegalArgumentException("Curso no encontrado con ID: " + cursoId);
        }

        var curso = cursoOpt.get();

        // Validación 1: Curso debe tener >= 1 módulo
        if (curso.getModulos() == null || curso.getModulos().isEmpty()) {
            throw new IllegalStateException("El curso no tiene módulos");
        }

        // Validación 2 y 3: Cada módulo debe tener >= 1 lección y todas deben tener contenido
        for (var modulo : curso.getModulos()) {
            if (modulo.getLecciones() == null || modulo.getLecciones().isEmpty()) {
                throw new IllegalStateException("Existe un módulo sin lecciones");
            }
            for (var leccion : modulo.getLecciones()) {
                if (!leccion.isTieneContenido()) {
                    throw new IllegalStateException("Existen lecciones sin contenido");
                }
            }
        }

        // Todas las validaciones pasaron. Cambiar estado a PUBLICADO y persistir en transacción.
        curso.setEstado(com.epn.redsaberesweb.domain.EstadoCurso.PUBLICADO);
        cursoRepository.update(curso);
    }

    public List<CursoResumeDTO> listarCursosPublicados() {
        return cursoRepository.findByEstado(EstadoCurso.PUBLICADO);
    }

    public Optional<Curso> obtenerCursoPublico(Long id) {
        return cursoRepository.findPublicById(id);
    }
}
