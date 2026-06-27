CREATE TABLE leccion
(
    id              bigint IDENTITY (1, 1) NOT NULL,
    modulo_id       bigint                 NOT NULL,
    titulo          varchar(255)           NOT NULL,
    orden           int                    NOT NULL,
    tiene_contenido bit                    NOT NULL DEFAULT 0,
    CONSTRAINT pk_leccion PRIMARY KEY (id)
)
GO

ALTER TABLE leccion
    ADD CONSTRAINT FK_LECCION_ON_MODULO FOREIGN KEY (modulo_id) REFERENCES modulo (id) ON DELETE CASCADE
GO
