<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Editar Contenido</title>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        .editor-main {
            max-width: 860px;
            margin: 0 auto;
            padding: 36px 24px 64px;
            animation: fadeIn .4s ease both;
        }

        /* ── Breadcrumb ── */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--color-texto-suave);
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .breadcrumb a {
            color: var(--color-texto-suave);
            text-decoration: none;
            font-weight: 600;
            transition: color .15s;
        }
        .breadcrumb a:hover { color: var(--color-celeste); }
        .breadcrumb .bc-current { color: var(--color-texto); font-weight: 700; }

        /* ── Page header ── */
        .page-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 14px;
            margin-bottom: 28px;
        }
        .page-header h1 {
            font-size: clamp(22px, 3vw, 28px);
            font-weight: 800;
            letter-spacing: -0.5px;
            color: var(--color-texto);
            margin-bottom: 4px;
        }
        .page-header .subtitle {
            font-size: 13px;
            color: var(--color-texto-suave);
        }
        .page-header .subtitle strong { color: var(--color-texto); }

        .btn-volver {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 38px;
            padding: 0 16px;
            border: 1.5px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            background: #fff;
            color: var(--color-texto);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: border-color .2s, transform .2s;
            white-space: nowrap;
        }
        .btn-volver:hover { border-color: var(--color-celeste); transform: translateY(-1px); }

        /* ── Mensajes ── */
        .msg-box {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 12px 16px;
            border-radius: var(--radio-pequeno);
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .msg-success { background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }
        .msg-error   { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }

        /* ── Card contenedor ── */
        .content-card {
            background: rgba(255,255,255,0.96);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            box-shadow: var(--sombra-suave);
            overflow: hidden;
            margin-bottom: 16px;
        }
        .content-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 24px;
            border-bottom: 1px solid #f1f5f9;
            background: #fafbfc;
        }
        .content-card-header h2 {
            font-size: 15px;
            font-weight: 700;
            color: var(--color-texto);
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
        }
        .content-card-header .count-badge {
            font-size: 11px;
            font-weight: 700;
            color: var(--color-texto-suave);
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 999px;
            padding: 2px 9px;
        }
        .content-card-body { padding: 0; }

        /* ── Lista de módulos ── */
        .module-list { list-style: none; padding: 0; margin: 0; }
        .module-item {
            border-bottom: 1px solid #f1f5f9;
        }
        .module-item:last-child { border-bottom: none; }

        /* Fila principal del módulo */
        .module-row {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px 20px;
            transition: background .2s;
        }
        .module-row:hover { background: #f8fafc; }

        .module-grip {
            color: #cbd5e1;
            flex-shrink: 0;
            cursor: grab;
        }
        .module-order {
            font-size: 12px;
            font-weight: 800;
            color: var(--color-celeste);
            min-width: 20px;
            flex-shrink: 0;
            text-align: center;
        }
        .module-reorder {
            display: flex;
            flex-direction: column;
            gap: 0;
            flex-shrink: 0;
        }
        .btn-reorder {
            width: 26px;
            height: 22px;
            border: none;
            background: transparent;
            cursor: pointer;
            display: grid;
            place-items: center;
            color: #94a3b8;
            border-radius: 4px;
            padding: 0;
            transition: color .15s, background .15s;
        }
        .btn-reorder:hover:not(:disabled) { color: var(--color-celeste); background: rgba(1,186,239,0.10); }
        .btn-reorder:disabled { opacity: 0.3; cursor: not-allowed; }

        .module-title {
            flex: 1;
            font-size: 15px;
            font-weight: 700;
            color: var(--color-texto);
            min-width: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .module-meta {
            font-size: 11px;
            color: var(--color-texto-suave);
            flex-shrink: 0;
            background: #f1f5f9;
            border-radius: 999px;
            padding: 3px 9px;
            font-weight: 600;
        }

        .module-actions-btns {
            display: flex;
            gap: 4px;
            flex-shrink: 0;
        }
        .btn-icon {
            width: 32px;
            height: 32px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            display: grid;
            place-items: center;
            transition: background .15s, color .15s;
            background: transparent;
            text-decoration: none;
        }
        .btn-icon-lessons {
            color: var(--color-azul-oscuro);
        }
        .btn-icon-lessons:hover { background: rgba(1,186,239,0.10); color: var(--color-celeste); }
        .btn-icon-edit {
            color: #64748b;
        }
        .btn-icon-edit:hover, .btn-icon-edit.active { background: rgba(1,186,239,0.12); color: var(--color-celeste); }
        .btn-icon-delete {
            color: #94a3b8;
        }
        .btn-icon-delete:hover { background: #fef2f2; color: #ef4444; }

        /* ── Formulario de edición inline ── */
        .edit-form-row {
            display: none;
            padding: 16px 20px 18px 56px; /* indent igual al row */
            background: #f0fbfd;
            border-top: 1px solid rgba(1,186,239,0.15);
        }
        .edit-form-row.open { display: block; }
        .edit-form-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--color-celeste);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 10px;
        }
        .edit-form-fields {
            display: flex;
            gap: 10px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .edit-form-input {
            flex: 1;
            min-width: 200px;
            height: 40px;
            padding: 0 12px;
            border: 1px solid #dbe3ee;
            border-radius: var(--radio-pequeno);
            font-size: 14px;
            outline: none;
            box-sizing: border-box;
            transition: border-color .2s, box-shadow .2s;
        }
        .edit-form-input:focus {
            border-color: var(--color-celeste);
            box-shadow: 0 0 0 3px rgba(1,186,239,0.14);
        }
        .btn-save-edit {
            height: 40px;
            padding: 0 18px;
            border: 0;
            border-radius: var(--radio-pequeno);
            background: var(--gradiente-marca);
            color: #fff;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: opacity .2s, transform .2s;
            white-space: nowrap;
        }
        .btn-save-edit:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-cancel-edit {
            height: 40px;
            padding: 0 14px;
            border: 1.5px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            background: #fff;
            color: var(--color-texto);
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: border-color .2s;
        }
        .btn-cancel-edit:hover { border-color: var(--color-celeste); }
        .char-counter {
            font-size: 11px;
            color: var(--color-texto-suave);
            align-self: flex-end;
            padding-bottom: 4px;
        }
        .char-counter.warning { color: var(--color-error); font-weight: 700; }

        /* ── Empty state de módulos ── */
        .modules-empty {
            padding: 48px 24px;
            text-align: center;
        }
        .modules-empty-icon {
            width: 52px;
            height: 52px;
            border-radius: 16px;
            background: rgba(1,186,239,0.08);
            display: inline-grid;
            place-items: center;
            color: var(--color-celeste);
            margin-bottom: 14px;
        }
        .modules-empty h3 { font-size: 16px; font-weight: 700; color: var(--color-texto); margin-bottom: 6px; }
        .modules-empty p  { font-size: 13px; color: var(--color-texto-suave); }

        /* ── Card de crear módulo ── */
        .create-module-card {
            background: rgba(255,255,255,0.96);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            box-shadow: var(--sombra-suave);
            padding: 22px 24px;
        }
        .create-module-card h2 {
            font-size: 15px;
            font-weight: 700;
            color: var(--color-texto);
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }
        .create-module-fields {
            display: flex;
            gap: 10px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .create-module-input {
            flex: 1;
            min-width: 220px;
            height: 44px;
            padding: 0 14px;
            border: 1px solid #dbe3ee;
            border-radius: var(--radio-pequeno);
            font-size: 14px;
            outline: none;
            box-sizing: border-box;
            transition: border-color .2s, box-shadow .2s;
        }
        .create-module-input:focus {
            border-color: var(--color-celeste);
            box-shadow: 0 0 0 3px rgba(1,186,239,0.14);
        }
        .btn-create-module {
            height: 44px;
            padding: 0 22px;
            border: 0;
            border-radius: var(--radio-pequeno);
            background: var(--gradiente-marca);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            box-shadow: 0 6px 18px rgba(1,186,239,0.24);
            transition: transform .2s, box-shadow .2s, opacity .2s;
            white-space: nowrap;
        }
        .btn-create-module:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 24px rgba(1,186,239,0.32);
            opacity: 0.95;
        }

        /* ── Modal de confirmación ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.38);
            backdrop-filter: blur(4px);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.active { display: flex; }
        .modal-box {
            background: #fff;
            border-radius: var(--radio-grande);
            box-shadow: 0 20px 60px rgba(0,0,0,0.18);
            padding: 28px;
            max-width: 380px;
            width: calc(100% - 32px);
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .modal-body {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            font-size: 14px;
            color: #4b5563;
            line-height: 1.55;
        }
        .modal-icon-warn { color: #f59e0b; flex-shrink: 0; margin-top: 2px; }
        .modal-actions { display: flex; gap: 8px; justify-content: flex-end; }
        .btn-modal-cancel {
            height: 36px; padding: 0 16px;
            border: 1.5px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            background: #fff; color: var(--color-texto);
            font-size: 13px; font-weight: 700; cursor: pointer;
            transition: border-color .2s;
        }
        .btn-modal-cancel:hover { border-color: var(--color-celeste); }
        .btn-modal-confirm {
            height: 36px; padding: 0 16px;
            border: 0; border-radius: var(--radio-pequeno);
            background: #ef4444; color: #fff;
            font-size: 13px; font-weight: 700; cursor: pointer;
            transition: background .2s;
        }
        .btn-modal-confirm:hover { background: #dc2626; }

        @media (max-width: 640px) {
            .editor-main { padding: 24px 14px 48px; }
            .module-row { padding: 12px 14px; }
            .edit-form-row { padding-left: 14px; }
            .edit-form-fields, .create-module-fields { flex-direction: column; }
            .btn-save-edit, .btn-create-module { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>

<%@ include file="./fragmentos/nav.jspf" %>

<%-- Modal de confirmación de eliminación --%>
<div class="modal-overlay" id="deleteModal" role="dialog" aria-modal="true" aria-labelledby="deleteModalMsg">
    <div class="modal-box">
        <div class="modal-body">
            <svg class="modal-icon-warn" xmlns="http://www.w3.org/2000/svg" width="22" height="22"
                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/>
                <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
            </svg>
            <span id="deleteModalMsg">¿Estás seguro de eliminar este módulo?</span>
        </div>
        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="closeDeleteModal()">Cancelar</button>
            <form id="deleteModalForm" method="post" style="display:contents;">
                <input type="hidden" name="action" value="eliminar">
                <input type="hidden" name="cursoId" id="deleteModalCursoId">
                <input type="hidden" name="moduloId" id="deleteModalModuloId">
                <button type="submit" class="btn-modal-confirm">Eliminar</button>
            </form>
        </div>
    </div>
</div>

<main class="editor-main">

    <nav class="breadcrumb" aria-label="Ruta de navegación">
        <a href="${pageContext.request.contextPath}/my-courses">Mis Cursos</a>
        <span aria-hidden="true">›</span>
        <%-- cursoTitulo debe ser pasado por el servlet --%>
        <c:choose>
            <c:when test="${not empty requestScope.cursoTitulo}">
                <a href="${pageContext.request.contextPath}/courses/detail?id=${requestScope.cursoId}">
                    <c:out value="${requestScope.cursoTitulo}"/>
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/courses/detail?id=${requestScope.cursoId}">Curso</a>
            </c:otherwise>
        </c:choose>
        <span aria-hidden="true">›</span>
        <span class="bc-current">Editar Contenido</span>
    </nav>

    <div class="page-header">
        <div>
            <h1>Editar Contenido</h1>
            <p class="subtitle">
                Curso:
                <strong>
                    <c:choose>
                        <c:when test="${not empty requestScope.cursoTitulo}">
                            <c:out value="${requestScope.cursoTitulo}"/>
                        </c:when>
                        <c:otherwise>ID ${requestScope.cursoId}</c:otherwise>
                    </c:choose>
                </strong>
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/courses/detail?id=${requestScope.cursoId}"
           class="btn-volver">
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                <path d="m15 18-6-6 6-6"/>
            </svg>
            Volver al Curso
        </a>
    </div>

    <%-- Mensajes --%>
    <c:if test="${not empty requestScope.error}">
        <div class="msg-box msg-error" role="alert"><c:out value="${requestScope.error}"/></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="msg-box msg-error" role="alert"><c:out value="${param.error}" escapeXml="false"/></div>
    </c:if>
    <c:if test="${not empty param.success}">
        <div class="msg-box msg-success" role="status"><c:out value="${param.success}" escapeXml="false"/></div>
    </c:if>

    <%-- ── Lista de Módulos ── --%>
    <div class="content-card">
        <div class="content-card-header">
            <h2>
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2" style="color:var(--color-celeste)" aria-hidden="true">
                    <rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/>
                    <line x1="12" y1="17" x2="12" y2="21"/>
                </svg>
                Módulos del Curso
                <span class="count-badge">${empty requestScope.modulos ? 0 : requestScope.modulos.size()} módulos</span>
            </h2>
        </div>

        <div class="content-card-body">
            <c:choose>
                <c:when test="${empty requestScope.modulos}">
                    <div class="modules-empty">
                        <div class="modules-empty-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
                                <polyline points="14 2 14 8 20 8"/>
                            </svg>
                        </div>
                        <h3>Aún no hay módulos</h3>
                        <p>Crea el primer módulo para estructurar el contenido del curso.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <ul class="module-list">
                        <c:forEach var="modulo" items="${requestScope.modulos}" varStatus="loop">

                            <%-- Fila del módulo --%>
                            <li class="module-item">
                                <div class="module-row">
                                    <svg class="module-grip" xmlns="http://www.w3.org/2000/svg"
                                         width="16" height="16" viewBox="0 0 24 24" fill="none"
                                         stroke="currentColor" stroke-width="2" aria-hidden="true">
                                        <circle cx="9" cy="5" r="1"/><circle cx="9" cy="12" r="1"/>
                                        <circle cx="9" cy="19" r="1"/><circle cx="15" cy="5" r="1"/>
                                        <circle cx="15" cy="12" r="1"/><circle cx="15" cy="19" r="1"/>
                                    </svg>

                                        <%-- Reordenar --%>
                                    <div class="module-reorder">
                                        <form action="${pageContext.request.contextPath}/modulos" method="post" style="display:contents;">
                                            <input type="hidden" name="action" value="reordenar">
                                            <input type="hidden" name="cursoId" value="${requestScope.cursoId}">
                                            <input type="hidden" name="moduloId" value="${modulo.id}">
                                            <input type="hidden" name="nuevoOrden" value="${modulo.orden - 1}">
                                            <button type="submit" class="btn-reorder" title="Subir" ${loop.first ? 'disabled' : ''}>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24"
                                                     fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                                                    <polyline points="18 15 12 9 6 15"/>
                                                </svg>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/modulos" method="post" style="display:contents;">
                                            <input type="hidden" name="action" value="reordenar">
                                            <input type="hidden" name="cursoId" value="${requestScope.cursoId}">
                                            <input type="hidden" name="moduloId" value="${modulo.id}">
                                            <input type="hidden" name="nuevoOrden" value="${modulo.orden + 1}">
                                            <button type="submit" class="btn-reorder" title="Bajar" ${loop.last ? 'disabled' : ''}>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24"
                                                     fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                                                    <polyline points="6 9 12 15 18 9"/>
                                                </svg>
                                            </button>
                                        </form>
                                    </div>

                                    <span class="module-order"><c:out value="${modulo.orden}"/></span>
                                    <span class="module-title"><c:out value="${modulo.titulo}"/></span>

                                        <%-- Muestra cantidad de lecciones si el modelo lo expone --%>
                                    <c:if test="${not empty modulo.cantidadLecciones}">
                                        <span class="module-meta">${modulo.cantidadLecciones} lec.</span>
                                    </c:if>

                                    <div class="module-actions-btns">
                                            <%-- Gestionar lecciones --%>
                                        <a href="${pageContext.request.contextPath}/lecciones?moduloId=${modulo.id}&cursoId=${requestScope.cursoId}"
                                           class="btn-icon btn-icon-lessons"
                                           title="Gestionar lecciones">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                 stroke-width="2" aria-hidden="true">
                                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                                            </svg>
                                        </a>
                                            <%-- Editar --%>
                                        <button type="button" class="btn-icon btn-icon-edit"
                                                id="editBtn${modulo.id}"
                                                onclick="toggleEditForm('${modulo.id}')"
                                                title="Editar módulo">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                                                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                 stroke-width="2" aria-hidden="true">
                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                            </svg>
                                        </button>
                                            <%-- Eliminar --%>
                                        <button type="button" class="btn-icon btn-icon-delete"
                                                onclick="openDeleteModal('${pageContext.request.contextPath}/modulos','${requestScope.cursoId}','${modulo.id}','<c:out value="${modulo.titulo}"/>')"
                                                title="Eliminar módulo">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                                                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                 stroke-width="2" aria-hidden="true">
                                                <polyline points="3 6 5 6 21 6"/>
                                                <path d="M19 6l-1 14H6L5 6"/>
                                                <path d="M10 11v6"/><path d="M14 11v6"/>
                                                <path d="M9 6V4h6v2"/>
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                    <%-- Formulario inline de edición --%>
                                <div id="editForm${modulo.id}" class="edit-form-row">
                                    <p class="edit-form-label">Editando módulo</p>
                                    <form action="${pageContext.request.contextPath}/modulos" method="post">
                                        <input type="hidden" name="action" value="editar">
                                        <input type="hidden" name="cursoId" value="${requestScope.cursoId}">
                                        <input type="hidden" name="moduloId" value="${modulo.id}">
                                        <div class="edit-form-fields">
                                            <input type="text"
                                                   id="editTitulo${modulo.id}"
                                                   name="titulo"
                                                   class="edit-form-input"
                                                   value="<c:out value="${modulo.titulo}"/>"
                                                   required minlength="3" maxlength="100"
                                                   placeholder="Título del módulo">
                                            <span id="editCounter${modulo.id}" class="char-counter"></span>
                                            <button type="submit" class="btn-save-edit">Guardar cambios</button>
                                            <button type="button" class="btn-cancel-edit"
                                                    onclick="toggleEditForm('${modulo.id}')">Cancelar</button>
                                        </div>
                                    </form>
                                </div>
                            </li>

                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- ── Crear nuevo módulo ── --%>
    <div class="create-module-card">
        <h2>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2"
                 style="color:var(--color-celeste)" aria-hidden="true">
                <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/>
                <line x1="8" y1="12" x2="16" y2="12"/>
            </svg>
            Añadir Módulo
        </h2>
        <form action="${pageContext.request.contextPath}/modulos" method="post">
            <input type="hidden" name="action" value="crear">
            <input type="hidden" name="cursoId" value="${requestScope.cursoId}">
            <input type="hidden" name="orden"
                   value="${(empty requestScope.modulos) ? 1 : (requestScope.modulos.size() + 1)}">
            <div class="create-module-fields">
                <input type="text"
                       id="newTitulo"
                       name="titulo"
                       class="create-module-input"
                       placeholder="Ej: Introducción al tema"
                       required minlength="3" maxlength="100">
                <span id="newTituloCounter" class="char-counter"></span>
                <button type="submit" class="btn-create-module">
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                    </svg>
                    Crear Módulo
                </button>
            </div>
        </form>
    </div>

</main>

<script>
    if (typeof lucide !== 'undefined') lucide.createIcons();

    /* ── Toggle formulario de edición ── */
    function toggleEditForm(moduloId) {
        const form = document.getElementById('editForm' + moduloId);
        const btn  = document.getElementById('editBtn' + moduloId);
        const isOpen = form.classList.contains('open');
        // Cerrar todos los demás
        document.querySelectorAll('.edit-form-row.open').forEach(el => el.classList.remove('open'));
        document.querySelectorAll('.btn-icon-edit.active').forEach(el => el.classList.remove('active'));
        if (!isOpen) {
            form.classList.add('open');
            btn.classList.add('active');
            form.querySelector('input[name="titulo"]').focus();
        }
    }

    /* ── Modal eliminar ── */
    function openDeleteModal(action, cursoId, moduloId, titulo) {
        document.getElementById('deleteModalForm').action = action;
        document.getElementById('deleteModalCursoId').value = cursoId;
        document.getElementById('deleteModalModuloId').value = moduloId;
        document.getElementById('deleteModalMsg').textContent =
            '¿Eliminar el módulo "' + titulo + '"? Esta acción no se puede deshacer.';
        document.getElementById('deleteModal').classList.add('active');
    }
    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.remove('active');
    }
    document.getElementById('deleteModal').addEventListener('click', function(e) {
        if (e.target === this) closeDeleteModal();
    });

    /* ── Contador de caracteres ── */
    function setupCounter(inputId, counterId, min, max) {
        const input   = document.getElementById(inputId);
        const counter = document.getElementById(counterId);
        if (!input || !counter) return;
        function update() {
            const len = input.value.length;
            const remaining = max - len;
            if (len < min) {
                counter.textContent = 'Faltan ' + (min - len) + ' caracteres';
                counter.className = 'char-counter warning';
            } else if (len > max) {
                counter.textContent = 'Excede por ' + (len - max);
                counter.className = 'char-counter warning';
            } else {
                counter.textContent = remaining + ' restantes';
                counter.className = remaining <= 10 ? 'char-counter warning' : 'char-counter';
            }
        }
        input.addEventListener('input', update);
        update();
    }

    document.addEventListener('DOMContentLoaded', () => {
        setupCounter('newTitulo', 'newTituloCounter', 3, 100);
        <c:forEach var="modulo" items="${requestScope.modulos}">
        setupCounter('editTitulo${modulo.id}', 'editCounter${modulo.id}', 3, 100);
        </c:forEach>
    });
</script>
</body>
</html>