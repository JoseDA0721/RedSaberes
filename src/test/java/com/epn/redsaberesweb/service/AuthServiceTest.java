package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.models.Usuario;
import com.epn.redsaberesweb.repository.UsuarioRepository;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mindrot.jbcrypt.BCrypt;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    private static final String NOMBRE_VALIDO = "Juan";
    private static final String APELLIDO_VALIDO = "Pérez";
    private static final String CORREO_VALIDO = "usuario@example.com";
    private static final String CORREO_INEXISTENTE = "desconocido@example.com";
    private static final String CORREO_DUPLICADO = "existente@example.com";
    private static final String CORREO_INVALIDO = "correo-invalido";
    private static final String PASSWORD_VALIDO = "password123";
    private static final String PASSWORD_INCORRECTO = "passwordIncorrecto";
    private static final String PASSWORD_DEBIL = "abc";
    private static final String PASSWORD_DIFERENTE = "password456";

    @Mock
    private UsuarioRepository usuarioRepository;

    @Mock
    private HttpSession session;

    private AuthService authService;

    @BeforeEach
    void setUp() {
        authService = new AuthService(usuarioRepository);
    }

    // =========================
    // PRUEBAS DE LOGIN
    // =========================

    @Test
    void login_conCredencialesValidas_retornaUsuario() {
        Usuario usuario = usuarioConCredenciales(true);
        when(usuarioRepository.findByCorreo(CORREO_VALIDO)).thenReturn(usuario);

        Usuario resultado = authService.login(CORREO_VALIDO, PASSWORD_VALIDO);

        assertSame(usuario, resultado);
        verify(usuarioRepository).findByCorreo(CORREO_VALIDO);
    }

    @Test
    void login_conCorreoInexistente_retornaNull() {
        when(usuarioRepository.findByCorreo(CORREO_INEXISTENTE)).thenReturn(null);

        Usuario resultado = authService.login(CORREO_INEXISTENTE, PASSWORD_VALIDO);

        assertNull(resultado);
        verify(usuarioRepository).findByCorreo(CORREO_INEXISTENTE);
    }

    @Test
    void login_conUsuarioInactivo_retornaNull() {
        Usuario usuario = usuarioConCredenciales(false);
        when(usuarioRepository.findByCorreo(CORREO_VALIDO)).thenReturn(usuario);

        Usuario resultado = authService.login(CORREO_VALIDO, PASSWORD_VALIDO);

        assertNull(resultado);
        verify(usuarioRepository).findByCorreo(CORREO_VALIDO);
    }

    @Test
    void login_conPasswordIncorrecto_retornaNull() {
        Usuario usuario = usuarioConCredenciales(true);
        when(usuarioRepository.findByCorreo(CORREO_VALIDO)).thenReturn(usuario);

        Usuario resultado = authService.login(CORREO_VALIDO, PASSWORD_INCORRECTO);

        assertNull(resultado);
        verify(usuarioRepository).findByCorreo(CORREO_VALIDO);
    }

    @Test
    void login_conCorreoNulo_noConsultaRepositorio() {
        Usuario resultado = authService.login(null, PASSWORD_VALIDO);

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void login_conCorreoVacio_noConsultaRepositorio() {
        Usuario resultado = authService.login("", PASSWORD_VALIDO);

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void login_conPasswordNulo_noConsultaRepositorio() {
        Usuario resultado = authService.login(CORREO_VALIDO, null);

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void login_conPasswordVacio_noConsultaRepositorio() {
        Usuario resultado = authService.login(CORREO_VALIDO, "");

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void validarCredenciales_conDatosValidos_retornaTrue() {
        Usuario usuario = usuarioConCredenciales(true);
        when(usuarioRepository.findByCorreo(CORREO_VALIDO)).thenReturn(usuario);

        boolean resultado = authService.validarCredenciales(CORREO_VALIDO, PASSWORD_VALIDO);

        assertTrue(resultado);
        verify(usuarioRepository).findByCorreo(CORREO_VALIDO);
    }

    @Test
    void validarCredenciales_conCorreoInexistente_retornaFalse() {
        when(usuarioRepository.findByCorreo(CORREO_INEXISTENTE)).thenReturn(null);

        boolean resultado = authService.validarCredenciales(CORREO_INEXISTENTE, PASSWORD_VALIDO);

        assertFalse(resultado);
        verify(usuarioRepository).findByCorreo(CORREO_INEXISTENTE);
    }

    @Test
    void validarCredenciales_conUsuarioInactivo_retornaFalse() {
        Usuario usuario = usuarioConCredenciales(false);
        when(usuarioRepository.findByCorreo(CORREO_VALIDO)).thenReturn(usuario);

        boolean resultado = authService.validarCredenciales(CORREO_VALIDO, PASSWORD_VALIDO);

        assertFalse(resultado);
        verify(usuarioRepository).findByCorreo(CORREO_VALIDO);
    }

    @Test
    void validarCredenciales_conPasswordIncorrecto_retornaFalse() {
        Usuario usuario = usuarioConCredenciales(true);
        when(usuarioRepository.findByCorreo(CORREO_VALIDO)).thenReturn(usuario);

        boolean resultado = authService.validarCredenciales(CORREO_VALIDO, PASSWORD_INCORRECTO);

        assertFalse(resultado);
        verify(usuarioRepository).findByCorreo(CORREO_VALIDO);
    }

    @Test
    void validarCredenciales_conDatosNulos_noConsultaRepositorio() {
        boolean resultado = authService.validarCredenciales(null, null);

        assertFalse(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void logout_conSesionValida_invalidaSesion() {
        authService.logout(session);

        verify(session).invalidate();
    }

    // =========================
    // PRUEBAS DE REGISTER
    // =========================

    @Test
    void register_conDatosValidos_guardaUsuarioConPasswordHash() {
        when(usuarioRepository.findByCorreo(CORREO_VALIDO)).thenReturn(null);
        when(usuarioRepository.save(any(Usuario.class))).thenAnswer(invocation -> {
            Usuario usuario = invocation.getArgument(0);
            usuario.setId(1L);
            return 1L;
        });

        Usuario resultado = authService.register(
                NOMBRE_VALIDO,
                APELLIDO_VALIDO,
                CORREO_VALIDO,
                PASSWORD_VALIDO,
                PASSWORD_VALIDO
        );

        assertNotNull(resultado);
        assertSame(NOMBRE_VALIDO, resultado.getNombres());
        assertSame(APELLIDO_VALIDO, resultado.getApellidos());
        assertSame(CORREO_VALIDO, resultado.getCorreo());
        assertNotNull(resultado.getPasswordHash());
        assertFalse(resultado.getPasswordHash().equals(PASSWORD_VALIDO));
        assertTrue(BCrypt.checkpw(PASSWORD_VALIDO, resultado.getPasswordHash()));
        assertTrue(Boolean.TRUE.equals(resultado.getEstado()));

        verify(usuarioRepository).findByCorreo(CORREO_VALIDO);
        verify(usuarioRepository).save(any(Usuario.class));
    }

    @Test
    void register_conCorreoDuplicado_retornaNull() {
        when(usuarioRepository.findByCorreo(CORREO_DUPLICADO)).thenReturn(usuarioConCredenciales(true));

        Usuario resultado = authService.register(
                NOMBRE_VALIDO,
                APELLIDO_VALIDO,
                CORREO_DUPLICADO,
                PASSWORD_VALIDO,
                PASSWORD_VALIDO
        );

        assertNull(resultado);
        verify(usuarioRepository).findByCorreo(CORREO_DUPLICADO);
    }

    @Test
    void register_conCorreoInvalido_retornaNull() {
        Usuario resultado = authService.register(
                NOMBRE_VALIDO,
                APELLIDO_VALIDO,
                CORREO_INVALIDO,
                PASSWORD_VALIDO,
                PASSWORD_VALIDO
        );

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void register_conPasswordNoCoincide_retornaNull() {
        Usuario resultado = authService.register(
                NOMBRE_VALIDO,
                APELLIDO_VALIDO,
                CORREO_VALIDO,
                PASSWORD_VALIDO,
                PASSWORD_DIFERENTE
        );

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void register_conPasswordDebil_retornaNull() {
        Usuario resultado = authService.register(
                NOMBRE_VALIDO,
                APELLIDO_VALIDO,
                CORREO_VALIDO,
                PASSWORD_DEBIL,
                PASSWORD_DEBIL
        );

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void register_conDatosObligatoriosNulos_retornaNull() {
        Usuario resultado = authService.register(null, null, null, null, null);

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void register_conNombreVacio_retornaNull() {
        Usuario resultado = authService.register(
                "",
                APELLIDO_VALIDO,
                CORREO_VALIDO,
                PASSWORD_VALIDO,
                PASSWORD_VALIDO
        );

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void register_conApellidoVacio_retornaNull() {
        Usuario resultado = authService.register(
                NOMBRE_VALIDO,
                "",
                CORREO_VALIDO,
                PASSWORD_VALIDO,
                PASSWORD_VALIDO
        );

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void register_conCorreoVacio_retornaNull() {
        Usuario resultado = authService.register(
                NOMBRE_VALIDO,
                APELLIDO_VALIDO,
                "",
                PASSWORD_VALIDO,
                PASSWORD_VALIDO
        );

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void register_conPasswordVacio_retornaNull() {
        Usuario resultado = authService.register(
                NOMBRE_VALIDO,
                APELLIDO_VALIDO,
                CORREO_VALIDO,
                "",
                PASSWORD_VALIDO
        );

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    @Test
    void register_conConfirmacionVacia_retornaNull() {
        Usuario resultado = authService.register(
                NOMBRE_VALIDO,
                APELLIDO_VALIDO,
                CORREO_VALIDO,
                PASSWORD_VALIDO,
                ""
        );

        assertNull(resultado);
        verifyNoInteractions(usuarioRepository);
    }

    private Usuario usuarioConCredenciales(boolean estado) {
        Usuario usuario = new Usuario();
        usuario.setCorreo(CORREO_VALIDO);
        usuario.setPasswordHash(BCrypt.hashpw(PASSWORD_VALIDO, BCrypt.gensalt()));
        usuario.setEstado(estado);
        return usuario;
    }
}