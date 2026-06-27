<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Lecciones</title>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        .lecciones-main {
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
        .breadcrumb a { color: var(--color-texto-suave); text-decoration: none; font-weight: 600; transition: color .15s; }
        .breadcrumb a:hover { color: var(--color-celeste); }
        .breadcrumb .bc-current { color: var(--color-texto); font-weight: 700; }

        /* ── Page header ── */
        .page-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 14px;
            margin-bottom: 24px;
        }
        .page-header h1 {
            font-size: clamp(20px, 3vw, 26px);
            font-weight: 800;
            letter-spacing: -0.4px;
            color: var(--color-texto);
            margin-bottom: 4px;
        }
        .page-header .subtitle { font-size: 13px; color: var(--color-texto-suave); }
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
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 16px; border-radius: var(--radio-pequeno);
            font-size: 14px; font-weight: 600; margin-bottom: 20px;
        }
        .msg-success { background:#d1fae5; color:#065f46; border:1px solid #6ee7b7; }
        .msg-error   { background:#fee2e2; color:#991b1b; border:1px solid #fca5a5; }

        /* ── Card ── */
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
            padding: 16px 22px;
            border-bottom: 1px solid #f1f5f9;
            background: #fafbfc;
        }
        .content-card-header h2 {
            font-size: 14px;
            font-weight: 700;
            color: var(--color-texto);
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
        }
        .count-badge {
            font-size: 11px; font-weight: 700;
            color: var(--color-texto-suave);
            background: #f1f5f9; border: 1px solid #e2e8f0;
            border-radius: 999px; padding: 2px 9px;
        }

        /* ── Lista de lecciones ── */
        .leccion-list { list-style: none; padding: 0; margin: 0; }
        .leccion-item { border-bottom: 1px solid #f1f5f9; }
        .leccion-item:last-child { border-bottom: none; }

        /* Fila principal */
        .leccion-row {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 13px 20px;
            transition: background .2s;
        }
        .leccion-row:hover { background: #f8fafc; }

        /* Reordenar */
        .leccion-reorder {
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }
        .btn-reorder {
            width: 26px; height: 20px;
            border: none; background: transparent;
            cursor: pointer; display: grid; place-items: center;
            color: #94a3b8; border-radius: 4px; padding: 0;
            transition: color .15s, background .15s;
        }
        .btn-reorder:hover:not(:disabled) { color: var(--color-celeste); background: rgba(1,186,239,0.10); }
        .btn-reorder:disabled { opacity: 0.3; cursor: not-allowed; }

        .leccion-order {
            font-size: 12px; font-weight: 800;
            color: var(--color-celeste);
            min-width: 20px; flex-shrink: 0; text-align: center;
        }

        /* Tipo de lección */
        .tipo-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 9px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            flex-shrink: 0;
        }
        .tipo-video   { background: #dbeafe; color: #1d4ed8; }
        .tipo-texto   { background: #f3f4f6; color: #374151; }
        .tipo-quiz    { background: #fef3c7; color: #92400e; }
        .tipo-default { background: #f3f4f6; color: #374151; }

        /* Título */
        .leccion-titulo {
            flex: 1;
            font-size: 14px;
            font-weight: 600;
            color: var(--color-texto);
            min-width: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        /* Badge contenido */
        .badge-contenido {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 9px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            flex-shrink: 0;
        }
        .badge-con    { background: #ecfdf3; color: #166534; border: 1px solid #bbf7d0; }
        .badge-sin    { background: #fff7ed; color: #9a3412; border: 1px solid #fed7aa; }

        /* Botones de acción */
        .leccion-actions { display: flex; gap: 4px; flex-shrink: 0; }
        .btn-icon {
            width: 32px; height: 32px;
            border: none; border-radius: 8px;
            cursor: pointer; display: grid; place-items: center;
            transition: background .15s, color .15s;
            background: transparent;
        }
        .btn-icon-edit  { color: #64748b; }
        .btn-icon-edit:hover, .btn-icon-edit.active { background: rgba(1,186,239,0.12); color: var(--color-celeste); }
        .btn-icon-del   { color: #94a3b8; }
        .btn-icon-del:hover { background: #fef2f2; color: #ef4444; }

        /* ── Formulario de edición inline ── */
        .edit-leccion-row {
            display: none;
            padding: 14px 20px 16px 56px;
            background: #f0fbfd;
            border-top: 1px solid rgba(1,186,239,0.15);
        }
        .edit-leccion-row.open { display: block; }
        .edit-leccion-label {
            font-size: 11px; font-weight: 700;
            color: var(--color-celeste);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 10px;
        }
        .edit-fields {
            display: flex;
            gap: 8px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .edit-text-input {
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
        .edit-text-input:focus {
            border-color: var(--color-celeste);
            box-shadow: 0 0 0 3px rgba(1,186,239,0.14);
        }

        /* Selector de tipo */
        .tipo-selector { display: flex; gap: 6px; flex-wrap: wrap; }
        .tipo-option { display: none; }
        .tipo-label {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 13px;
            border-radius: var(--radio-pequeno);
            border: 1.5px solid #e2e8f0;
            font-size: 12px;
            font-weight: 700;
            color: #64748b;
            cursor: pointer;
            transition: border-color .15s, background .15s, color .15s;
        }
        .tipo-option:checked + .tipo-label {
            border-color: var(--color-celeste);
            background: rgba(1,186,239,0.10);
            color: var(--color-azul-oscuro);
        }

        .btn-save {
            height: 40px; padding: 0 18px;
            border: 0; border-radius: var(--radio-pequeno);
            background: var(--gradiente-marca); color: #fff;
            font-size: 13px; font-weight: 700; cursor: pointer;
            transition: opacity .2s, transform .2s; white-space: nowrap;
        }
        .btn-save:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-cancel {
            height: 40px; padding: 0 14px;
            border: 1.5px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            background: #fff; color: var(--color-texto);
            font-size: 13px; font-weight: 700; cursor: pointer;
            transition: border-color .2s;
        }
        .btn-cancel:hover { border-color: var(--color-celeste); }

        /* ── Empty state ── */
        .lecciones-empty {
            padding: 48px 24px; text-align: center;
        }
        .lecciones-empty-icon {
            width: 50px; height: 50px;
            border-radius: 16px; background: rgba(1,186,239,0.08);
            display: inline-grid; place-items: center;
            color: var(--color-celeste); margin-bottom: 12px;
        }
        .lecciones-empty h3 { font-size: 15px; font-weight: 700; color: var(--color-texto); margin-bottom: 6px; }
        .lecciones-empty p  { font-size: 13px; color: var(--color-texto-suave); }

        /* ── Crear lección ── */
        .create-leccion-card {
            background: rgba(255,255,255,0.96);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            box-shadow: var(--sombra-suave);
            padding: 22px 24px;
        }
        .create-leccion-card h2 {
            font-size: 14px; font-weight: 700;
            color: var(--color-texto);
            display: flex; align-items: center; gap: 8px;
            margin-bottom: 16px;
        }
        .create-fields { display: flex; flex-direction: column; gap: 12px; }
        .create-field-label {
            font-size: 12px; font-weight: 700;
            color: #374151;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 6px;
        }
        .create-text-input {
            width: 100%; height: 44px; padding: 0 14px;
            border: 1px solid #dbe3ee; border-radius: var(--radio-pequeno);
            font-size: 14px; outline: none; box-sizing: border-box;
            transition: border-color .2s, box-shadow .2s;
        }
        .create-text-input:focus {
            border-color: var(--color-celeste);
            box-shadow: 0 0 0 3px rgba(1,186,239,0.14);
        }
        .create-actions {
            display: flex;
            justify-content: flex-end;
            padding-top: 14px;
            border-top: 1px solid #f1f5f9;
        }
        .btn-create {
            display: inline-flex; align-items: center; gap: 7px;
            height: 44px; padding: 0 22px;
            border: 0; border-radius: var(--radio-pequeno);
            background: var(--gradiente-marca); color: #fff;
            font-size: 14px; font-weight: 700; cursor: pointer;
            box-shadow: 0 6px 18px rgba(1,186,239,0.24);
            transition: transform .2s, box-shadow .2s, opacity .2s;
        }
        .btn-create:hover { transform: translateY(-1px); box-shadow: 0 10px 24px rgba(1,186,239,0.32); opacity: 0.95; }

        /* ── Modal ── */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.38); backdrop-filter: blur(4px);
            z-index: 1000; align-items: center; justify-content: center;
        }
        .modal-overlay.active { display: flex; }
        .modal-box {
            background: #fff; border-radius: var(--radio-grande);
            box-shadow: 0 20px 60px rgba(0,0,0,0.18);
            padding: 28px; max-width: 380px; width: calc(100% - 32px);
            display: flex; flex-direction: column; gap: 20px;
        }
        .modal-body { display: flex; align-items: flex-start; gap: 12px; font-size: 14px; color: #4b5563; line-height: 1.55; }
        .modal-warn { color: #f59e0b; flex-shrink: 0; margin-top: 2px; }
        .modal-actions { display: flex; gap: 8px; justify-content: flex-end; }
        .btn-mc { height: 36px; padding: 0 16px; border: 1.5px solid var(--color-borde); border-radius: var(--radio-pequeno); background: #fff; color: var(--color-texto); font-size: 13px; font-weight: 700; cursor: pointer; transition: border-color .2s; }
        .btn-mc:hover { border-color: var(--color-celeste); }
        .btn-mconfirm { height: 36px; padding: 0 16px; border: 0; border-radius: var(--radio-pequeno); background: #ef4444; color: #fff; font-size: 13px; font-weight: 700; cursor: pointer; transition: background .2s; }
        .btn-mconfirm:hover { background: #dc2626; }

        @media (max-width: 640px) {
            .lecciones-main { padding: 24px 14px 48px; }
            .leccion-row { flex-wrap: wrap; }
            .edit-leccion-row { padding-left: 14px; }
            .edit-fields { flex-direction: column; }
            .btn-save, .btn-create { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>

<%@ include file="./fragmentos/nav.jspf" %>

<%-- Modal de confirmación --%>
<div class="modal-overlay" id="delModal" role="dialog" aria-modal="true">
    <div class="modal-box">
        <div class="modal-body">
            <svg class="modal-warn" xmlns="http://www.w3.org/2000/svg" width="22" height="22"
                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/>
                <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
            </svg>
            <span id="delModalMsg">¿Eliminar esta lección?</span>
        </div>
        <div class="modal-actions">
            <button class="btn-mc" onclick="closeDelModal()">Cancelar</button>
            <form id="delModalForm" method="post" style="display:contents;">
                <input type="hidden" name="accion" value="eliminar">
                <input type="hidden" name="leccionId" id="delModalLeccionId">
                <input type="hidden" name="moduloId"  id="delModalModuloId">
                <button type="submit" class="btn-mconfirm">Eliminar</button>
            </form>
        </div>
    </div>
</div>

<main class="lecciones-main">

    <nav class="breadcrumb" aria-label="Ruta de navegación">
        <a href="${pageContext.request.contextPath}/my-courses">Mis Cursos</a>
        <span>›</span>
        <c:if test="${not empty requestScope.cursoId}">
            <a href="${pageContext.request.contextPath}/modulos?cursoId=${requestScope.cursoId}">
                <c:choose>
                    <c:when test="${not empty requestScope.cursoTitulo}"><c:out value="${requestScope.cursoTitulo}"/></c:when>
                    <c:otherwise>Curso</c:otherwise>
                </c:choose>
            </a>
            <span>›</span>
        </c:if>
        <a href="${pageContext.request.contextPath}/modulos?cursoId=${requestScope.cursoId}">Módulos</a>
        <span>›</span>
        <span class="bc-current">
            <c:choose>
                <c:when test="${not empty modulo}"><c:out value="${modulo.titulo}"/></c:when>
                <c:otherwise>Lecciones</c:otherwise>
            </c:choose>
        </span>
    </nav>

    <div class="page-header">
        <div>
            <h1>Gestión de Lecciones</h1>
            <c:if test="${not empty modulo}">
                <p class="subtitle">Módulo: <strong><c:out value="${modulo.titulo}"/></strong></p>
            </c:if>
        </div>
        <a href="${pageContext.request.contextPath}/modulos?cursoId=${requestScope.cursoId}"
           class="btn-volver">
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                <path d="m15 18-6-6 6-6"/>
            </svg>
            Volver a Módulos
        </a>
    </div>

    <%@ include file="./fragmentos/alertas.jspf" %>

    <c:if test="${not empty modulo}">

        <%-- ── Lista de lecciones ── --%>
        <div class="content-card">
            <div class="content-card-header">
                <h2>
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2"
                         style="color:var(--color-celeste)" aria-hidden="true">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                    </svg>
                    Lecciones
                    <span class="count-badge">${fn:length(lecciones)} lecciones</span>
                </h2>
            </div>

            <c:choose>
                <c:when test="${not empty lecciones}">
                    <ul class="leccion-list">
                        <c:forEach var="leccion" items="${lecciones}" varStatus="est">
                            <li class="leccion-item">
                                    <%-- Fila --%>
                                <div class="leccion-row">
                                        <%-- Reordenar --%>
                                    <div class="leccion-reorder">
                                        <form action="${pageContext.request.contextPath}/lecciones" method="post" style="display:contents;">
                                            <input type="hidden" name="accion" value="reordenar">
                                            <input type="hidden" name="leccionId" value="${leccion.id}">
                                            <input type="hidden" name="moduloId"  value="${modulo.id}">
                                            <input type="hidden" name="nuevoOrden" value="${leccion.orden - 1}">
                                            <button type="submit" class="btn-reorder" title="Subir" ${est.first ? 'disabled' : ''}>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12"
                                                     viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                    <polyline points="18 15 12 9 6 15"/>
                                                </svg>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/lecciones" method="post" style="display:contents;">
                                            <input type="hidden" name="accion" value="reordenar">
                                            <input type="hidden" name="leccionId" value="${leccion.id}">
                                            <input type="hidden" name="moduloId"  value="${modulo.id}">
                                            <input type="hidden" name="nuevoOrden" value="${leccion.orden + 1}">
                                            <button type="submit" class="btn-reorder" title="Bajar" ${est.last ? 'disabled' : ''}>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12"
                                                     viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                    <polyline points="6 9 12 15 18 9"/>
                                                </svg>
                                            </button>
                                        </form>
                                    </div>

                                    <span class="leccion-order"><c:out value="${leccion.orden}"/></span>

                                        <%-- Tipo badge — si tu modelo expone leccion.tipo úsalo aquí --%>
                                    <c:choose>
                                        <c:when test="${leccion.tipo == 'VIDEO'}">
                                            <span class="tipo-badge tipo-video">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="11" height="11"
                                                     viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <polygon points="23 7 16 12 23 17 23 7"/>
                                                    <rect x="1" y="5" width="15" height="14" rx="2"/>
                                                </svg>
                                                Video
                                            </span>
                                        </c:when>
                                        <c:when test="${leccion.tipo == 'QUIZ'}">
                                            <span class="tipo-badge tipo-quiz">Quiz</span>
                                        </c:when>
                                        <c:when test="${leccion.tipo == 'TEXTO'}">
                                            <span class="tipo-badge tipo-texto">Texto</span>
                                        </c:when>
                                    </c:choose>

                                    <span class="leccion-titulo"><c:out value="${leccion.titulo}"/></span>

                                    <span class="badge-contenido ${leccion.tieneContenido ? 'badge-con' : 'badge-sin'}">
                                        <c:out value="${leccion.tieneContenido ? 'Con contenido' : 'Sin contenido'}"/>
                                    </span>

                                    <div class="leccion-actions">
                                        <button type="button"
                                                class="btn-icon btn-icon-edit"
                                                id="editLecBtn${leccion.id}"
                                                onclick="toggleEditLec('${leccion.id}')"
                                                title="Editar lección">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                                                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                            </svg>
                                        </button>
                                        <button type="button"
                                                class="btn-icon btn-icon-del"
                                                onclick="openDelModal('${pageContext.request.contextPath}/lecciones','${leccion.id}','${modulo.id}','<c:out value="${leccion.titulo}"/>')"
                                                title="Eliminar lección">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                                                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <polyline points="3 6 5 6 21 6"/>
                                                <path d="M19 6l-1 14H6L5 6"/>
                                                <path d="M10 11v6"/><path d="M14 11v6"/>
                                                <path d="M9 6V4h6v2"/>
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                    <%-- Formulario de edición inline --%>
                                <div id="editLec${leccion.id}" class="edit-leccion-row">
                                    <p class="edit-leccion-label">Editando lección</p>
                                    <form action="${pageContext.request.contextPath}/lecciones" method="post">
                                        <input type="hidden" name="accion" value="editar">
                                        <input type="hidden" name="leccionId" value="${leccion.id}">
                                        <input type="hidden" name="moduloId"  value="${modulo.id}">
                                        <div class="edit-fields">
                                            <input type="text"
                                                   class="edit-text-input"
                                                   name="titulo"
                                                   value="${fn:escapeXml(leccion.titulo)}"
                                                   required minlength="3" maxlength="100">
                                                <%-- Selector de tipo (si el modelo lo soporta) --%>
                                            <c:if test="${not empty leccion.tipo}">
                                                <div class="tipo-selector">
                                                    <input type="radio" class="tipo-option" name="tipo" id="tVideo${leccion.id}" value="VIDEO" ${leccion.tipo=='VIDEO' ? 'checked' : ''}>
                                                    <label class="tipo-label" for="tVideo${leccion.id}">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="23 7 16 12 23 17 23 7"/><rect x="1" y="5" width="15" height="14" rx="2"/></svg>
                                                        Video
                                                    </label>
                                                    <input type="radio" class="tipo-option" name="tipo" id="tTexto${leccion.id}" value="TEXTO" ${leccion.tipo=='TEXTO' ? 'checked' : ''}>
                                                    <label class="tipo-label" for="tTexto${leccion.id}">Texto</label>
                                                    <input type="radio" class="tipo-option" name="tipo" id="tQuiz${leccion.id}" value="QUIZ" ${leccion.tipo=='QUIZ' ? 'checked' : ''}>
                                                    <label class="tipo-label" for="tQuiz${leccion.id}">Quiz</label>
                                                </div>
                                            </c:if>
                                            <button type="submit" class="btn-save">Guardar</button>
                                            <button type="button" class="btn-cancel"
                                                    onclick="toggleEditLec('${leccion.id}')">Cancelar</button>
                                        </div>
                                    </form>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="lecciones-empty">
                        <div class="lecciones-empty-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                            </svg>
                        </div>
                        <h3>Este módulo aún no tiene lecciones</h3>
                        <p>Añade la primera lección para comenzar a organizar el contenido.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- ── Crear lección ── --%>
        <div class="create-leccion-card">
            <h2>
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2"
                     style="color:var(--color-celeste)" aria-hidden="true">
                    <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/>
                    <line x1="8" y1="12" x2="16" y2="12"/>
                </svg>
                Añadir Lección
            </h2>
            <form class="create-fields" action="${pageContext.request.contextPath}/lecciones" method="post">
                <input type="hidden" name="accion"   value="crear">
                <input type="hidden" name="moduloId" value="${modulo.id}">
                <input type="hidden" name="orden"    value="${fn:length(lecciones) + 1}">

                <div>
                    <p class="create-field-label">Título de la lección</p>
                    <input id="newLecTitulo"
                           class="create-text-input"
                           type="text"
                           name="titulo"
                           placeholder="Ej: Introducción al módulo"
                           required minlength="3" maxlength="100">
                </div>

                    <%-- Selector de tipo para nueva lección --%>
                <div>
                    <p class="create-field-label">Tipo</p>
                    <div class="tipo-selector">
                        <input type="radio" class="tipo-option" name="tipo" id="newVideo" value="VIDEO" checked>
                        <label class="tipo-label" for="newVideo">
                            <svg xmlns="http://www.w3.org/2000/svg" width="11" height="11" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2">
                                <polygon points="23 7 16 12 23 17 23 7"/>
                                <rect x="1" y="5" width="15" height="14" rx="2"/>
                            </svg>
                            Video
                        </label>
                        <input type="radio" class="tipo-option" name="tipo" id="newTexto" value="TEXTO">
                        <label class="tipo-label" for="newTexto">Texto</label>
                        <input type="radio" class="tipo-option" name="tipo" id="newQuiz" value="QUIZ">
                        <label class="tipo-label" for="newQuiz">Quiz</label>
                    </div>
                </div>

                <div class="create-actions">
                    <button type="submit" class="btn-create">
                        <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                            <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                        </svg>
                        Guardar Lección
                    </button>
                </div>
            </form>
        </div>

    </c:if>
</main>

<script>
    if (typeof lucide !== 'undefined') lucide.createIcons();

    /* ── Toggle formulario de edición de lección ── */
    function toggleEditLec(leccionId) {
        const form = document.getElementById('editLec' + leccionId);
        const btn  = document.getElementById('editLecBtn' + leccionId);
        const isOpen = form.classList.contains('open');
        document.querySelectorAll('.edit-leccion-row.open').forEach(el => el.classList.remove('open'));
        document.querySelectorAll('.btn-icon-edit.active').forEach(el => el.classList.remove('active'));
        if (!isOpen) {
            form.classList.add('open');
            btn.classList.add('active');
            form.querySelector('input[name="titulo"]').focus();
        }
    }

    /* ── Modal de eliminación ── */
    function openDelModal(action, leccionId, moduloId, titulo) {
        document.getElementById('delModalForm').action = action;
        document.getElementById('delModalLeccionId').value = leccionId;
        document.getElementById('delModalModuloId').value  = moduloId;
        document.getElementById('delModalMsg').textContent =
            '¿Eliminar "' + titulo + '"? Se eliminará también todo el contenido asociado. Esta acción es irreversible.';
        document.getElementById('delModal').classList.add('active');
    }
    function closeDelModal() {
        document.getElementById('delModal').classList.remove('active');
    }
    document.getElementById('delModal').addEventListener('click', function(e) {
        if (e.target === this) closeDelModal();
    });
</script>
</body>
</html>