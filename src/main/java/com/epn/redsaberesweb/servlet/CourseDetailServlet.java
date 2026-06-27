package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.dto.CourseDetailDTO;
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
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@WebServlet(name = "CourseDetailServlet", urlPatterns = {"/courses/detail"})
public class CourseDetailServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(CourseDetailServlet.class);

    private CursoService cursoService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.cursoService = new CursoService(new CursoRepository());
        } catch (Exception e) {
            logger.error("Error inicializando CourseDetailServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de cursos", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

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
            Optional<CourseDetailDTO> curso= cursoService.obtenerDetallesCurso(courseId);

            if (curso.isEmpty()) {
                logger.warn("Curso no encontrado para ID: {}. Usuario ID: {}", courseId, loggedInUserId);
                request.setAttribute("error", "El curso solicitado no existe.");
                request.getRequestDispatcher("/WEB-INF/vistas/course-detail.jsp").forward(request, response);
                return;
            }

            CourseDetailDTO cursoDetail = curso.get();
            System.out.println("Creador del curso: " + cursoDetail.creadorId() + ". Usuario ID: " + loggedInUserId + ".");
            if (!cursoDetail.creadorId().equals(loggedInUserId)) {
                logger.warn("Intento de acceso no autorizado al curso ID: {} por usuario ID: {}", courseId, loggedInUserId);
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permiso para ver este curso.");
                return;
            }

            if (cursoDetail.fechaCreacion() != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                request.setAttribute("fechaCreacionFormateada", cursoDetail.fechaCreacion().format(formatter));
            } else {
                request.setAttribute("fechaCreacionFormateada", "N/A");
            }

            request.setAttribute("curso", cursoDetail);
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
}