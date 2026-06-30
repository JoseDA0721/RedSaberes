<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Contenido de Lección</title>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        /* ═══════════════════════════════════════════════
           CONTENIDO-LECCION — estilos de página
           Reutiliza las variables de encabezado.jspf
        ═══════════════════════════════════════════════ */
        .contenido-main {
            max-width: 860px;
            margin: 0 auto;
            padding: 36px 24px 72px;
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
        .breadcrumb .bc-sep { color: #d1d5db; }
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

        /* ── Info card: resumen de la lección ── */
        .info-card {
            background: rgba(255,255,255,0.96);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            box-shadow: var(--sombra-suave);
            padding: 18px 22px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }
        .info-icon {
            width: 46px;
            height: 46px;
            border-radius: 14px;
            background: var(--gradiente-marca);
            display: grid;
            place-items: center;
            color: #fff;
            flex-shrink: 0;
            box-shadow: 0 6px 18px rgba(1,186,239,0.22);
        }
        .info-body { flex: 1; min-width: 0; }
        .info-body h2 {
            font-size: 16px;
            font-weight: 800;
            color: var(--color-texto);
            margin-bottom: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .info-badges { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }

        .tipo-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }
        .tipo-video   { background: #dbeafe; color: #1d4ed8; }
        .tipo-texto   { background: #f3f4f6; color: #374151; }
        .tipo-quiz    { background: #fef3c7; color: #92400e; }

        .modulo-tag {
            font-size: 11px;
            font-weight: 700;
            color: var(--color-azul-oscuro);
            background: rgba(1,186,239,0.10);
            border: 1px solid rgba(1,186,239,0.20);
            padding: 3px 10px;
            border-radius: 999px;
        }
        .badge-con-contenido {
            font-size: 11px; font-weight: 700;
            background: #ecfdf3; color: #166534;
            border: 1px solid #bbf7d0;
            padding: 3px 10px; border-radius: 999px;
        }
        .badge-sin-contenido {
            font-size: 11px; font-weight: 700;
            background: #fff7ed; color: #9a3412;
            border: 1px solid #fed7aa;
            padding: 3px 10px; border-radius: 999px;
        }

        /* ── Content cards ── */
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
            gap: 10px;
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
        .badge-guardado {
            font-size: 11px; font-weight: 700;
            background: #d1fae5; color: #065f46;
            border-radius: 999px; padding: 2px 9px;
        }
        .badge-sin-texto {
            font-size: 11px; font-weight: 700;
            background: #f1f5f9; color: var(--color-texto-suave);
            border: 1px solid #e2e8f0;
            border-radius: 999px; padding: 2px 9px;
        }
        .count-badge {
            font-size: 11px; font-weight: 700;
            color: var(--color-texto-suave);
            background: #f1f5f9; border: 1px solid #e2e8f0;
            border-radius: 999px; padding: 2px 9px;
        }

        /* ── Botón editar texto (header) ── */
        .btn-editar-texto {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 32px;
            padding: 0 13px;
            border: 1.5px solid rgba(1,186,239,0.35);
            border-radius: 8px;
            background: rgba(1,186,239,0.07);
            color: var(--color-azul-oscuro);
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: background .15s, border-color .15s;
        }
        .btn-editar-texto:hover,
        .btn-editar-texto.active {
            background: rgba(1,186,239,0.15);
            border-color: var(--color-celeste);
        }

        /* ── Texto: display de texto guardado ── */
        .texto-display-body { padding: 20px 22px; }
        .texto-content {
            font-size: 14px;
            line-height: 1.8;
            color: var(--color-texto);
            white-space: pre-wrap;
            word-break: break-word;
            background: #f8fafc;
            border: 1px solid #f1f5f9;
            border-radius: var(--radio-pequeno);
            padding: 16px;
            min-height: 80px;
        }
        .texto-meta {
            font-size: 11px;
            color: var(--color-texto-suave);
            margin-top: 8px;
            text-align: right;
        }

        /* ── Formulario de texto (crear / editar) ── */
        .texto-form-body {
            padding: 20px 22px;
        }
        .texto-form-body.edit-mode {
            background: #f0fbfd;
            border-top: 1px solid rgba(1,186,239,0.15);
        }
        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: #374151;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 8px;
        }
        .form-label.accent { color: var(--color-celeste); }
        .form-hint {
            font-size: 13px;
            color: var(--color-texto-suave);
            margin-bottom: 14px;
        }
        .textarea-control {
            width: 100%;
            min-height: 180px;
            padding: 14px 16px;
            border: 1px solid #dbe3ee;
            border-radius: var(--radio-pequeno);
            font-size: 14px;
            line-height: 1.7;
            color: var(--color-texto);
            background: #fff;
            outline: none;
            resize: vertical;
            box-sizing: border-box;
            transition: border-color .2s, box-shadow .2s;
            font-family: inherit;
        }
        .textarea-control:focus {
            border-color: var(--color-celeste);
            box-shadow: 0 0 0 3px rgba(1,186,239,0.14);
        }
        .char-counter {
            font-size: 11px;
            color: var(--color-texto-suave);
            text-align: right;
            margin-top: 6px;
            min-height: 16px;
        }
        .char-counter.warning { color: #ef4444; font-weight: 700; }

        /* ── Imágenes existentes ── */
        .imagen-list { list-style: none; padding: 0; margin: 0; }
        .imagen-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 22px;
            border-bottom: 1px solid #f1f5f9;
            transition: background .2s;
        }
        .imagen-item:last-child { border-bottom: none; }
        .imagen-item:hover { background: #f8fafc; }

        .img-thumb {
            width: 52px;
            height: 52px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid #e2e8f0;
            flex-shrink: 0;
        }
        .img-thumb-placeholder {
            width: 52px;
            height: 52px;
            border-radius: 10px;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            color: #94a3b8;
        }
        .img-orden {
            font-size: 12px;
            font-weight: 800;
            color: var(--color-celeste);
            min-width: 20px;
            text-align: center;
            flex-shrink: 0;
        }
        .img-info { flex: 1; min-width: 0; }
        .img-nombre {
            font-size: 13px;
            font-weight: 700;
            color: var(--color-texto);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .img-meta { font-size: 11px; color: var(--color-texto-suave); margin-top: 2px; }
        .ext-badge {
            font-size: 10px;
            font-weight: 800;
            padding: 2px 8px;
            border-radius: 5px;
            background: rgba(1,186,239,0.10);
            color: var(--color-azul-oscuro);
            flex-shrink: 0;
        }
        .btn-del-img {
            width: 32px; height: 32px;
            border: none; border-radius: 8px;
            cursor: pointer; display: grid; place-items: center;
            background: transparent; color: #94a3b8;
            transition: background .15s, color .15s;
            flex-shrink: 0;
        }
        .btn-del-img:hover { background: #fef2f2; color: #ef4444; }

        /* Empty state imágenes */
        .imgs-empty {
            padding: 44px 24px;
            text-align: center;
        }
        .imgs-empty-icon {
            width: 50px; height: 50px;
            border-radius: 16px; background: rgba(1,186,239,0.08);
            display: inline-grid; place-items: center;
            color: var(--color-celeste); margin-bottom: 12px;
        }
        .imgs-empty h3 { font-size: 14px; font-weight: 700; color: var(--color-texto); margin-bottom: 5px; }
        .imgs-empty p  { font-size: 12px; color: var(--color-texto-suave); }

        /* ── Zona de subida ── */
        .upload-card {
            background: rgba(255,255,255,0.96);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            box-shadow: var(--sombra-suave);
            padding: 22px 24px;
            margin-bottom: 16px;
        }
        .upload-card h2 {
            font-size: 14px;
            font-weight: 700;
            color: var(--color-texto);
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 6px;
        }
        .upload-slots {
            font-size: 12px;
            color: var(--color-texto-suave);
            margin-bottom: 16px;
        }
        .upload-slots strong { color: var(--color-texto); }

        .drop-zone {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 36px 24px;
            border: 2px dashed #dbe3ee;
            border-radius: var(--radio-medio);
            cursor: pointer;
            transition: border-color .2s, background .2s;
            text-align: center;
        }
        .drop-zone:hover,
        .drop-zone.drag-over {
            border-color: var(--color-celeste);
            background: rgba(1,186,239,0.04);
        }
        .drop-zone input[type="file"] {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }
        .drop-icon {
            width: 46px; height: 46px;
            background: rgba(1,186,239,0.10);
            border-radius: 14px;
            display: inline-grid;
            place-items: center;
            color: var(--color-celeste);
        }
        .drop-title { font-size: 14px; font-weight: 700; color: var(--color-texto); }
        .drop-sub   { font-size: 12px; color: var(--color-texto-suave); }
        .drop-sub span { color: var(--color-celeste); font-weight: 700; }

        /* Preview de archivo seleccionado */
        .file-preview {
            display: none;
            align-items: center;
            gap: 12px;
            margin-top: 12px;
            padding: 12px 14px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: var(--radio-pequeno);
        }
        .file-preview.visible { display: flex; }
        .preview-img {
            width: 48px; height: 48px;
            border-radius: 8px;
            object-fit: cover;
            border: 1px solid #e2e8f0;
            flex-shrink: 0;
        }
        .preview-info { flex: 1; min-width: 0; }
        .preview-name {
            font-size: 13px; font-weight: 700;
            color: var(--color-texto);
            overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
        }
        .preview-size { font-size: 11px; color: var(--color-texto-suave); margin-top: 2px; }
        .btn-clear-file {
            background: none; border: none;
            cursor: pointer; color: #94a3b8;
            padding: 4px; border-radius: 6px;
            transition: color .15s;
            flex-shrink: 0;
        }
        .btn-clear-file:hover { color: #ef4444; }

        /* ── Botones de formulario ── */
        .form-actions {
            display: flex;
            gap: 8px;
            margin-top: 16px;
            align-items: center;
        }
        .btn-primary {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            height: 42px;
            padding: 0 22px;
            border: 0;
            border-radius: var(--radio-pequeno);
            background: var(--gradiente-marca);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 6px 18px rgba(1,186,239,0.24);
            transition: transform .2s, box-shadow .2s, opacity .2s;
        }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 10px 24px rgba(1,186,239,0.32); opacity: 0.95; }
        .btn-primary:disabled { opacity: 0.42; cursor: not-allowed; transform: none; }

        .btn-secondary {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 42px;
            padding: 0 16px;
            border: 1.5px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            background: #fff;
            color: var(--color-texto);
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: border-color .2s;
        }
        .btn-secondary:hover { border-color: var(--color-celeste); }

        .upload-submit {
            display: flex;
            justify-content: flex-end;
            margin-top: 14px;
        }

        /* ── Límite alcanzado ── */
        .limite-aviso {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px 18px;
            background: #fffbeb;
            border: 1px solid #fde68a;
            border-radius: var(--radio-pequeno);
            font-size: 13px;
            color: #92400e;
            font-weight: 600;
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
            box-shadow: 0 24px 64px rgba(0,0,0,0.18);
            padding: 28px;
            max-width: 400px;
            width: calc(100% - 32px);
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .modal-body {
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }
        .modal-warn-icon { color: #f59e0b; flex-shrink: 0; margin-top: 2px; }
        .modal-title {
            font-size: 15px;
            font-weight: 800;
            color: var(--color-texto);
            margin-bottom: 4px;
        }
        .modal-desc { font-size: 13px; color: var(--color-texto-suave); line-height: 1.55; }
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
            height: 36px; padding: 0 18px;
            border: 0; border-radius: var(--radio-pequeno);
            background: #ef4444; color: #fff;
            font-size: 13px; font-weight: 700; cursor: pointer;
            transition: background .2s;
        }
        .btn-modal-confirm:hover { background: #dc2626; }

        /* ── Responsive ── */
        @media (max-width: 640px) {
            .contenido-main { padding: 24px 14px 56px; }
            .imagen-item { flex-wrap: wrap; }
            .form-actions { flex-direction: column; }
            .btn-primary, .btn-secondary { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>

<%@ include file="./fragmentos/nav.jspf" %>

<%-- ═══════════════════════════════════════════════════
     MODAL — Confirmación eliminar imagen
════════════════════════════════════════════════════ --%>
<div class="modal-overlay" id="delImgModal" role="dialog" aria-modal="true" aria-labelledby="delImgModalTitle">
    <div class="modal-box">
        <div class="modal-body">
            <svg class="modal-warn-icon" xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/>
                <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
            </svg>
            <div>
                <p id="delImgModalTitle" class="modal-title">¿Eliminar imagen?</p>
                <p id="delImgModalDesc" class="modal-desc">Esta acción no se puede deshacer.</p>
            </div>
        </div>
        <div class="modal-actions">
            <button type="button" class="btn-modal-cancel" onclick="closeDelImgModal()">Cancelar</button>
            <form id="delImgForm" method="post" action="${pageContext.request.contextPath}/contenido-leccion"
                  style="display:contents;">
                <input type="hidden" name="operacion"  value="eliminarImagen">
                <input type="hidden" name="leccionId"  value="${leccion.id}">
                <input type="hidden" name="cursoId"    value="${cursoId}">
                <input type="hidden" name="imagenId"   id="delImgIdInput">
                <button type="submit" class="btn-modal-confirm">Sí, eliminar</button>
            </form>
        </div>
    </div>
</div>

<main class="contenido-main">

    <%-- ── Breadcrumb ── --%>
    <nav class="breadcrumb" aria-label="Ruta de navegación">
        <a href="${pageContext.request.contextPath}/my-courses">Mis Cursos</a>
        <span class="bc-sep" aria-hidden="true">›</span>
        <c:choose>
            <c:when test="${not empty cursoTitulo}">
                <a href="${pageContext.request.contextPath}/modulos?cursoId=${cursoId}">
                    <c:out value="${cursoTitulo}"/>
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/modulos?cursoId=${cursoId}">Curso</a>
            </c:otherwise>
        </c:choose>
        <span class="bc-sep" aria-hidden="true">›</span>
        <a href="${pageContext.request.contextPath}/lecciones?moduloId=${leccion.modulo.id}&cursoId=${cursoId}">
            <c:choose>
                <c:when test="${not empty modulo}"><c:out value="${modulo.titulo}"/></c:when>
                <c:otherwise>Módulo</c:otherwise>
            </c:choose>
        </a>
        <span class="bc-sep" aria-hidden="true">›</span>
        <span class="bc-current">Contenido</span>
    </nav>

    <%-- ── Page header ── --%>
    <div class="page-header">
        <div>
            <h1>Contenido de la Lección</h1>
            <p class="subtitle">
                Lección: <strong><c:out value="${leccion.titulo}"/></strong>
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/lecciones?moduloId=${leccion.modulo.id}&cursoId=${cursoId}"
           class="btn-volver">
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                <path d="m15 18-6-6 6-6"/>
            </svg>
            Volver a Lecciones
        </a>
    </div>

    <%-- ── Alertas (incluye success/error de requestScope y param) ── --%>
    <%@ include file="./fragmentos/alertas.jspf" %>
    <c:if test="${not empty param.success}">
        <div class="alerta alerta-exito"><c:out value="${param.success}" escapeXml="false"/></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alerta alerta-error"><c:out value="${param.error}" escapeXml="false"/></div>
    </c:if>

    <%-- ── Info card: resumen de la lección ── --%>
    <div class="info-card">
        <div class="info-icon" aria-hidden="true">
            <c:choose>
                <c:when test="${leccion.tipo == 'VIDEO'}">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2">
                        <polygon points="23 7 16 12 23 17 23 7"/>
                        <rect x="1" y="5" width="15" height="14" rx="2"/>
                    </svg>
                </c:when>
                <c:when test="${leccion.tipo == 'QUIZ'}">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                        <polyline points="14 2 14 8 20 8"/>
                        <line x1="16" y1="13" x2="8" y2="13"/>
                        <line x1="16" y1="17" x2="8" y2="17"/>
                    </svg>
                </c:when>
                <c:otherwise>
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                    </svg>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="info-body">
            <h2><c:out value="${leccion.titulo}"/></h2>
            <div class="info-badges">
                <%-- Tipo --%>
                <c:choose>
                    <c:when test="${leccion.tipo == 'VIDEO'}">
                        <span class="tipo-badge tipo-video">
                            <svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2">
                                <polygon points="23 7 16 12 23 17 23 7"/>
                                <rect x="1" y="5" width="15" height="14" rx="2"/>
                            </svg>
                            Video
                        </span>
                    </c:when>
                    <c:when test="${leccion.tipo == 'QUIZ'}">
                        <span class="tipo-badge tipo-quiz">Quiz</span>
                    </c:when>
                    <c:otherwise>
                        <span class="tipo-badge tipo-texto">Texto</span>
                    </c:otherwise>
                </c:choose>
                <%-- Módulo --%>
                <c:if test="${not empty modulo}">
                    <span class="modulo-tag"><c:out value="${modulo.titulo}"/></span>
                </c:if>
                <%-- Estado contenido --%>
                <c:choose>
                    <c:when test="${leccion.tieneContenido}">
                        <span class="badge-con-contenido">Con contenido</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge-sin-contenido">Sin contenido</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%-- ═══════════════════════════════════════════════════════════════
         FORMULARIO PRINCIPAL — guarda texto e imágenes en un solo POST
         enctype multipart/form-data requerido para subir archivos
    ═══════════════════════════════════════════════════════════════ --%>
    <form id="mainForm"
          action="${pageContext.request.contextPath}/contenido-leccion"
          method="post"
          enctype="multipart/form-data"
          novalidate>

        <input type="hidden" name="operacion" value="guardar">
        <input type="hidden" name="leccionId" value="${leccion.id}">
        <input type="hidden" name="cursoId"   value="${cursoId}">

        <%-- ─────────────────────────────────────
             SECCIÓN 1 — CONTENIDO DE TEXTO
        ───────────────────────────────────── --%>
        <div class="content-card" id="textoCard">
            <div class="content-card-header">
                <h2>
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2"
                         style="color:var(--color-celeste)" aria-hidden="true">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                        <polyline points="14 2 14 8 20 8"/>
                        <line x1="16" y1="13" x2="8" y2="13"/>
                        <line x1="16" y1="17" x2="8" y2="17"/>
                        <line x1="10" y1="9" x2="8" y2="9"/>
                    </svg>
                    Contenido de Texto
                    <c:choose>
                        <c:when test="${not empty contenido and contenido.tieneTexto}">
                            <span class="badge-guardado">Guardado</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-sin-texto">Sin texto</span>
                        </c:otherwise>
                    </c:choose>
                </h2>
                <%-- Botón editar solo aparece cuando hay texto guardado --%>
                <c:if test="${not empty contenido and contenido.tieneTexto}">
                    <button type="button"
                            id="btnEditarTexto"
                            class="btn-editar-texto"
                            onclick="toggleEditarTexto()">
                        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                        Editar texto
                    </button>
                </c:if>
            </div>

            <%-- Caso A: hay texto guardado → mostrar display + form oculto --%>
            <c:if test="${not empty contenido and contenido.tieneTexto}">
                <%-- Display del texto guardado --%>
                <div class="texto-display-body" id="textoDisplay">
                    <div class="texto-content"><c:out value="${contenido.texto}"/></div>
                    <p class="texto-meta"><c:out value="${contenido.caracteres}"/> caracteres</p>
                </div>

                <%-- Formulario de edición (oculto hasta presionar "Editar texto") --%>
                <div class="texto-form-body edit-mode" id="textoEditForm" style="display:none;">
                    <p class="form-label accent">Editando contenido</p>
                    <textarea id="textoInput"
                              name="texto"
                              class="textarea-control"
                              maxlength="${maxCaracteres}"
                              placeholder="Escribe el contenido de la lección..."
                              rows="8">${fn:escapeXml(contenido.texto)}</textarea>
                    <p class="char-counter" id="charCounter"></p>
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="cancelarEditarTexto()">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18"/>
                                <line x1="6" y1="6" x2="18" y2="18"/>
                            </svg>
                            Cancelar
                        </button>
                        <button type="submit" class="btn-primary" id="btnGuardarTexto">
                            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                                <polyline points="20 6 9 17 4 12"/>
                            </svg>
                            Guardar Cambios
                        </button>
                    </div>
                </div>
            </c:if>

            <%-- Caso B: no hay texto → mostrar formulario de creación directamente --%>
            <c:if test="${empty contenido or not contenido.tieneTexto}">
                <div class="texto-form-body">
                    <p class="form-hint">
                        Esta lección aún no tiene texto. Escríbelo aquí para que los estudiantes puedan leerlo.
                    </p>
                    <label class="form-label" for="textoInput">Texto de la lección</label>
                    <textarea id="textoInput"
                              name="texto"
                              class="textarea-control"
                              maxlength="${maxCaracteres}"
                              placeholder="Escribe el contenido de la lección aquí..."
                              rows="8"></textarea>
                    <p class="char-counter" id="charCounter">0 / <c:out value="${maxCaracteres}"/> caracteres</p>
                </div>
            </c:if>
        </div>

        <%-- ─────────────────────────────────────
             SECCIÓN 2 — IMÁGENES EXISTENTES
        ───────────────────────────────────── --%>
        <div class="content-card">
            <div class="content-card-header">
                <h2>
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2"
                         style="color:var(--color-celeste)" aria-hidden="true">
                        <rect x="3" y="3" width="18" height="18" rx="2"/>
                        <circle cx="8.5" cy="8.5" r="1.5"/>
                        <polyline points="21 15 16 10 5 21"/>
                    </svg>
                    Imágenes
                    <span class="count-badge">${fn:length(imagenes)} / ${maxImagenes}</span>
                </h2>
            </div>

            <c:choose>
                <c:when test="${not empty imagenes}">
                    <ul class="imagen-list" aria-label="Imágenes de la lección">
                        <c:forEach var="img" items="${imagenes}" varStatus="st">
                            <li class="imagen-item">
                                    <%-- Thumbnail --%>
                                <img src="${pageContext.request.contextPath}/${img.ruta}"
                                     alt="Imagen ${img.orden}: ${img.nombreArchivo}"
                                     class="img-thumb"
                                     onerror="this.style.display='none';this.nextElementSibling.style.display='grid';">
                                <div class="img-thumb-placeholder" style="display:none;" aria-hidden="true">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                         fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2"/>
                                        <circle cx="8.5" cy="8.5" r="1.5"/>
                                        <polyline points="21 15 16 10 5 21"/>
                                    </svg>
                                </div>
                                    <%-- Orden --%>
                                <span class="img-orden" aria-label="Orden ${img.orden}">${img.orden}</span>
                                    <%-- Info --%>
                                <div class="img-info">
                                    <p class="img-nombre" title="${img.nombreArchivo}">
                                        <c:out value="${img.nombreArchivo}"/>
                                    </p>
                                    <p class="img-meta"><c:out value="${img.tamanioFormateado}"/></p>
                                </div>
                                    <%-- Extensión --%>
                                <span class="ext-badge"><c:out value="${img.extension}"/></span>
                                    <%-- Eliminar --%>
                                <button type="button"
                                        class="btn-del-img"
                                        onclick="openDelImgModal('${img.id}', '<c:out value="${img.nombreArchivo}"/>')"
                                        title="Eliminar imagen"
                                        aria-label="Eliminar ${img.nombreArchivo}">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                                         viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="3 6 5 6 21 6"/>
                                        <path d="M19 6l-1 14H6L5 6"/>
                                        <path d="M10 11v6"/><path d="M14 11v6"/>
                                        <path d="M9 6V4h6v2"/>
                                    </svg>
                                </button>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="imgs-empty">
                        <div class="imgs-empty-icon" aria-hidden="true">
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="3" width="18" height="18" rx="2"/>
                                <circle cx="8.5" cy="8.5" r="1.5"/>
                                <polyline points="21 15 16 10 5 21"/>
                            </svg>
                        </div>
                        <h3>No hay imágenes todavía</h3>
                        <p>Sube imágenes para enriquecer el contenido de la lección.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- ─────────────────────────────────────
             SECCIÓN 3 — SUBIR IMAGEN
             Solo se muestra si no se alcanzó el límite de 5 imágenes
        ───────────────────────────────────── --%>
        <c:choose>
            <c:when test="${fn:length(imagenes) >= maxImagenes}">
                <%-- Límite alcanzado --%>
                <div class="limite-aviso">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2">
                        <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/>
                        <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
                    </svg>
                    Límite alcanzado: esta lección ya tiene el máximo de
                    <strong>${maxImagenes} imágenes</strong>.
                    Elimina alguna para poder subir otra.
                </div>
            </c:when>
            <c:otherwise>
                <div class="upload-card">
                    <h2>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2"
                             style="color:var(--color-celeste)" aria-hidden="true">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                            <polyline points="17 8 12 3 7 8"/>
                            <line x1="12" y1="3" x2="12" y2="15"/>
                        </svg>
                        Subir Imagen
                    </h2>
                    <p class="upload-slots">
                        Puedes añadir hasta
                        <strong>${maxImagenes - fn:length(imagenes)} imagen(es)</strong> más
                        en esta lección.
                    </p>

                        <%-- Drop zone --%>
                    <div class="drop-zone" id="dropZone">
                        <input type="file"
                               id="fileInput"
                               name="imagenes"
                               accept=".jpg,.jpeg,.png,.gif"
                               aria-label="Seleccionar imagen"
                               multiple>
                        <div class="drop-icon" aria-hidden="true">
                            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="3" width="18" height="18" rx="2"/>
                                <circle cx="8.5" cy="8.5" r="1.5"/>
                                <polyline points="21 15 16 10 5 21"/>
                            </svg>
                        </div>
                        <p class="drop-title">Arrastra una imagen o haz clic</p>
                        <p class="drop-sub">
                            JPG, PNG, GIF ·
                            <span>máx. 5 MB por imagen</span>
                        </p>
                    </div>

                        <%-- Vista previa --%>
                    <div class="file-preview" id="filePreview">
                        <img id="previewImg" src="" alt="Vista previa" class="preview-img">
                        <div class="preview-info">
                            <p class="preview-name" id="previewName"></p>
                            <p class="preview-size" id="previewSize"></p>
                        </div>
                        <button type="button"
                                class="btn-clear-file"
                                onclick="limpiarArchivo()"
                                title="Quitar archivo seleccionado">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18"/>
                                <line x1="6" y1="6" x2="18" y2="18"/>
                            </svg>
                        </button>
                    </div>

                    <div class="upload-submit">
                        <button type="submit"
                                id="btnSubirImagen"
                                class="btn-primary"
                                disabled>
                            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                <polyline points="17 8 12 3 7 8"/>
                                <line x1="12" y1="3" x2="12" y2="15"/>
                            </svg>
                            Subir imagen
                        </button>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </form><%-- /mainForm --%>

</main>

<script>
    if (typeof lucide !== 'undefined') lucide.createIcons();

    /* ═══════════════════════════════════════════════════════
       CONTADOR DE CARACTERES
    ════════════════════════════════════════════════════════ */
    const MAX_CHARS   = parseInt('${maxCaracteres}', 10) || 5000;
    const textoInput  = document.getElementById('textoInput');
    const charCounter = document.getElementById('charCounter');

    function actualizarContador() {
        if (!textoInput || !charCounter) return;
        const len  = textoInput.value.length;
        const rest = MAX_CHARS - len;
        charCounter.textContent = len.toLocaleString() + ' / ' + MAX_CHARS.toLocaleString() + ' caracteres';
        if (rest < 0) {
            charCounter.className = 'char-counter warning';
        } else if (rest <= 100) {
            charCounter.className = 'char-counter warning';
        } else {
            charCounter.className = 'char-counter';
        }
    }

    if (textoInput) {
        textoInput.addEventListener('input', actualizarContador);
        actualizarContador(); // inicializar al cargar
    }

    /* ═══════════════════════════════════════════════════════
       TOGGLE EDITAR TEXTO
    ════════════════════════════════════════════════════════ */
    function toggleEditarTexto() {
        const display   = document.getElementById('textoDisplay');
        const editForm  = document.getElementById('textoEditForm');
        const btn       = document.getElementById('btnEditarTexto');
        if (!editForm) return;

        const estaOculto = editForm.style.display === 'none';
        editForm.style.display = estaOculto ? 'block' : 'none';
        if (display) display.style.display = estaOculto ? 'none' : 'block';
        if (btn)     btn.classList.toggle('active', estaOculto);
        if (estaOculto && textoInput) {
            textoInput.focus();
            actualizarContador();
        }
    }

    function cancelarEditarTexto() {
        const display  = document.getElementById('textoDisplay');
        const editForm = document.getElementById('textoEditForm');
        const btn      = document.getElementById('btnEditarTexto');
        if (editForm)  editForm.style.display = 'none';
        if (display)   display.style.display  = 'block';
        if (btn)       btn.classList.remove('active');
    }

    /* ═══════════════════════════════════════════════════════
       UPLOAD — preview + validación cliente
    ════════════════════════════════════════════════════════ */
    const MAX_SIZE   = 5 * 1024 * 1024; // 5 MB
    const fileInput  = document.getElementById('fileInput');
    const dropZone   = document.getElementById('dropZone');
    const filePreview   = document.getElementById('filePreview');
    const previewImg    = document.getElementById('previewImg');
    const previewName   = document.getElementById('previewName');
    const previewSize   = document.getElementById('previewSize');
    const btnSubirImagen = document.getElementById('btnSubirImagen');

    function formatBytes(bytes) {
        if (bytes < 1024)       return bytes + ' B';
        if (bytes < 1_048_576)  return (bytes / 1024).toFixed(1) + ' KB';
        return (bytes / 1_048_576).toFixed(1) + ' MB';
    }

    function mostrarArchivo(file) {
        if (!file) return;
        // Validar tipo en cliente
        const tiposPermitidos = ['image/jpeg', 'image/png', 'image/gif'];
        if (!tiposPermitidos.includes(file.type)) {
            alert('Formato no permitido: "' + file.type + '". Solo se aceptan JPG, PNG y GIF.');
            limpiarArchivo();
            return;
        }
        // Validar tamaño en cliente
        if (file.size > MAX_SIZE) {
            alert('El archivo "' + file.name + '" supera 5 MB (' + formatBytes(file.size) + ').');
            limpiarArchivo();
            return;
        }
        // Mostrar preview
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src      = e.target.result;
            previewName.textContent = file.name;
            previewSize.textContent = formatBytes(file.size);
            filePreview.classList.add('visible');
            if (btnSubirImagen) btnSubirImagen.disabled = false;
        };
        reader.readAsDataURL(file);
    }

    function limpiarArchivo() {
        if (fileInput)  fileInput.value = '';
        if (previewImg) previewImg.src  = '';
        if (filePreview) filePreview.classList.remove('visible');
        if (btnSubirImagen) btnSubirImagen.disabled = true;
    }

    if (fileInput) {
        fileInput.addEventListener('change', function(e) {
            if (e.target.files && e.target.files[0]) {
                mostrarArchivo(e.target.files[0]);
            }
        });
    }

    // Drag & drop
    if (dropZone) {
        ['dragenter', 'dragover'].forEach(function(evt) {
            dropZone.addEventListener(evt, function(e) {
                e.preventDefault();
                dropZone.classList.add('drag-over');
            });
        });
        ['dragleave', 'drop'].forEach(function(evt) {
            dropZone.addEventListener(evt, function(e) {
                dropZone.classList.remove('drag-over');
            });
        });
        dropZone.addEventListener('drop', function(e) {
            e.preventDefault();
            const file = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
            if (file) {
                try {
                    const dt = new DataTransfer();
                    dt.items.add(file);
                    fileInput.files = dt.files;
                } catch(_) { /* fallback sin asignar a input */ }
                mostrarArchivo(file);
            }
        });
    }

    /* ═══════════════════════════════════════════════════════
       MODAL ELIMINAR IMAGEN
    ════════════════════════════════════════════════════════ */
    function openDelImgModal(imagenId, nombreArchivo) {
        document.getElementById('delImgIdInput').value = imagenId;
        document.getElementById('delImgModalDesc').textContent =
            '¿Eliminar "' + nombreArchivo + '"? Esta acción no se puede deshacer.';
        document.getElementById('delImgModal').classList.add('active');
    }
    function closeDelImgModal() {
        document.getElementById('delImgModal').classList.remove('active');
    }
    document.getElementById('delImgModal').addEventListener('click', function(e) {
        if (e.target === this) closeDelImgModal();
    });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeDelImgModal();
    });
</script>
</body>
</html>