package com.epn.redsaberesweb.servlet;

import com.epn.redsaberesweb.domain.EstadoCurso;
import com.epn.redsaberesweb.dto.CourseDetailDTO;
import com.epn.redsaberesweb.dto.CursoEstructuraDTO;
import com.epn.redsaberesweb.service.CursoService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PreviewServletTest {

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

    private PreviewServlet servlet;

    @BeforeEach
    void setUp() {
        servlet = new PreviewServlet();
        servlet.setCursoService(cursoService);
    }

    @Test
    void doGet_cursoDelInstructor_cargaEstructuraYEnviaALaVista()
            throws ServletException, IOException {
        autenticar(10L);
        when(request.getParameter("cursoId")).thenReturn("1");
        when(cursoService.obtenerDetallesCurso(1L)).thenReturn(Optional.of(detalle(1L, 10L)));
        CursoEstructuraDTO estructura = estructura(1L, 10L);
        when(cursoService.obtenerEstructuraCompleta(1L)).thenReturn(Optional.of(estructura));
        when(request.getRequestDispatcher("/WEB-INF/vistas/preview-curso.jsp")).thenReturn(dispatcher);

        servlet.doGet(request, response);

        InOrder orden = inOrder(cursoService);
        orden.verify(cursoService).obtenerDetallesCurso(1L);
        orden.verify(cursoService).obtenerEstructuraCompleta(1L);
        verify(request).setAttribute("cursoEstructura", estructura);
        verify(dispatcher).forward(request, response);
    }

    @Test
    void doGet_sinSesion_redirigeALogin() throws ServletException, IOException {
        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/redsaberes");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/redsaberes/login");
        verify(cursoService, never()).obtenerEstructuraCompleta(1L);
    }

    @Test
    void doGet_sinCursoId_respondeBadRequest() throws ServletException, IOException {
        autenticar(10L);

        servlet.doGet(request, response);

        verify(response).sendError(HttpServletResponse.SC_BAD_REQUEST,
                "El ID del curso es obligatorio.");
        verify(cursoService, never()).obtenerDetallesCurso(1L);
    }

    @Test
    void doGet_cursoIdInvalido_respondeBadRequest() throws ServletException, IOException {
        autenticar(10L);
        when(request.getParameter("cursoId")).thenReturn("abc");

        servlet.doGet(request, response);

        verify(response).sendError(HttpServletResponse.SC_BAD_REQUEST,
                "El ID del curso debe ser un numero valido.");
    }

    @Test
    void doGet_cursoNoExiste_respondeNotFound() throws ServletException, IOException {
        autenticar(10L);
        when(request.getParameter("cursoId")).thenReturn("99");
        when(cursoService.obtenerDetallesCurso(99L)).thenReturn(Optional.empty());

        servlet.doGet(request, response);

        verify(response).sendError(HttpServletResponse.SC_NOT_FOUND,
                "El curso solicitado no existe.");
        verify(cursoService, never()).obtenerEstructuraCompleta(99L);
    }

    @Test
    void doGet_cursoDeOtroInstructor_respondeForbiddenSinCargarEstructura()
            throws ServletException, IOException {
        autenticar(10L);
        when(request.getParameter("cursoId")).thenReturn("2");
        when(cursoService.obtenerDetallesCurso(2L)).thenReturn(Optional.of(detalle(2L, 20L)));

        servlet.doGet(request, response);

        verify(response).sendError(HttpServletResponse.SC_FORBIDDEN,
                "No tiene permisos para previsualizar este curso.");
        verify(cursoService, never()).obtenerEstructuraCompleta(2L);
    }

    private void autenticar(Long usuarioId) {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("userId")).thenReturn(usuarioId);
    }

    private CourseDetailDTO detalle(Long cursoId, Long creadorId) {
        return new CourseDetailDTO(
                cursoId,
                "Curso",
                "Descripcion",
                "Categoria",
                EstadoCurso.BORRADOR,
                LocalDateTime.of(2026, 6, 29, 10, 0),
                "Ana",
                "Perez",
                creadorId
        );
    }

    private CursoEstructuraDTO estructura(Long cursoId, Long creadorId) {
        return new CursoEstructuraDTO(
                cursoId,
                "Curso",
                "Descripcion",
                "Categoria",
                EstadoCurso.BORRADOR,
                LocalDateTime.of(2026, 6, 29, 10, 0),
                "Ana",
                "Perez",
                creadorId,
                List.of(),
                0,
                0
        );
    }
}
