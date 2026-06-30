package com.epn.redsaberesweb.util;

import com.epn.redsaberesweb.models.*;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {

    private static final SessionFactory sessionFactory = buildSessionFactory();

    private HibernateUtil() { }

    private static SessionFactory buildSessionFactory() {
        try {
            Configuration configuration = new Configuration();

            // Primero probar system properties (-D...)
            String driver = getConfig("DB_DRIVER", "com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = getConfig("DB_URL", null);
            String user = getConfig("DB_USER", null);
            String pass = getConfig("DB_PASSWORD", null);
            String dialect = getConfig("HIBERNATE_DIALECT", "org.hibernate.dialect.SQLServerDialect");
            String ddl = getConfig("HIBERNATE_DDL", "validate");

            if (url == null || url.isBlank()) {
                throw new IllegalStateException("Variable de configuración DB_URL no encontrada (ni system property ni env var).");
            }
            if (user == null || user.isBlank()) {
                throw new IllegalStateException("Variable de configuración DB_USER no encontrada (ni system property ni env var).");
            }
            if (pass == null) {
                // ¿Permitir vacío? Normalmente no
                throw new IllegalStateException("Variable de configuración DB_PASSWORD no encontrada (ni system property ni env var).");
            }

            configuration.setProperty("hibernate.connection.driver_class", driver);
            configuration.setProperty("hibernate.connection.url", url);
            configuration.setProperty("hibernate.connection.username", user);
            configuration.setProperty("hibernate.connection.password", pass);
            configuration.setProperty("hibernate.dialect", dialect);
            configuration.setProperty("hibernate.hbm2ddl.auto", ddl);
            configuration.setProperty("hibernate.show_sql", "true");
            configuration.setProperty("hibernate.format_sql", "true");

            configuration.addAnnotatedClass(Usuario.class);
            configuration.addAnnotatedClass(Curso.class);
            configuration.addAnnotatedClass(Modulo.class);
            configuration.addAnnotatedClass(Leccion.class);
            configuration.addAnnotatedClass(ContenidoLeccion.class);
            configuration.addAnnotatedClass(ImagenLeccion.class);

            return configuration.buildSessionFactory();
        } catch (Exception e) {
            // Dejar traza clara para facilitar debugging en despliegues
            throw new ExceptionInInitializerError("Error al crear SessionFactory: " + e.getMessage());
        }
    }

    private static String getConfig(String key, String defaultValue) {
        // primero system property, luego environment variable, luego default
        String v = System.getProperty(key);
        if (v != null && !v.isBlank()) return v;
        v = System.getenv(key);
        if (v != null && !v.isBlank()) return v;
        return defaultValue;
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}