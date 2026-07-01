<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Detalle del Curso</title>
    <%-- Incluye el fragmento de encabezado para estilos globales y meta tags --%>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        /* Estilos específicos para la vista de detalle del curso */
        .course-detail-main {
            max-width: 900px; /* Ancho máximo para el contenido principal */
            margin: 40px auto; /* Centrar el contenido y darle espacio */
            padding: 0 24px; /* Padding lateral para responsividad */
            animation: fadeIn .4s ease both;
        }

        .detail-card {
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande); /* Usando variable global */
            box-shadow: var(--sombra-suave); /* Usando variable global */
            padding: 38px;
        }

        .detail-header {
            margin-bottom: 30px;
            border-bottom: 1px solid var(--color-borde);
            padding-bottom: 20px;
        }

        .detail-header h1 {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            font-size: clamp(28px, 3vw, 38px);
            font-weight: 800;
            letter-spacing: -0.8px;
            color: var(--color-texto);
            margin-bottom: 10px;
        }

        .status-badge {
            display: inline-block;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            line-height: 1.2;
            padding: 4px 12px;
            white-space: nowrap;
        }

        .badge-borrador {
            background: #f1f3f5;
            color: #495057;
        }

        .badge-publicado {
            background: #d3f9d8;
            color: #2b8a3e;
        }

        .detail-header p {
            font-size: 16px;
            color: var(--color-texto-suave);
            line-height: 1.6;
        }

        .detail-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .info-item {
            background: #f8fafc;
            border: 1px solid #eef2f7;
            border-radius: var(--radio-medio);
            padding: 18px;
        }

        .info-item span {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: var(--color-texto-suave);
            margin-bottom: 6px;
        }

        .info-item strong {
            display: block;
            font-size: 16px;
            font-weight: 700;
            color: var(--color-texto);
        }

        .detail-section {
            margin-bottom: 30px;
        }

        .detail-section h2 {
            font-size: 22px;
            font-weight: 800;
            color: var(--color-texto);
            margin-bottom: 15px;
            border-bottom: 1px solid var(--color-borde);
            padding-bottom: 10px;
        }

        .detail-section-content p {
            font-size: 15px;
            line-height: 1.7;
            color: var(--color-texto);
        }

        .back-button-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 40px;
        }

        .publish-course-form {
            margin: 0;
        }

        .btn:disabled {
            cursor: not-allowed;
            opacity: 0.65;
            box-shadow: none;
        }

        .warning-box {
            background: #fff9db;
            border: 1px solid #ffe8cc;
            border-radius: var(--radio-medio);
            color: #856404;
            font-size: 15px;
            font-weight: 700;
            line-height: 1.5;
            margin-bottom: 24px;
            padding: 16px;
        }

        .warning-box strong {
            color: #d9480f;
        }

        @media (max-width: 640px) {
            .course-detail-main {
                padding: 28px 14px;
            }
            .detail-card {
                padding: 28px 20px;
            }
            .detail-header h1 {
                font-size: 28px;
            }
            .detail-info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<%-- Incluye la barra de navegación --%>
<%@ include file="./fragmentos/nav.jspf" %>

<main class="course-detail-main">
    <c:if test="${not empty requestScope.curso}">
        <c:if test="${requestScope.puedePublicar == false and requestScope.curso.estado() != 'PUBLICADO'}">
            <div class="warning-box" role="alert">
                <strong>Antes de publicar:</strong>
                <c:out value="${requestScope.mensajeBoton}" />
            </div>
        </c:if>

        <div class="detail-card">
            <header class="detail-header">
                <h1>
                    <c:out value="${requestScope.curso.titulo()}" />
                    <c:choose>
                        <c:when test="${requestScope.curso.estado() == 'BORRADOR'}">
                            <span class="status-badge badge-borrador">Borrador</span>
                        </c:when>
                        <c:when test="${requestScope.curso.estado() == 'PUBLICADO'}">
                            <span class="status-badge badge-publicado">Publicado</span>
                        </c:when>
                    </c:choose>
                </h1>
                <p><c:out value="${requestScope.curso.descripcion()}" /></p>
            </header>

            <div class="detail-info-grid">
                <div class="info-item">
                    <span>Categoría</span>
                    <strong><c:out value="${requestScope.curso.categoria()}" /></strong>
                </div>
                <div class="info-item">
                    <span>Estado</span>
                    <strong><c:out value="${requestScope.curso.estado()}" /></strong>
                </div>
                <div class="info-item">
                    <span>Fecha de Creación</span>
                    <strong><c:out value="${requestScope.fechaCreacionFormateada}"/></strong>
                </div>
                <div class="info-item">
                    <span>Creador</span>
                    <strong><c:out value="${requestScope.curso.creadorNombres()}"/> <c:out
                            value="${requestScope.curso.creadorApellidos()}"/></strong>
                </div>
            </div>

                <%-- Sección para descripción detallada si fuera necesario, o simplemente se usa la de arriba --%>
            <div class="detail-section">
                <h2>Descripción Completa</h2>
                <div class="detail-section-content">
                    <p><c:out value="${requestScope.curso.descripcion()}" /></p>
                </div>
            </div>

            <div class="back-button-container">
                <button type="button" class="btn btn-secundario" onclick="window.history.back()">Volver</button>
                <form class="publish-course-form" method="post" action="${pageContext.request.contextPath}/publicar-curso"
                      onsubmit="return confirmarPublicacion(event)">
                    <input type="hidden" name="cursoId" value="${requestScope.curso.id()}" />
                    <c:choose>
                        <c:when test="${requestScope.puedePublicar}">
                            <button type="submit" class="btn btn-marca">
                                <c:out value="${requestScope.mensajeBoton}" />
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" class="btn btn-secundario" disabled>
                                <c:out value="${requestScope.mensajeBoton}" />
                            </button>
                        </c:otherwise>
                    </c:choose>
                </form>
            </div>
        </div>
    </c:if>
    <c:if test="${empty requestScope.curso}">
        <div class="detail-card">
            <div class="empty-state fade-in">
                <h2>Curso no encontrado</h2>
                <p>El curso que intentas ver no existe o no está disponible.</p>
                <button type="button" class="btn btn-marca" onclick="window.history.back()" style="margin-top: 20px;">Volver</button>
            </div>
        </div>
    </c:if>
</main>

<script>
    function confirmarPublicacion(event) {
        var confirmado = confirm('¿Está seguro de publicar este curso? Una vez publicado será visible para todos los estudiantes de la plataforma.');
        if (!confirmado) {
            event.preventDefault();
            return false;
        }
        return true;
    }

    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
</script>
</body>
</html>
