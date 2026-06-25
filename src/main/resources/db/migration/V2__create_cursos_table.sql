CREATE TABLE cursos
(
    id             bigint IDENTITY (1, 1) NOT NULL,
    titulo         varchar(255)           NOT NULL,
    descripcion    varchar(max),
    categoria      varchar(255)           NOT NULL,
    fecha_creacion datetime               NOT NULL,
    estado         varchar(255)           NOT NULL,
    CONSTRAINT pk_cursos PRIMARY KEY (id)
)
GO