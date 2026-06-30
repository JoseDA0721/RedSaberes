package com.epn.redsaberesweb.repository;

import com.epn.redsaberesweb.models.ContenidoLeccion;
import com.epn.redsaberesweb.models.ImagenLeccion;
import com.epn.redsaberesweb.models.Leccion;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ContenidoLeccionRepository extends GenericRepositoryImpl<ContenidoLeccion, Long> {

    private static final Logger logger = Logger.getLogger(ContenidoLeccionRepository.class.getName());

    public ContenidoLeccionRepository() {
        super(ContenidoLeccion.class);
    }
    
    public Optional<ContenidoLeccion> obtenerPorLeccion(Long leccionId) {
        try (Session session = getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT c FROM ContenidoLeccion c WHERE c.leccion.id = :leccionId",
                            ContenidoLeccion.class)
                    .setParameter("leccionId", leccionId)
                    .uniqueResultOptional();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al obtener contenido para lección ID: " + leccionId, e);
            throw new RuntimeException("No se pudo recuperar el contenido de la lección.", e);
        }
    }

    public void guardarTexto(Long leccionId, String texto) {
        Transaction tx = null;
        try (Session session = getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            ContenidoLeccion contenido = session.createQuery(
                            "SELECT c FROM ContenidoLeccion c WHERE c.leccion.id = :id",
                            ContenidoLeccion.class)
                    .setParameter("id", leccionId)
                    .uniqueResult();

            if (contenido != null) {
                // UPDATE — solo modifica el texto
                contenido.setTexto(texto);
                session.merge(contenido);
            } else {
                // INSERT — crea el registro con referencia a la lección
                Leccion leccion = session.getReference(Leccion.class, leccionId);
                ContenidoLeccion nuevo = new ContenidoLeccion(leccion, texto);
                session.persist(nuevo);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            logger.log(Level.SEVERE, "Error al guardar texto para lección ID: " + leccionId, e);
            throw new RuntimeException("No se pudo guardar el contenido de texto.", e);
        }
    }

    public List<ImagenLeccion> listarImagenes(Long leccionId) {
        try (Session session = getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT i FROM ImagenLeccion i WHERE i.leccion.id = :leccionId ORDER BY i.orden ASC",
                            ImagenLeccion.class)
                    .setParameter("leccionId", leccionId)
                    .getResultList();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al listar imágenes para lección ID: " + leccionId, e);
            throw new RuntimeException("No se pudieron listar las imágenes de la lección.", e);
        }
    }

    public void guardarImagen(ImagenLeccion imagen) {
        Transaction tx = null;
        try (Session session = getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(imagen);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            logger.log(Level.SEVERE, "Error al guardar imagen para lección ID: " + imagen.getLeccion().getId(), e);
            throw new RuntimeException("No se pudo registrar la imagen.", e);
        }
    }

    public String eliminarImagen(Long imagenId) {
        Transaction tx = null;
        try (Session session = getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            ImagenLeccion imagen = session.find(ImagenLeccion.class, imagenId);
            if (imagen == null) {
                throw new IllegalArgumentException("La imagen con ID " + imagenId + " no existe.");
            }

            String ruta = imagen.getRuta();
            session.remove(imagen);
            tx.commit();
            return ruta; // devuelve ruta para borrado físico en el servicio
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            logger.log(Level.SEVERE, "Error al eliminar imagen ID: " + imagenId, e);
            throw new RuntimeException("No se pudo eliminar la imagen.", e);
        }
    }

    public int contarImagenes(Long leccionId) {
        try (Session session = getSessionFactory().openSession()) {
            Long count = session.createQuery(
                            "SELECT COUNT(i) FROM ImagenLeccion i WHERE i.leccion.id = :leccionId",
                            Long.class)
                    .setParameter("leccionId", leccionId)
                    .uniqueResult();
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al contar imágenes para lección ID: " + leccionId, e);
            throw new RuntimeException("No se pudo contar las imágenes.", e);
        }
    }


    public int obtenerSiguienteOrden(Long leccionId) {
        try (Session session = getSessionFactory().openSession()) {
            Integer maxOrden = session.createQuery(
                            "SELECT MAX(i.orden) FROM ImagenLeccion i WHERE i.leccion.id = :leccionId",
                            Integer.class)
                    .setParameter("leccionId", leccionId)
                    .uniqueResult();
            return (maxOrden != null ? maxOrden : 0) + 1;
        } catch (Exception e) {
            return 1;
        }
    }
}