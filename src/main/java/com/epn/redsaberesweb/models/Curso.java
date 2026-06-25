package com.epn.redsaberesweb.models;

import com.epn.redsaberesweb.domain.EstadoCurso;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "cursos")
public class Curso {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String titulo;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(nullable = false)
    private String categoria;

    @Column(name= "fecha_creacion", nullable = false)
    private LocalDateTime fechaCreacion;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EstadoCurso estado = EstadoCurso.BORRADOR;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "creador_id", nullable = false)
    private Usuario creador;

    public Curso () {

    }

    public Curso(Usuario creador, EstadoCurso estado, LocalDateTime fechaCreacion, String categoria, String descripcion, String titulo, Long id) {
        this.creador = creador;
        this.estado = estado;
        this.fechaCreacion = fechaCreacion;
        this.categoria = categoria;
        this.descripcion = descripcion;
        this.titulo = titulo;
        this.id = id;
    }

    @PrePersist
    public void prePersist() {
        if (fechaCreacion == null) {
            fechaCreacion = LocalDateTime.now();
        }
    }

    public Usuario getCreador() {
        return creador;
    }

    public void setCreador(Usuario creador) {
        this.creador = creador;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public EstadoCurso getEstado() {
        return estado;
    }

    public void setEstado(EstadoCurso estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return "Curso{" +
               "id=" + id +
               ", titulo='" + titulo + '\'' +
               ", categoria='" + categoria + '\'' +
               ", estado=" + estado +
               ", creadorId=" + (creador != null ? creador.getId() : "null") +
               '}';
    }
}