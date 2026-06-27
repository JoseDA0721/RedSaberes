package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.models.Modulo;
import com.epn.redsaberesweb.repository.CursoRepository;
import com.epn.redsaberesweb.repository.ModuloRepository;
import com.epn.redsaberesweb.service.CursoService;
import com.epn.redsaberesweb.service.ModuloService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ModuloServlet", urlPatterns = {"/modulos"})
public class ModuloServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(ModuloServlet.class);
    private ModuloService moduloService;
    private CursoService cursoService;
    private final ModuloRepository moduloRepository = new ModuloRepository();
    private final CursoRepository cursoRepository = new CursoRepository();

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.moduloService = new ModuloService(moduloRepository, cursoRepository);
            this.cursoService = new CursoService(cursoRepository);
        } catch (Exception e) {
            logger.error("Error inicializando ModuloServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de módulos", e);
        }
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String cursoIdParam = request.getParameter("cursoId");

        if(cursoIdParam == null || cursoIdParam.trim().isEmpty()){
            logger.warn("Solicitud GET a /modulos sin cursoId. Usuario ID: {}", session.getAttribute("userId"));
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de curso es requerido.");
            return;
        }

        try{
            Long cursoId = Long.parseLong(cursoIdParam);
            Optional<Curso> cursoOpt = cursoService.obtenerCurso(cursoId);
            if(cursoOpt.isEmpty()){
                logger.warn("Curso no encontrado para ID: {} al listar módulos. Usuario ID: {}", cursoId, session.getAttribute("userId"));
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Curso solicitado no existe.");
                return;
            }
            Curso curso = cursoOpt.get();
            List<Modulo> modulos = moduloService.listarModulosPorCurso(cursoId);

            request.setAttribute("modulos", modulos);
            request.setAttribute("cursoId", cursoId);
            request.setAttribute("cursoTitulo", curso.getTitulo());
            request.getRequestDispatcher("/WEB-INF/vistas/gestion-modulos.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            logger.warn("ID de curso inválido en GET /modulos: {}. Usuario ID: {}", cursoIdParam, session.getAttribute("userId"));
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Formato de ID de curso inválido.");
        } catch (IllegalArgumentException e) {
            logger.error("Error de validación al listar módulos: {}", e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            logger.error("Error al listar módulos para curso ID: {} para usuario ID: {}", cursoIdParam, session.getAttribute("userId"), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno al listar módulos.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String cursoIdParam = request.getParameter("cursoId"); // Necesario para redireccionar

        if (cursoIdParam == null || cursoIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de curso requerido para operaciones de módulo.");
            return;
        }
        Long cursoId;
        try {
            cursoId = Long.parseLong(cursoIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Formato de ID de curso inválido.");
            return;
        }

        try {
            switch (action != null ? action : "") {
                case "crear":
                    handleCrearModulo(request, response, cursoId);
                    break;
                case "editar":
                    handleEditarModulo(request, response, cursoId);
                    break;
                case "eliminar":
                    handleEliminarModulo(request, response, cursoId);
                    break;
                case "reordenar":
                    handleReordenarModulo(request, response, cursoId);
                    break;
                default:
                    logger.warn("Acción POST desconocida: {}. Usuario ID: {}", action, session.getAttribute("userId"));
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida.");
                    break;
            }
        } catch (IllegalArgumentException e) {
            logger.error("Error de validación en acción '{}': {}", action, e.getMessage());
            request.setAttribute("error", e.getMessage());
            // Redireccionar de vuelta a la página de módulos con el error
            response.sendRedirect(request.getContextPath() + "/modulos?cursoId=" + cursoId + "&error=" + e.getMessage());
        } catch (Exception e) {
            logger.error("Error en acción '{}' para curso ID: {} para usuario ID: {}", action, cursoId, session.getAttribute("userId"), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno al procesar la solicitud.");
        }
    }

    private void handleCrearModulo(HttpServletRequest request, HttpServletResponse response, Long cursoId)
            throws IOException {
        String titulo = request.getParameter("titulo");
        String ordenParam = request.getParameter("orden");
        Optional<Curso> curso = cursoRepository.findById(cursoId);
        Modulo nuevoModulo = new Modulo();
        nuevoModulo.setTitulo(titulo);
        nuevoModulo.setCurso(curso.get());

        if (ordenParam != null && !ordenParam.trim().isEmpty()) {
            try {
                nuevoModulo.setOrden(Integer.parseInt(ordenParam));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("El formato del orden es inválido.");
            }
        } else {
            // Lógica para asignar un orden por defecto si no se especifica
            // Por ejemplo, encontrar el último orden y sumarle 1.
            // Para simplificar, si no viene, el servicio podría manejarlo o lanzar error.
            // Aquí asumimos que el servicio lo validará o asignará.
        }

        moduloService.crearModulo(nuevoModulo);
        response.sendRedirect(request.getContextPath() + "/modulos?cursoId=" + cursoId + "&success=Modulo creado exitosamente.");
    }

    private void handleEditarModulo(HttpServletRequest request, HttpServletResponse response, Long cursoId)
            throws IOException{
        String moduloIdParam = request.getParameter("moduloId");
        String titulo = request.getParameter("titulo");
        String ordenParam = request.getParameter("orden");

        if (moduloIdParam == null || moduloIdParam.trim().isEmpty()) {
            throw new IllegalArgumentException("ID de módulo requerido para editar.");
        }
        Long moduloId = Long.parseLong(moduloIdParam);
        Optional<Curso> curso = cursoRepository.findById(cursoId);
        Modulo moduloAEditar = new Modulo();
        moduloAEditar.setId(moduloId);
        moduloAEditar.setTitulo(titulo);
        moduloAEditar.setCurso(curso.get()); // Asegurar que el curso está asociado

        if (ordenParam != null && !ordenParam.trim().isEmpty()) {
            try {
                moduloAEditar.setOrden(Integer.parseInt(ordenParam));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("El formato del orden es inválido.");
            }
        } else {
            // Si el orden no se especifica, se podría mantener el orden existente
            // o lanzar una excepción si es obligatorio.
            // Por ahora, el servicio lo validará.
        }

        moduloService.editarModulo(moduloAEditar);
        response.sendRedirect(request.getContextPath() + "/modulos?cursoId=" + cursoId + "&success=Modulo actualizado exitosamente.");
    }

    private void handleEliminarModulo(HttpServletRequest request, HttpServletResponse response, Long cursoId)
            throws IOException{
        String moduloIdParam = request.getParameter("moduloId");

        if (moduloIdParam == null || moduloIdParam.trim().isEmpty()) {
            throw new IllegalArgumentException("ID de módulo requerido para eliminar.");
        }
        Long moduloId = Long.parseLong(moduloIdParam);

        moduloService.eliminarModulo(moduloId);
        response.sendRedirect(request.getContextPath() + "/modulos?cursoId=" + cursoId + "&success=Modulo eliminado exitosamente.");
    }

    private void handleReordenarModulo(HttpServletRequest request, HttpServletResponse response, Long cursoId)
            throws IOException{
        String moduloIdParam = request.getParameter("moduloId");
        String nuevoOrdenParam = request.getParameter("nuevoOrden");

        if (moduloIdParam == null || moduloIdParam.trim().isEmpty()) {
            throw new IllegalArgumentException("ID de módulo requerido para reordenar.");
        }
        if (nuevoOrdenParam == null || nuevoOrdenParam.trim().isEmpty()) {
            throw new IllegalArgumentException("Nuevo orden requerido para reordenar.");
        }

        Long moduloId = Long.parseLong(moduloIdParam);
        int nuevoOrden = Integer.parseInt(nuevoOrdenParam);

        moduloService.reordenarModulo(moduloId, nuevoOrden);
        response.sendRedirect(request.getContextPath() + "/modulos?cursoId=" + cursoId + "&success=Módulo reordenado exitosamente.");
    }
}
