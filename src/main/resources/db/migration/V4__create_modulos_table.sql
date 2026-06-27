CREATE TABLE modulo
(
    id       bigint IDENTITY (1, 1) NOT NULL,
    curso_id bigint                 NOT NULL,
    titulo   varchar(255)           NOT NULL,
    orden    int                    NOT NULL,
    CONSTRAINT pk_modulo PRIMARY KEY (id)
)
GO

ALTER TABLE modulo
    ADD CONSTRAINT FK_MODULO_ON_CURSO FOREIGN KEY (curso_id) REFERENCES cursos (id)
GO