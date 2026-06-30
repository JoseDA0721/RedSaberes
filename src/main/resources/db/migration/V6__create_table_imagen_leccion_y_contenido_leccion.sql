CREATE TABLE contenido_leccion
(
    id         bigint IDENTITY (1, 1) NOT NULL,
    leccion_id bigint                 NOT NULL,
    texto      varchar(max)           NOT NULL,
    CONSTRAINT pk_contenido_leccion PRIMARY KEY (id)
)
GO

CREATE TABLE imagen_leccion
(
    id             bigint IDENTITY (1, 1) NOT NULL,
    leccion_id     bigint                 NOT NULL,
    nombre_archivo varchar(255)           NOT NULL,
    ruta           varchar(500)           NOT NULL,
    tamanio_bytes  bigint,
    orden          int                    NOT NULL,
    CONSTRAINT pk_imagen_leccion PRIMARY KEY (id)
)
GO

ALTER TABLE contenido_leccion
    ADD CONSTRAINT uc_contenido_leccion_leccion UNIQUE (leccion_id)
GO

ALTER TABLE contenido_leccion
    ADD CONSTRAINT FK_CONTENIDO_LECCION_ON_LECCION FOREIGN KEY (leccion_id) REFERENCES leccion (id)
GO

ALTER TABLE imagen_leccion
    ADD CONSTRAINT FK_IMAGEN_LECCION_ON_LECCION FOREIGN KEY (leccion_id) REFERENCES leccion (id)
GO