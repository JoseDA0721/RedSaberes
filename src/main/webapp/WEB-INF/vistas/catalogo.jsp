<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Catálogo de Cursos</title>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        /* ═══════════════════════════════════════════
           CATÁLOGO DE CURSOS
        ═══════════════════════════════════════════ */
        .catalogo-main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px 72px;
            animation: fadeIn .4s ease both;
        }

        /* ── Hero ── */
        .catalogo-hero {
            background: var(--gradiente-marca);
            padding: 64px 24px 56px;
            text-align: center;
            margin-bottom: 0;
            position: relative;
            overflow: hidden;
        }

        .catalogo-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.04'%3E%3Ccircle cx='30' cy='30' r='20'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }

        .catalogo-hero-content {
            position: relative;
            z-index: 1;
        }

        .catalogo-hero-icon {
            width: 64px;
            height: 64px;
            background: rgba(255, 255, 255, 0.18);
            border-radius: 20px;
            display: inline-grid;
            place-items: center;
            margin-bottom: 20px;
        }

        .catalogo-hero h1 {
            font-size: clamp(28px, 4vw, 44px);
            font-weight: 800;
            letter-spacing: -1px;
            color: #fff;
            margin-bottom: 12px;
        }

        .catalogo-hero p {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.82);
            max-width: 520px;
            margin: 0 auto 20px;
            line-height: 1.6;
        }

        .catalogo-hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.18);
            border: 1px solid rgba(255, 255, 255, 0.28);
            color: #fff;
            font-size: 13px;
            font-weight: 700;
            padding: 6px 16px;
            border-radius: 999px;
        }

        /* ── Barra de conteo / metadatos ── */
        .catalogo-meta-bar {
            background: #fff;
            border-bottom: 1px solid #eef2f7;
            padding: 14px 24px;
            margin-bottom: 40px;
        }

        .catalogo-meta-inner {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
        }

        .catalogo-count {
            font-size: 14px;
            color: var(--color-texto-suave);
            font-weight: 600;
        }

        .catalogo-count strong {
            color: var(--color-texto);
        }

        /* ── Grid de cursos ── */
        .cursos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
            gap: 24px;
        }

        /* ── Tarjeta de curso ── */
        .curso-card {
            display: flex;
            flex-direction: column;
            background: rgba(255, 255, 255, 0.97);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            box-shadow: var(--sombra-suave);
            overflow: hidden;
            transition: transform .25s ease, box-shadow .25s ease;
            text-decoration: none;
            color: inherit;
        }

        .curso-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--sombra-media);
        }

        /* Franja superior de color */
        .curso-card-banner {
            height: 6px;
            background: var(--gradiente-marca);
        }

        .curso-card-body {
            padding: 22px 22px 16px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        /* Icono + categoría */
        .curso-card-top {
            display: flex;
            align-items: flex-start;
            gap: 14px;
        }

        .curso-icon {
            width: 52px;
            height: 52px;
            border-radius: 16px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            color: #fff;
            background: var(--gradiente-marca);
            box-shadow: 0 8px 20px rgba(1, 186, 239, 0.22);
        }

        .curso-meta-top {
            flex: 1;
            min-width: 0;
        }

        .curso-categoria {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 11px;
            font-weight: 700;
            color: var(--color-azul-oscuro);
            background: rgba(1, 186, 239, 0.10);
            border: 1px solid rgba(1, 186, 239, 0.20);
            padding: 3px 10px;
            border-radius: 999px;
            margin-bottom: 8px;
        }

        .curso-titulo {
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -0.3px;
            color: var(--color-texto);
            line-height: 1.25;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* Descripción */
        .curso-descripcion {
            font-size: 13px;
            color: var(--color-texto-suave);
            line-height: 1.6;
            flex: 1;
        }

        /* Separador */
        .curso-divider {
            height: 1px;
            background: #f1f5f9;
            margin: 0 -22px;
        }

        /* Metadatos inferiores */
        .curso-card-footer {
            padding: 14px 22px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .curso-instructor {
            display: flex;
            align-items: center;
            gap: 8px;
            min-width: 0;
        }

        .instructor-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--gradiente-marca);
            display: grid;
            place-items: center;
            flex-shrink: 0;
            font-size: 12px;
            font-weight: 800;
            color: #fff;
        }

        .instructor-info {
            min-width: 0;
        }

        .instructor-label {
            font-size: 10px;
            color: var(--color-texto-suave);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .instructor-name {
            font-size: 12px;
            font-weight: 700;
            color: var(--color-texto);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 140px;
        }

        .curso-modulos-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            font-weight: 700;
            color: var(--color-texto-suave);
            background: #f8fafc;
            border: 1px solid #eef2f7;
            padding: 5px 11px;
            border-radius: 999px;
            white-space: nowrap;
            flex-shrink: 0;
        }

        /* CTA en tarjeta */
        .curso-card-cta {
            display: flex;
            justify-content: flex-end;
            padding: 0 22px 18px;
        }

        .btn-ver-curso {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            height: 40px;
            padding: 0 20px;
            border: 0;
            border-radius: var(--radio-pequeno);
            background: var(--gradiente-marca);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            box-shadow: 0 6px 18px rgba(1, 186, 239, 0.24);
            transition: transform .2s, box-shadow .2s, opacity .2s;
        }

        .btn-ver-curso:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 24px rgba(1, 186, 239, 0.34);
            opacity: 0.95;
        }

        /* ── Empty state ── */
        .catalogo-empty {
            grid-column: 1 / -1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 20px;
            padding: 80px 24px;
            text-align: center;
            background: rgba(255, 255, 255, 0.9);
            border: 1.5px dashed #dbe3ee;
            border-radius: var(--radio-grande);
        }

        .empty-illustration {
            width: 80px;
            height: 80px;
            border-radius: 24px;
            background: rgba(1, 186, 239, 0.08);
            display: inline-grid;
            place-items: center;
            color: var(--color-celeste);
        }

        .catalogo-empty h2 {
            font-size: 22px;
            font-weight: 800;
            color: var(--color-texto);
        }

        .catalogo-empty p {
            color: var(--color-texto-suave);
            font-size: 15px;
            max-width: 380px;
            line-height: 1.6;
        }

        /* ── Responsive ── */
        @media (max-width: 768px) {
            .catalogo-hero {
                padding: 48px 20px 44px;
            }

            .catalogo-main {
                padding: 0 14px 48px;
            }

            .cursos-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
        }

        @media (min-width: 769px) and (max-width: 1024px) {
            .cursos-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>

<%@ include file="./fragmentos/nav.jspf" %>

<%-- ── Hero ── --%>
<section class="catalogo-hero">
    <div class="catalogo-hero-content">
        <div class="catalogo-hero-icon" aria-hidden="true">
            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24"
                 fill="none" stroke="#fff" stroke-width="2">
                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
            </svg>
        </div>
        <h1>Explora nuestros cursos</h1>
        <p>Aprende con los mejores instructores y lleva tus habilidades al siguiente nivel.</p>
        <c:if test="${not empty cursos}">
            <span class="catalogo-hero-badge">
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                    <polyline points="22 4 12 14.01 9 11.01"/>
                </svg>
                ${fn:length(cursos)} curso${fn:length(cursos) != 1 ? 's' : ''} disponible${fn:length(cursos) != 1 ? 's' : ''}
            </span>
        </c:if>
    </div>
</section>

<%-- ── Barra de metadatos ── --%>
<div class="catalogo-meta-bar">
    <div class="catalogo-meta-inner">
        <p class="catalogo-count">
            <c:choose>
                <c:when test="${not empty cursos}">
                    Mostrando <strong>${fn:length(cursos)}</strong>
                    curso${fn:length(cursos) != 1 ? 's' : ''} publicado${fn:length(cursos) != 1 ? 's' : ''}
                </c:when>
                <c:otherwise>Sin resultados</c:otherwise>
            </c:choose>
        </p>
    </div>
</div>

<main class="catalogo-main">
    <section class="cursos-grid" aria-label="Catálogo de cursos">
        <c:choose>
            <c:when test="${not empty cursos}">
                <c:forEach var="curso" items="${cursos}" varStatus="idx">
                    <article class="curso-card fade-in"
                             style="animation-delay: ${idx.index * 0.05}s">

                        <div class="curso-card-banner" aria-hidden="true"></div>

                        <div class="curso-card-body">
                            <div class="curso-card-top">
                                <div class="curso-icon" aria-hidden="true">
                                    <i data-lucide="book-open" style="width:22px;height:22px;"></i>
                                </div>
                                <div class="curso-meta-top">
                                    <div class="curso-categoria">
                                        <c:out value="${curso.categoria}"/>
                                    </div>
                                    <h2 class="curso-titulo">
                                        <c:out value="${curso.titulo}"/>
                                    </h2>
                                </div>
                            </div>

                                <%-- Descripción: máximo 150 caracteres --%>
                            <p class="curso-descripcion">
                                <c:choose>
                                    <c:when test="${fn:length(curso.descripcion) > 150}">
                                        <c:out value="${fn:substring(curso.descripcion, 0, 150)}"/>...
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${curso.descripcion}"/>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="curso-divider" aria-hidden="true"></div>

                        <div class="curso-card-footer">
                                <%-- Instructor --%>
                            <div class="curso-instructor">
                                <div class="instructor-avatar" aria-hidden="true">
                                    <c:out value="${curso.instructorInicial}"/>
                                </div>
                                <div class="instructor-info">
                                    <p class="instructor-label">Instructor</p>
                                    <p class="instructor-name">
                                        <c:out value="${curso.instructorNombreCompleto}"/>
                                    </p>
                                </div>
                            </div>

                                <%-- Módulos y lecciones --%>
                            <div style="display:flex;flex-direction:column;align-items:flex-end;gap:4px;">
                <span class="curso-modulos-badge">
                    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                        <line x1="8" y1="21" x2="16" y2="21"/>
                        <line x1="12" y1="17" x2="12" y2="21"/>
                    </svg>
                    ${curso.cantidadModulos} módulo${curso.cantidadModulos != 1 ? 's' : ''}
                </span>
                                <span style="font-size:11px;color:var(--color-texto-suave);">
                    ${curso.cantidadLecciones} lección${curso.cantidadLecciones != 1 ? 'es' : ''}
                </span>
                            </div>
                        </div>

                            <%-- CTA — usa curso.id del DTO --%>
                        <div class="curso-card-cta">
                            <a href="${pageContext.request.contextPath}/curso-publico?id=${curso.id}"
                               class="btn-ver-curso"
                               onclick="guardarScrollCatalogo()">
                                Ver Curso
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                                     fill="none" stroke="currentColor" stroke-width="2.5">
                                    <path d="m9 18 6-6-6-6"/>
                                </svg>
                            </a>
                        </div>
                    </article>
                </c:forEach>
            </c:when>

            <%-- Empty state --%>
            <c:otherwise>
                <div class="catalogo-empty fade-in">
                    <div class="empty-illustration" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="38" height="38" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="1.5">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                        </svg>
                    </div>
                    <h2>Aún no hay cursos publicados</h2>
                    <p>
                        Estamos preparando contenido de calidad para ti.
                        Vuelve pronto para explorar el catálogo.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<script>
    if (typeof lucide !== 'undefined') lucide.createIcons();

    /* ═══════════════════════════════════════════════════════
       SCROLL POSITION — restaurar y guardar posición del catálogo
    ════════════════════════════════════════════════════════ */
    var SCROLL_KEY = 'redsaberes_catalogo_scroll';

    /** Guarda la posición actual del scroll antes de salir del catálogo */
    function guardarScrollCatalogo() {
        try {
            sessionStorage.setItem(SCROLL_KEY, String(Math.round(window.scrollY)));
        } catch (e) { /* sessionStorage no disponible */
        }
    }

    /** Restaura la posición de scroll al volver al catálogo */
    document.addEventListener('DOMContentLoaded', function () {
        try {
            var savedY = sessionStorage.getItem(SCROLL_KEY);
            if (savedY !== null) {
                var targetY = parseInt(savedY, 10);
                sessionStorage.removeItem(SCROLL_KEY); // limpiar tras restaurar
                // Pequeño delay para que el layout esté completamente renderizado
                setTimeout(function () {
                    window.scrollTo({top: targetY, behavior: 'instant'});
                }, 60);
            }
        } catch (e) { /* sin sessionStorage */
        }
    });

    /* Si el usuario navega con el botón atrás del navegador,
       guardar el scroll al descargar la página también */
    window.addEventListener('pagehide', function () {
        guardarScrollCatalogo();
    });
</script>
</body>
</html>