package com.epn.redsaberesweb.repository;

import com.epn.redsaberesweb.models.Leccion;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LeccionRepository extends GenericRepositoryImpl<Leccion, Long> {

    private static final Logger logger = Logger.getLogger(LeccionRepository.class.getName());

    public LeccionRepository() {
        super(Leccion.class);
    }

    /**
     * Lista todas las lecciones de un módulo específico, ordenadas por su campo 'orden' ascendente.
     * @param moduloId El ID del módulo.
     * @return Una lista de lecciones ordenadas.
     */
    public List<Leccion> listarPorModulo(Long moduloId) {
        try (Session session = getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT l FROM Leccion l WHERE l.modulo.id = :moduloId ORDER BY l.orden ASC",
                            Leccion.class
                    )
                    .setParameter("moduloId", moduloId)
                    .getResultList();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al listar lecciones por módulo", e);
            throw new RuntimeException("No se pudieron listar las lecciones para el módulo con ID: " + moduloId, e);
        }
    }

    /**
     * Actualiza directamente el campo 'orden' de una lección específica.
     * @param leccionId El ID de la lección a actualizar.
     * @param nuevoOrden El nuevo valor para el campo 'orden'.
     */
    public void actualizarOrden(Long leccionId, int nuevoOrden) {
        Transaction tx = null;
        try (Session session = getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Query<?> query = session.createQuery(
                    "UPDATE Leccion l SET l.orden = :nuevoOrden WHERE l.id = :leccionId"
            );
            query.setParameter("nuevoOrden", nuevoOrden);
            query.setParameter("leccionId", leccionId);
            query.executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            logger.log(Level.SEVERE, "Error al actualizar orden de la lección", e);
            throw new RuntimeException("No se pudo actualizar el orden de la lección con ID: " + leccionId, e);
        }
    }

    /**
     * Actualiza el estado de contenido de una lección específica.
     * Utilizado para marcar si una lección tiene contenido asociado.
     * @param leccionId El ID de la lección a actualizar.
     * @param tieneContenido El nuevo estado de contenido (true/false).
     */
    public void actualizarEstadoContenido(Long leccionId, boolean tieneContenido) {
        Transaction tx = null;
        try (Session session = getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Query<?> query = session.createQuery(
                    "UPDATE Leccion l SET l.tieneContenido = :tieneContenido WHERE l.id = :leccionId"
            );
            query.setParameter("tieneContenido", tieneContenido);
            query.setParameter("leccionId", leccionId);
            query.executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            logger.log(Level.SEVERE, "Error al actualizar estado de contenido de la lección", e);
            throw new RuntimeException("No se pudo actualizar el estado de contenido de la lección con ID: " + leccionId, e);
        }
    }

    /**
     * Intercambia el valor de orden entre dos lecciones dentro de una misma transacción.
     */
    public void intercambiarOrdenes(Long leccionIdA, Long leccionIdB) {
        Transaction tx = null;
        try (Session session = getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            Leccion leccionA = session.find(Leccion.class, leccionIdA);
            Leccion leccionB = session.find(Leccion.class, leccionIdB);

            if (leccionA == null || leccionB == null) {
                throw new IllegalArgumentException("No se pudieron encontrar las lecciones para intercambiar sus órdenes.");
            }

            int ordenTemporal = leccionA.getOrden();
            leccionA.setOrden(leccionB.getOrden());
            leccionB.setOrden(ordenTemporal);

            session.merge(leccionA);
            session.merge(leccionB);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            logger.log(Level.SEVERE, "Error al intercambiar órdenes de lecciones", e);
            throw new RuntimeException("No se pudieron intercambiar los órdenes de las lecciones.", e);
        }
    }

    /**
     * Obtiene una lección específica de un módulo por su número de orden.
     * Utilizado para lógicas de intercambio o validación.
     * @param moduloId El ID del módulo al que pertenece la lección.
     * @param orden El número de orden de la lección.
     * @return Un Optional que contiene la lección si se encuentra, o vacío si no.
     */
    public Optional<Leccion> obtenerPorOrden(Long moduloId, int orden) {
        try (Session session = getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT l FROM Leccion l WHERE l.modulo.id = :moduloId AND l.orden = :orden",
                            Leccion.class
                    )
                    .setParameter("moduloId", moduloId)
                    .setParameter("orden", orden)
                    .uniqueResultOptional();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al obtener lección por orden", e);
            throw new RuntimeException("No se pudo obtener la lección para el módulo " + moduloId + " y orden " + orden, e);
        }
    }
}
