package com.epn.redsaberesweb.repository;

import com.epn.redsaberesweb.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

import java.util.List;
import java.util.Optional;

/**
 * @param <T>  Tipo de la entidad JPA
 * @param <ID> Tipo del identificador (Integer en todas las entidades actuales)
 */
public abstract class GenericRepositoryImpl<T, ID> implements GenericRepository<T, ID> {

    private final Class<T> entityClass;
    private final SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

    protected GenericRepositoryImpl(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    @Override
    public void save(T entity) {
        Session session = sessionFactory.openSession();
        try {
            session.getTransaction().begin();
            session.persist(entity);
            session.getTransaction().commit();
        } catch (Exception e) {
            if (session.getTransaction().isActive()) {
                session.getTransaction().rollback();
            }
            throw e;
        } finally {
            session.close();
        }
    }

    @Override
    public void update(T entity) {
        Session session = sessionFactory.openSession();
        try {
            session.getTransaction().begin();
            session.merge(entity);
            session.getTransaction().commit();
        } catch (Exception e) {
            if (session.getTransaction().isActive()) {
                session.getTransaction().rollback();
            }
            throw e;
        } finally {
            session.close();
        }
    }

    @Override
    public void delete(ID id) {
        Session session = sessionFactory.openSession();
        try {
            session.getTransaction().begin();
            T entity = session.find(entityClass, id);
            if (entity != null) {
                session.remove(entity);
            }
            session.getTransaction().commit();
        } catch (Exception e) {
            if (session.getTransaction().isActive()) {
                session.getTransaction().rollback();
            }
            throw e;
        } finally {
            session.close();
        }
    }

    @Override
    public Optional<T> findById(ID id) {
        try (Session session = sessionFactory.openSession()) {
            T entity = session.find(entityClass, id);
            return Optional.ofNullable(entity);
        }
    }

    @Override
    public List<T> findAll() {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("FROM " + entityClass.getSimpleName(), entityClass)
                    .getResultList();
        }
    }

    protected SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}