package com.epn.redsaberesweb.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.util.Collections;
import java.util.Enumeration;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LogoutServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                limpiarAtributosSesion(session);
                session.invalidate();
                logger.info("Sesión invalidada correctamente");
            } else {
                logger.info("No existía sesión activa para invalidar");
            }

            response.setStatus(HttpServletResponse.SC_FOUND);
            response.sendRedirect(request.getContextPath() + "/login");
        } catch (Exception e) {
            logger.error("Error al cerrar sesión", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al cerrar sesión");
        }
    }

    private void limpiarAtributosSesion(HttpSession session) {
        Enumeration<String> nombresAtributos = session.getAttributeNames();
        if (nombresAtributos == null) {
            nombresAtributos = Collections.emptyEnumeration();
        }

        while (nombresAtributos.hasMoreElements()) {
            String nombre = nombresAtributos.nextElement();
            session.removeAttribute(nombre);
        }
    }
}

