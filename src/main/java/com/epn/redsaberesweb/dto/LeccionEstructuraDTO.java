package com.epn.redsaberesweb.dto;

import com.epn.redsaberesweb.domain.TipoLeccion;

public record LeccionEstructuraDTO(
        Long id,
        String titulo,
        int orden,
        TipoLeccion tipo,
        boolean tieneContenido
) {
}
