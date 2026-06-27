package com.epn.redsaberesweb.repository;

import com.epn.redsaberesweb.models.Curso;
import org.hibernate.Session;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.epn.redsaberesweb.dto.CourseDetailDTO;


public class CursoRepository extends GenericRepositoryImpl<Curso, Long> {
    private static final Logger logger = Logger.getLogger(CursoRepository.class.getName());

    public CursoRepository () {
        super(Curso.class);
    }

    public Optional<CourseDetailDTO> findDetailById(Long id) {
        try (Session session = getSessionFactory().openSession()) {
            String hql = """
            SELECT new com.epn.redsaberesweb.dto.CourseDetailDTO(
                c.id, c.titulo, c.descripcion, c.categoria,
                c.estado, c.fechaCreacion,
                u.nombres, u.apellidos, u.id
            )
            FROM Curso c
            JOIN c.creador u
            WHERE c.id = :id
        """;

            return session.createQuery(hql, CourseDetailDTO.class)
                    .setParameter("id", id)
                    .uniqueResultOptional();
        }
    }

    public List<Curso> findByCreator(Long creadorId){
        try (Session session = getSessionFactory().openSession()) { // Usar openSession() del padre
            return session.createQuery("select c from Curso c where c.creador.id = :creadorId ORDER BY c.fechaCreacion DESC", Curso.class)
                    .setParameter("creadorId", creadorId)
                    .getResultList();

        }catch (Exception e){
            logger.log(Level.SEVERE, "Error al buscar Cursos por creador", e);
            throw new RuntimeException("No se pudo encontrar cursos para el creador con ID: " + creadorId, e);
        }
    }
}
