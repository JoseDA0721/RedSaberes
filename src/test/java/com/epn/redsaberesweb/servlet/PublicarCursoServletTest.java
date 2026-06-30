package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.models.Usuario;
import com.epn.redsaberesweb.service.CursoService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.io.IOException;
import java.util.Optional;

import static org.mockito.Mockito.anyLong;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class PublicarCursoServletTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher dispatcher;

    @Mock
    private CursoService cursoService;

    private PublicarCursoServlet servlet;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        servlet = new PublicarCursoServlet();
        servlet.setCursoService(cursoService);
    }

    @Test
    void doPost_publicacionExitosa_publicaYRedirigeADetalleConSuccess()
            throws ServletException, IOException {
        Long cursoId = 1L;
        autenticarUsuario(10L);
        when(request.getParameter("cursoId")).thenReturn(cursoId.toString());
        when(request.getContextPath()).thenReturn("/redsaberes");
        when(cursoService.obtenerCurso(cursoId)).thenReturn(Optional.of(cursoDeCreador(10L)));

        servlet.doPost(request, response);

        verify(cursoService).publicar(cursoId);
        verify(response).sendRedirect("/redsaberes/courses/detail?id=1&success=Curso+publicado+correctamente");
    }

    @Test
    void doPost_usuarioNoAutenticado_redirigeALogin() throws ServletException, IOException {
        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/redsaberes");

        servlet.doPost(request, response);

        verify(response).sendRedirect("/redsaberes/login");
        verify(cursoService, never()).publicar(anyLong());
    }

    @Test
    void doPost_cursoNoPerteneceAlInstructor_respondeForbidden()
            throws ServletException, IOException {
        Long cursoId = 2L;
        autenticarUsuario(10L);
        when(request.getParameter("cursoId")).thenReturn(cursoId.toString());
        when(cursoService.obtenerCurso(cursoId)).thenReturn(Optional.of(cursoDeCreador(20L)));

        servlet.doPost(request, response);

        verify(response).sendError(HttpServletResponse.SC_FORBIDDEN, "No tiene permisos para publicar este curso");
        verify(cursoService, never()).publicar(anyLong());
    }

    @Test
    void doPost_cursoSinModulos_enviaMensajeError() throws ServletException, IOException {
        validaErrorDeService("El curso no tiene modulos");
    }

    @Test
    void doPost_moduloSinLecciones_enviaMensajeError() throws ServletException, IOException {
        validaErrorDeService("Existe un modulo sin lecciones");
    }

    @Test
    void doPost_leccionSinContenido_enviaMensajeError() throws ServletException, IOException {
        validaErrorDeService("Existen lecciones sin contenido");
    }

    private void validaErrorDeService(String mensaje) throws ServletException, IOException {
        Long cursoId = 3L;
        autenticarUsuario(10L);
        when(request.getParameter("cursoId")).thenReturn(cursoId.toString());
        when(cursoService.obtenerCurso(cursoId)).thenReturn(Optional.of(cursoDeCreador(10L)));
        doThrow(new IllegalStateException(mensaje)).when(cursoService).publicar(cursoId);
        when(request.getRequestDispatcher("/WEB-INF/vistas/dashboard.jsp")).thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request).setAttribute("error", mensaje);
        verify(dispatcher).forward(request, response);
    }

    private void autenticarUsuario(Long userId) {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("userId")).thenReturn(userId);
    }

    private Curso cursoDeCreador(Long creadorId) {
        Usuario creador = new Usuario();
        creador.setId(creadorId);
        Curso curso = new Curso();
        curso.setCreador(creador);
        return curso;
    }
}
