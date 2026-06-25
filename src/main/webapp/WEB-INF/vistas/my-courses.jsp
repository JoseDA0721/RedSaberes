<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Mis Cursos</title>
    <%@ include file="./fragmentos/encabezado.jspf" %>

    <style>
        /* =============================================
           MIS CURSOS — estilo de página
        ============================================= */
        .my-courses-main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 24px 56px;
            animation: fadeIn .4s ease both;
        }

        .page-header {
            margin-bottom: 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
        }

        .page-header-content {
            flex: 1;
            min-width: 0;
        }

        .page-header h1 {
            font-size: clamp(26px, 3vw, 34px);
            font-weight: 800;
            letter-spacing: -0.7px;
            color: var(--color-texto);
            margin-bottom: 8px;
        }

        .page-header p {
            color: var(--color-texto-suave);
            line-height: 1.5;
        }

        .btn-crear-curso-header {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            height: 44px;
            padding: 0 20px;
            border: 0;
            border-radius: var(--radio-pequeno);
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: transform .2s ease, box-shadow .2s ease, opacity .2s ease;
            text-decoration: none;
            white-space: nowrap;
            background: var(--gradiente-marca);
            color: #fff;
            box-shadow: 0 8px 24px rgba(1, 186, 239, 0.28);
        }

        .btn-crear-curso-header:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 32px rgba(1, 186, 239, 0.38);
            opacity: 0.95;
        }
        .btn-crear-curso-header:active {
            transform: translateY(0);
        }


        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }

        .course-card {
            display: flex;
            flex-direction: column;
            gap: 16px;
            min-height: 240px;
            border-radius: var(--radio-grande);
            border: 1px solid #eef2f7;
            background: rgba(255, 255, 255, 0.96);
            box-shadow: var(--sombra-suave);
            padding: 24px;
            transition: transform .25s ease, box-shadow .25s ease;
        }

        .course-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--sombra-media);
        }

        .course-card-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 14px;
        }

        .course-icon {
            width: 52px;
            height: 52px;
            border-radius: 16px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            color: #ffffff;
            background: var(--gradiente-marca);
            box-shadow: 0 10px 24px rgba(1, 186, 239, 0.24);
        }

        .course-meta {
            flex: 1;
            min-width: 0;
        }

        .course-meta h2 {
            font-size: 20px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: -0.4px;
            color: var(--color-texto);
            margin-bottom: 6px;
            word-break: break-word;
        }

        .course-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            color: var(--color-azul-oscuro);
            background: rgba(1, 186, 239, 0.10);
            border: 1px solid rgba(1, 186, 239, 0.18);
        }

        .course-details {
            display: grid;
            gap: 12px;
        }

        .course-detail-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 14px;
            border-radius: 14px;
            background: #f8fafc;
            border: 1px solid #eef2f7;
        }

        .course-detail-item span {
            color: var(--color-texto-suave);
            font-size: 13px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .course-detail-item strong {
            color: var(--color-texto);
            font-size: 14px;
            font-weight: 700;
            text-align: right;
            word-break: break-word;
        }

        .course-date {
            color: var(--color-texto);
            font-size: 14px;
            font-weight: 700;
            text-align: right;
        }

        /* --- NUEVO ESTILO: Acciones de la tarjeta --- */
        .course-card-actions {
            margin-top: 10px; /* Espacio entre los detalles y las acciones */
            display: flex;
            justify-content: flex-end; /* Alinear el botón a la derecha */
        }

        .btn-ver-detalle {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 38px;
            padding: 0 16px;
            border: 1px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            background: #fff;
            color: var(--color-texto);
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            transition: background .2s ease, border-color .2s ease, transform .2s ease;
        }

        .btn-ver-detalle:hover {
            background: #f8fafc;
            border-color: var(--color-celeste);
            transform: translateY(-1px);
        }

        .empty-state {
            grid-column: 1 / -1;
            padding: 42px 24px;
            text-align: center;
            border-radius: var(--radio-grande);
            border: 1px dashed #dbe3ee;
            background: rgba(255, 255, 255, 0.86);
        }

        .empty-state h2 {
            font-size: 22px;
            font-weight: 800;
            color: var(--color-texto);
            margin-bottom: 8px;
        }

        .empty-state p {
            color: var(--color-texto-suave);
        }

        @media (max-width: 640px) {
            .my-courses-main {
                padding: 28px 14px 42px;
            }

            .course-card {
                padding: 20px;
            }

            .course-detail-item {
                flex-direction: column;
                align-items: flex-start;
            }

            .course-detail-item strong,
            .course-date {
                text-align: left;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .btn-crear-curso-header {
                width: 100%;
                justify-content: center;
            }
        }

        /* =============================================
           PAGINACIÓN — controles simples (Anterior / Siguiente)
        ============================================= */
        .pagination {
            margin-top: 24px;
            display: flex;
            gap: 10px;
            align-items: center;
            justify-content: center;
        }

        .pagination a,
        .pagination span {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 10px;
            border: 1px solid #e6eef6;
            background: #ffffff;
            color: var(--color-azul-oscuro);
            text-decoration: none;
            font-weight: 700;
        }

        .pagination a:hover {
            box-shadow: var(--sombra-suave);
            transform: translateY(-2px);
        }

        .pagination .disabled {
            opacity: 0.5;
            pointer-events: none;
            background: #f5f7fa;
        }
    </style>
</head>
<body>

<%@ include file="./fragmentos/nav.jspf" %>

<main class="my-courses-main">
    <header class="page-header">
        <div class="page-header-content">
            <h1>Mis Cursos</h1>
            <p>Revisa el catálogo personal de cursos que has creado o administras en RedSaberes.</p>
        </div>

        <div class="page-header-actions">
            <a href="${pageContext.request.contextPath}/courses/create" class="btn-crear-curso-header">
                <i data-lucide="plus-circle" style="width:18px;height:18px;"></i>
                Crear Nuevo Curso
            </a>
        </div>
    </header>

    <section class="courses-grid" aria-label="Listado de cursos del usuario">
        <c:choose>
            <c:when test="${not empty cursos}">
                <c:forEach var="curso" items="${cursos}">
                    <article class="course-card fade-in">
                        <div class="course-card-top">
                            <div class="course-icon" aria-hidden="true">
                                <i data-lucide="book-open" style="width:24px;height:24px;"></i>
                            </div>

                            <div class="course-meta">
                                <h2><c:out value="${curso.titulo}" /></h2>
                                <span class="course-badge">
                                    <i data-lucide="tag" style="width:14px;height:14px;"></i>
                                    <c:out value="${curso.categoria}" />
                                </span>
                            </div>
                        </div>

                        <div class="course-details">
                            <div class="course-detail-item">
                                <span>Estado</span>
                                <strong><c:out value="${curso.estado}" /></strong>
                            </div>

                            <div class="course-detail-item">
                                <span>Fecha de creación</span>
                                <strong class="course-date"><c:out value="${curso.fechaCreacion}" /></strong>
                            </div>
                        </div>

                            <%-- NUEVA SECCIÓN: Botón Ver Detalle --%>
                        <div class="course-card-actions">
                            <a href="${pageContext.request.contextPath}/courses/detail?id=${curso.id}" class="btn-ver-detalle">
                                <i data-lucide="file-search" style="width:16px;height:16px;"></i>
                                Ver Detalle
                            </a>
                        </div>
                    </article>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state fade-in">
                    <h2>Aún no has creado cursos.</h2> <%-- Mensaje actualizado --%>
                    <p>Cuando crees cursos, aparecerán aquí con su título, categoría, estado y fecha de creación.</p>
                    <a href="${pageContext.request.contextPath}/courses/create" class="btn btn-marca" style="margin-top: 20px;">
                        <i data-lucide="plus-circle" style="width:18px;height:18px;"></i>
                        Crear mi primer curso
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <c:if test="${not empty totalPages}">
        <nav class="pagination" aria-label="Paginación de cursos">
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/my-courses?page=${currentPage - 1}" class="prev">Anterior</a>
            </c:if>

            <span> Página <strong><c:out value="${currentPage}" /></strong> de <strong><c:out value="${totalPages}" /></strong> </span>

            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/my-courses?page=${currentPage + 1}" class="next">Siguiente</a>
            </c:if>
        </nav>
    </c:if>

</main>

<script>
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
</script>

</body>
</html>