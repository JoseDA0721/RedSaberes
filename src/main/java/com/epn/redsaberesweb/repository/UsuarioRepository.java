package com.epn.redsaberesweb.repository;

import com.epn.redsaberesweb.models.Usuario;
import org.hibernate.Session;

import java.util.logging.Level;
import java.util.logging.Logger;


public class UsuarioRepository extends GenericRepositoryImpl<Usuario, Long>{

    private static final Logger logger = Logger.getLogger(UsuarioRepository.class.getName());

    public UsuarioRepository() {
        super(Usuario.class);
    }

    public Usuario findByCorreo(String correo) {
        try (Session session = getSessionFactory().openSession()) {
            return session.createQuery("select u from Usuario u where u.correo = :correo", Usuario.class)
                    .setParameter("correo", correo)
                    .uniqueResult();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error al buscar Usuario por correo", e);
            throw new RuntimeException("No se pudo buscar el usuario por correo", e);
        }
    }
}

