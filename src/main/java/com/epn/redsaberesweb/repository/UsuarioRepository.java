package com.epn.redsaberesweb.repository;

import com.epn.redsaberesweb.models.Usuario;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import java.util.logging.Level;
import java.util.logging.Logger;


public class UsuarioRepository {

    private static final Logger logger = Logger.getLogger(UsuarioRepository.class.getName());

    private final SessionFactory sessionFactory;

    public UsuarioRepository(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }


    public Long save(Usuario usuario) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();

            session.persist(usuario);
            session.flush();

            tx.commit();

            return usuario.getId();
        } catch (Exception e) {
            try {
                if (tx != null && tx.isActive()) {
                    tx.rollback();
                }
            } catch (Exception ex) {
                logger.log(Level.SEVERE, "Error al hacer rollback", ex);
            }
            logger.log(Level.SEVERE, "Error al guardar Usuario", e);
            throw new RuntimeException("No se pudo guardar el usuario", e);
        }
    }

    public void update(Usuario usuario) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            session.merge(usuario);
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
            logger.log(Level.SEVERE, "Error al actualizar Usuario", e);
            throw new RuntimeException("No se pudo actualizar el usuario", e);
        }
    }

    public Usuario findById(Long id) {
        try (Session session = sessionFactory.openSession()) {
            return session.find(Usuario.class, id);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al buscar Usuario por id", e);
            throw new RuntimeException("No se pudo buscar el usuario por id", e);
        }
    }

    public Usuario findByCorreo(String correo) {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("select u from Usuario u where u.correo = :correo", Usuario.class)
                    .setParameter("correo", correo)
                    .uniqueResult();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al buscar Usuario por correo", e);
            throw new RuntimeException("No se pudo buscar el usuario por correo", e);
        }
    }
}

