package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.models.Leccion;
import com.epn.redsaberesweb.models.Modulo;
import com.epn.redsaberesweb.repository.ContenidoLeccionRepository;
import com.epn.redsaberesweb.repository.LeccionRepository;
import com.epn.redsaberesweb.repository.ModuloRepository;
import com.epn.redsaberesweb.service.ContenidoLeccionService;
import com.epn.redsaberesweb.service.ContenidoLeccionService.ContenidoDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.util.Collection;

@WebServlet(name = "ContenidoLeccionServlet", urlPatterns = {"/contenido-leccion"})
@MultipartConfig(
        maxFileSize      = 5_242_880L,   // 5 MB por archivo
        maxRequestSize   = 26_214_400L,  // 25 MB total (5 imágenes × 5 MB)
        fileSizeThreshold = 1_048_576    // 1 MB antes de escribir en disco temporal
)
public class ContenidoLeccionServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(ContenidoLeccionServlet.class);

    private static final String VISTA         = "/WEB-INF/vistas/contenido-leccion.jsp";
    private static final String PARAM_LECCION = "leccionId";
    private static final String PARAM_IMAGEN  = "imagenId";
    private static final String PARAM_TEXTO   = "texto";
    private static final String PARAM_OP      = "operacion";
    private static final String OP_GUARDAR    = "guardar";
    private static final String OP_ELIMINAR   = "eliminarImagen";

    private ContenidoLeccionService servicio;
    private ModuloRepository        moduloRepo;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            ContenidoLeccionRepository contenidoRepo = new ContenidoLeccionRepository();
            LeccionRepository          leccionRepo   = new LeccionRepository();
            this.servicio   = new ContenidoLeccionService(contenidoRepo, leccionRepo);
            this.moduloRepo = new ModuloRepository();
        } catch (Exception e) {
            logger.error("Error inicializando ContenidoLeccionServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de contenido.", e);
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // GET — cargar contenido actual de la lección
    // ═══════════════════════════════════════════════════════════════════════════

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarSesion(request, response)) return;

        String leccionIdParam = request.getParameter(PARAM_LECCION);
        if (leccionIdParam == null || leccionIdParam.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de lección requerido.");
            return;
        }

        try {
            Long leccionId = Long.parseLong(leccionIdParam);
            cargarVista(request, response, leccionId, null, null);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de lección inválido.");
        } catch (Exception e) {
            logger.error("Error al cargar contenido de lección ID: {}", leccionIdParam, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error al cargar el contenido.");
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // POST — guardar texto + imágenes / eliminar imagen
    // ═══════════════════════════════════════════════════════════════════════════

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarSesion(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String leccionIdParam = request.getParameter(PARAM_LECCION);
        String operacion      = request.getParameter(PARAM_OP);

        if (leccionIdParam == null || leccionIdParam.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de lección requerido.");
            return;
        }

        Long leccionId;
        try {
            leccionId = Long.parseLong(leccionIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de lección inválido.");
            return;
        }

        try {
            switch (operacion != null ? operacion : "") {
                case OP_GUARDAR      -> handleGuardar(request, response, leccionId);
                case OP_ELIMINAR     -> handleEliminarImagen(request, response, leccionId);
                default              -> response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Operación no reconocida: " + operacion);
            }
        } catch (IllegalArgumentException e) {
            // Error de validación de negocio — mostrar en la vista
            logger.warn("Validación fallida en contenido lección ID {}: {}", leccionId, e.getMessage());
            cargarVista(request, response, leccionId, null, e.getMessage());
        } catch (Exception e) {
            logger.error("Error inesperado en POST contenido lección ID: {}", leccionId, e);
            cargarVista(request, response, leccionId, null, "Error interno. Inténtalo de nuevo.");
        }
    }

    // ─── Manejadores de operaciones ───────────────────────────────────────────

    private void handleGuardar(HttpServletRequest request, HttpServletResponse response,
                               Long leccionId) throws ServletException, IOException {

        String               texto   = request.getParameter(PARAM_TEXTO);
        Collection<Part>     partes  = request.getParts(); // todos los Parts del multipart

        // Filtrar solo los Parts de archivo (campo name="imagenes")
        Collection<Part> partesImagen = partes.stream()
                .filter(p -> "imagenes".equals(p.getName()))
                .toList();

        servicio.guardarContenido(leccionId, texto, partesImagen);

        // Redireccionar con mensaje de éxito (PRG pattern)
        response.sendRedirect(request.getContextPath()
                + "/contenido-leccion?" + PARAM_LECCION + "=" + leccionId
                + "&success=Contenido+guardado+exitosamente.");
    }

    private void handleEliminarImagen(HttpServletRequest request, HttpServletResponse response,
                                      Long leccionId) throws ServletException, IOException {

        String imagenIdParam = request.getParameter(PARAM_IMAGEN);
        if (imagenIdParam == null || imagenIdParam.isBlank()) {
            throw new IllegalArgumentException("El ID de la imagen es obligatorio para eliminar.");
        }

        Long imagenId = Long.parseLong(imagenIdParam);
        servicio.eliminarImagen(imagenId, leccionId);

        response.sendRedirect(request.getContextPath()
                + "/contenido-leccion?" + PARAM_LECCION + "=" + leccionId
                + "&success=Imagen+eliminada+correctamente.");
    }

    // ─── Carga de la vista ────────────────────────────────────────────────────

    /**
     * Carga todos los atributos necesarios para la JSP y hace forward.
     */
    private void cargarVista(HttpServletRequest request, HttpServletResponse response,
                             Long leccionId, String success, String error)
            throws ServletException, IOException {

        // Datos de contenido
        ContenidoDTO dto = servicio.obtenerContenido(leccionId);
        request.setAttribute("contenido", dto.getContenido());
        request.setAttribute("imagenes",  dto.getImagenes());

        // Datos de la lección y su módulo/curso para breadcrumb
        cargarContextoLeccion(request, leccionId);

        // Mensajes
        if (success != null) request.setAttribute("success", success);
        if (error   != null) request.setAttribute("error",   error);

        // Constantes de negocio — disponibles en JSP para validación JS
        request.setAttribute("maxCaracteres", ContenidoLeccionService.MAX_CARACTERES_TEXTO);
        request.setAttribute("maxImagenes",   ContenidoLeccionService.MAX_IMAGENES);

        request.getRequestDispatcher(VISTA).forward(request, response);
    }

    /**
     * Carga la lección, su módulo y el ID del curso para el breadcrumb y la vista.
     */
    private void cargarContextoLeccion(HttpServletRequest request, Long leccionId) {
        try {
            // Leccion
            LeccionRepository leccionRepo = new LeccionRepository();
            Leccion leccion = leccionRepo.findById(leccionId)
                    .orElseThrow(() -> new IllegalArgumentException("Lección no encontrada."));
            request.setAttribute("leccion", leccion);

            // Módulo → Curso
            if (leccion.getModulo() != null) {
                Modulo modulo = moduloRepo.findById(leccion.getModulo().getId()).orElse(null);
                if (modulo != null) {
                    request.setAttribute("modulo",      modulo);
                    request.setAttribute("cursoId",     modulo.getCurso().getId());
                    request.setAttribute("cursoTitulo", modulo.getCurso().getTitulo());
                }
            }
        } catch (Exception e) {
            logger.warn("No se pudo cargar el contexto completo para lección ID: {}", leccionId, e);
        }
    }

    // ─── Sesión ───────────────────────────────────────────────────────────────

    private boolean verificarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}