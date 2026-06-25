<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Dashboard</title>
    <%@ include file="./fragmentos/encabezado.jspf" %>

    <style>
        /* =============================================
           DASHBOARD — estilos de página
        ============================================= */
        .dashboard-main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 24px 48px;
        }

        /* --- Bienvenida --- */
        .bienvenida {
            margin-bottom: 40px;
            animation: fadeIn .4s ease both;
        }

        .bienvenida h1 {
            font-size: clamp(24px, 3vw, 32px);
            font-weight: 800;
            letter-spacing: -0.6px;
            color: var(--color-texto);
            margin-bottom: 6px;
        }

        .bienvenida p {
            color: var(--color-texto-suave);
        }

        /* --- Sección "Crear Curso" hero --- */
        .crear-hero {
            display: flex;
            align-items: center;
            gap: 32px;
            padding: 40px 48px;
            border-radius: var(--radio-grande);
            background: var(--gradiente-marca);
            box-shadow: 0 16px 48px rgba(1, 186, 239, 0.30);
            color: #fff;
            margin-bottom: 40px;
            animation: fadeIn .45s ease both;
            position: relative;
            overflow: hidden;
        }

        .crear-hero::before {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
            top: -60px;
            right: -60px;
            pointer-events: none;
        }

        .crear-hero::after {
            content: "";
            position: absolute;
            width: 160px;
            height: 160px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.06);
            bottom: -40px;
            left: 200px;
            pointer-events: none;
        }

        .crear-hero-icono {
            width: 72px;
            height: 72px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.22);
            backdrop-filter: blur(8px);
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border: 2px solid rgba(255, 255, 255, 0.35);
        }

        .crear-hero-texto { flex: 1; }

        .crear-hero-texto h2 {
            font-size: clamp(22px, 2.5vw, 28px);
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: -0.4px;
        }

        .crear-hero-texto p {
            font-size: 15px;
            opacity: .90;
            line-height: 1.5;
            max-width: 480px;
        }

        .crear-hero-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            height: 48px;
            padding: 0 28px;
            border-radius: var(--radio-pequeno);
            background: #fff;
            color: var(--color-azul-oscuro);
            font-size: 15px;
            font-weight: 800;
            text-decoration: none;
            white-space: nowrap;
            transition: transform .2s ease, box-shadow .2s ease;
            box-shadow: 0 8px 24px rgba(0,0,0,0.14);
            flex-shrink: 0;
        }

        .crear-hero-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 32px rgba(0,0,0,0.2);
        }

        /* --- Responsive --- */
        @media (max-width: 640px) {
            .crear-hero {
                flex-direction: column;
                align-items: flex-start;
                padding: 28px 24px;
                gap: 20px;
            }

            .crear-hero-btn { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>

<%-- Navegación principal --%>
<%@ include file="./fragmentos/nav.jspf" %>

<main class="dashboard-main">

    <%-- Bienvenida --%>
    <div class="bienvenida">
        <h1>¡Bienvenido, ${sessionScope.userName}!</h1>
        <p>Gestiona tus cursos y comparte tu conocimiento con la comunidad.</p>
    </div>

    <%-- Hero: Crear Curso --%>
    <section class="crear-hero" aria-label="Crear un nuevo curso">
        <div class="crear-hero-icono">
            <i data-lucide="plus-circle" style="width:36px;height:36px;color:#fff;"></i>
        </div>

        <div class="crear-hero-texto">
            <h2>Crea un Nuevo Curso</h2>
            <p>Comparte tu conocimiento con miles de estudiantes. Define el temario, sube recursos y publica tu curso en minutos.</p>
        </div>

        <a href="${pageContext.request.contextPath}/courses/create" class="crear-hero-btn">
            <i data-lucide="plus" style="width:20px;height:20px;"></i>
            Crear Curso
        </a>
    </section>

</main>

<script>
    lucide.createIcons();
</script>

</body>
</html>