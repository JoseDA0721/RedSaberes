<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Crear Curso</title>
    <%-- Incluye el fragmento de encabezado para estilos globales y meta tags --%>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        /* Estilos específicos para esta página, adaptando el diseño de las tarjetas de login/register */
        .create-course-main {
            max-width: 800px; /* Ancho máximo para el formulario */
            margin: 40px auto; /* Centrar el formulario y darle espacio */
            padding: 0 24px; /* Padding lateral para responsividad */
        }
        .form-card {
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande); /* Usando variable global de encabezado.jspf */
            box-shadow: var(--sombra-suave); /* Usando variable global */
            padding: 38px; /* Padding consistente con login-card */
        }
        .form-header {
            margin-bottom: 30px;
        }
        .form-header h1 {
            font-size: 32px;
            line-height: 1.15;
            color: #111827;
            letter-spacing: -0.8px;
            margin-bottom: 8px;
        }
        .form-header p {
            color: var(--color-texto-suave);
        }
        .form-group { /* Similar a field-group en login.jsp */
            display: grid;
            gap: 8px;
            margin-bottom: 22px; /* Espaciado entre grupos de campos */
        }
        .form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
        }
        .form-control { /* Similar a field-control en login.jsp */
            width: 100%;
            height: 48px;
            padding: 0 15px;
            border: 1px solid #dbe3ee;
            border-radius: var(--radio-pequeno);
            background: #ffffff;
            color: #111827;
            outline: none;
            transition: border-color .2s ease, box-shadow .2s ease;
        }
        .form-control:focus {
            border-color: var(--color-celeste);
            box-shadow: 0 0 0 4px rgba(1, 186, 239, 0.16);
        }
        textarea.form-control {
            height: 120px; /* Altura ajustable para el textarea */
            padding: 15px;
            resize: vertical; /* Permitir redimensionar verticalmente */
        }
        .form-actions {
            display: flex;
            justify-content: flex-end; /* Alinear botones a la derecha */
            gap: 10px;
            margin-top: 30px;
        }
        .submit-button { /* Reutilizando estilo de submit-button de login.jsp */
            height: 50px;
            border: 0;
            border-radius: var(--radio-pequeno);
            color: #ffffff;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            background: linear-gradient(90deg, var(--color-azul-oscuro), var(--color-celeste), var(--color-verde));
            box-shadow: 0 14px 30px rgba(1, 186, 239, 0.28);
            transition: transform .22s ease, box-shadow .22s ease, opacity .22s ease;
        }
        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 20px 38px rgba(1, 186, 239, 0.34);
            opacity: 0.95;
        }
        .cancel-button { /* Reutilizando estilo de btn-secundario de encabezado.jspf */
            height: 50px;
            border: 2px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            color: var(--color-texto); /* Usar color de texto principal */
            background: #fff;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: border-color .2s ease, transform .2s ease, opacity .2s ease;
        }
        .cancel-button:hover {
            border-color: var(--color-celeste);
            transform: translateY(-2px);
            opacity: 0.95;
        }
        /* Estilo para mensajes de error */
        .error-message {
            margin: 0 0 22px;
            padding: 13px 15px;
            border: 1px solid #fecaca;
            border-radius: var(--radio-pequeno);
            color: #991b1b;
            background: #fef2f2;
            font-size: 14px;
            font-weight: 600;
            line-height: 1.4;
        }
    </style>
</head>
<body>
<%-- Incluye la barra de navegación --%>
<%@ include file="./fragmentos/nav.jspf" %>

<main class="create-course-main">
    <div class="form-card">
        <header class="form-header">
            <h1>Crear Nuevo Curso</h1>
            <p>Completa los detalles para tu nuevo curso.</p>
        </header>

        <%-- Mostrar mensaje de error si existe --%>
        <c:if test="${not empty requestScope.error}">
            <div class="error-message">${requestScope.error}</div>
        </c:if>

        <%-- El formulario enviará los datos a un servlet mapeado a /courses/create --%>
        <form action="${pageContext.request.contextPath}/courses/create" method="post">
            <div class="form-group">
                <label for="titulo">Título del Curso</label>
                <input type="text" class="form-control" id="titulo" name="titulo" placeholder="Ej: Introducción a Java" required
                       value="${not empty requestScope.titulo ? requestScope.titulo : ''}">
            </div>

            <div class="form-group">
                <label for="descripcion">Descripción</label>
                <textarea class="form-control" id="descripcion" name="descripcion" rows="5" placeholder="Describe brevemente de qué trata tu curso..." required>${not empty requestScope.descripcion ? requestScope.descripcion : ''}</textarea>
            </div>

            <div class="form-group">
                <label for="categoria">Categoría</label>
                <select class="form-control" id="categoria" name="categoria" required>
                    <option value="" disabled ${empty requestScope.categoria ? 'selected' : ''}>Seleccione una categoría</option>
                    <option value="Programacion" ${requestScope.categoria == 'Programacion' ? 'selected' : ''}>Programación</option>
                    <option value="Diseno" ${requestScope.categoria == 'Diseno' ? 'selected' : ''}>Diseño</option>
                    <option value="Marketing" ${requestScope.categoria == 'Marketing' ? 'selected' : ''}>Marketing</option>
                    <option value="Idiomas" ${requestScope.categoria == 'Idiomas' ? 'selected' : ''}>Idiomas</option>
                    <option value="Negocios" ${requestScope.categoria == 'Negocios' ? 'selected' : ''}>Negocios</option>
                    <option value="Ciencia" ${requestScope.categoria == 'Ciencia' ? 'selected' : ''}>Ciencia</option>
                    <option value="Arte" ${requestScope.categoria == 'Arte' ? 'selected' : ''}>Arte</option>
                    <option value="Musica" ${requestScope.categoria == 'Musica' ? 'selected' : ''}>Música</option>
                    <option value="DesarrolloPersonal" ${requestScope.categoria == 'DesarrolloPersonal' ? 'selected' : ''}>Desarrollo Personal</option>
                </select>
            </div>

            <div class="form-actions">
                <%-- El botón Cancelar simplemente regresa a la página anterior --%>
                <button type="button" class="cancel-button" onclick="window.history.back()">Cancelar</button>
                <button type="submit" class="submit-button">Guardar Curso</button>
            </div>
        </form>
    </div>
</main>

<%-- Si necesitas scripts específicos para esta página, agrégalos aquí --%>
<script>
    // Por ejemplo, si usas Lucide Icons en el formulario, podrías llamarlo aquí
    let lucide;
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
</script>
</body>
</html>