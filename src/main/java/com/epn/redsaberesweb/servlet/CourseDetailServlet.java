package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.dto.CourseDetailDTO;
import com.epn.redsaberesweb.repository.CursoRepository;
import com.epn.redsaberesweb.service.CursoService;
import com.epn.redsaberesweb.util.HibernateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.SessionFactory;

import java.io.IOException;
import java.time.format.DateTimeFormatter; // Importar DateTimeFormatter

@WebServlet(name = "CourseDetailServlet", urlPatterns = {"/courses/detail"})
public class CourseDetailServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(CourseDetailServlet.class);

    private CursoService cursoService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
            this.cursoService = new CursoService(new CursoRepository(sessionFactory));
        } catch (Exception e) {
            logger.error("Error inicializando CourseDetailServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de cursos", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long loggedInUserId = (Long) session.getAttribute("userId");
        String courseIdParam = request.getParameter("id");

        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            logger.warn("Solicitud de detalle de curso sin ID. Usuario ID: {}", loggedInUserId);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de curso requerido.");
            return;
        }

        try {
            Long courseId = Long.parseLong(courseIdParam);
            CourseDetailDTO curso = cursoService.obtenerCurso(courseId);

            if (curso == null) {
                logger.warn("Curso no encontrado para ID: {}. Usuario ID: {}", courseId, loggedInUserId);
                request.setAttribute("error", "El curso solicitado no existe.");
                request.getRequestDispatcher("/WEB-INF/vistas/course-detail.jsp").forward(request, response);
                return;
            }

            if (!curso.getCreadorId().equals(loggedInUserId)) {
                logger.warn("Intento de acceso no autorizado al curso ID: {} por usuario ID: {}", courseId, loggedInUserId);
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permiso para ver este curso.");
                return;
            }

            if (curso.getFechaCreacion() != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                request.setAttribute("fechaCreacionFormateada", curso.getFechaCreacion().format(formatter));
            } else {
                request.setAttribute("fechaCreacionFormateada", "N/A");
            }

            request.setAttribute("curso", curso);
            request.getRequestDispatcher("/WEB-INF/vistas/course-detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            logger.warn("ID de curso inválido: {}. Usuario ID: {}", courseIdParam, loggedInUserId);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Formato de ID de curso inválido.");
        } catch (Exception e) {
            logger.error("Error al obtener detalles del curso ID: {} para usuario ID: {}", courseIdParam, loggedInUserId, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno al cargar el curso.");
        }
    }

    // Método para inyectar el servicio en tests (opcional)
    public void setCursoService(CursoService cursoService) {
        this.cursoService = cursoService;
    }
}