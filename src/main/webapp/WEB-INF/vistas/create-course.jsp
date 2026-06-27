<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>RedSaberes | Crear Curso</title>
    <%@ include file="./fragmentos/encabezado.jspf" %>
    <style>
        .create-course-main {
            max-width: 680px;
            margin: 36px auto;
            padding: 0 24px 56px;
        }

        /* ── Breadcrumb ── */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--color-texto-suave);
            margin-bottom: 18px;
        }
        .breadcrumb a {
            color: var(--color-texto-suave);
            text-decoration: none;
            font-weight: 600;
            transition: color .15s;
        }
        .breadcrumb a:hover { color: var(--color-celeste); }
        .breadcrumb .bc-current { color: var(--color-texto); font-weight: 700; }

        /* ── Card ── */
        .form-card {
            background: rgba(255,255,255,0.96);
            border: 1px solid #eef2f7;
            border-radius: var(--radio-grande);
            box-shadow: var(--sombra-suave);
            overflow: hidden;
        }

        /* Cabecera de la card con línea divisora */
        .form-card-header {
            padding: 28px 38px 22px;
            border-bottom: 1px solid #eef2f7;
        }
        .form-card-header h1 {
            font-size: 26px;
            font-weight: 800;
            color: #111827;
            letter-spacing: -0.6px;
            margin-bottom: 4px;
        }
        .form-card-header p { color: var(--color-texto-suave); font-size: 14px; }

        .form-card-body { padding: 28px 38px 32px; }

        /* ── Campos ── */
        .form-group {
            display: grid;
            gap: 7px;
            margin-bottom: 20px;
        }
        .form-group label {
            font-size: 13px;
            font-weight: 700;
            color: #374151;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        .form-group.categoria label { color: var(--color-celeste); }

        .form-control {
            width: 100%;
            height: 46px;
            padding: 0 14px;
            border: 1px solid #dbe3ee;
            border-radius: var(--radio-pequeno);
            background: #ffffff;
            color: #111827;
            font-size: 15px;
            outline: none;
            box-sizing: border-box;
            transition: border-color .2s, box-shadow .2s;
        }
        .form-control:focus {
            border-color: var(--color-celeste);
            box-shadow: 0 0 0 4px rgba(1,186,239,0.14);
        }
        textarea.form-control {
            height: 110px;
            padding: 12px 14px;
            resize: vertical;
        }
        select.form-control { cursor: pointer; }

        /* ── Error ── */
        .error-message {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 20px;
            padding: 12px 14px;
            border: 1px solid #fecaca;
            border-radius: var(--radio-pequeno);
            color: #991b1b;
            background: #fef2f2;
            font-size: 14px;
            font-weight: 600;
        }

        /* ── Acciones ── */
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 28px;
            padding-top: 22px;
            border-top: 1px solid #eef2f7;
        }
        .cancel-button {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 0 20px;
            height: 46px;
            border: 1.5px solid var(--color-borde);
            border-radius: var(--radio-pequeno);
            color: var(--color-texto);
            background: #fff;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            transition: border-color .2s, transform .2s;
        }
        .cancel-button:hover {
            border-color: var(--color-celeste);
            transform: translateY(-1px);
        }
        .submit-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 0 28px;
            height: 46px;
            border: 0;
            border-radius: var(--radio-pequeno);
            color: #ffffff;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            background: var(--gradiente-marca);
            box-shadow: 0 10px 26px rgba(1,186,239,0.28);
            transition: transform .2s, box-shadow .2s, opacity .2s;
        }
        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 34px rgba(1,186,239,0.36);
            opacity: 0.95;
        }

        @media (max-width: 640px) {
            .form-card-header, .form-card-body { padding: 22px 20px; }
            .form-actions { flex-direction: column-reverse; }
            .cancel-button, .submit-button { width: 100%; justify-content: center; height: 50px; }
        }
    </style>
</head>
<body>
<%@ include file="./fragmentos/nav.jspf" %>

<main class="create-course-main">

    <nav class="breadcrumb" aria-label="Ruta de navegación">
        <a href="${pageContext.request.contextPath}/my-courses">Mis Cursos</a>
        <span aria-hidden="true">›</span>
        <span class="bc-current">Crear Nuevo Curso</span>
    </nav>

    <div class="form-card">
        <div class="form-card-header">
            <h1>Crear Nuevo Curso</h1>
            <p>Completa los detalles básicos. Luego podrás añadir módulos y lecciones.</p>
        </div>

        <div class="form-card-body">
            <c:if test="${not empty requestScope.error}">
                <div class="error-message" role="alert">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                        <circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <c:out value="${requestScope.error}"/>
                </div>
            </c:if>

            <%--
                El servlet /courses/create debe:
                1. Guardar el curso con estado=BORRADOR
                2. Hacer redirect a: /modulos?cursoId={nuevoId}&success=Curso+creado+exitosamente
            --%>
            <form action="${pageContext.request.contextPath}/courses/create" method="post">
                <div class="form-group">
                    <label for="titulo">Título del Curso</label>
                    <input type="text" class="form-control" id="titulo" name="titulo"
                           placeholder="Ej: Introducción a Java" required maxlength="150"
                           value="${not empty requestScope.titulo ? requestScope.titulo : ''}">
                </div>

                <div class="form-group">
                    <label for="descripcion">Descripción</label>
                    <textarea class="form-control" id="descripcion" name="descripcion"
                              placeholder="Describe brevemente de qué trata tu curso..."
                              required>${not empty requestScope.descripcion ? requestScope.descripcion : ''}</textarea>
                </div>

                <div class="form-group categoria">
                    <label for="categoria">Categoría</label>
                    <select class="form-control" id="categoria" name="categoria" required>
                        <option value="" disabled ${empty requestScope.categoria ? 'selected' : ''}>
                            Seleccione una categoría
                        </option>
                        <option value="Programacion"     ${requestScope.categoria == 'Programacion'     ? 'selected' : ''}>Programación</option>
                        <option value="Diseno"           ${requestScope.categoria == 'Diseno'           ? 'selected' : ''}>Diseño</option>
                        <option value="Marketing"        ${requestScope.categoria == 'Marketing'        ? 'selected' : ''}>Marketing</option>
                        <option value="Idiomas"          ${requestScope.categoria == 'Idiomas'          ? 'selected' : ''}>Idiomas</option>
                        <option value="Negocios"         ${requestScope.categoria == 'Negocios'         ? 'selected' : ''}>Negocios</option>
                        <option value="Ciencia"          ${requestScope.categoria == 'Ciencia'          ? 'selected' : ''}>Ciencia</option>
                        <option value="Arte"             ${requestScope.categoria == 'Arte'             ? 'selected' : ''}>Arte</option>
                        <option value="Musica"           ${requestScope.categoria == 'Musica'           ? 'selected' : ''}>Música</option>
                        <option value="DesarrolloPersonal" ${requestScope.categoria == 'DesarrolloPersonal' ? 'selected' : ''}>Desarrollo Personal</option>
                    </select>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/my-courses" class="cancel-button">
                        Cancelar
                    </a>
                    <button type="submit" class="submit-button">
                        <svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                        Guardar y Continuar
                    </button>
                </div>
            </form>
        </div>
    </div>

</main>

<script>
    if (typeof lucide !== 'undefined') lucide.createIcons();
</script>
</body>
</html>