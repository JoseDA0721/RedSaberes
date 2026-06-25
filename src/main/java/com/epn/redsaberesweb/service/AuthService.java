package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.models.Usuario;
import com.epn.redsaberesweb.repository.UsuarioRepository;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.util.regex.Pattern;

public class AuthService {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
    );

    private final UsuarioRepository usuarioRepository;

    public AuthService(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    public Usuario login(String correo, String password) {
        if (correo == null || correo.isBlank()
                || password == null || password.isBlank()) {
            return null;
        }

        Usuario usuario = usuarioRepository.findByCorreo(correo);

        if (usuario == null) {
            return null;
        }

        if (!Boolean.TRUE.equals(usuario.getEstado())) {
            return null;
        }

        if (!BCrypt.checkpw(password, usuario.getPasswordHash())) {
            return null;
        }

        return usuario;
    }

    public boolean validarCredenciales(String correo, String password) {
        return login(correo, password) != null;
    }

    public Usuario register(String nombre,
                            String apellido,
                            String correo,
                            String password,
                            String confirmarPassword) {

        if (nombre == null || nombre.isBlank()
                || apellido == null || apellido.isBlank()
                || correo == null || correo.isBlank()
                || password == null || password.isBlank()
                || confirmarPassword == null || confirmarPassword.isBlank()) {
            return null;
        }

        String nombreLimpio = nombre.trim();
        String apellidoLimpio = apellido.trim();
        String correoLimpio = correo.trim().toLowerCase();

        if (!EMAIL_PATTERN.matcher(correoLimpio).matches()) {
            return null;
        }

        if (!password.equals(confirmarPassword)) {
            return null;
        }

        if (!esPasswordValida(password)) {
            return null;
        }

        if (usuarioRepository.findByCorreo(correoLimpio) != null) {
            return null;
        }

        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

        Usuario usuario = new Usuario();
        usuario.setNombres(nombreLimpio);
        usuario.setApellidos(apellidoLimpio);
        usuario.setCorreo(correoLimpio);
        usuario.setPasswordHash(passwordHash);
        usuario.setEstado(Boolean.TRUE);

        usuarioRepository.save(usuario);
        return usuario;
    }

    private boolean esPasswordValida(String password) {
        return password != null
                && password.length() >= 6
                && password.chars().anyMatch(Character::isLetter)
                && password.chars().anyMatch(Character::isDigit);
    }

    public void logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }
}