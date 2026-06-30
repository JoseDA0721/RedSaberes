package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.dto.CursoResumeDTO;
import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.repository.CursoRepository;
import com.epn.redsaberesweb.service.CursoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CatalogoServlet", urlPatterns = {"/catalogo"})
public class CatalogoServlet extends HttpServlet {

    private CursoService cursoService;

    @Override
    public void init() throws ServletException {
        this.cursoService = new CursoService(new CursoRepository());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // No requiere sesión — es vista pública
        List<CursoResumeDTO> cursos = cursoService.listarCursosPublicados();
        req.setAttribute("cursos", cursos);
        req.getRequestDispatcher("/WEB-INF/vistas/catalogo.jsp").forward(req, res);
    }
}