package com.epn.redsaberesweb.dto;

public record CursoResumeDTO (
        String titulo,
        String categoria,
        String descripcion,
        String nombreCreador,
        String apellidoCreador,
        Long numeroModulos,
        Long numeroLecciones

) {

    @Override
    public Long numeroLecciones() {
        return numeroLecciones;
    }

    @Override
    public Long numeroModulos() {
        return numeroModulos;
    }

    @Override
    public String apellidoCreador() {
        return apellidoCreador;
    }

    @Override
    public String nombreCreador() {
        return nombreCreador;
    }

    @Override
    public String descripcion() {
        return descripcion;
    }

    @Override
    public String categoria() {
        return categoria;
    }

    @Override
    public String titulo() {
        return titulo;
    }
}
