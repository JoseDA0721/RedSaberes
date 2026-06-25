<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>RedSaberes | Registro</title>

    <style>
        :root {
            --color-azul-oscuro: #0B4F6C;
            --color-celeste: #01BAEF;
            --color-verde: #20BF55;
            --color-naranja: #fb923c;
            --color-amarillo: #facc15;
            --color-texto: #1f2937;
            --color-texto-suave: #6b7280;
            --color-borde: #e5e7eb;
            --color-fondo: #f8fafc;
            --sombra-suave: 0 20px 45px rgba(15, 23, 42, 0.14);
            --sombra-fuerte: 0 25px 70px rgba(15, 23, 42, 0.22);
            --radio-grande: 28px;
            --radio-medio: 18px;
            --radio-pequeno: 12px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            color: var(--color-texto);
            background: linear-gradient(135deg, #eff6ff 0%, #ecfeff 48%, #ffffff 100%);
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        button,
        input {
            font: inherit;
        }

        .register-page {
            min-height: 100vh;
            width: 100%;
            display: flex;
            background: linear-gradient(135deg, #eff6ff 0%, #ecfeff 48%, #ffffff 100%);
            overflow: hidden;
        }

        /* =========================
           Sección visual izquierda
        ========================== */
        .hero-panel {
            position: relative;
            width: 58%;
            min-height: 100vh;
            padding: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background: linear-gradient(135deg, var(--color-azul-oscuro), var(--color-celeste), var(--color-verde));
        }

        .hero-panel::before,
        .hero-panel::after {
            content: "";
            position: absolute;
            border-radius: 999px;
            filter: blur(60px);
            opacity: 0.18;
            pointer-events: none;
        }

        .hero-panel::before {
            width: 280px;
            height: 280px;
            top: 45px;
            left: 45px;
            background: #ffffff;
        }

        .hero-panel::after {
            width: 390px;
            height: 390px;
            right: 70px;
            bottom: 70px;
            background: #fde047;
        }

        .network-lines {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            opacity: 0.22;
            pointer-events: none;
        }

        .network-node {
            position: absolute;
            display: grid;
            place-items: center;
            border-radius: 50%;
            color: #ffffff;
            border: 2px solid rgba(255, 255, 255, 0.42);
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(8px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.14);
            animation: floatNode 5s ease-in-out infinite;
        }

        .network-node svg {
            width: 50%;
            height: 50%;
            stroke-width: 2.2;
        }

        .node-book { top: 20%; left: 20%; width: 64px; height: 64px; animation-delay: 0s; }
        .node-graduation { top: 35%; left: 45%; width: 80px; height: 80px; background: rgba(255, 255, 255, 0.3); animation-delay: .4s; }
        .node-light { top: 25%; left: 70%; width: 56px; height: 56px; animation-delay: .8s; }
        .node-network { top: 65%; left: 50%; width: 72px; height: 72px; animation-delay: 1.2s; }
        .node-award { top: 70%; left: 75%; width: 52px; height: 52px; animation-delay: 1.6s; }
        .node-users { top: 70%; left: 30%; width: 56px; height: 56px; animation-delay: 2s; }

        @keyframes floatNode {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .hero-content {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 590px;
        }

        .floating-card {
            width: 100%;
            max-width: 500px;
            padding: 24px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.94);
            backdrop-filter: blur(14px);
            box-shadow: var(--sombra-fuerte);
            transition: transform .28s ease, box-shadow .28s ease;
        }

        .floating-card:hover {
            transform: rotate(0deg) translateY(-4px);
            box-shadow: 0 30px 75px rgba(15, 23, 42, 0.28);
        }

        .floating-card:first-child {
            transform: rotate(-2deg);
        }

        .floating-card:last-child {
            max-width: 390px;
            margin-left: auto;
            transform: rotate(2deg);
        }

        .floating-card-content {
            display: flex;
            align-items: flex-start;
            gap: 16px;
        }

        .floating-icon {
            width: 64px;
            height: 64px;
            flex: 0 0 64px;
            display: grid;
            place-items: center;
            border-radius: 16px;
            color: #ffffff;
        }

        .floating-icon.orange {
            background: linear-gradient(135deg, var(--color-naranja), var(--color-amarillo));
        }

        .floating-icon.blue {
            background: linear-gradient(135deg, #2dd4bf, #3b82f6);
        }

        .floating-icon svg {
            width: 32px;
            height: 32px;
        }

        .floating-card h3 {
            margin-bottom: 4px;
            font-size: 18px;
            color: #1f2937;
        }

        .floating-card p {
            font-size: 14px;
            line-height: 1.5;
            color: #64748b;
        }

        .hero-title {
            padding: 48px 0;
            text-align: center;
            color: #ffffff;
        }

        .hero-title h1 {
            margin-bottom: 18px;
            font-size: clamp(42px, 5vw, 58px);
            line-height: 1.05;
            letter-spacing: -1.2px;
            text-shadow: 0 10px 25px rgba(0, 0, 0, 0.22);
        }

        .hero-title span {
            display: inline-block;
            font-size: clamp(54px, 6vw, 72px);
            color: #fde047;
            background: linear-gradient(90deg, #fde047, #fb923c);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-title p {
            max-width: 460px;
            margin: 0 auto;
            font-size: 20px;
            line-height: 1.5;
            color: rgba(255, 255, 255, 0.92);
            text-shadow: 0 8px 20px rgba(0, 0, 0, 0.18);
        }

        /* =========================
           Sección del formulario
        ========================== */
        .form-panel {
            flex: 1;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 48px;
        }

        .form-wrapper {
            width: 100%;
            max-width: 460px;
        }

        .mobile-brand {
            display: none;
            margin-bottom: 30px;
            text-align: center;
        }

        .mobile-brand h1 {
            margin-bottom: 8px;
            font-size: 42px;
            letter-spacing: -1px;
            background: linear-gradient(90deg, var(--color-azul-oscuro), var(--color-celeste));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .mobile-brand p {
            color: var(--color-texto-suave);
        }

        .register-card {
            padding: 38px;
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            background: rgba(255, 255, 255, 0.96);
            box-shadow: var(--sombra-suave);
        }

        .brand-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 28px;
        }

        .brand-icon {
            width: 50px;
            height: 50px;
            display: grid;
            place-items: center;
            border-radius: 14px;
            color: #ffffff;
            background: linear-gradient(135deg, var(--color-azul-oscuro), var(--color-celeste));
            box-shadow: 0 14px 28px rgba(1, 186, 239, 0.25);
        }

        .brand-row h2 {
            font-size: 25px;
            color: #1f2937;
        }

        .register-header {
            margin-bottom: 30px;
        }

        .register-header h1 {
            margin-bottom: 8px;
            font-size: 32px;
            line-height: 1.15;
            color: #111827;
            letter-spacing: -0.8px;
        }

        .register-header p {
            color: var(--color-texto-suave);
        }

        .register-form {
            display: grid;
            gap: 18px;
        }

        .error {
            margin: 0 0 6px;
            padding: 13px 15px;
            border: 1px solid #fecaca;
            border-radius: var(--radio-pequeno);
            color: #991b1b;
            background: #fef2f2;
            font-size: 14px;
            font-weight: 600;
            line-height: 1.4;
        }

        .success {
            margin: 0 0 6px;
            padding: 13px 15px;
            border: 1px solid #bbf7d0;
            border-radius: var(--radio-pequeno);
            color: #166534;
            background: #f0fdf4;
            font-size: 14px;
            font-weight: 600;
            line-height: 1.4;
        }

        .field-group {
            display: grid;
            gap: 8px;
        }

        .field-group label {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
        }

        .field-control {
            width: 100%;
            height: 48px;
            padding: 0 15px;
            border: 1px solid #dbe3ee;
            border-radius: var(--radio-pequeno);
            background: #ffffff;
            color: #111827;
            outline: none;
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }

        .field-control::placeholder {
            color: #9ca3af;
        }

        .field-control:focus {
            border-color: var(--color-celeste);
            box-shadow: 0 0 0 4px rgba(1, 186, 239, 0.16);
        }

        .field-control.invalid {
            border-color: #ef4444;
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.12);
        }

        .field-control.valid {
            border-color: #22c55e;
            box-shadow: 0 0 0 4px rgba(34, 197, 94, 0.10);
        }

        .password-box {
            position: relative;
        }

        .password-box .field-control {
            padding-right: 48px;
        }

        .toggle-password {
            position: absolute;
            top: 50%;
            right: 12px;
            width: 34px;
            height: 34px;
            display: grid;
            place-items: center;
            border: 0;
            border-radius: 10px;
            background: transparent;
            color: #6b7280;
            cursor: pointer;
            transition: background .2s ease, color .2s ease;
            transform: translateY(-50%);
        }

        .toggle-password:hover {
            background: #f3f4f6;
            color: #374151;
        }

        .icon-eye-off {
            display: none;
        }

        .password-hint {
            font-size: 12px;
            color: var(--color-texto-suave);
            margin-top: -2px;
        }

        .match-hint {
            font-size: 12px;
            font-weight: 700;
            color: #64748b;
            margin-top: -2px;
        }

        .match-hint.ok {
            color: #16a34a;
        }

        .match-hint.bad {
            color: #dc2626;
        }

        .submit-button {
            height: 50px;
            border: 0;
            border-radius: var(--radio-pequeno);
            color: #ffffff;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            background: linear-gradient(90deg, var(--color-azul-oscuro), var(--color-celeste), var(--color-verde));
            box-shadow: 0 14px 30px rgba(1, 186, 239, 0.28);
            transition: transform .22s ease, box-shadow .22s ease, opacity .22s ease;
            margin-top: 4px;
        }

        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 20px 38px rgba(1, 186, 239, 0.34);
            opacity: 0.95;
        }

        .submit-button:active {
            transform: translateY(0);
        }

        .divider {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 2px 0;
            color: #9ca3af;
            font-size: 14px;
        }

        .divider::before {
            content: "";
            width: 100%;
            height: 1px;
            background: var(--color-borde);
            position: absolute;
            left: 0;
            top: 50%;
        }

        .divider span {
            position: relative;
            z-index: 1;
            padding: 0 16px;
            background: #ffffff;
        }

        .login-text {
            text-align: center;
            color: #64748b;
            line-height: 1.5;
        }

        .login-link {
            font-size: 14px;
            font-weight: 700;
            color: var(--color-celeste);
            transition: color .2s ease;
        }

        .login-link:hover {
            color: var(--color-azul-oscuro);
        }

        .footer-text {
            margin-top: 28px;
            text-align: center;
            font-size: 13px;
            color: #64748b;
            line-height: 1.5;
        }

        /* =========================
           Responsivo
        ========================== */
        @media (max-width: 1100px) {
            .hero-panel {
                width: 52%;
                padding: 36px;
            }

            .hero-title h1 {
                font-size: 44px;
            }

            .hero-title span {
                font-size: 54px;
            }

            .form-panel {
                padding: 34px;
            }
        }

        @media (max-width: 900px) {
            .register-page {
                display: block;
                min-height: 100vh;
            }

            .hero-panel {
                display: none;
            }

            .form-panel {
                min-height: 100vh;
                padding: 32px 20px;
            }

            .mobile-brand {
                display: block;
            }
        }

        @media (max-width: 520px) {
            .form-panel {
                align-items: flex-start;
                padding: 24px 14px;
            }

            .register-card {
                padding: 28px 22px;
                border-radius: 22px;
            }

            .register-header h1 {
                font-size: 28px;
            }

            .brand-row h2 {
                font-size: 22px;
            }
        }

        .sr-only {
            position: absolute;
            width: 1px;
            height: 1px;
            padding: 0;
            margin: -1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            white-space: nowrap;
            border: 0;
        }
    </style>
</head>
<body>
<svg aria-hidden="true" style="position:absolute;width:0;height:0;overflow:hidden;">
    <symbol id="icon-book" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
        <path d="M4 4.5A2.5 2.5 0 0 1 6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5z" />
    </symbol>

    <symbol id="icon-users" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
        <circle cx="9" cy="7" r="4" />
        <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
        <path d="M16 3.13a4 4 0 0 1 0 7.75" />
    </symbol>

    <symbol id="icon-award" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="8" r="6" />
        <path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11" />
    </symbol>

    <symbol id="icon-light" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
        <path d="M9 18h6" />
        <path d="M10 22h4" />
        <path d="M12 2a7 7 0 0 0-4 12.74V16h8v-1.26A7 7 0 0 0 12 2z" />
    </symbol>

    <symbol id="icon-network" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="6" cy="6" r="3" />
        <circle cx="18" cy="6" r="3" />
        <circle cx="12" cy="18" r="3" />
        <path d="m8.5 8 2.3 6.3" />
        <path d="m15.5 8-2.3 6.3" />
        <path d="M9 6h6" />
    </symbol>

    <symbol id="icon-graduation" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
        <path d="M22 10 12 5 2 10l10 5 10-5z" />
        <path d="M6 12v5c3 2 9 2 12 0v-5" />
        <path d="M22 10v6" />
    </symbol>

    <symbol id="icon-eye" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
        <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z" />
        <circle cx="12" cy="12" r="3" />
    </symbol>

    <symbol id="icon-eye-off" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
        <path d="M3 3l18 18" />
        <path d="M10.58 10.58A2 2 0 0 0 12 14a2 2 0 0 0 1.42-.58" />
        <path d="M9.88 5.1A10.8 10.8 0 0 1 12 5c6.5 0 10 7 10 7a18 18 0 0 1-3.14 4.19" />
        <path d="M6.61 6.61C3.55 8.68 2 12 2 12s3.5 7 10 7a10.7 10.7 0 0 0 4.4-.93" />
    </symbol>
</svg>

<main class="register-page">
    <section class="hero-panel" aria-label="Presentación de RedSaberes">
        <svg class="network-lines" aria-hidden="true">
            <line x1="20%" y1="20%" x2="45%" y2="35%" stroke="white" stroke-width="2" stroke-dasharray="6 6" />
            <line x1="45%" y1="35%" x2="70%" y2="25%" stroke="white" stroke-width="2" stroke-dasharray="6 6" />
            <line x1="45%" y1="35%" x2="50%" y2="65%" stroke="white" stroke-width="2" stroke-dasharray="6 6" />
            <line x1="50%" y1="65%" x2="75%" y2="70%" stroke="white" stroke-width="2" stroke-dasharray="6 6" />
            <line x1="30%" y1="70%" x2="50%" y2="65%" stroke="white" stroke-width="2" stroke-dasharray="6 6" />
        </svg>

        <div class="network-node node-book"><svg><use href="#icon-book" /></svg></div>
        <div class="network-node node-graduation"><svg><use href="#icon-graduation" /></svg></div>
        <div class="network-node node-light"><svg><use href="#icon-light" /></svg></div>
        <div class="network-node node-network"><svg><use href="#icon-network" /></svg></div>
        <div class="network-node node-award"><svg><use href="#icon-award" /></svg></div>
        <div class="network-node node-users"><svg><use href="#icon-users" /></svg></div>

        <div class="hero-content">
            <article class="floating-card">
                <div class="floating-card-content">
                    <div class="floating-icon orange">
                        <svg><use href="#icon-book" /></svg>
                    </div>
                    <div>
                        <h3>Aprende a tu ritmo</h3>
                        <p>Accede a cursos, recursos y comunidades para potenciar tu desarrollo personal y profesional.</p>
                    </div>
                </div>
            </article>

            <div class="hero-title">
                <h1>
                    Únete a<br />
                    <span>RedSaberes</span>
                </h1>
                <p>Crea tu cuenta y forma parte de una comunidad digital donde el conocimiento crece contigo.</p>
            </div>

            <article class="floating-card">
                <div class="floating-card-content">
                    <div class="floating-icon blue">
                        <svg><use href="#icon-users" /></svg>
                    </div>
                    <div>
                        <h3>Conecta con la comunidad</h3>
                        <p>Comparte, colabora y aprende junto a estudiantes, expertos y creadores de contenido.</p>
                    </div>
                </div>
            </article>
        </div>
    </section>

    <section class="form-panel" aria-label="Formulario de registro">
        <div class="form-wrapper">
            <div class="mobile-brand">
                <h1>RedSaberes</h1>
                <p>Aprende, comparte, crece</p>
            </div>

            <div class="register-card">
                <header class="register-header">
                    <div class="brand-row">
                        <div class="brand-icon">
                            <svg width="28" height="28"><use href="#icon-graduation" /></svg>
                        </div>
                        <h2>RedSaberes</h2>
                    </div>

                    <h1>Crear cuenta</h1>
                    <p>Completa tus datos para registrarte</p>
                </header>

                <% if (request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
                <% } %>

                <% if (request.getAttribute("success") != null) { %>
                <div class="success"><%= request.getAttribute("success") %></div>
                <% } %>

                <form class="register-form" method="post" action="${pageContext.request.contextPath}/register" id="registerForm" novalidate>
                    <div class="field-group">
                        <label for="nombre">Nombre</label>
                        <input class="field-control" type="text" id="nombre" name="nombre" placeholder="Tu nombre" required minlength="2" />
                    </div>

                    <div class="field-group">
                        <label for="apellido">Apellido</label>
                        <input class="field-control" type="text" id="apellido" name="apellido" placeholder="Tu apellido" required minlength="2" />
                    </div>

                    <div class="field-group">
                        <label for="correo">Correo electrónico</label>
                        <input class="field-control" type="email" id="correo" name="correo" placeholder="tu@email.com" required />
                    </div>

                    <div class="field-group">
                        <label for="password">Contraseña</label>
                        <div class="password-box">
                            <input class="field-control" type="password" id="password" name="password" placeholder="••••••••" required minlength="6" />
                            <button class="toggle-password" type="button" id="togglePassword" aria-label="Mostrar contraseña">
                                <svg class="icon-eye" width="21" height="21"><use href="#icon-eye" /></svg>
                                <svg class="icon-eye-off" width="21" height="21"><use href="#icon-eye-off" /></svg>
                            </button>
                        </div>
                        <small class="password-hint">Mínimo 6 caracteres.</small>
                    </div>

                    <div class="field-group">
                        <label for="confirmarPassword">Confirmar contraseña</label>
                        <div class="password-box">
                            <input class="field-control" type="password" id="confirmarPassword" name="confirmarPassword" placeholder="••••••••" required minlength="6" />
                            <button class="toggle-password" type="button" id="toggleConfirmPassword" aria-label="Mostrar contraseña">
                                <svg class="icon-eye" width="21" height="21"><use href="#icon-eye" /></svg>
                                <svg class="icon-eye-off" width="21" height="21"><use href="#icon-eye-off" /></svg>
                            </button>
                        </div>
                        <small class="match-hint" id="matchHint">Las contraseñas deben coincidir.</small>
                    </div>

                    <button class="submit-button" type="submit" id="submitButton">Registrarme</button>

                    <div class="divider"><span>o</span></div>

                    <p class="login-text">
                        ¿Ya tienes una cuenta?
                        <a href="${pageContext.request.contextPath}/login" class="login-link">Inicia sesión</a>
                    </p>
                </form>
            </div>

            <footer class="footer-text">
                <p>© 2026 RedSaberes. Una plataforma de aprendizaje colaborativo.</p>
            </footer>
        </div>
    </section>
</main>

<script>
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmarPassword');
    const togglePassword = document.getElementById('togglePassword');
    const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
    const matchHint = document.getElementById('matchHint');
    const registerForm = document.getElementById('registerForm');
    const submitButton = document.getElementById('submitButton');

    function toggleVisibility(input, button) {
        if (!input || !button) return;

        const eyeIcon = button.querySelector('.icon-eye');
        const eyeOffIcon = button.querySelector('.icon-eye-off');

        button.addEventListener('click', function () {
            const isHidden = input.type === 'password';
            input.type = isHidden ? 'text' : 'password';
            button.setAttribute('aria-label', isHidden ? 'Ocultar contraseña' : 'Mostrar contraseña');

            if (eyeIcon && eyeOffIcon) {
                eyeIcon.style.display = isHidden ? 'none' : 'block';
                eyeOffIcon.style.display = isHidden ? 'block' : 'none';
            }
        });
    }

    function validatePasswords() {
        if (!passwordInput || !confirmPasswordInput || !matchHint || !submitButton) return true;

        const password = passwordInput.value.trim();
        const confirmPassword = confirmPasswordInput.value.trim();

        passwordInput.classList.remove('valid', 'invalid');
        confirmPasswordInput.classList.remove('valid', 'invalid');
        matchHint.classList.remove('ok', 'bad');

        if (!password || !confirmPassword) {
            matchHint.textContent = 'Las contraseñas deben coincidir.';
            submitButton.disabled = false;
            return true;
        }

        if (password === confirmPassword) {
            passwordInput.classList.add('valid');
            confirmPasswordInput.classList.add('valid');
            matchHint.textContent = 'Las contraseñas coinciden.';
            matchHint.classList.add('ok');
            submitButton.disabled = false;
            return true;
        } else {
            passwordInput.classList.add('invalid');
            confirmPasswordInput.classList.add('invalid');
            matchHint.textContent = 'Las contraseñas no coinciden.';
            matchHint.classList.add('bad');
            submitButton.disabled = true;
            return false;
        }
    }

    toggleVisibility(passwordInput, togglePassword);
    toggleVisibility(confirmPasswordInput, toggleConfirmPassword);

    if (passwordInput && confirmPasswordInput) {
        passwordInput.addEventListener('input', validatePasswords);
        confirmPasswordInput.addEventListener('input', validatePasswords);
    }

    if (registerForm) {
        registerForm.addEventListener('submit', function (e) {
            const isValid = validatePasswords();
            if (!isValid) {
                e.preventDefault();
            }
        });
    }
</script>
</body>
</html>