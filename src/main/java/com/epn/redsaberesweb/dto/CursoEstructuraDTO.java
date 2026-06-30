package com.epn.redsaberesweb.dto;

import com.epn.redsaberesweb.domain.EstadoCurso;

import java.time.LocalDateTime;
import java.util.List;

public record CursoEstructuraDTO(
        Long id,
        String titulo,
        String descripcion,
        String categoria,
        EstadoCurso estado,
        LocalDateTime fechaCreacion,
        String creadorNombres,
        String creadorApellidos,
        Long creadorId,
        List<ModuloEstructuraDTO> modulos,
        int totalModulos,
        int totalLecciones
) {
    public CursoEstructuraDTO {
        modulos = List.copyOf(modulos);
    }
}
