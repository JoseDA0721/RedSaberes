package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.repository.CursoRepository;
import com.epn.redsaberesweb.service.CursoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "DetalleCursoPublicoServlet", urlPatterns = {"/curso-publico"})
public class DetalleCursoPublicoServlet extends HttpServlet {

    private CursoService cursoService;

    @Override
    public void init() throws ServletException {
        this.cursoService = new CursoService(new CursoRepository());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null) { res.sendRedirect(req.getContextPath() + "/catalogo"); return; }

        try {
            Long id = Long.parseLong(idParam);
            // Cargar curso con módulos y lecciones (JOIN FETCH)
            Optional<Curso> cursoOpt = cursoService.obtenerCursoPublico(id);
            if (cursoOpt.isEmpty()) { res.sendRedirect(req.getContextPath() + "/catalogo"); return; }

            req.setAttribute("curso", cursoOpt.get());
            req.getRequestDispatcher("/WEB-INF/vistas/detalle-curso-publico.jsp").forward(req, res);
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/catalogo");
        }
    }
}
