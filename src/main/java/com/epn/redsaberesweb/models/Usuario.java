package com.epn.redsaberesweb.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "usuarios", uniqueConstraints = {
        @UniqueConstraint(name = "uk_usuarios_correo", columnNames = "correo")
})
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nombres;

    private String apellidos;

    @Column(nullable = false, unique = true)
    private String correo;

    @Column(nullable = false, name = "password_hash")
    private String passwordHash;

    @Column(nullable = false, name = "fecha_registro")
    private LocalDateTime fechaRegistro;

    @Column(nullable = false)
    private Boolean estado;

    @OneToMany(
            mappedBy = "creador",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private List<Curso> cursosCreados = new ArrayList<>();

    public Usuario() {
    }

    // Constructor con todos los campos excepto la lista de cursos, si es necesario
    public Usuario(String nombres, String apellidos, String correo, String passwordHash, LocalDateTime fechaRegistro, Boolean estado) {
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.correo = correo;
        this.passwordHash = passwordHash;
        this.fechaRegistro = fechaRegistro;
        this.estado = estado;
    }


    @PrePersist
    public void prePersist() {
        if (fechaRegistro == null) {
            fechaRegistro = LocalDateTime.now();
        }
        if (estado == null) {
            estado = Boolean.TRUE;
        }
    }

    // Getters y setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Boolean getEstado() {
        return estado;
    }

    public void setEstado(Boolean estado) {
        this.estado = estado;
    }

    public List<Curso> getCursosCreados() {
        return cursosCreados;
    }

    public void setCursosCreados(List<Curso> cursosCreados) {
        this.cursosCreados = cursosCreados;
    }

    public LocalDateTime getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(LocalDateTime fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    // Métodos de conveniencia para manejar la relación bidireccional
    public void addCurso(Curso curso) {
        cursosCreados.add(curso);
        curso.setCreador(this);
    }

    public void removeCurso(Curso curso) {
        cursosCreados.remove(curso);
        curso.setCreador(null);
    }
}