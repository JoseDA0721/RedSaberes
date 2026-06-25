ALTER TABLE cursos
    ADD creador_id bigint
GO

ALTER TABLE cursos
    ALTER COLUMN creador_id bigint NOT NULL
GO

ALTER TABLE cursos
    ADD CONSTRAINT FK_CURSOS_ON_CREADOR FOREIGN KEY (creador_id) REFERENCES usuarios (id)
GO