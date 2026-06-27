package com.epn.redsaberesweb.dto;

import com.epn.redsaberesweb.domain.EstadoCurso;

import java.time.LocalDateTime;

public record CourseDetailDTO(Long id, String titulo, String descripcion, String categoria, EstadoCurso estado,
                              LocalDateTime fechaCreacion, String creadorNombres, String creadorApellidos,
                              Long creadorId) {
    @Override
    public Long creadorId() {
        return creadorId;
    }

    @Override
    public String creadorApellidos() {
        return creadorApellidos;
    }

    @Override
    public String creadorNombres() {
        return creadorNombres;
    }

    @Override
    public LocalDateTime fechaCreacion() {
        return fechaCreacion;
    }

    @Override
    public EstadoCurso estado() {
        return estado;
    }

    @Override
    public String categoria() {
        return categoria;
    }

    @Override
    public String descripcion() {
        return descripcion;
    }

    @Override
    public String titulo() {
        return titulo;
    }

    @Override
    public Long id() {
        return id;
    }
}