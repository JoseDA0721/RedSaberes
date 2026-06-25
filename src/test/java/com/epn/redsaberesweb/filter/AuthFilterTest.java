package com.epn.redsaberesweb.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AuthFilterTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private FilterChain chain;

    private AuthFilter authFilter;

    /**
     * Configura el filtro antes de cada prueba.
     */
    @BeforeEach
    void setUp() {
        authFilter = new AuthFilter();
    }

    /**
     * PRUEBA 1: Validar que el filtro está registrado para las rutas protegidas.
     */
    @Test
    void authFilter_registradoParaRutasProtegidas() {
        // Act
        WebFilter registro = AuthFilter.class.getAnnotation(WebFilter.class);

        // Assert
        assertNotNull(registro);
        assertEquals("AuthFilter", registro.filterName());
        assertArrayEquals(
                new String[]{"/dashboard", "/dashboard/*"},
                registro.urlPatterns()
        );
    }

    /**
     * PRUEBA 2: Validar que una sesión con usuario permite continuar.
     */
    @Test
    void accesoProtegido_conSesionValida_permiteContinuar()
            throws ServletException, IOException {
        // Arrange
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("userId")).thenReturn(1L);

        // Act
        authFilter.doFilter(request, response, chain);

        // Assert
        verify(request).getSession(false);
        verify(chain).doFilter(request, response);
        verify(response, never()).sendRedirect(anyString());
    }

    /**
     * PRUEBA 3: Validar que una petición sin sesión redirige al login.
     */
    @Test
    void accesoProtegido_sinSesion_redirigeALogin()
            throws ServletException, IOException {
        // Arrange
        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/redsaberes");

        // Act
        authFilter.doFilter(request, response, chain);

        // Assert
        verify(request).getSession(false);
        verify(response).sendRedirect("/redsaberes/login");
        verify(chain, never()).doFilter(request, response);
    }

    /**
     * PRUEBA 4: Validar que una sesión sin usuario redirige al login.
     */
    @Test
    void accesoProtegido_conSesionSinUsuario_redirigeALogin()
            throws ServletException, IOException {
        // Arrange
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("userId")).thenReturn(null);
        when(request.getContextPath()).thenReturn("/redsaberes");

        // Act
        authFilter.doFilter(request, response, chain);

        // Assert
        verify(request).getSession(false);
        verify(response).sendRedirect("/redsaberes/login");
        verify(chain, never()).doFilter(request, response);
    }
}
