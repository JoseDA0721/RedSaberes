package com.epn.redsaberesweb.models;

import com.epn.redsaberesweb.domain.TipoLeccion;
import jakarta.persistence.*;

@Entity
@Table(name = "leccion")
public class Leccion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "modulo_id", nullable = false)
    private Modulo modulo;

    @Column(nullable = false)
    private String titulo;

    @Column(nullable = false)
    private int orden;

    @Column(nullable = false, columnDefinition = "boolean default false", name = "tiene_contenido")
    private boolean tieneContenido = false;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo", nullable = true)
    private TipoLeccion tipo = TipoLeccion.TEXTO;

    // Getters and Setters
    public TipoLeccion getTipo() {
        return tipo;
    }

    public void setTipo(TipoLeccion tipo) {
        this.tipo = tipo;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Modulo getModulo() {
        return modulo;
    }

    public void setModulo(Modulo modulo) {
        this.modulo = modulo;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public boolean isTieneContenido() {
        return tieneContenido;
    }

    public void setTieneContenido(boolean tieneContenido) {
        this.tieneContenido = tieneContenido;
    }
}
