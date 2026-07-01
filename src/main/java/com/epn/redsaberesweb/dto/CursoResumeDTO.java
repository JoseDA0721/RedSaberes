package com.epn.redsaberesweb.dto;

public class CursoResumeDTO {

    private final Long   id;
    private final String titulo;
    private final String categoria;
    private final String descripcion;
    private final String nombres;
    private final String apellidos;
    private final Long   cantidadModulos;
    private final Long   cantidadLecciones;

    // Constructor que coincide con la query HQL (orden = orden en SELECT)
    public CursoResumeDTO(Long id, String titulo, String categoria,
                          String descripcion, String nombres, String apellidos,
                          Long cantidadModulos, Long cantidadLecciones) {
        this.id                = id;
        this.titulo            = titulo;
        this.categoria         = categoria;
        this.descripcion       = descripcion;
        this.nombres           = nombres;
        this.apellidos         = apellidos;
        this.cantidadModulos   = cantidadModulos;
        this.cantidadLecciones = cantidadLecciones;
    }

    // ── Helper de vista ──────────────────────────────────────────────────
    /** Nombre completo del instructor para mostrar en JSP */
    public String getInstructorNombreCompleto() {
        return (nombres != null ? nombres : "") + " " + (apellidos != null ? apellidos : "");
    }

    /** Inicial para el avatar circular */
    public String getInstructorInicial() {
        return (nombres != null && !nombres.isEmpty())
                ? String.valueOf(nombres.charAt(0)).toUpperCase()
                : "?";
    }

    // ── Getters ──────────────────────────────────────────────────────────
    public Long   getId()                  { return id; }
    public String getTitulo()              { return titulo; }
    public String getCategoria()           { return categoria; }
    public String getDescripcion()         { return descripcion; }
    public String getNombres()             { return nombres; }
    public String getApellidos()           { return apellidos; }
    public Long   getCantidadModulos()     { return cantidadModulos != null ? cantidadModulos : 0L; }
    public Long   getCantidadLecciones()   { return cantidadLecciones != null ? cantidadLecciones : 0L; }
}
