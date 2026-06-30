package com.epn.redsaberesweb.repository;

import com.epn.redsaberesweb.domain.EstadoCurso;
import com.epn.redsaberesweb.dto.CursoResumeDTO;
import com.epn.redsaberesweb.models.Curso;
import org.hibernate.Session;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.epn.redsaberesweb.dto.CourseDetailDTO;
import com.epn.redsaberesweb.dto.CursoEstructuraFilaDTO;


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

    /**
     * Obtiene en una sola consulta los datos necesarios para construir el preview
     * de un curso. La proyeccion escalar evita inicializaciones lazy y consultas N+1.
     *
     * El resultado se ordena por la posicion del modulo y de la leccion. Los IDs
     * se usan como desempate para mantener un resultado determinista si existen
     * posiciones repetidas.
     */
    public List<CursoEstructuraFilaDTO> findEstructuraCompleta(Long cursoId) {
        try (Session session = getSessionFactory().openSession()) {
            String hql = """
                SELECT new com.epn.redsaberesweb.dto.CursoEstructuraFilaDTO(
                       c.id, c.titulo, c.descripcion, c.categoria,
                       c.estado, c.fechaCreacion,
                       u.nombres, u.apellidos, u.id,
                       m.id, m.titulo, m.orden,
                       l.id, l.titulo, l.orden, l.tipo, l.tieneContenido)
                FROM Curso c
                JOIN c.creador u
                LEFT JOIN c.modulos m
                LEFT JOIN m.lecciones l
                WHERE c.id = :cursoId
                ORDER BY m.orden ASC, m.id ASC, l.orden ASC, l.id ASC
            """;

            return session.createQuery(hql, CursoEstructuraFilaDTO.class)
                    .setParameter("cursoId", cursoId)
                    .setReadOnly(true)
                    .getResultList();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al obtener la estructura del curso", e);
            throw new RuntimeException("No se pudo obtener la estructura del curso con ID: " + cursoId, e);
        }
    }

    /**
     * Obtiene un curso con sus módulos y lecciones cargadas (eager loading)
     * Útil para validaciones previa a publicación.
     */
    public Optional<Curso> findCursoWithModulosAndLecciones(Long cursoId) {
        try (Session session = getSessionFactory().openSession()) {
            String hql = """
                SELECT DISTINCT c FROM Curso c
                LEFT JOIN FETCH c.modulos m
                LEFT JOIN FETCH m.lecciones l
                WHERE c.id = :cursoId
            """;
            return session.createQuery(hql, Curso.class)
                    .setParameter("cursoId", cursoId)
                    .uniqueResultOptional();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al buscar Curso con módulos y lecciones", e);
            throw new RuntimeException("No se pudo encontrar el curso con ID: " + cursoId, e);
        }
    }

    public List<CursoResumeDTO> findByEstado(EstadoCurso estado) {
        try (Session session = getSessionFactory().openSession()) {
            String hql = """
                SELECT new com.epn.redsaberesweb.dto.CursoResumeDTO(
                       c.titulo,
                       c.categoria,
                       c.descripcion,
                       u.nombres,
                       u.apellidos,
                       count (m.id),
                       count(l.id)
                )
                FROM Curso c
                JOIN c.creador u
                left JOIN c.modulos m
                LEFT JOIN c.modulos l
                WHERE c.estado = :estado
                GROUP BY c.id, c.titulo, c.categoria, c.descripcion, u.nombres, u.apellidos, c.modulos
            """;
            return session.createQuery(hql, CursoResumeDTO.class)
                    .setParameter("estado", estado)
                    .setReadOnly(true)
                    .getResultList();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al obtener el resumen de los cursos publicados", e);
            throw new RuntimeException("No se pudo obtener el resumen de los cursos publicados", e);
        }
    }

    public Optional<Curso> findPublicById(Long id) {
        try (Session session = getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT c FROM Curso c " +
                                    "LEFT JOIN FETCH c.modulos m " +
                                    "LEFT JOIN FETCH m.lecciones " +  // carga lecciones en memoria
                                    "LEFT JOIN FETCH c.creador " +
                                    "WHERE c.id = :id AND c.estado = 'PUBLICADO'",
                            Curso.class)
                    .setParameter("id", id)
                    .uniqueResultOptional();
        }
    }

}
