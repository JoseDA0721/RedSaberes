package com.epn.redsaberesweb.repository;

import com.epn.redsaberesweb.models.Modulo;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ModuloRepository extends GenericRepositoryImpl<Modulo, Long> {

    private static final Logger logger = Logger.getLogger(ModuloRepository.class.getName());

    public ModuloRepository() {
        super(Modulo.class);
    }

    /**
     * Lista todos los módulos de un curso específico, ordenados por su campo 'orden' ascendente.
     * @param cursoId El ID del curso.
     * @return Una lista de módulos.
     */
    public List<Modulo> listarPorCurso(Long cursoId) {
        try (Session session = getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT m FROM Modulo m WHERE m.curso.id = :cursoId ORDER BY m.orden ASC",
                            Modulo.class
                    )
                    .setParameter("cursoId", cursoId)
                    .getResultList();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al listar módulos por curso", e);
            throw new RuntimeException("No se pudieron listar los módulos para el curso con ID: " + cursoId, e);
        }
    }

    /**
     * Actualiza directamente el campo 'orden' de un módulo específico.
     * @param moduloId El ID del módulo a actualizar.
     * @param nuevoOrden El nuevo valor para el campo 'orden'.
     */
    public void actualizarOrden(Long moduloId, int nuevoOrden) {
        Transaction tx = null;
        try (Session session = getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Query<?> query = session.createQuery(
                    "UPDATE Modulo m SET m.orden = :nuevoOrden WHERE m.id = :moduloId"
            );
            query.setParameter("nuevoOrden", nuevoOrden);
            query.setParameter("moduloId", moduloId);
            query.executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("No se pudo actualizar el orden del módulo con ID: " + moduloId, e);
        }
    }

    /**
     * Obtiene un módulo específico de un curso por su número de orden.
     * Utilizado para lógicas de intercambio o validación.
     * @param cursoId El ID del curso al que pertenece el módulo.
     * @param orden El número de orden del módulo.
     * @return Un Optional que contiene el módulo si se encuentra, o vacío si no.
     */
    public Optional<Modulo> obtenerPorOrden(Long cursoId, int orden) {
        try (Session session = getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT m FROM Modulo m WHERE m.curso.id = :cursoId AND m.orden = :orden",
                            Modulo.class
                    )
                    .setParameter("cursoId", cursoId)
                    .setParameter("orden", orden)
                    .uniqueResultOptional(); // uniqueResultOptional() es más seguro que uniqueResult()
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al obtener módulo por orden", e);
            throw new RuntimeException("No se pudo obtener el módulo para el curso " + cursoId + " y orden " + orden, e);
        }
    }
}
