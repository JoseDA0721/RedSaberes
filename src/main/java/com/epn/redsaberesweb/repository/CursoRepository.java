package com.epn.redsaberesweb.repository;

import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.dto.CourseDetailDTO;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CursoRepository {
    private static final Logger logger = Logger.getLogger(CursoRepository.class.getName());

    private final SessionFactory sessionFactory;

    public CursoRepository (SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public Long save(Curso curso){
        Transaction tx = null;
        try(Session session = sessionFactory.openSession()){
            tx = session.beginTransaction();
            session.persist(curso);
            session.flush();
            tx.commit();
            return curso.getId();
        } catch (Exception e) {
            try {
                if (tx != null && tx.isActive()) {
                    tx.rollback();
                }
            } catch (Exception ex) {
                logger.log(Level.SEVERE, "Error al hacer rollback", ex);
            }
            logger.log(Level.SEVERE, "Error al guardar Curso", e);
            throw new RuntimeException("No se pudo guardar el curso", e);
        }
    }

    public void update(Curso curso) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            session.merge(curso);
            session.flush();
            tx.commit();

        } catch (Exception e) {
            try {
                if (tx != null && tx.isActive()) {
                    tx.rollback();
                }
            } catch (Exception ex) {
                logger.log(Level.SEVERE, "Error al hacer rollback", ex);
            }
            logger.log(Level.SEVERE, "Error al actualizar Curso", e);
            throw new RuntimeException("No se pudo actualizar el Curso", e);
        }
    }

    public CourseDetailDTO findById(Long cursoId) {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery(
                            """
                                    select new com.epn.redsaberesweb.dto.CourseDetailDTO(
                                        c.id,
                                        c.titulo,
                                        c.descripcion,
                                        c.categoria,
                                        c.estado,
                                        c.fechaCreacion,
                                        u.nombres,
                                        u.apellidos,
                                        u.id
                                    )
                                    from Curso c
                                    join c.creador u
                                    where c.id = :cursoId
                                    """,
                            CourseDetailDTO.class
                    )
                    .setParameter("cursoId", cursoId)
                    .uniqueResult();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al buscar detalle de Curso por ID", e);
            throw new RuntimeException("No se pudo encontrar el detalle del curso con ID: " + cursoId, e);
        }
    }

    public List<Curso> findByCreator(Long creadorId){
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("select c from Curso c where c.creador.id = :creadorId ORDER BY c.fechaCreacion DESC", Curso.class)
                    .setParameter("creadorId", creadorId)
                    .getResultList();

        }catch (Exception e){
            logger.log(Level.SEVERE, "Error al buscar Cursos por creador", e);
            throw new RuntimeException("No se pudo encontrar cursos para el creador con ID: " + creadorId, e);
        }
    }
}