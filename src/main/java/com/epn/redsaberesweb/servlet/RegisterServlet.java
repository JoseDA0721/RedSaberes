package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.models.Usuario;
import com.epn.redsaberesweb.repository.UsuarioRepository;
import com.epn.redsaberesweb.service.AuthService;
import com.epn.redsaberesweb.util.HibernateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.SessionFactory;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(RegisterServlet.class);

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();

        try {
            SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
            UsuarioRepository usuarioRepository = new UsuarioRepository(sessionFactory);
            this.authService = new AuthService(usuarioRepository);
        } catch (Exception e) {
            logger.error("Error inicializando RegisterServlet", e);
            throw new ServletException("No se pudo inicializar el servlet de registro", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/vistas/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String correo = request.getParameter("correo");
            String password = request.getParameter("password");
            String confirmarPassword = request.getParameter("confirmarPassword");

            Usuario usuarioRegistrado = authService.register(
                    nombre,
                    apellido,
                    correo,
                    password,
                    confirmarPassword
            );

            if (usuarioRegistrado == null) {
                request.setAttribute("error", "No se pudo completar el registro. Verifica los datos ingresados.");
                request.getRequestDispatcher("/WEB-INF/vistas/register.jsp")
                        .forward(request, response);
                return;
            }

            request.getSession().setAttribute(
                    "success",
                    "Registro exitoso. Ahora puedes iniciar sesión."
            );
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (Exception e) {
            logger.error("Error en RegisterServlet", e);
            request.setAttribute("error", "Ocurrió un error al registrar el usuario.");
            request.getRequestDispatcher("/WEB-INF/vistas/register.jsp")
                    .forward(request, response);
        }
    }
}