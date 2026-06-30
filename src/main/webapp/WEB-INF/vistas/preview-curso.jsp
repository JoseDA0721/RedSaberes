<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Previsualización del curso</title>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        .preview-page {
            --preview-brand: #0b4f6c;
            --preview-sky: #01baef;
            --preview-green: #20bf55;
            --preview-amber: #d97706;
            --preview-text: #172b3a;
            --preview-muted: #64748b;
            --preview-border: rgba(11, 79, 108, .12);
            width: min(100% - 32px, 1100px);
            margin: 0 auto;
            padding: 34px 0 64px;
        }

        .preview-stack {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .preview-page-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .preview-title-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 7px;
        }

        .preview-title-icon {
            width: 38px;
            height: 38px;
            display: grid;
            place-items: center;
            flex: 0 0 auto;
            border-radius: 12px;
            background: rgba(1, 186, 239, .1);
            color: var(--preview-sky);
        }

        .preview-title-icon i {
            width: 20px;
            height: 20px;
        }

        .preview-page-header h1 {
            color: var(--preview-text);
            font-size: clamp(25px, 4vw, 32px);
            line-height: 1.15;
            letter-spacing: -.025em;
        }

        .preview-page-subtitle {
            color: var(--preview-muted);
            font-size: 14px;
            line-height: 1.6;
        }

        .preview-header-actions,
        .preview-bottom-actions {
            display: flex;
            align-items: center;
            gap: 9px;
            flex-wrap: wrap;
        }

        .preview-action {
            min-height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 9px 15px;
            border: 1px solid rgba(11, 79, 108, .2);
            border-radius: 12px;
            background: #fff;
            color: var(--preview-brand);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: transform .18s ease, background .18s ease, box-shadow .18s ease;
        }

        .preview-action:hover {
            transform: translateY(-1px);
            background: #f0f9ff;
            box-shadow: 0 5px 15px rgba(11, 79, 108, .08);
        }

        .preview-action-primary {
            border-color: var(--preview-brand);
            background: var(--preview-brand);
            color: #fff;
        }

        .preview-action-primary:hover {
            background: #083f57;
        }

        .preview-action i {
            width: 15px;
            height: 15px;
        }

        .preview-readonly-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            width: fit-content;
            padding: 6px 11px;
            border: 1px solid #dbe4eb;
            border-radius: 999px;
            background: #f8fafc;
            color: #526575;
            font-size: 12px;
            font-weight: 700;
        }

        .preview-readonly-badge i {
            width: 13px;
            height: 13px;
        }

        .preview-warning-banner {
            display: flex;
            align-items: flex-start;
            gap: 13px;
            padding: 16px 18px;
            border: 1px solid #fde68a;
            border-radius: 16px;
            background: #fffbeb;
        }

        .preview-warning-icon {
            width: 36px;
            height: 36px;
            display: grid;
            place-items: center;
            flex: 0 0 auto;
            border-radius: 11px;
            background: #fef3c7;
            color: var(--preview-amber);
        }

        .preview-warning-icon i {
            width: 18px;
            height: 18px;
        }

        .preview-warning-title {
            margin-bottom: 3px;
            color: #92400e;
            font-size: 14px;
            font-weight: 800;
        }

        .preview-warning-text {
            color: #a16207;
            font-size: 13px;
            line-height: 1.55;
        }

        .preview-course-card {
            overflow: hidden;
            border: 1px solid var(--preview-border);
            border-radius: 20px;
            background: rgba(255, 255, 255, .97);
            box-shadow: 0 3px 15px rgba(15, 23, 42, .06);
        }

        .preview-course-accent {
            height: 5px;
            background: linear-gradient(90deg, var(--preview-brand), var(--preview-sky), var(--preview-green));
        }

        .preview-course-body {
            padding: 27px 30px 25px;
        }

        .preview-course-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }

        .preview-course-title {
            max-width: 760px;
            color: var(--preview-text);
            font-size: clamp(21px, 3vw, 27px);
            line-height: 1.28;
            letter-spacing: -.02em;
        }

        .preview-course-status {
            display: inline-flex;
            padding: 5px 10px;
            border: 1px solid #bfdbfe;
            border-radius: 999px;
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 11px;
            font-weight: 800;
            text-transform: capitalize;
        }

        .preview-course-description {
            max-width: 850px;
            margin-bottom: 20px;
            color: var(--preview-muted);
            font-size: 14px;
            line-height: 1.7;
        }

        .preview-course-meta {
            display: flex;
            align-items: center;
            gap: 12px 26px;
            flex-wrap: wrap;
        }

        .preview-meta-item {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            color: var(--preview-muted);
            font-size: 12px;
        }

        .preview-meta-item i {
            width: 14px;
            height: 14px;
            color: var(--preview-sky);
        }

        .preview-stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
        }

        .preview-stat-card {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
            padding: 16px;
            border: 1px solid var(--preview-border);
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 2px 9px rgba(15, 23, 42, .045);
        }

        .preview-stat-icon {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            flex: 0 0 auto;
            border-radius: 12px;
        }

        .preview-stat-icon i {
            width: 20px;
            height: 20px;
        }

        .preview-stat-icon-modules {
            background: #eff6ff;
            color: var(--preview-brand);
        }

        .preview-stat-icon-lessons {
            background: #f0f9ff;
            color: #0284c7;
        }

        .preview-stat-icon-complete {
            background: #f0fdf4;
            color: #16a34a;
        }

        .preview-stat-icon-pending {
            background: #fffbeb;
            color: var(--preview-amber);
        }

        .preview-stat-value {
            color: var(--preview-text);
            font-size: 28px;
            font-weight: 800;
            line-height: 1;
        }

        .preview-stat-label {
            margin-top: 4px;
            color: var(--preview-muted);
            font-size: 12px;
            line-height: 1.25;
        }

        .preview-section-heading {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 13px;
        }

        .preview-section-heading i {
            width: 19px;
            height: 19px;
            color: var(--preview-sky);
        }

        .preview-section-heading h2 {
            color: var(--preview-text);
            font-size: 18px;
        }

        .preview-section-count {
            color: var(--preview-muted);
            font-size: 13px;
        }

        .preview-module-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .preview-module-card {
            overflow: hidden;
            border: 1px solid var(--preview-border);
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 2px 10px rgba(15, 23, 42, .045);
            transition: border-color .2s ease, box-shadow .2s ease;
        }

        .preview-module-card:hover {
            box-shadow: 0 7px 22px rgba(15, 23, 42, .075);
        }

        .preview-module-card.preview-module-has-pending {
            border-color: #fde68a;
        }

        .preview-module-toggle {
            width: 100%;
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 17px 20px;
            border: 0;
            background: transparent;
            color: inherit;
            text-align: left;
            cursor: pointer;
            transition: background .18s ease;
        }

        .preview-module-toggle:hover {
            background: #f8fafc;
        }

        .preview-module-number {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            flex: 0 0 auto;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--preview-brand), var(--preview-sky));
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            box-shadow: 0 3px 9px rgba(11, 79, 108, .2);
        }

        .preview-module-info {
            min-width: 0;
            flex: 1;
        }

        .preview-module-title {
            color: var(--preview-text);
            font-size: 15px;
            font-weight: 800;
            line-height: 1.35;
        }

        .preview-module-meta {
            display: flex;
            align-items: center;
            gap: 7px;
            margin-top: 5px;
            flex-wrap: wrap;
            color: var(--preview-muted);
            font-size: 12px;
        }

        .preview-module-pending {
            color: var(--preview-amber);
            font-weight: 700;
        }

        .preview-module-chevron {
            width: 30px;
            height: 30px;
            display: grid;
            place-items: center;
            flex: 0 0 auto;
            border-radius: 9px;
            color: var(--preview-muted);
            transition: transform .25s ease, background .2s ease;
        }

        .preview-module-chevron i {
            width: 17px;
            height: 17px;
        }

        .preview-module-card.collapsed .preview-module-chevron {
            transform: rotate(-90deg);
        }

        .preview-lessons-wrap {
            display: grid;
            grid-template-rows: 1fr;
            transition: grid-template-rows .28s ease;
        }

        .preview-module-card.collapsed .preview-lessons-wrap {
            grid-template-rows: 0fr;
        }

        .preview-lessons-inner {
            min-height: 0;
            overflow: hidden;
        }

        .preview-lessons-content {
            padding: 0 20px 20px;
        }

        .preview-lessons-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
            list-style: none;
        }

        .preview-lesson-row {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 13px 15px;
            border: 1px solid rgba(11, 79, 108, .09);
            border-radius: 13px;
            background: #fff;
        }

        .preview-lesson-row.preview-lesson-pending {
            border-color: #fde68a;
            background: #fffdf4;
        }

        .preview-lesson-number {
            width: 26px;
            height: 26px;
            display: grid;
            place-items: center;
            flex: 0 0 auto;
            margin-top: 1px;
            border-radius: 50%;
            background: #f1f5f9;
            color: #64748b;
            font-size: 11px;
            font-weight: 800;
        }

        .preview-lesson-body {
            min-width: 0;
            flex: 1;
        }

        .preview-lesson-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
        }

        .preview-lesson-title {
            color: var(--preview-text);
            font-size: 14px;
            font-weight: 700;
            line-height: 1.4;
        }

        .preview-lesson-type {
            display: block;
            margin-top: 4px;
            color: var(--preview-muted);
            font-size: 11px;
        }

        .preview-lesson-warning {
            margin-top: 7px;
            color: #b45309;
            font-size: 11px;
            line-height: 1.4;
        }

        .preview-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            flex: 0 0 auto;
            padding: 4px 8px;
            border: 1px solid;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
            white-space: nowrap;
        }

        .preview-pill i {
            width: 12px;
            height: 12px;
        }

        .preview-pill-ok {
            border-color: #bbf7d0;
            background: #dcfce7;
            color: #15803d;
        }

        .preview-pill-pending {
            border-color: #fde68a;
            background: #fef3c7;
            color: #b45309;
        }

        .preview-empty-module {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 32px 20px;
            border: 1px dashed #cbd5e1;
            border-radius: 13px;
            background: #f8fafc;
            text-align: center;
        }

        .preview-empty-icon {
            width: 46px;
            height: 46px;
            display: grid;
            place-items: center;
            margin-bottom: 10px;
            border-radius: 50%;
            background: #eef2f6;
            color: #94a3b8;
        }

        .preview-empty-icon i {
            width: 23px;
            height: 23px;
        }

        .preview-empty-module h4,
        .preview-empty-course h2,
        .preview-load-error h1 {
            margin-bottom: 6px;
            color: #475569;
            font-size: 15px;
        }

        .preview-empty-module p,
        .preview-empty-course p,
        .preview-load-error p {
            max-width: 420px;
            color: #8493a3;
            font-size: 12px;
            line-height: 1.55;
        }

        .preview-empty-course,
        .preview-load-error {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 58px 24px;
            border: 1px dashed rgba(11, 79, 108, .2);
            border-radius: 20px;
            background: #fff;
            text-align: center;
        }

        .preview-empty-course .preview-action,
        .preview-load-error .preview-action {
            margin-top: 18px;
        }

        .preview-bottom-actions {
            justify-content: flex-end;
            padding-top: 3px;
        }

        @media (max-width: 820px) {
            .preview-stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 680px) {
            .preview-page {
                width: min(100% - 24px, 1100px);
                padding-top: 24px;
            }

            .preview-page-header {
                flex-direction: column;
            }

            .preview-header-actions {
                width: 100%;
            }

            .preview-header-actions .preview-action {
                flex: 1;
            }

            .preview-course-body {
                padding: 22px 20px;
            }

            .preview-bottom-actions .preview-action {
                flex: 1;
            }
        }

        @media (max-width: 460px) {
            .preview-stats-grid {
                grid-template-columns: 1fr;
            }

            .preview-stat-card {
                padding: 14px;
            }

            .preview-module-toggle {
                padding: 15px;
            }

            .preview-lessons-content {
                padding: 0 15px 15px;
            }

            .preview-lesson-top {
                display: block;
            }

            .preview-pill {
                margin-top: 8px;
            }
        }
    </style>
</head>
<body>

<%@ include file="./fragmentos/nav.jspf" %>

<main class="preview-page">
    <c:choose>
        <c:when test="${not empty requestScope.cursoEstructura}">
            <c:set var="leccionesConContenido" value="${0}" />
            <c:set var="leccionesSinContenido" value="${0}" />
            <c:set var="hayModulosSinLecciones" value="${false}" />

            <c:forEach var="moduloResumen" items="${requestScope.cursoEstructura.modulos()}">
                <c:if test="${empty moduloResumen.lecciones()}">
                    <c:set var="hayModulosSinLecciones" value="${true}" />
                </c:if>
                <c:forEach var="leccionResumen" items="${moduloResumen.lecciones()}">
                    <c:choose>
                        <c:when test="${leccionResumen.tieneContenido()}">
                            <c:set var="leccionesConContenido" value="${leccionesConContenido + 1}" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="leccionesSinContenido" value="${leccionesSinContenido + 1}" />
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </c:forEach>

            <c:set var="cursoIncompleto"
                   value="${hayModulosSinLecciones or leccionesSinContenido gt 0}" />

            <div class="preview-stack">
                <header class="preview-page-header">
                    <div>
                        <div class="preview-title-row">
                            <span class="preview-title-icon" aria-hidden="true">
                                <i data-lucide="eye"></i>
                            </span>
                            <h1>Previsualización del curso</h1>
                        </div>
                        <p class="preview-page-subtitle">
                            Revisa la estructura del curso antes de publicarlo.
                        </p>
                        <span class="preview-readonly-badge">
                            <i data-lucide="lock" aria-hidden="true"></i>
                            Solo lectura
                        </span>
                    </div>

                    <nav class="preview-header-actions" aria-label="Acciones de previsualización">
                        <a class="preview-action"
                           href="${pageContext.request.contextPath}/my-courses">
                            <i data-lucide="library" aria-hidden="true"></i>
                            Ver mis cursos
                        </a>
                        <a class="preview-action preview-action-primary"
                           href="${pageContext.request.contextPath}/modulos?cursoId=${requestScope.cursoEstructura.id()}">
                            <i data-lucide="arrow-left" aria-hidden="true"></i>
                            Volver a edición
                        </a>
                    </nav>
                </header>

                <c:if test="${cursoIncompleto}">
                    <aside class="preview-warning-banner" role="alert">
                        <span class="preview-warning-icon" aria-hidden="true">
                            <i data-lucide="triangle-alert"></i>
                        </span>
                        <div>
                            <p class="preview-warning-title">Curso con elementos pendientes</p>
                            <p class="preview-warning-text">
                                Este curso tiene elementos pendientes. Revisa las lecciones sin contenido
                                o los módulos vacíos antes de publicarlo.
                            </p>
                        </div>
                    </aside>
                </c:if>

                <section class="preview-course-card" aria-labelledby="preview-course-title">
                    <div class="preview-course-accent"></div>
                    <div class="preview-course-body">
                        <div class="preview-course-top">
                            <h2 id="preview-course-title" class="preview-course-title">
                                <c:out value="${requestScope.cursoEstructura.titulo()}" />
                            </h2>
                            <c:choose>
                                <c:when test="${not empty requestScope.cursoEstructura.estado()}">
                                    <span class="preview-course-status">
                                        <c:out value="${requestScope.cursoEstructura.estado()}" />
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="preview-course-status">Estado no definido</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:choose>
                            <c:when test="${not empty requestScope.cursoEstructura.descripcion()}">
                                <p class="preview-course-description">
                                    <c:out value="${requestScope.cursoEstructura.descripcion()}" />
                                </p>
                            </c:when>
                            <c:otherwise>
                                <p class="preview-course-description">Sin descripción registrada.</p>
                            </c:otherwise>
                        </c:choose>

                        <div class="preview-course-meta">
                            <span class="preview-meta-item">
                                <i data-lucide="tag" aria-hidden="true"></i>
                                <c:choose>
                                    <c:when test="${not empty requestScope.cursoEstructura.categoria()}">
                                        <c:out value="${requestScope.cursoEstructura.categoria()}" />
                                    </c:when>
                                    <c:otherwise>Sin categoría</c:otherwise>
                                </c:choose>
                            </span>

                            <span class="preview-meta-item">
                                <i data-lucide="user-round" aria-hidden="true"></i>
                                <c:choose>
                                    <c:when test="${not empty requestScope.cursoEstructura.creadorNombres()
                                                    or not empty requestScope.cursoEstructura.creadorApellidos()}">
                                        <c:out value="${requestScope.cursoEstructura.creadorNombres()}" />
                                        <c:out value="${requestScope.cursoEstructura.creadorApellidos()}" />
                                    </c:when>
                                    <c:otherwise>Creador no disponible</c:otherwise>
                                </c:choose>
                            </span>

                            <span class="preview-meta-item">
                                <i data-lucide="calendar-days" aria-hidden="true"></i>
                                <c:choose>
                                    <c:when test="${not empty requestScope.cursoEstructura.fechaCreacion()}">
                                        <c:out value="${requestScope.cursoEstructura.fechaCreacion()}" />
                                    </c:when>
                                    <c:otherwise>Fecha no disponible</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </section>

                <section class="preview-stats-grid" aria-label="Resumen de la estructura">
                    <article class="preview-stat-card">
                        <span class="preview-stat-icon preview-stat-icon-modules" aria-hidden="true">
                            <i data-lucide="layers-3"></i>
                        </span>
                        <div>
                            <p class="preview-stat-value">
                                <c:out value="${requestScope.cursoEstructura.totalModulos()}" />
                            </p>
                            <p class="preview-stat-label">Módulos</p>
                        </div>
                    </article>

                    <article class="preview-stat-card">
                        <span class="preview-stat-icon preview-stat-icon-lessons" aria-hidden="true">
                            <i data-lucide="book-open"></i>
                        </span>
                        <div>
                            <p class="preview-stat-value">
                                <c:out value="${requestScope.cursoEstructura.totalLecciones()}" />
                            </p>
                            <p class="preview-stat-label">Lecciones</p>
                        </div>
                    </article>

                    <article class="preview-stat-card">
                        <span class="preview-stat-icon preview-stat-icon-complete" aria-hidden="true">
                            <i data-lucide="circle-check"></i>
                        </span>
                        <div>
                            <p class="preview-stat-value"><c:out value="${leccionesConContenido}" /></p>
                            <p class="preview-stat-label">Con contenido</p>
                        </div>
                    </article>

                    <article class="preview-stat-card">
                        <span class="preview-stat-icon preview-stat-icon-pending" aria-hidden="true">
                            <i data-lucide="circle-alert"></i>
                        </span>
                        <div>
                            <p class="preview-stat-value"><c:out value="${leccionesSinContenido}" /></p>
                            <p class="preview-stat-label">Pendientes</p>
                        </div>
                    </article>
                </section>

                <section aria-labelledby="preview-structure-title">
                    <div class="preview-section-heading">
                        <i data-lucide="list-tree" aria-hidden="true"></i>
                        <h2 id="preview-structure-title">Estructura del curso</h2>
                        <span class="preview-section-count">
                            <c:out value="${requestScope.cursoEstructura.totalModulos()}" />
                            <c:choose>
                                <c:when test="${requestScope.cursoEstructura.totalModulos() eq 1}">módulo</c:when>
                                <c:otherwise>módulos</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <c:choose>
                        <c:when test="${empty requestScope.cursoEstructura.modulos()}">
                            <div class="preview-empty-course">
                                <span class="preview-empty-icon" aria-hidden="true">
                                    <i data-lucide="folder-open"></i>
                                </span>
                                <h2>Este curso no tiene módulos registrados</h2>
                                <p>Regresa a la edición del curso para completar su estructura.</p>
                                <a class="preview-action preview-action-primary"
                                   href="${pageContext.request.contextPath}/modulos?cursoId=${requestScope.cursoEstructura.id()}">
                                    <i data-lucide="arrow-left" aria-hidden="true"></i>
                                    Volver a edición
                                </a>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="preview-module-list">
                                <c:forEach var="modulo"
                                           items="${requestScope.cursoEstructura.modulos()}"
                                           varStatus="moduloStatus">
                                    <c:set var="pendientesModulo" value="${0}" />
                                    <c:forEach var="leccionModulo" items="${modulo.lecciones()}">
                                        <c:if test="${not leccionModulo.tieneContenido()}">
                                            <c:set var="pendientesModulo" value="${pendientesModulo + 1}" />
                                        </c:if>
                                    </c:forEach>

                                    <article class="preview-module-card ${empty modulo.lecciones() or pendientesModulo gt 0
                                                     ? 'preview-module-has-pending' : ''}">
                                        <button type="button"
                                                class="preview-module-toggle"
                                                aria-expanded="true"
                                                aria-controls="preview-module-body-${moduloStatus.index}">
                                            <span class="preview-module-number">
                                                <c:out value="${modulo.orden()}" />
                                            </span>

                                            <span class="preview-module-info">
                                                <span class="preview-module-title">
                                                    <c:out value="${modulo.titulo()}" />
                                                </span>
                                                <span class="preview-module-meta">
                                                    <span>
                                                        <c:out value="${fn:length(modulo.lecciones())}" />
                                                        <c:choose>
                                                            <c:when test="${fn:length(modulo.lecciones()) eq 1}">
                                                                lección
                                                            </c:when>
                                                            <c:otherwise>lecciones</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <c:choose>
                                                        <c:when test="${empty modulo.lecciones()}">
                                                            <span aria-hidden="true">·</span>
                                                            <span class="preview-module-pending">Módulo vacío</span>
                                                        </c:when>
                                                        <c:when test="${pendientesModulo gt 0}">
                                                            <span aria-hidden="true">·</span>
                                                            <span class="preview-module-pending">
                                                                <c:out value="${pendientesModulo}" />
                                                                <c:choose>
                                                                    <c:when test="${pendientesModulo eq 1}">
                                                                        pendiente
                                                                    </c:when>
                                                                    <c:otherwise>pendientes</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </span>
                                            </span>

                                            <span class="preview-module-chevron" aria-hidden="true">
                                                <i data-lucide="chevron-up"></i>
                                            </span>
                                        </button>

                                        <div id="preview-module-body-${moduloStatus.index}"
                                             class="preview-lessons-wrap">
                                            <div class="preview-lessons-inner">
                                                <div class="preview-lessons-content">
                                                    <c:choose>
                                                        <c:when test="${empty modulo.lecciones()}">
                                                            <div class="preview-empty-module">
                                                                <span class="preview-empty-icon" aria-hidden="true">
                                                                    <i data-lucide="notebook-tabs"></i>
                                                                </span>
                                                                <h4>Este módulo no tiene lecciones.</h4>
                                                                <p>
                                                                    Agrega lecciones desde la edición del curso
                                                                    para completar la estructura.
                                                                </p>
                                                            </div>
                                                        </c:when>

                                                        <c:otherwise>
                                                            <ol class="preview-lessons-list">
                                                                <c:forEach var="leccion" items="${modulo.lecciones()}">
                                                                    <li class="preview-lesson-row ${leccion.tieneContenido()
                                                                               ? '' : 'preview-lesson-pending'}">
                                                                        <span class="preview-lesson-number">
                                                                            <c:out value="${leccion.orden()}" />
                                                                        </span>
                                                                        <div class="preview-lesson-body">
                                                                            <div class="preview-lesson-top">
                                                                                <div>
                                                                                    <p class="preview-lesson-title">
                                                                                        <c:out value="${leccion.titulo()}" />
                                                                                    </p>
                                                                                    <c:if test="${not empty leccion.tipo()}">
                                                                                        <span class="preview-lesson-type">
                                                                                            Tipo:
                                                                                            <c:out value="${leccion.tipo()}" />
                                                                                        </span>
                                                                                    </c:if>
                                                                                </div>

                                                                                <c:choose>
                                                                                    <c:when test="${leccion.tieneContenido()}">
                                                                                        <span class="preview-pill preview-pill-ok">
                                                                                            <i data-lucide="circle-check"
                                                                                               aria-hidden="true"></i>
                                                                                            Con contenido
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="preview-pill preview-pill-pending">
                                                                                            <i data-lucide="circle-alert"
                                                                                               aria-hidden="true"></i>
                                                                                            Sin contenido
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>

                                                                            <c:if test="${not leccion.tieneContenido()}">
                                                                                <p class="preview-lesson-warning">
                                                                                    Esta lección no tiene contenido educativo.
                                                                                </p>
                                                                            </c:if>
                                                                        </div>
                                                                    </li>
                                                                </c:forEach>
                                                            </ol>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <nav class="preview-bottom-actions" aria-label="Acciones de previsualización">
                    <a class="preview-action"
                       href="${pageContext.request.contextPath}/my-courses">
                        Ver mis cursos
                    </a>
                    <a class="preview-action preview-action-primary"
                       href="${pageContext.request.contextPath}/modulos?cursoId=${requestScope.cursoEstructura.id()}">
                        <i data-lucide="arrow-left" aria-hidden="true"></i>
                        Volver a edición
                    </a>
                </nav>
            </div>
        </c:when>

        <c:otherwise>
            <section class="preview-load-error" role="status">
                <span class="preview-empty-icon" aria-hidden="true">
                    <i data-lucide="file-warning"></i>
                </span>
                <h1>No se pudo cargar la información del curso</h1>
                <p>La estructura del curso no está disponible en este momento.</p>
                <a class="preview-action"
                   href="${pageContext.request.contextPath}/my-courses">
                    Ver mis cursos
                </a>
            </section>
        </c:otherwise>
    </c:choose>
</main>

<script>
    document.querySelectorAll(".preview-module-toggle").forEach(function (toggle) {
        toggle.addEventListener("click", function () {
            var moduleCard = toggle.closest(".preview-module-card");
            var isCollapsed = moduleCard.classList.toggle("collapsed");
            toggle.setAttribute("aria-expanded", String(!isCollapsed));
        });
    });

    if (typeof lucide !== "undefined") {
        lucide.createIcons();
    }
</script>
</body>
</html>
