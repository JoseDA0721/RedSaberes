package com.epn.redsaberesweb.models;

import jakarta.persistence.*;

@Entity
@Table(name = "imagen_leccion")
public class ImagenLeccion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "leccion_id", nullable = false)
    private Leccion leccion;

    @Column(name = "nombre_archivo", nullable = false, length = 255)
    private String nombreArchivo;

    @Column(nullable = false, length = 500)
    private String ruta;

    @Column(name = "tamanio_bytes")
    private Long tamanioBytes;

    @Column(nullable = false)
    private int orden;

    public ImagenLeccion() {}

    // ── Helpers de vista ──────────────────────────────────────────────────────
    public String getTamanioFormateado() {
        if (tamanioBytes == null || tamanioBytes <= 0) return "—";
        if (tamanioBytes < 1_024)           return tamanioBytes + " B";
        if (tamanioBytes < 1_048_576)       return String.format("%.1f KB", tamanioBytes / 1_024.0);
        return String.format("%.1f MB", tamanioBytes / 1_048_576.0);
    }

    public String getExtension() {
        if (nombreArchivo == null || !nombreArchivo.contains(".")) return "IMG";
        return nombreArchivo.substring(nombreArchivo.lastIndexOf('.') + 1).toUpperCase();
    }

    // ── Getters / Setters ─────────────────────────────────────────────────────
    public Long getId()                         { return id; }
    public void setId(Long id)                  { this.id = id; }

    public Leccion getLeccion()                 { return leccion; }
    public void    setLeccion(Leccion leccion)  { this.leccion = leccion; }

    public String getNombreArchivo()                    { return nombreArchivo; }
    public void   setNombreArchivo(String nombreArchivo){ this.nombreArchivo = nombreArchivo; }

    public String getRuta()               { return ruta; }
    public void   setRuta(String ruta)    { this.ruta = ruta; }

    public Long getTamanioBytes()                   { return tamanioBytes; }
    public void setTamanioBytes(Long tamanioBytes)  { this.tamanioBytes = tamanioBytes; }

    public int  getOrden()              { return orden; }
    public void setOrden(int orden)     { this.orden = orden; }
}