<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Mis Cursos</title>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        .my-courses-main {
            max-width: 1160px;
            margin: 0 auto;
            padding: 40px 24px 60px;
            animation: fadeIn .4s ease both;
        }

        /* ── Cabecera de página ── */
        .page-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 32px;
        }
        .page-header h1 {
            font-size: clamp(24px, 3vw, 32px);
            font-weight: 800;
            letter-spacing: -0.6px;
            color: var(--color-texto);
            margin-bottom: 6px;
        }
        .page-header p { color: var(--color-texto-suave); font-size: 14px; line-height: 1.5; }

        .btn-crear-curso {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            height: 44px;
            padding: 0 22px;
            border: 0;
            border-radius: var(--radio-pequeno);
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            white-space: nowrap;
            color: #fff;
            background: var(--gradiente-marca);
            box-shadow: 0 8px 22px rgba(1,186,239,0.28);
            transition: transform .2s, box-shadow .2s, opacity .2s;
        }
        .btn-crear-curso:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 30px rgba(1,186,239,0.38);
            opacity: 0.95;
        }

        /* ── Grid de cursos ── */
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        /* ── Tarjeta de curso ── */
        .course-card {
            display: flex;
            flex-direction: column;
            gap: 0;
            border-radius: var(--radio-grande);
            border: 1px solid #eef2f7;
            background: rgba(255,255,255,0.96);
            box-shadow: var(--sombra-suave);
            overflow: hidden;
            transition: transform .25s, box-shadow .25s;
        }
        .course-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--sombra-media);
        }

        .course-card-body { padding: 22px 22px 0; flex: 1; }

        .course-card-top {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            margin-bottom: 16px;
        }
        .course-icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            color: #fff;
            background: var(--gradiente-marca);
            box-shadow: 0 8px 20px rgba(1,186,239,0.22);
        }
        .course-meta { flex: 1; min-width: 0; }
        .course-meta h2 {
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -0.3px;
            color: var(--color-texto);
            margin-bottom: 6px;
            word-break: break-word;
        }
        .course-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            color: var(--color-azul-oscuro);
            background: rgba(1,186,239,0.10);
            border: 1px solid rgba(1,186,239,0.20);
        }

        /* ── Detalles (estado, fecha) ── */
        .course-details { display: grid; gap: 8px; }
        .course-detail-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding: 10px 12px;
            border-radius: 12px;
            background: #f8fafc;
            border: 1px solid #eef2f7;
        }
        .course-detail-item .label {
            color: var(--color-texto-suave);
            font-size: 12px;
            font-weight: 700;
            flex-shrink: 0;
        }

        /* ── Badges de estado ── */
        .badge-estado {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }
        .badge-publicado  { background: #d1fae5; color: #065f46; }
        .badge-borrador   { background: #fef3c7; color: #92400e; }
        .badge-archivado  { background: #f3f4f6; color: #374151; }

        .course-date {
            font-size: 13px;
            font-weight: 700;
            color: var(--color-texto);
            text-align: right;
        }

        /* ── Acciones de la tarjeta ── */
        .course-card-actions {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
            padding: 14px 22px 18px;
            border-top: 1px solid #f1f5f9;
            margin-top: 16px;
        }
        .btn-ver-detalle {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 36px;
            padding: 0 14px;
            border: 1.5px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            background: #fff;
            color: var(--color-texto);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: background .2s, border-color .2s, transform .2s;
        }
        .btn-ver-detalle:hover {
            background: #f8fafc;
            border-color: var(--color-celeste);
            transform: translateY(-1px);
        }
        /* Botón primario de la tarjeta */
        .btn-editar-contenido {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 36px;
            padding: 0 16px;
            border: 0;
            border-radius: var(--radio-pequeno);
            background: var(--gradiente-marca);
            color: #fff;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            box-shadow: 0 4px 14px rgba(1,186,239,0.22);
            transition: transform .2s, box-shadow .2s, opacity .2s;
        }
        .btn-editar-contenido:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 20px rgba(1,186,239,0.32);
            opacity: 0.95;
        }

        /* ── Empty state ── */
        .empty-state {
            grid-column: 1 / -1;
            padding: 56px 24px;
            text-align: center;
            border-radius: var(--radio-grande);
            border: 1.5px dashed #dbe3ee;
            background: rgba(255,255,255,0.8);
        }
        .empty-state-icon {
            width: 56px;
            height: 56px;
            border-radius: 18px;
            background: rgba(1,186,239,0.08);
            display: inline-grid;
            place-items: center;
            margin-bottom: 16px;
            color: var(--color-celeste);
        }
        .empty-state h2 { font-size: 20px; font-weight: 800; color: var(--color-texto); margin-bottom: 8px; }
        .empty-state p  { color: var(--color-texto-suave); margin-bottom: 20px; }

        /* ── Paginación ── */
        .pagination {
            margin-top: 28px;
            display: flex;
            gap: 8px;
            align-items: center;
            justify-content: center;
        }
        .pagination a, .pagination span {
            display: inline-block;
            padding: 7px 14px;
            border-radius: 10px;
            border: 1px solid #e6eef6;
            background: #fff;
            color: var(--color-azul-oscuro);
            text-decoration: none;
            font-weight: 700;
            font-size: 13px;
            transition: box-shadow .2s, transform .2s;
        }
        .pagination a:hover { box-shadow: var(--sombra-suave); transform: translateY(-1px); }
        .pagination .disabled { opacity: 0.45; pointer-events: none; background: #f5f7fa; }

        @media (max-width: 640px) {
            .my-courses-main { padding: 28px 14px 44px; }
            .page-header { flex-direction: column; align-items: flex-start; }
            .btn-crear-curso { width: 100%; justify-content: center; }
            .course-card-actions { flex-direction: column; }
            .btn-ver-detalle, .btn-editar-contenido { width: 100%; justify-content: center; height: 44px; }
        }
    </style>
</head>
<body>

<%@ include file="./fragmentos/nav.jspf" %>

<main class="my-courses-main">

    <header class="page-header">
        <div>
            <h1>Mis Cursos</h1>
            <p>Revisa el catálogo personal de cursos que has creado o administras en RedSaberes.</p>
        </div>
        <a href="${pageContext.request.contextPath}/courses/create" class="btn-crear-curso">
            <i data-lucide="plus-circle" style="width:17px;height:17px;" aria-hidden="true"></i>
            Crear Nuevo Curso
        </a>
    </header>

    <section class="courses-grid" aria-label="Listado de cursos">
        <c:choose>
            <c:when test="${not empty cursos}">
                <c:forEach var="curso" items="${cursos}">
                    <article class="course-card fade-in">
                        <div class="course-card-body">
                            <div class="course-card-top">
                                <div class="course-icon" aria-hidden="true">
                                    <i data-lucide="book-open" style="width:22px;height:22px;"></i>
                                </div>
                                <div class="course-meta">
                                    <h2><c:out value="${curso.titulo}"/></h2>
                                    <span class="course-badge">
                                        <i data-lucide="tag" style="width:12px;height:12px;" aria-hidden="true"></i>
                                        <c:out value="${curso.categoria}"/>
                                    </span>
                                </div>
                            </div>

                            <div class="course-details">
                                <div class="course-detail-item">
                                    <span class="label">Estado</span>
                                    <c:choose>
                                        <c:when test="${curso.estado.name() == 'PUBLICADO'}">
                                            <span class="badge-estado badge-publicado">
                                                <i data-lucide="check-circle-2" style="width:11px;height:11px;"></i>
                                                PUBLICADO
                                            </span>
                                        </c:when>
                                        <c:when test="${curso.estado.name() == 'ARCHIVADO'}">
                                            <span class="badge-estado badge-archivado">ARCHIVADO</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-estado badge-borrador">
                                                <i data-lucide="clock" style="width:11px;height:11px;"></i>
                                                BORRADOR
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="course-detail-item">
                                    <span class="label">Creado</span>
                                    <strong class="course-date"><c:out value="${curso.fechaCreacion}"/></strong>
                                </div>
                            </div>
                        </div>

                        <div class="course-card-actions">
                            <a href="${pageContext.request.contextPath}/courses/detail?id=${curso.id}"
                               class="btn-ver-detalle">
                                <i data-lucide="file-search" style="width:14px;height:14px;" aria-hidden="true"></i>
                                Ver Detalle
                            </a>
                            <a href="${pageContext.request.contextPath}/modulos?cursoId=${curso.id}"
                               class="btn-editar-contenido">
                                <i data-lucide="layers" style="width:14px;height:14px;" aria-hidden="true"></i>
                                Editar Contenido
                            </a>
                        </div>
                    </article>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state fade-in">
                    <div class="empty-state-icon">
                        <i data-lucide="book-open" style="width:26px;height:26px;" aria-hidden="true"></i>
                    </div>
                    <h2>Aún no has creado cursos</h2>
                    <p>Cuando crees cursos, aparecerán aquí con su título, categoría y estado.</p>
                    <a href="${pageContext.request.contextPath}/courses/create" class="btn-crear-curso"
                       style="display:inline-flex;">
                        <i data-lucide="plus-circle" style="width:16px;height:16px;" aria-hidden="true"></i>
                        Crear mi primer curso
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <c:if test="${not empty totalPages}">
        <nav class="pagination" aria-label="Paginación de cursos">
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/my-courses?page=${currentPage - 1}">Anterior</a>
            </c:if>
            <span>Página <strong>${currentPage}</strong> de <strong>${totalPages}</strong></span>
            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/my-courses?page=${currentPage + 1}">Siguiente</a>
            </c:if>
        </nav>
    </c:if>

</main>

<script>
    if (typeof lucide !== 'undefined') lucide.createIcons();
</script>
</body>
</html>