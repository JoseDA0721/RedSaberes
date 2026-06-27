package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.models.Usuario;
import com.epn.redsaberesweb.repository.CursoRepository;
import com.epn.redsaberesweb.repository.UsuarioRepository;
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
import java.time.LocalDateTime;
import java.util.Optional;

@WebServlet(name = "CreateCourseServlet", urlPatterns = {"/courses/create"}) // Endpoint corregido
public class CreateCourseServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(CreateCourseServlet.class);

    private CursoService cursoService;
    private UsuarioRepository usuarioRepository; // Necesario para obtener el objeto Usuario completo

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.cursoService = new CursoService(new CursoRepository());
            this.usuarioRepository = new UsuarioRepository();
        } catch (Exception e) {
            logger.error("Error inicializando CreateCourseServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de cursos o usuario", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verificar si el usuario está logueado
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Simplemente reenvía al formulario JSP
        request.getRequestDispatcher("/WEB-INF/vistas/create-course.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Verificar si el usuario está logueado
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");
        Optional<Usuario> creador = usuarioRepository.findById(userId); // Obtener el objeto Usuario completo

        if (creador.isEmpty()) {
            logger.error("Usuario no encontrado para el ID en sesión: {}", userId);
            request.setAttribute("error", "No se pudo encontrar el usuario creador.");
            request.getRequestDispatcher("/WEB-INF/vistas/create-course.jsp").forward(request, response);
            return;
        }

        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String categoria = request.getParameter("categoria");

        // Crear objeto Curso
        Curso nuevoCurso = new Curso();
        nuevoCurso.setTitulo(titulo);
        nuevoCurso.setDescripcion(descripcion);
        nuevoCurso.setCategoria(categoria);
        nuevoCurso.setCreador(creador.get()); // Asignar el usuario creador
        nuevoCurso.setFechaCreacion(LocalDateTime.now()); // Establecer la fecha de creación
        // El estado se establece por defecto en BORRADOR en la entidad Curso

        try {
            cursoService.crearCurso(nuevoCurso);
            logger.info("Curso '{}' creado exitosamente por el usuario ID: {}", titulo, userId);
            response.sendRedirect(request.getContextPath() + "/modulos?cursoId=" + nuevoCurso.getId() + "&success=Curso+creado+exitosamente"); // Redirigir al dashboard
        } catch (IllegalArgumentException e) {
            // Error de validación del servicio
            logger.warn("Error de validación al crear curso para usuario ID {}: {}", userId, e.getMessage());
            request.setAttribute("error", e.getMessage());
            // Mantener los datos ingresados para que el usuario no tenga que reescribir
            request.setAttribute("titulo", titulo);
            request.setAttribute("descripcion", descripcion);
            request.setAttribute("categoria", categoria);
            request.getRequestDispatcher("/WEB-INF/vistas/create-course.jsp").forward(request, response);
        } catch (Exception e) {
            // Otros errores inesperados
            logger.error("Error inesperado al crear curso para usuario ID {}: {}", userId, e.getMessage(), e);
            request.setAttribute("error", "Ocurrió un error al intentar crear el curso. Inténtalo de nuevo.");
            request.getRequestDispatcher("/WEB-INF/vistas/create-course.jsp").forward(request, response);
        }
    }
}
