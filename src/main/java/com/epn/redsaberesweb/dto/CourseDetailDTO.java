package com.epn.redsaberesweb.dto;

import com.epn.redsaberesweb.domain.EstadoCurso;

import java.time.LocalDateTime;

public class CourseDetailDTO {
    private Long id;
    private String titulo;
    private String descripcion;
    private String categoria;
    private EstadoCurso estado;
    private LocalDateTime fechaCreacion;
    private String creadorNombres;
    private String creadorApellidos;
    private Long creadorId;

    public CourseDetailDTO(Long id,
                           String titulo,
                           String descripcion,
                           String categoria,
                           EstadoCurso estado,
                           LocalDateTime fechaCreacion,
                           String creadorNombres,
                           String creadorApellidos,
                           Long creadorId) {
        this.id = id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.categoria = categoria;
        this.estado = estado;
        this.fechaCreacion = fechaCreacion;
        this.creadorNombres = creadorNombres;
        this.creadorApellidos = creadorApellidos;
        this.creadorId = creadorId;
    }

    public Long getId() {
        return id;
    }

    public String getTitulo() {
        return titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public String getCategoria() {
        return categoria;
    }

    public EstadoCurso getEstado() {
        return estado;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public String getCreadorNombres() {
        return creadorNombres;
    }

    public String getCreadorApellidos() {
        return creadorApellidos;
    }

    public Long getCreadorId() {
        return creadorId;
    }
}