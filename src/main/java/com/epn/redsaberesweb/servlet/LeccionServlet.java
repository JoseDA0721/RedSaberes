package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.domain.TipoLeccion;
import com.epn.redsaberesweb.models.Leccion;
import com.epn.redsaberesweb.models.Modulo;
import com.epn.redsaberesweb.repository.LeccionRepository;
import com.epn.redsaberesweb.repository.ModuloRepository;
import com.epn.redsaberesweb.service.LeccionService;
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

@WebServlet(name = "LeccionServlet", urlPatterns = {"/lecciones"})
public class LeccionServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LeccionServlet.class);
    private static final String LECCIONES_VIEW = "/WEB-INF/vistas/gestion-lecciones.jsp";

    private LeccionService leccionService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.leccionService = new LeccionService(
                    new LeccionRepository(),
                    new ModuloRepository()
            );
        } catch (Exception e) {
            logger.error("Error inicializando LeccionServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de lecciones", e);
        }
    }

    /**
     * Maneja peticiones GET para listar lecciones de un módulo.
     * Parámetro requerido: moduloId
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long loggedInUserId = (Long) session.getAttribute("userId");
        String moduloIdParam = request.getParameter("moduloId");

        if (moduloIdParam == null || moduloIdParam.trim().isEmpty()) {
            logger.warn("Solicitud de lecciones sin moduloId. Usuario ID: {}", loggedInUserId);
            request.setAttribute("error", "El ID del módulo es requerido.");
            forwardToLecciones(request, response, null);
            return;
        }

        try {
            Long moduloId = Long.parseLong(moduloIdParam);
            cargarDatosVistaLecciones(request, moduloId);
            String cursoIdParam = request.getParameter("cursoId");
            if (cursoIdParam != null && request.getAttribute("cursoId") == null) {
                request.setAttribute("cursoId", Long.parseLong(cursoIdParam));
            }
            request.getRequestDispatcher(LECCIONES_VIEW).forward(request, response);

        } catch (NumberFormatException e) {
            logger.warn("ID de módulo inválido: {}. Usuario ID: {}", moduloIdParam, loggedInUserId);
            request.setAttribute("error", "Formato de ID de módulo inválido.");
            forwardToLecciones(request, response, null);
        } catch (IllegalArgumentException e) {
            logger.warn("Validación fallida al listar lecciones: {}. Usuario ID: {}", e.getMessage(), loggedInUserId);
            request.setAttribute("error", e.getMessage());
            forwardToLecciones(request, response, null);
        } catch (Exception e) {
            logger.error("Error al listar lecciones del módulo {} para usuario ID: {}", moduloIdParam, loggedInUserId, e);
            request.setAttribute("error", "Error interno al cargar las lecciones.");
            forwardToLecciones(request, response, null);
        }
    }

    /**
     * Maneja peticiones POST para operaciones sobre lecciones.
     * Parámetro requerido: accion (crear, editar, eliminar, reordenar)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long loggedInUserId = (Long) session.getAttribute("userId");
        String accion = request.getParameter("accion");

        if (accion == null || accion.trim().isEmpty()) {
            logger.warn("Solicitud POST sin acción. Usuario ID: {}", loggedInUserId);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "La acción es requerida.");
            return;
        }

        try {
            switch (accion.toLowerCase()) {
                case "crear":
                    handleCrear(request, response, loggedInUserId);
                    break;
                case "editar":
                    handleEditar(request, response, loggedInUserId);
                    break;
                case "eliminar":
                    handleEliminar(request, response, loggedInUserId);
                    break;
                case "reordenar":
                    handleReordenar(request, response, loggedInUserId);
                    break;
                default:
                    logger.warn("Acción desconocida: {}. Usuario ID: {}", accion, loggedInUserId);
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida: " + accion);
            }
        } catch (Exception e) {
            logger.error("Error procesando acción '{}' para usuario ID: {}", accion, loggedInUserId, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno al procesar la solicitud.");
        }
    }

    /**
     * Maneja la creación de una nueva lección.
     */
    private void handleCrear(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws IOException {
        try {
            String moduloIdParam = request.getParameter("moduloId");
            String titulo = request.getParameter("titulo");
            String ordenParam = request.getParameter("orden");
            String tipoParam = request.getParameter("tipo"); // NUEVO

            // ...validaciones existentes...

            Long moduloId = Long.parseLong(moduloIdParam);
            int orden = Integer.parseInt(ordenParam);

            Modulo modulo = new Modulo();
            modulo.setId(moduloId);

            Leccion nuevaLeccion = new Leccion();
            nuevaLeccion.setModulo(modulo);
            nuevaLeccion.setTitulo(titulo.trim());
            nuevaLeccion.setOrden(orden);

            // NUEVO: asignar tipo si viene del formulario
            if (tipoParam != null && !tipoParam.trim().isEmpty()) {
                try {
                    nuevaLeccion.setTipo(TipoLeccion.valueOf(tipoParam.trim().toUpperCase()));
                } catch (IllegalArgumentException e) {
                    nuevaLeccion.setTipo(TipoLeccion.VIDEO); // fallback
                }
            }

            leccionService.crearLeccion(nuevaLeccion);
            response.sendRedirect(request.getContextPath() + "/lecciones?moduloId=" + moduloId);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            forwardToLecciones(request, response, obtenerModuloIdDesdeRequest(request));
        }
    }

    private void forwardToLecciones(HttpServletRequest request, HttpServletResponse response, Long moduloId) throws IOException {
        try {
            if (moduloId != null) {
                cargarDatosVistaLecciones(request, moduloId);
            }
            request.getRequestDispatcher(LECCIONES_VIEW).forward(request, response);
        } catch (ServletException e) {
            logger.error("Error al hacer forward a gestion-lecciones.jsp", e);
            throw new IOException("Error en forward", e);
        } catch (IllegalArgumentException e) {
            logger.warn("No se pudo cargar la vista de lecciones para moduloId={}: {}", moduloId, e.getMessage());
            request.setAttribute("error", e.getMessage());
            try {
                request.getRequestDispatcher(LECCIONES_VIEW).forward(request, response);
            } catch (ServletException ex) {
                logger.error("Error al hacer forward de recuperación a gestion-lecciones.jsp", ex);
                throw new IOException("Error en forward", ex);
            }
        }
    }

    /**
     * Maneja la edición de una lección existente.
     */
    private void handleEditar(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws IOException {
        try {
            String leccionIdParam = request.getParameter("leccionId");
            String titulo = request.getParameter("titulo");
            String tipoParam = request.getParameter("tipo"); // NUEVO

            if (leccionIdParam == null || leccionIdParam.trim().isEmpty())
                throw new IllegalArgumentException("El ID de la lección es obligatorio.");
            if (titulo == null || titulo.trim().isEmpty())
                throw new IllegalArgumentException("El título es obligatorio.");

            Long leccionId = Long.parseLong(leccionIdParam);
            Leccion leccion = leccionService.obtenerLeccion(leccionId);
            leccion.setTitulo(titulo.trim());

            // NUEVO: actualizar tipo si viene del formulario
            if (tipoParam != null && !tipoParam.trim().isEmpty()) {
                try {
                    leccion.setTipo(TipoLeccion.valueOf(tipoParam.trim().toUpperCase()));
                } catch (IllegalArgumentException e) {
                    // tipo inválido: mantener el actual
                }
            }

            leccionService.editarLeccion(leccion);
            Long moduloId = leccion.getModulo().getId();
            response.sendRedirect(request.getContextPath() + "/lecciones?moduloId=" + moduloId);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            forwardToLecciones(request, response, obtenerModuloIdDesdeRequest(request));
        }
    }

    /**
     * Maneja la eliminación de una lección.
     */
    private void handleEliminar(HttpServletRequest request, HttpServletResponse response, Long userId) throws IOException {
        try {
            String leccionIdParam = request.getParameter("leccionId");
            String moduloIdParam = request.getParameter("moduloId");

            if (leccionIdParam == null || leccionIdParam.trim().isEmpty()) {
                throw new IllegalArgumentException("El ID de la lección es obligatorio.");
            }

            Long leccionId = Long.parseLong(leccionIdParam);
            Long moduloId = moduloIdParam != null ? Long.parseLong(moduloIdParam) : null;

            leccionService.eliminarLeccion(leccionId);

            logger.info("Lección eliminada exitosamente. ID: {}. Usuario ID: {}", leccionId, userId);
            
            if (moduloId != null) {
                response.sendRedirect(request.getContextPath() + "/lecciones?moduloId=" + moduloId);
            } else {
                response.sendRedirect(request.getContextPath() + "/courses");
            }

        } catch (NumberFormatException e) {
            logger.warn("Formato de número inválido: {}", e.getMessage());
            request.setAttribute("error", "Formato de número inválido.");
            forwardToLecciones(request, response, obtenerModuloIdDesdeRequest(request));
        } catch (IllegalArgumentException e) {
            logger.warn("Validación fallida al eliminar lección: {}", e.getMessage());
            request.setAttribute("error", e.getMessage());
            forwardToLecciones(request, response, obtenerModuloIdDesdeRequest(request));
        }
    }

    /**
     * Maneja la reordenación de una lección.
     */
    private void handleReordenar(HttpServletRequest request, HttpServletResponse response, Long userId) throws IOException {
        try {
            String leccionIdParam = request.getParameter("leccionId");
            String nuevoOrdenParam = request.getParameter("nuevoOrden");
            String moduloIdParam = request.getParameter("moduloId");

            if (leccionIdParam == null || leccionIdParam.trim().isEmpty()) {
                throw new IllegalArgumentException("El ID de la lección es obligatorio.");
            }
            if (nuevoOrdenParam == null || nuevoOrdenParam.trim().isEmpty()) {
                throw new IllegalArgumentException("El nuevo orden es obligatorio.");
            }

            Long leccionId = Long.parseLong(leccionIdParam);
            int nuevoOrden = Integer.parseInt(nuevoOrdenParam);
            Long moduloId = moduloIdParam != null ? Long.parseLong(moduloIdParam) : null;

            leccionService.reordenarLeccion(leccionId, nuevoOrden);

            logger.info("Lección reordenada exitosamente. ID: {}, nuevo orden: {}. Usuario ID: {}", leccionId, nuevoOrden, userId);
            
            if (moduloId != null) {
                response.sendRedirect(request.getContextPath() + "/lecciones?moduloId=" + moduloId);
            } else {
                response.sendRedirect(request.getContextPath() + "/courses");
            }

        } catch (NumberFormatException e) {
            logger.warn("Formato de número inválido: {}", e.getMessage());
            request.setAttribute("error", "Formato de número inválido.");
            forwardToLecciones(request, response, obtenerModuloIdDesdeRequest(request));
        } catch (IllegalArgumentException e) {
            logger.warn("Validación fallida al reordenar lección: {}", e.getMessage());
            request.setAttribute("error", e.getMessage());
            forwardToLecciones(request, response, obtenerModuloIdDesdeRequest(request));
        }
    }

    private void cargarDatosVistaLecciones(HttpServletRequest request, Long moduloId) {
        Modulo modulo    = leccionService.obtenerModulo(moduloId);
        List<Leccion> lecciones = leccionService.listarLeccionesPorModulo(moduloId);

        request.setAttribute("modulo",    modulo);
        request.setAttribute("moduloId",  moduloId);
        request.setAttribute("lecciones", lecciones);

        // ← NUEVO: exponer cursoId y cursoTitulo para el botón "Contenido"
        if (modulo != null && modulo.getCurso() != null) {
            request.setAttribute("cursoId",     modulo.getCurso().getId());
            request.setAttribute("cursoTitulo", modulo.getCurso().getTitulo());
        } else {
            // Fallback desde parámetro URL si la relación lazy no cargó
            String cursoIdParam = request.getParameter("cursoId");
            if (cursoIdParam != null) {
                try { request.setAttribute("cursoId", Long.parseLong(cursoIdParam)); }
                catch (NumberFormatException ignored) {}
            }
        }
    }

    private Long obtenerModuloIdDesdeRequest(HttpServletRequest request) {
        String moduloIdParam = request.getParameter("moduloId");
        if (moduloIdParam == null || moduloIdParam.trim().isEmpty()) {
            return null;
        }
        try {
            return Long.parseLong(moduloIdParam);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
