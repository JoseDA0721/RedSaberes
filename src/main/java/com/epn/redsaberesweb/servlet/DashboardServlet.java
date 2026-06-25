package com.epn.redsaberesweb.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(DashboardServlet.class);

    @Override
    public void init() throws ServletException {
        super.init();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // No crear sesión si no existe

        if (session == null || session.getAttribute("userId") == null) {
            // Si no hay sesión o el usuario no está autenticado, redirigir al login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");

        try {
            // Obtener la lista de cursos creados por el usuario
//            List<Curso> cursos = cursoService.listarCursosPorCreador(userId);
//
//            // Colocar la lista de cursos en el request para que el JSP pueda acceder a ella
//            request.setAttribute("cursos", cursos);

            // Reenviar al JSP del dashboard
            request.getRequestDispatcher("/WEB-INF/vistas/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.error("Error al cargar el dashboard para el usuario ID: {}", userId, e);
            // Manejo de errores: podrías redirigir a una página de error o mostrar un mensaje
            request.setAttribute("error", "No se pudieron cargar los cursos. Inténtalo de nuevo más tarde.");
            request.getRequestDispatcher("/WEB-INF/vistas/dashboard.jsp")
                    .forward(request, response);
        }
    }

}
