package com.epn.redsaberesweb.dto;

import com.epn.redsaberesweb.domain.EstadoCurso;
import com.epn.redsaberesweb.domain.TipoLeccion;

import java.time.LocalDateTime;

/**
 * Proyeccion plana y tipada de la consulta de estructura de un curso.
 * Los campos de modulo y leccion pueden ser nulos por los LEFT JOIN.
 */
public record CursoEstructuraFilaDTO(
        Long cursoId,
        String cursoTitulo,
        String cursoDescripcion,
        String cursoCategoria,
        EstadoCurso cursoEstado,
        LocalDateTime cursoFechaCreacion,
        String creadorNombres,
        String creadorApellidos,
        Long creadorId,
        Long moduloId,
        String moduloTitulo,
        Integer moduloOrden,
        Long leccionId,
        String leccionTitulo,
        Integer leccionOrden,
        TipoLeccion leccionTipo,
        Boolean leccionTieneContenido
) {
}
