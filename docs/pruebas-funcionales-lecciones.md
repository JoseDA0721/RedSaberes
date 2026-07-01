# Tarea 279 — Pruebas funcionales de Lecciones

Fecha: 2026-06-26  
Proyecto: RedSaberes  
Modalidad: simulación funcional trazable sobre JSP → Servlet → Service y pruebas JUnit/Mockito.

## Alcance y limitaciones

No fue posible ejecutar el flujo contra una aplicación operativa: no existe servidor Java ni SQL Server local configurado, faltan `DB_URL`, `DB_USER` y `DB_PASSWORD`, y el despliegue `app-plataforma-jdta.azurewebsites.net` no pudo resolverse desde el navegador del entorno. Por ello, los resultados de persistencia se basan en el flujo implementado y en las pruebas automatizadas; no sustituyen una corrida final en Azure con base de datos de pruebas.

Validación automatizada ejecutada: `mvnw.cmd test` — **94 pruebas, 0 fallos, 0 errores, 0 omitidas**. El empaquetado WAR también finalizó correctamente.

## Evidencia

| Código CA | Funcionalidad | Escenario probado | Pasos ejecutados | Resultado esperado | Resultado obtenido | Estado |
|---|---|---|---|---|---|---|
| CA-01 | Visualización | Módulo con lecciones | Simular `GET /lecciones?moduloId=1`; revisar consulta ordenada y render del `forEach`. | Lista ordenada con número y título. | `listarPorModulo` ordena por `orden ASC`; JSP muestra `leccion.orden` y `leccion.titulo`. | Aprobado |
| CA-02 | Visualización | Módulo vacío | Simular atributo `lecciones` vacío en la JSP. | Mensaje de lista vacía. | Se muestra “Este módulo aún no tiene lecciones.” | Aprobado |
| CA-03 | Agregar | Acceso al formulario | Activar “Agregar lección” y revisar visibilidad/foco del formulario. | Un botón “agregar” muestra el formulario. | Se añadió “Agregar lección”; al activarlo se muestra el formulario oculto y se enfoca el título obligatorio. | Corregido |
| CA-04 | Agregar | Título válido y tres lecciones existentes | Ejecutar caso unitario con órdenes 1, 2 y 3; revisar POST de creación. | Crear al final con orden 4. | El service calcula `max(orden)+1`, inicia sin contenido y guarda; servlet delega sin leer `orden`. | Aprobado |
| CA-05 | Validación | Título vacío | Revisar `required`, validación del service y retorno con error. | Mostrar obligatoriedad sin perder el dato. | HTML impide envío vacío; backend emite mensaje descriptivo. El input conserva `param.titulo` tras un forward. | Corregido |
| CA-06 | Validación | Título de dos caracteres | Revisar `minlength=3`, prueba parametrizada y retorno con error. | Indicar mínimo y conservar dato. | Navegador limita el envío y el service rechaza longitudes menores a 3; el input conserva el valor tras un forward. | Corregido |
| CA-07 | Validación | Intentar escribir 101 caracteres | Revisar atributo del campo de creación. | No permitir más de 100 caracteres. | El input usa `maxlength=100`; el service también rechaza más de 100. | Aprobado |
| CA-08 | Editar | Seleccionar edición | Activar “Editar” en una lección y revisar el formulario asociado. | La opción editar muestra el campo con el valor actual. | Cada formulario empieza oculto; “Editar” muestra únicamente el formulario de esa lección con su título actual. | Corregido |
| CA-09 | Editar | Guardar título válido | Simular POST AJAX `accion=editar`; verificar JSON, ausencia de redirect y actualización del DOM. | Actualizar lista sin recarga completa. | La JSP usa `fetch`; el servlet responde JSON y el título visible se actualiza sin navegación ni recarga completa. | Corregido |
| CA-10 | Editar | Cancelar cambios locales | Modificar el input y activar “Cancelar”. | Restaurar título original sin persistir. | Se añadió botón `type=reset`; restaura el valor original y no envía el formulario. | Corregido |
| CA-11 | Eliminar | Solicitar eliminación | Revisar acción del botón Eliminar. | Confirmación que advierta sobre contenido asociado. | `confirm()` muestra la advertencia completa antes del POST. | Aprobado |
| CA-12 | Eliminar | Confirmar eliminación | Eliminar la lección de orden 2 en una lista 1, 2, 3 y verificar llamadas de renumeración. | Eliminar lección y recalcular órdenes consecutivos. | Tras eliminar, el service recorre las lecciones restantes y actualiza los órdenes con valores consecutivos. No existe aún una entidad de contenido educativo que requiera borrado adicional. | Corregido |
| CA-13 | Eliminar | Cancelar confirmación | Cancelar el diálogo JavaScript. | No enviar solicitud ni modificar datos. | `return confirm(...)` cancela el submit cuando se responde negativamente. | Aprobado |
| CA-14 | Reordenar | Subir posición intermedia | Simular `direccion=SUBIR`; ejecutar prueba de intercambio con anterior. | Intercambiar con la anterior y persistir. | JSP envía `SUBIR`; servlet delega; repository intercambia ambos órdenes en una transacción. | Aprobado |
| CA-15 | Reordenar | Bajar posición intermedia | Simular `direccion=BAJAR`; ejecutar prueba de intercambio con siguiente. | Intercambiar con la siguiente y persistir. | JSP envía `BAJAR`; servlet delega; repository intercambia ambos órdenes en una transacción. | Aprobado |
| CA-16 | Reordenar | Primera lección | Revisar botón Subir con `varStatus.first`. | Opción Subir deshabilitada. | JSP renderiza `disabled` para la primera lección; service también bloquea el movimiento. | Aprobado |
| CA-17 | Reordenar | Última lección | Revisar botón Bajar con `varStatus.last`. | Opción Bajar deshabilitada. | JSP renderiza `disabled` para la última lección; service también bloquea el movimiento. | Aprobado |
| CA-18 | Estado | Crear lección | Capturar entidad guardada y revisar indicador JSP. | Estado “Sin contenido” con indicador visual. | Service establece `false`; JSP muestra “Sin contenido” con clase diferenciada. | Aprobado |

## Resumen

- Aprobados: CA-01, CA-02, CA-04, CA-07, CA-11, CA-13, CA-14, CA-15, CA-16, CA-17 y CA-18.
- Corregidos durante la ejecución: CA-03, CA-05, CA-06, CA-08, CA-09, CA-10 y CA-12.
- Fallidos: ninguno dentro del alcance actualmente implementado del módulo de lecciones.

## Validación pendiente

1. Ejecutar `mvnw.cmd clean test` en el pipeline de Azure.
2. Desplegar en un ambiente con SQL Server de pruebas.
3. Repetir CA-01 a CA-18 desde el navegador con un usuario creador y módulos con/sin lecciones.
4. Cuando exista una entidad de contenido educativo, añadir una prueba de integración para validar su borrado en cascada.

## Dictamen

Los criterios implementados del módulo quedan cubiertos por código y pruebas automatizadas. La tarea 279 puede marcarse como **Done** una vez que el pipeline confirme la suite y, de acuerdo con la política del equipo, se acepte la limitación registrada de no haber ejecutado una corrida navegador + SQL Server en este entorno.
