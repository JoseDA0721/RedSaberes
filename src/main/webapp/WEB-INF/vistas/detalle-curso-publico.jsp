<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | <c:out value="${curso.titulo}"/></title>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        /* ═══════════════════════════════════════════
           DETALLE CURSO PÚBLICO
        ═══════════════════════════════════════════ */
        body {
            /* Fondo levemente diferente para distinguir la vista pública */
            background: linear-gradient(160deg, #f0f9ff 0%, #ecfeff 40%, #f8fafc 100%);
        }

        /* ── Hero del curso ── */
        .curso-hero {
            background: var(--gradiente-marca);
            padding: 48px 24px 52px;
            position: relative;
            overflow: hidden;
        }
        .curso-hero::before {
            content: '';
            position: absolute;
            top: -60px; right: -60px;
            width: 320px; height: 320px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
        }
        .curso-hero::after {
            content: '';
            position: absolute;
            bottom: -40px; left: 10%;
            width: 200px; height: 200px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
        }
        .curso-hero-inner {
            max-width: 860px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        /* Breadcrumb en hero */
        .hero-breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: rgba(255,255,255,0.70);
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .hero-breadcrumb a {
            color: rgba(255,255,255,0.75);
            text-decoration: none;
            font-weight: 600;
            transition: color .15s;
        }
        .hero-breadcrumb a:hover { color: #fff; }
        .hero-breadcrumb .sep { color: rgba(255,255,255,0.40); }
        .hero-breadcrumb .current { color: rgba(255,255,255,0.90); font-weight: 700; }

        .curso-hero h1 {
            font-size: clamp(24px, 3.5vw, 38px);
            font-weight: 800;
            letter-spacing: -0.8px;
            color: #fff;
            margin-bottom: 14px;
            line-height: 1.15;
        }
        .curso-hero-descripcion {
            font-size: 15px;
            color: rgba(255,255,255,0.80);
            line-height: 1.65;
            max-width: 620px;
            margin-bottom: 28px;
        }

        /* Pastillas de metadatos en el hero */
        .curso-hero-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .hero-pill {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            background: rgba(255,255,255,0.16);
            border: 1px solid rgba(255,255,255,0.24);
            color: #fff;
            font-size: 13px;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 999px;
        }

        /* ── Layout principal ── */
        .detalle-layout {
            max-width: 860px;
            margin: 0 auto;
            padding: 36px 24px 72px;
        }

        /* ── Card de currículum (acordeón) ── */
        .curriculum-card {
            background: rgba(255,255,255,0.97);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            box-shadow: var(--sombra-suave);
            overflow: hidden;
            margin-bottom: 20px;
            animation: fadeIn .4s ease both;
        }
        .curriculum-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }
        .curriculum-header h2 {
            font-size: 17px;
            font-weight: 800;
            color: var(--color-texto);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .curriculum-stats {
            font-size: 12px;
            color: var(--color-texto-suave);
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
        }
        .curriculum-stat {
            display: flex;
            align-items: center;
            gap: 5px;
            font-weight: 600;
        }

        /* ── Acordeón de módulos ── */
        .modulo-acordeon {
            border-bottom: 1px solid #f1f5f9;
        }
        .modulo-acordeon:last-child { border-bottom: none; }

        .modulo-header {
            width: 100%;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 24px;
            background: #fafbfc;
            border: none;
            cursor: pointer;
            text-align: left;
            transition: background .2s;
            position: relative;
        }
        .modulo-header:hover { background: #f1f5f9; }
        .modulo-header.active { background: rgba(1,186,239,0.06); }

        .modulo-num {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            background: #f1f5f9;
            display: grid;
            place-items: center;
            font-size: 12px;
            font-weight: 800;
            color: var(--color-texto-suave);
            flex-shrink: 0;
            transition: background .2s, color .2s;
        }
        .modulo-header.active .modulo-num {
            background: var(--gradiente-marca);
            color: #fff;
        }

        .modulo-info { flex: 1; min-width: 0; }
        .modulo-titulo {
            font-size: 15px;
            font-weight: 700;
            color: var(--color-texto);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .modulo-header.active .modulo-titulo { color: var(--color-azul-oscuro); }

        .modulo-leccion-count {
            font-size: 11px;
            color: var(--color-texto-suave);
            margin-top: 2px;
            font-weight: 600;
        }

        .modulo-chevron {
            flex-shrink: 0;
            color: #94a3b8;
            transition: transform .3s ease, color .2s;
        }
        .modulo-header.active .modulo-chevron {
            transform: rotate(180deg);
            color: var(--color-celeste);
        }

        /* ── Cuerpo del acordeón (lecciones) ── */
        .modulo-body {
            max-height: 0;
            overflow: hidden;
            transition: max-height .35s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .modulo-body.open {
            max-height: 2000px; /* suficientemente grande */
        }

        /* ── Filas de lección ── */
        .lecciones-lista { list-style: none; padding: 0; margin: 0; }
        .leccion-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 24px 12px 64px;
            border-top: 1px solid #f8fafc;
            cursor: pointer;
            transition: background .15s;
            position: relative;
        }
        .leccion-row:hover {
            background: rgba(1,186,239,0.04);
        }
        .leccion-row:hover .leccion-titulo-text {
            color: var(--color-azul-oscuro);
        }

        /* Indicador de tipo de lección */
        .leccion-tipo-icon {
            width: 30px;
            height: 30px;
            border-radius: 8px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
        }
        .leccion-tipo-video { background: #dbeafe; color: #1d4ed8; }
        .leccion-tipo-texto { background: #f3f4f6; color: #374151; }
        .leccion-tipo-quiz  { background: #fef3c7; color: #92400e; }

        .leccion-titulo-text {
            flex: 1;
            font-size: 14px;
            font-weight: 600;
            color: var(--color-texto);
            min-width: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            transition: color .15s;
        }

        /* Candado */
        .leccion-lock {
            flex-shrink: 0;
            color: #94a3b8;
            transition: color .15s;
        }
        .leccion-row:hover .leccion-lock { color: var(--color-celeste); }

        /* ── Toast de inscripción ── */
        .inscripcion-toast {
            position: fixed;
            bottom: 28px;
            left: 50%;
            transform: translateX(-50%) translateY(20px);
            background: #fff;
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            box-shadow: 0 16px 48px rgba(15,23,42,0.18);
            padding: 16px 22px;
            display: flex;
            align-items: flex-start;
            gap: 14px;
            max-width: 440px;
            width: calc(100% - 48px);
            z-index: 500;
            opacity: 0;
            pointer-events: none;
            transition: opacity .3s ease, transform .3s ease;
        }
        .inscripcion-toast.visible {
            opacity: 1;
            pointer-events: auto;
            transform: translateX(-50%) translateY(0);
        }
        .toast-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: rgba(1,186,239,0.12);
            display: grid;
            place-items: center;
            color: var(--color-celeste);
            flex-shrink: 0;
        }
        .toast-body { flex: 1; min-width: 0; }
        .toast-titulo {
            font-size: 14px;
            font-weight: 800;
            color: var(--color-texto);
            margin-bottom: 3px;
        }
        .toast-msg {
            font-size: 13px;
            color: var(--color-texto-suave);
            line-height: 1.5;
        }
        .toast-close {
            background: none;
            border: none;
            cursor: pointer;
            color: #94a3b8;
            padding: 2px;
            border-radius: 6px;
            flex-shrink: 0;
            transition: color .15s;
        }
        .toast-close:hover { color: var(--color-texto); }

        /* ── Botón Volver ── */
        .detalle-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            padding-top: 20px;
            border-top: 1px solid #eef2f7;
        }
        .btn-volver-catalogo {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            height: 44px;
            padding: 0 20px;
            border: 1.5px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            background: #fff;
            color: var(--color-texto);
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            transition: border-color .2s, transform .2s, box-shadow .2s;
        }
        .btn-volver-catalogo:hover {
            border-color: var(--color-celeste);
            transform: translateY(-1px);
            box-shadow: var(--sombra-suave);
        }

        /* Hint texto del candado */
        .curriculum-hint {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--color-texto-suave);
            font-style: italic;
        }

        @media (max-width: 640px) {
            .curso-hero { padding: 36px 16px 40px; }
            .detalle-layout { padding: 24px 14px 56px; }
            .modulo-header { padding: 14px 16px; }
            .leccion-row { padding: 11px 16px 11px 52px; }
            .inscripcion-toast { bottom: 16px; }
        }
    </style>
</head>
<body>

<%@ include file="./fragmentos/nav.jspf" %>

<%-- ═══════════════════════════════════════════════════════
     TOAST — Mensaje de inscripción (oculto por defecto)
════════════════════════════════════════════════════════ --%>
<div class="inscripcion-toast" id="inscripcionToast" role="alert" aria-live="polite">
    <div class="toast-icon" aria-hidden="true">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
             fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
        </svg>
    </div>
    <div class="toast-body">
        <p class="toast-titulo">Acceso restringido</p>
        <p class="toast-msg">
            Debes estar inscrito en este curso para acceder al
            contenido de las lecciones.
        </p>
    </div>
    <button type="button"
            class="toast-close"
            onclick="cerrarToast()"
            aria-label="Cerrar mensaje">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
             fill="none" stroke="currentColor" stroke-width="2.5">
            <line x1="18" y1="6" x2="6" y2="18"/>
            <line x1="6" y1="6" x2="18" y2="18"/>
        </svg>
    </button>
</div>

<%-- ═══════════════════════════════════════════════════════
     HERO DEL CURSO
════════════════════════════════════════════════════════ --%>
<c:if test="${not empty curso}">

    <header class="curso-hero">
        <div class="curso-hero-inner">
                <%-- Breadcrumb --%>
            <nav class="hero-breadcrumb" aria-label="Ruta de navegación">
                <a href="${pageContext.request.contextPath}/catalogo">Catálogo</a>
                <span class="sep" aria-hidden="true">›</span>
                <span class="current" title="${curso.titulo}">
                <c:choose>
                    <c:when test="${fn:length(curso.titulo) > 40}">
                        <c:out value="${fn:substring(curso.titulo, 0, 40)}"/>...
                    </c:when>
                    <c:otherwise><c:out value="${curso.titulo}"/></c:otherwise>
                </c:choose>
            </span>
            </nav>

                <%-- Título --%>
            <h1><c:out value="${curso.titulo}"/></h1>

                <%-- Descripción completa --%>
            <c:if test="${not empty curso.descripcion}">
                <p class="curso-hero-descripcion">
                    <c:out value="${curso.descripcion}"/>
                </p>
            </c:if>

                <%-- Pills de metadatos --%>
            <div class="curso-hero-pills">
                    <%-- Instructor --%>
                <c:if test="${not empty curso.creador}">
                <span class="hero-pill">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    <c:out value="${curso.creador.nombres}"/>
                    <c:out value="${curso.creador.apellidos}"/>
                </span>
                </c:if>
                    <%-- Categoría --%>
                <span class="hero-pill">
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                    <line x1="7" y1="7" x2="7.01" y2="7"/>
                </svg>
                <c:out value="${curso.categoria}"/>
            </span>
                    <%-- Módulos --%>
                <c:if test="${not empty curso.modulos}">
                <span class="hero-pill">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                        <line x1="8" y1="21" x2="16" y2="21"/>
                        <line x1="12" y1="17" x2="12" y2="21"/>
                    </svg>
                    ${fn:length(curso.modulos)} módulo${fn:length(curso.modulos) != 1 ? 's' : ''}
                </span>
                </c:if>
            </div>
        </div>
    </header>

    <%-- ═══════════════════════════════════════════════════════
         CONTENIDO PRINCIPAL
    ════════════════════════════════════════════════════════ --%>
    <div class="detalle-layout">

            <%-- ── Currículum / Acordeón ── --%>
        <div class="curriculum-card">
            <div class="curriculum-header">
                <h2>
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2"
                         style="color:var(--color-celeste)" aria-hidden="true">
                        <line x1="8" y1="6" x2="21" y2="6"/>
                        <line x1="8" y1="12" x2="21" y2="12"/>
                        <line x1="8" y1="18" x2="21" y2="18"/>
                        <line x1="3" y1="6" x2="3.01" y2="6"/>
                        <line x1="3" y1="12" x2="3.01" y2="12"/>
                        <line x1="3" y1="18" x2="3.01" y2="18"/>
                    </svg>
                    Contenido del Curso
                </h2>
                <div class="curriculum-stats">
                    <c:if test="${not empty curso.modulos}">
                    <span class="curriculum-stat">
                        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="2" y="3" width="20" height="14" rx="2"/>
                            <line x1="8" y1="21" x2="16" y2="21"/>
                        </svg>
                        ${fn:length(curso.modulos)} módulos
                    </span>
                    </c:if>
                    <span class="curriculum-stat" style="color:var(--color-celeste);">
                    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="11" width="18" height="11" rx="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    Requiere inscripción
                </span>
                </div>
            </div>

                <%-- Lista de módulos --%>
            <c:choose>
                <c:when test="${not empty curso.modulos}">
                    <c:forEach var="modulo" items="${curso.modulos}" varStatus="mSt">
                        <div class="modulo-acordeon">
                                <%-- Header del módulo (botón) --%>
                            <button type="button"
                                    class="modulo-header ${mSt.first ? 'active' : ''}"
                                    id="header-${modulo.id}"
                                    onclick="toggleModulo('${modulo.id}')"
                                    aria-expanded="${mSt.first ? 'true' : 'false'}"
                                    aria-controls="body-${modulo.id}">

                                <span class="modulo-num">${modulo.orden}</span>

                                <div class="modulo-info">
                                    <p class="modulo-titulo"><c:out value="${modulo.titulo}"/></p>
                                    <c:if test="${not empty modulo.lecciones}">
                                        <p class="modulo-leccion-count">
                                                ${fn:length(modulo.lecciones)}
                                            lección${fn:length(modulo.lecciones) != 1 ? 'es' : ''}
                                        </p>
                                    </c:if>
                                </div>

                                    <%-- Chevron --%>
                                <svg class="modulo-chevron"
                                     id="chevron-${modulo.id}"
                                     xmlns="http://www.w3.org/2000/svg"
                                     width="18" height="18" viewBox="0 0 24 24"
                                     fill="none" stroke="currentColor" stroke-width="2.5"
                                     aria-hidden="true"
                                     style="${mSt.first ? 'transform:rotate(180deg);color:var(--color-celeste)' : ''}">
                                    <polyline points="6 9 12 15 18 9"/>
                                </svg>
                            </button>

                                <%-- Cuerpo: lista de lecciones --%>
                            <div class="modulo-body ${mSt.first ? 'open' : ''}"
                                 id="body-${modulo.id}"
                                 role="region"
                                 aria-labelledby="header-${modulo.id}">

                                <c:choose>
                                    <c:when test="${not empty modulo.lecciones}">
                                        <ul class="lecciones-lista">
                                            <c:forEach var="leccion" items="${modulo.lecciones}">
                                                <li class="leccion-row"
                                                    onclick="mostrarMensajeInscripcion()"
                                                    title="Haz clic para más información"
                                                    tabindex="0"
                                                    onkeydown="if(event.key==='Enter'||event.key===' ')mostrarMensajeInscripcion()">

                                                        <%-- Icono según tipo --%>
                                                    <span class="leccion-tipo-icon
                                                    <c:choose>
                                                        <c:when test='${leccion.tipo == "VIDEO"}'>leccion-tipo-video</c:when>
                                                        <c:when test='${leccion.tipo == "QUIZ"}'>leccion-tipo-quiz</c:when>
                                                        <c:otherwise>leccion-tipo-texto</c:otherwise>
                                                    </c:choose>"
                                                          aria-hidden="true">
                                                    <c:choose>
                                                        <c:when test="${leccion.tipo == 'VIDEO'}">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                                                                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <polygon points="23 7 16 12 23 17 23 7"/>
                                                                <rect x="1" y="5" width="15" height="14" rx="2"/>
                                                            </svg>
                                                        </c:when>
                                                        <c:when test="${leccion.tipo == 'QUIZ'}">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                                                                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                                                                <polyline points="14 2 14 8 20 8"/>
                                                                <line x1="16" y1="13" x2="8" y2="13"/>
                                                            </svg>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                                                                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                                                                <polyline points="14 2 14 8 20 8"/>
                                                            </svg>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>

                                                    <span class="leccion-titulo-text">
                                                    <c:out value="${leccion.titulo}"/>
                                                </span>

                                                        <%-- Candado --%>
                                                    <span class="leccion-lock" aria-label="Contenido bloqueado">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                                                         viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                                    </svg>
                                                </span>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="padding:16px 24px 16px 64px;font-size:13px;color:var(--color-texto-suave);">
                                            Este módulo no tiene lecciones aún.
                                        </p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>

                    <%-- Hint: click en lección --%>
                    <div style="padding:14px 24px;border-top:1px solid #f1f5f9;background:#fafbfc;">
                        <p class="curriculum-hint">
                            <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"/>
                                <line x1="12" y1="8" x2="12" y2="12"/>
                                <line x1="12" y1="16" x2="12.01" y2="16"/>
                            </svg>
                            Haz clic en cualquier lección para ver los requisitos de acceso.
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="padding:48px 24px;text-align:center;color:var(--color-texto-suave);">
                        <p>Este curso aún no tiene contenido disponible.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

            <%-- ── Footer: botón volver ── --%>
        <div class="detalle-footer">
            <a href="${pageContext.request.contextPath}/catalogo"
               class="btn-volver-catalogo"
               id="btnVolver">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                    <path d="m15 18-6-6 6-6"/>
                </svg>
                Volver al Catálogo
            </a>
            <p style="font-size:12px;color:var(--color-texto-suave);">
                ¿Quieres acceder? Inscríbete para desbloquear todo el contenido.
            </p>
        </div>
    </div>

</c:if>

<%-- Fallback si no hay curso --%>
<c:if test="${empty curso}">
    <div style="max-width:500px;margin:80px auto;text-align:center;padding:24px;">
        <h2 style="color:var(--color-texto);margin-bottom:12px;">Curso no encontrado</h2>
        <p style="color:var(--color-texto-suave);margin-bottom:24px;">
            El curso solicitado no existe o no está disponible.
        </p>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-marca">
            Volver al Catálogo
        </a>
    </div>
</c:if>

<script>
    if (typeof lucide !== 'undefined') lucide.createIcons();

    /* ═══════════════════════════════════════════════════════
       ACORDEÓN DE MÓDULOS
       Primer módulo expandido por defecto (manejado desde HTML con clase .open)
    ════════════════════════════════════════════════════════ */
    function toggleModulo(moduloId) {
        var body    = document.getElementById('body-' + moduloId);
        var header  = document.getElementById('header-' + moduloId);
        var chevron = document.getElementById('chevron-' + moduloId);

        if (!body) return;

        var estaAbierto = body.classList.contains('open');

        // Cerrar TODOS los módulos primero (comportamiento acordeón exclusivo)
        document.querySelectorAll('.modulo-body').forEach(function(b) {
            b.classList.remove('open');
        });
        document.querySelectorAll('.modulo-header').forEach(function(h) {
            h.classList.remove('active');
            h.setAttribute('aria-expanded', 'false');
        });
        document.querySelectorAll('.modulo-chevron').forEach(function(c) {
            c.style.transform = '';
            c.style.color = '';
        });

        // Si estaba cerrado → abrir; si estaba abierto → dejarlo cerrado (ya se cerró arriba)
        if (!estaAbierto) {
            body.classList.add('open');
            header.classList.add('active');
            header.setAttribute('aria-expanded', 'true');
            if (chevron) {
                chevron.style.transform = 'rotate(180deg)';
                chevron.style.color     = 'var(--color-celeste)';
            }
        }
    }

    /* ═══════════════════════════════════════════════════════
       MENSAJE DE INSCRIPCIÓN — toast no bloqueante
    ════════════════════════════════════════════════════════ */
    var toastTimer = null;

    function mostrarMensajeInscripcion() {
        var toast = document.getElementById('inscripcionToast');
        if (!toast) return;

        // Cancelar cierre automático previo
        if (toastTimer) clearTimeout(toastTimer);

        toast.classList.add('visible');

        // Cerrar automáticamente después de 5 segundos
        toastTimer = setTimeout(function () {
            cerrarToast();
        }, 5000);
    }

    function cerrarToast() {
        var toast = document.getElementById('inscripcionToast');
        if (toast) toast.classList.remove('visible');
        if (toastTimer) { clearTimeout(toastTimer); toastTimer = null; }
    }

    // Cerrar al hacer clic fuera del toast
    document.addEventListener('click', function (e) {
        var toast = document.getElementById('inscripcionToast');
        if (toast && toast.classList.contains('visible') && !toast.contains(e.target)) {
            var esLeccion = e.target.closest('.leccion-row');
            if (!esLeccion) cerrarToast();
        }
    });

    // Cerrar con Escape
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') cerrarToast();
    });

    /* ═══════════════════════════════════════════════════════
       BOTÓN VOLVER — Guarda posición del catálogo antes de salir
       (La restauración la hace catalogo.jsp al cargar)
    ════════════════════════════════════════════════════════ */
    var SCROLL_KEY = 'redsaberes_catalogo_scroll';

    /* No necesitamos hacer nada especial aquí:
       La posición se guardó en catalogo.jsp cuando el usuario hizo
       clic en "Ver Curso". El botón volver es un enlace GET estándar
       y catalogo.jsp restaura la posición al cargar. */

    var btnVolver = document.getElementById('btnVolver');
    if (btnVolver) {
        /* Accesibilidad: marcar que regresa al catálogo */
        btnVolver.setAttribute('aria-label', 'Volver al catálogo de cursos');
    }
</script>
</body>
</html>