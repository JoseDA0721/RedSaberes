package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.models.Curso;
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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

@WebServlet("/publicar-curso")
public class PublicarCursoServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(PublicarCursoServlet.class);
    private static final String ERROR_VIEW = "/WEB-INF/vistas/dashboard.jsp";

    private CursoService cursoService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.cursoService = new CursoService(new CursoRepository());
        } catch (Exception e) {
            logger.error("Error inicializando PublicarCursoServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de cursos", e);
        }
    }

    void setCursoService(CursoService cursoService) {
        this.cursoService = cursoService;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");
        String cursoIdParam = request.getParameter("cursoId");
        if (cursoIdParam == null || cursoIdParam.trim().isEmpty()) {
            enviarError(request, response, "El ID del curso es obligatorio.");
            return;
        }

        Long cursoId;
        try {
            cursoId = Long.parseLong(cursoIdParam.trim());
        } catch (NumberFormatException e) {
            enviarError(request, response, "El ID del curso debe ser un numero valido.");
            return;
        }

        Optional<Curso> cursoOpt = cursoService.obtenerCurso(cursoId);
        if (cursoOpt.isEmpty()) {
            enviarError(request, response, "El curso solicitado no existe.");
            return;
        }

        Curso curso = cursoOpt.get();
        if (curso.getCreador() == null || !userId.equals(curso.getCreador().getId())) {
            logger.warn("Intento de publicar curso ID: {} por usuario no autorizado ID: {}", cursoId, userId);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tiene permisos para publicar este curso");
            return;
        }

        try {
            cursoService.publicar(cursoId);
            String success = URLEncoder.encode("Curso publicado correctamente", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/courses/detail?id=" + cursoId + "&success=" + success);
        } catch (IllegalStateException e) {
            logger.warn("Error de validacion al publicar curso {} para usuario {}: {}", cursoId, userId, e.getMessage());
            enviarError(request, response, e.getMessage());
        }
    }

    private void enviarError(HttpServletRequest request, HttpServletResponse response, String mensaje)
            throws ServletException, IOException {
        request.setAttribute("error", mensaje);
        request.getRequestDispatcher(ERROR_VIEW).forward(request, response);
    }
}
