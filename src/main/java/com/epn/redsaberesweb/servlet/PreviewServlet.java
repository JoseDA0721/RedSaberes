package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.dto.CourseDetailDTO;
import com.epn.redsaberesweb.dto.CursoEstructuraDTO;
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
import java.util.Optional;

@WebServlet(name = "PreviewServlet", urlPatterns = {"/preview-curso"})
public class PreviewServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(PreviewServlet.class);
    private static final String PREVIEW_VIEW = "/WEB-INF/vistas/preview-curso.jsp";

    private CursoService cursoService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.cursoService = new CursoService(new CursoRepository());
        } catch (Exception e) {
            logger.error("Error inicializando PreviewServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de cursos", e);
        }
    }

    void setCursoService(CursoService cursoService) {
        this.cursoService = cursoService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long usuarioId = (Long) session.getAttribute("userId");
        String cursoIdParam = request.getParameter("cursoId");
        if (cursoIdParam == null || cursoIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El ID del curso es obligatorio.");
            return;
        }

        Long cursoId;
        try {
            cursoId = Long.parseLong(cursoIdParam.trim());
            if (cursoId <= 0) {
                throw new NumberFormatException("El ID debe ser positivo");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El ID del curso debe ser un numero valido.");
            return;
        }

        try {
            Optional<CourseDetailDTO> detalleOpt = cursoService.obtenerDetallesCurso(cursoId);
            if (detalleOpt.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "El curso solicitado no existe.");
                return;
            }

            CourseDetailDTO detalle = detalleOpt.get();
            if (!usuarioId.equals(detalle.creadorId())) {
                logger.warn("Intento de previsualizar curso ID: {} por usuario no autorizado ID: {}",
                        cursoId, usuarioId);
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "No tiene permisos para previsualizar este curso.");
                return;
            }

            Optional<CursoEstructuraDTO> estructuraOpt = cursoService.obtenerEstructuraCompleta(cursoId);
            if (estructuraOpt.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "El curso solicitado no existe.");
                return;
            }

            request.setAttribute("cursoEstructura", estructuraOpt.get());
            request.getRequestDispatcher(PREVIEW_VIEW).forward(request, response);
        } catch (RuntimeException e) {
            logger.error("Error al cargar el preview del curso ID: {} para el usuario ID: {}",
                    cursoId, usuarioId, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error interno al cargar la previsualizacion del curso.");
        }
    }
}
