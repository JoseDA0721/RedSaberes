package com.epn.redsaberesweb.models;

import jakarta.persistence.*;


@Entity
@Table(name = "contenido_leccion")
public class ContenidoLeccion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "leccion_id", nullable = false, unique = true)
    private Leccion leccion;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String texto;

    public ContenidoLeccion (){}

    public ContenidoLeccion(Leccion leccion, String texto) {
        this.leccion = leccion;
        this.texto = texto;
    }

    public boolean isTieneTexto() {
        return texto != null && !texto.trim().isEmpty();
    }

    public int getCaracteres(){
        return texto != null ? texto.trim().length() : 0;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Leccion getLeccion() {
        return leccion;
    }

    public void setLeccion(Leccion leccion) {
        this.leccion = leccion;
    }

    public String getTexto() {
        return texto;
    }

    public void setTexto(String texto) {
        this.texto = texto;
    }
}
