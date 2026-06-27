package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.models.Usuario;
import com.epn.redsaberesweb.repository.UsuarioRepository;
import com.epn.redsaberesweb.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LoginServlet.class);

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            UsuarioRepository usuarioRepository = new UsuarioRepository();
            this.authService = new com.epn.redsaberesweb.service.AuthService(usuarioRepository);
        } catch (Exception e) {
            logger.error("Error inicializando LoginServlet", e);
            throw new ServletException("No se pudo inicializar el servicio de autenticación", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/vistas/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            // PASO 1: Obtener parámetros del formulario
            String correo = request.getParameter("correo");
            String password = request.getParameter("password");

            // PASO 2: Validar parámetros
            if (!validarParametros(correo, password, request, response)) {
                return;
            }

            // PASO 3: Invocar AuthService
            Usuario usuarioAutenticado = autenticar(
                    request,
                    correo,
                    password,
                    response
            );

            if (usuarioAutenticado == null) {
                return; // El método autenticar ya maneja la respuesta de error
            }

            // PASO 4: Crear sesión cuando la autenticación sea exitosa
            crearSesion(request, usuarioAutenticado, response);

        } catch (Exception e) {
            logger.error("Error en LoginServlet", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
            response.setContentType("application/json");
            try (PrintWriter writer = response.getWriter()) {
                writer.write("{\"error\": \"Error interno del servidor\"}");
            }
        }
    }

    /**
     * Valida que los parámetros requeridos no estén vacíos o nulos
     */
    private boolean validarParametros(String correo, String password,
                                      HttpServletRequest request,
                                      HttpServletResponse response) throws ServletException, IOException {
        StringBuilder errores = new StringBuilder();
        if (correo == null || correo.trim().isEmpty()) errores.append("Correo requerido. ");
        if (password == null || password.trim().isEmpty()) errores.append("Contraseña requerida.");
        if (!errores.isEmpty()) {
            request.setAttribute("error", errores.toString().trim());
            request.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(request, response);
            logger.warn("Validación fallida: {}", errores.toString());
            return false;
        }
        return true;
    }

    /**
     * Invoca el servicio de autenticación.
     */
    private Usuario autenticar(HttpServletRequest request,
                               String correo,
                               String password,
                               HttpServletResponse response) throws IOException {

        try {
            if (authService == null) {
                logger.error("AuthService no está inicializado");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                try (PrintWriter writer = response.getWriter()) {
                    writer.write("{\"error\": \"Servicio de autenticación no disponible\"}");
                }
                return null;
            }

            Usuario usuario = authService.login(correo, password);

            if (usuario == null) {
                request.setAttribute(
                        "error",
                        "Correo o contraseña incorrectos"
                );
                request.getRequestDispatcher("/WEB-INF/vistas/login.jsp")
                        .forward(request, response);
                logger.warn("Autenticación fallida para: {}", correo);
                return null;
            }

            return usuario;

        } catch (Exception e) {
            logger.error("Error durante autenticación", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            try (PrintWriter writer = response.getWriter()) {
                writer.write("{\"error\": \"Error durante autenticación\"}");
            }
            return null;
        }
    }

    /**
     * Crea la sesión del usuario autenticado.
     */
    private void crearSesion(HttpServletRequest request, Usuario usuario,
                            HttpServletResponse response) throws IOException {

        try {
            HttpSession old = request.getSession(false);
            if (old != null) {
                old.invalidate();
            }
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", usuario.getId());
            session.setAttribute("userName", usuario.getNombres());
            session.setAttribute("userEmail", usuario.getCorreo());

            response.sendRedirect(request.getContextPath() + "/dashboard");
            logger.info("Sesión creada para usuario: {}", usuario.getCorreo());

        } catch (Exception e) {
            logger.error("Error al crear sesión", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            try (PrintWriter writer = response.getWriter()) {
                writer.write("{\"error\": \"Error al crear sesión\"}");
            }
        }
    }
}
