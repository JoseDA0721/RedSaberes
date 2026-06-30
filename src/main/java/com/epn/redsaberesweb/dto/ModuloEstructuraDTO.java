package com.epn.redsaberesweb.dto;

import java.util.List;

public record ModuloEstructuraDTO(
        Long id,
        String titulo,
        int orden,
        List<LeccionEstructuraDTO> lecciones
) {
    public ModuloEstructuraDTO {
        lecciones = List.copyOf(lecciones);
    }
}
