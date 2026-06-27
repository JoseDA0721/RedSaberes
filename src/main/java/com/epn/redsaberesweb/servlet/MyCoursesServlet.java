package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.repository.CursoRepository;
import com.epn.redsaberesweb.service.CursoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;

@WebServlet(name = "MyCoursesServlet", urlPatterns = {"/my-courses"})
public class MyCoursesServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(MyCoursesServlet.class);

    private CursoService cursoService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.cursoService = new CursoService(new CursoRepository());
        } catch (Exception e) {
            logger.error("Error inicializando MyCoursesServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de cursos", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // --- CAMBIO AQUÍ ---
        Long userId = (Long) session.getAttribute("userId"); // Recuperar userId directamente
        if (userId == null) { // Si no hay userId en sesión, redirigir
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // --- FIN CAMBIO ---

        try {
            if (cursoService == null) {
                logger.error("CursoService no está inicializado en MyCoursesServlet");
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Servicio de cursos no disponible");
                return;
            }

            // Usar userId directamente para listar los cursos
            request.setAttribute("cursos", cursoService.listarCursosPorCreador(userId));
            request.getRequestDispatcher("/WEB-INF/vistas/my-courses.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            logger.error("Error al cargar los cursos del usuario ID: {}", userId, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudieron cargar los cursos");
        }
    }

}