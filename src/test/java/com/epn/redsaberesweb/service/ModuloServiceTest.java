package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.models.Modulo;
import com.epn.redsaberesweb.repository.CursoRepository; // Necesario para validar la existencia del curso
import com.epn.redsaberesweb.repository.ModuloRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests para ModuloService")
class ModuloServiceTest {

    @Mock
    private ModuloRepository moduloRepository;

    @Mock
    private CursoRepository cursoRepository;

    @InjectMocks
    private ModuloService moduloService;

    private Curso cursoExistente;
    private Modulo moduloExistente; // Orden 1
    private Modulo moduloAdyacente; // Orden 2
    private Modulo otroModulo; // Orden 3

    @BeforeEach
    void setUp() {
        cursoExistente = new Curso();
        cursoExistente.setId(1L);
        cursoExistente.setTitulo("Curso de Prueba");

        moduloExistente = new Modulo();
        moduloExistente.setId(10L);
        moduloExistente.setCurso(cursoExistente);
        moduloExistente.setTitulo("Introducción");
        moduloExistente.setOrden(1); // Orden inicial

        moduloAdyacente = new Modulo();
        moduloAdyacente.setId(11L);
        moduloAdyacente.setCurso(cursoExistente);
        moduloAdyacente.setTitulo("Segundo Tema");
        moduloAdyacente.setOrden(2); // Orden inicial

        otroModulo = new Modulo();
        otroModulo.setId(12L);
        otroModulo.setCurso(cursoExistente);
        otroModulo.setTitulo("Tercer Tema");
        otroModulo.setOrden(3); // Orden inicial
    }

    // --- Tests para crearModulo ---

    @Test
    @DisplayName("Debería crear un módulo con datos válidos")
    void dado_datos_validos_cuando_crear_modulo_entonces_modulo_creado() {
        // GIVEN
        Modulo nuevoModulo = new Modulo();
        nuevoModulo.setCurso(cursoExistente);
        nuevoModulo.setTitulo("Nuevo Tema");
        nuevoModulo.setOrden(2);

        // Mockear la existencia del curso
        when(cursoRepository.findById(cursoExistente.getId())).thenReturn(Optional.of(cursoExistente));
        // Mockear el save del repositorio (es void)
        doAnswer(invocation -> {
            Modulo moduloArg = invocation.getArgument(0);
            moduloArg.setId(20L); // Simular asignación de ID
            return null;
        }).when(moduloRepository).save(any(Modulo.class));

        // WHEN
        moduloService.crearModulo(nuevoModulo);

        // THEN
        assertNotNull(nuevoModulo.getId());
        assertEquals(20L, nuevoModulo.getId());
        assertEquals("Nuevo Tema", nuevoModulo.getTitulo());
        assertEquals(2, nuevoModulo.getOrden());
        assertEquals(cursoExistente.getId(), nuevoModulo.getCurso().getId());

        verify(cursoRepository, times(1)).findById(cursoExistente.getId());
        verify(moduloRepository, times(1)).save(nuevoModulo);
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @ParameterizedTest
    @MethodSource("provideInvalidTitles")
    @DisplayName("Debería lanzar IllegalArgumentException si el título del módulo es nulo, vacío o solo espacios")
    void dado_titulo_invalido_cuando_crear_modulo_entonces_lanza_excepcion(String invalidTitle, String expectedMessage) {
        // GIVEN
        Modulo modulo = new Modulo();
        modulo.setCurso(cursoExistente);
        modulo.setTitulo(invalidTitle);
        modulo.setOrden(1);

        // Mockear la existencia del curso
        when(cursoRepository.findById(cursoExistente.getId())).thenReturn(Optional.of(cursoExistente));

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> moduloService.crearModulo(modulo)
        );

        assertEquals(expectedMessage, exception.getMessage());

        // Verificaciones
        // findById se llama una vez por cada ejecución del test parametrizado
        verify(cursoRepository, times(1)).findById(cursoExistente.getId());
        verify(moduloRepository, never()).save(any(Modulo.class));
        verifyNoMoreInteractions(moduloRepository);
    }

    private static Stream<Arguments> provideInvalidTitles() {
        return Stream.of(
                Arguments.of(null, "El título del módulo es obligatorio."), // Se debe castear a String para el argumento null
                Arguments.of("", "El título del módulo es obligatorio."),
                Arguments.of("   ", "El título del módulo es obligatorio."),
                Arguments.of("a", "El título del módulo debe tener entre 3 y 100 caracteres."),
                Arguments.of("ab", "El título del módulo debe tener entre 3 y 100 caracteres."),
                Arguments.of("a".repeat(101), "El título del módulo debe tener entre 3 y 100 caracteres.")
        );
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el curso del módulo es nulo")
    void dado_curso_nulo_cuando_crear_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Modulo nuevoModulo = new Modulo();
        nuevoModulo.setCurso(null); // Curso nulo
        nuevoModulo.setTitulo("Título Válido");
        nuevoModulo.setOrden(1);

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> moduloService.crearModulo(nuevoModulo)
        );
        assertEquals("El curso asociado al módulo es obligatorio.", exception.getMessage());

        verify(cursoRepository, never()).findById(anyLong());
        verify(moduloRepository, never()).save(any(Modulo.class));
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el ID del curso del módulo es nulo")
    void dado_cursoId_nulo_cuando_crear_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Curso cursoConIdNulo = new Curso();
        cursoConIdNulo.setTitulo("Curso sin ID");

        Modulo nuevoModulo = new Modulo();
        nuevoModulo.setCurso(cursoConIdNulo); // Curso con ID nulo
        nuevoModulo.setTitulo("Título Válido");
        nuevoModulo.setOrden(1);

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.crearModulo(nuevoModulo));
        assertEquals("El curso asociado al módulo es obligatorio.", exception.getMessage());

        verify(cursoRepository, never()).findById(anyLong());
        verify(moduloRepository, never()).save(any(Modulo.class));
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el curso no existe")
    void dado_curso_no_existente_cuando_crear_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Modulo nuevoModulo = new Modulo();
        nuevoModulo.setCurso(cursoExistente); // ID 1L
        nuevoModulo.setTitulo("Título Válido");
        nuevoModulo.setOrden(1);

        // Mockear que el curso no se encuentra
        when(cursoRepository.findById(cursoExistente.getId())).thenReturn(Optional.empty());

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.crearModulo(nuevoModulo));
        assertEquals("El curso asociado al módulo no existe.", exception.getMessage());

        verify(cursoRepository, times(1)).findById(cursoExistente.getId());
        verify(moduloRepository, never()).save(any(Modulo.class));
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    // --- Tests para listarModulosPorCurso ---

    @Test
    @DisplayName("Debería retornar una lista de módulos ordenados por 'orden' ASC para un curso")
    void dado_cursoId_valido_cuando_listar_modulos_entonces_retorna_lista_ordenada() {
        // GIVEN
        Modulo modulo1 = new Modulo();
        modulo1.setId(1L);
        modulo1.setCurso(cursoExistente);
        modulo1.setTitulo("Modulo 1");
        modulo1.setOrden(1);

        Modulo modulo2 = new Modulo();
        modulo2.setId(2L);
        modulo2.setCurso(cursoExistente);
        modulo2.setTitulo("Modulo 2");
        modulo2.setOrden(2);

        List<Modulo> modulosEsperados = Arrays.asList(modulo1, modulo2);

        when(moduloRepository.listarPorCurso(cursoExistente.getId())).thenReturn(modulosEsperados);

        // WHEN
        List<Modulo> resultado = moduloService.listarModulosPorCurso(cursoExistente.getId());

        // THEN
        assertNotNull(resultado);
        assertFalse(resultado.isEmpty());
        assertEquals(2, resultado.size());
        assertEquals(1L, resultado.get(0).getId());
        assertEquals(2L, resultado.get(1).getId());
        assertEquals(1, resultado.get(0).getOrden());
        assertEquals(2, resultado.get(1).getOrden());

        verify(moduloRepository, times(1)).listarPorCurso(cursoExistente.getId());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería retornar una lista vacía si el curso no tiene módulos")
    void dado_cursoId_sin_modulos_cuando_listar_modulos_entonces_retorna_lista_vacia() {
        // GIVEN
        when(moduloRepository.listarPorCurso(cursoExistente.getId())).thenReturn(Collections.emptyList());

        // WHEN
        List<Modulo> resultado = moduloService.listarModulosPorCurso(cursoExistente.getId());

        // THEN
        assertNotNull(resultado);
        assertTrue(resultado.isEmpty());

        verify(moduloRepository, times(1)).listarPorCurso(cursoExistente.getId());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el cursoId es nulo al listar módulos")
    void dado_cursoId_nulo_cuando_listar_modulos_entonces_lanza_excepcion() {
        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.listarModulosPorCurso(null));
        assertEquals("El ID del curso es obligatorio para listar módulos.", exception.getMessage());

        verify(moduloRepository, never()).listarPorCurso(anyLong());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    // --- Tests para editarModulo ---

    @Test
    @DisplayName("Debería editar un módulo existente con datos válidos")
    void dado_datos_validos_cuando_editar_modulo_existente_entonces_modulo_actualizado() {
        // GIVEN
        Modulo moduloActualizado = new Modulo();
        moduloActualizado.setId(moduloExistente.getId());
        moduloActualizado.setCurso(cursoExistente);
        moduloActualizado.setTitulo("Título Actualizado");
        moduloActualizado.setOrden(3);

        when(moduloRepository.findById(moduloExistente.getId())).thenReturn(Optional.of(moduloExistente));
        when(cursoRepository.findById(cursoExistente.getId())).thenReturn(Optional.of(cursoExistente));
        doAnswer(invocation -> {
            Modulo arg = invocation.getArgument(0);
            // Simular que el repositorio actualiza el objeto
            moduloExistente.setTitulo(arg.getTitulo());
            moduloExistente.setOrden(arg.getOrden());
            return moduloExistente; // Retornar el objeto actualizado
        }).when(moduloRepository).update(any(Modulo.class));

        // WHEN
        moduloService.editarModulo(moduloActualizado);

        // THEN
        assertEquals(moduloExistente.getId(), moduloActualizado.getId());
        assertEquals("Título Actualizado", moduloActualizado.getTitulo());
        assertEquals(3, moduloActualizado.getOrden());

        verify(moduloRepository, times(1)).findById(moduloExistente.getId());
        verify(cursoRepository, times(1)).findById(cursoExistente.getId());
        verify(moduloRepository, times(1)).update(any(Modulo.class));
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el módulo a editar no existe")
    void dado_modulo_no_existente_cuando_editar_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Modulo moduloNoExistente = new Modulo();
        moduloNoExistente.setId(99L);
        moduloNoExistente.setCurso(cursoExistente);
        moduloNoExistente.setTitulo("Cualquier Título");
        moduloNoExistente.setOrden(1);

        when(moduloRepository.findById(moduloNoExistente.getId())).thenReturn(Optional.empty());

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.editarModulo(moduloNoExistente));
        assertEquals("El módulo a editar no existe.", exception.getMessage());

        verify(moduloRepository, times(1)).findById(moduloNoExistente.getId());
        verify(cursoRepository, never()).findById(anyLong());
        verify(moduloRepository, never()).update(any(Modulo.class));
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el título del módulo editado es inválido")
    void dado_titulo_invalido_cuando_editar_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Modulo moduloConTituloInvalido = new Modulo();
        moduloConTituloInvalido.setId(moduloExistente.getId());
        moduloConTituloInvalido.setCurso(cursoExistente);
        moduloConTituloInvalido.setTitulo("a"); // Título muy corto
        moduloConTituloInvalido.setOrden(1);

        when(moduloRepository.findById(moduloExistente.getId())).thenReturn(Optional.of(moduloExistente));
        when(cursoRepository.findById(cursoExistente.getId())).thenReturn(Optional.of(cursoExistente));

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.editarModulo(moduloConTituloInvalido));
        assertEquals("El título del módulo debe tener entre 3 y 100 caracteres.", exception.getMessage());

        verify(moduloRepository, times(1)).findById(moduloExistente.getId());
        verify(cursoRepository, times(1)).findById(cursoExistente.getId());
        verify(moduloRepository, never()).update(any(Modulo.class));
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    // --- Tests para eliminarModulo ---

    @Test
    @DisplayName("Debería eliminar un módulo existente")
    void dado_moduloId_existente_cuando_eliminar_modulo_entonces_modulo_eliminado() {
        // GIVEN
        Long moduloIdAEliminar = moduloExistente.getId();
        when(moduloRepository.findById(moduloIdAEliminar)).thenReturn(Optional.of(moduloExistente));
        doNothing().when(moduloRepository).delete(moduloIdAEliminar); // deleteById es void

        // WHEN
        moduloService.eliminarModulo(moduloIdAEliminar);

        // THEN
        verify(moduloRepository, times(1)).findById(moduloIdAEliminar);
        verify(moduloRepository, times(1)).delete(moduloIdAEliminar);
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el ID del módulo a eliminar es nulo")
    void dado_moduloId_nulo_cuando_eliminar_modulo_entonces_lanza_excepcion() {
        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.eliminarModulo(null));
        assertEquals("El ID del módulo a eliminar es obligatorio.", exception.getMessage());

        verify(moduloRepository, never()).findById(anyLong());
        verify(moduloRepository, never()).delete(anyLong());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el módulo a eliminar no existe")
    void dado_modulo_no_existente_cuando_eliminar_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Long moduloIdNoExistente = 99L;
        when(moduloRepository.findById(moduloIdNoExistente)).thenReturn(Optional.empty());

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.eliminarModulo(moduloIdNoExistente));
        assertEquals("El módulo a eliminar no existe.", exception.getMessage());

        verify(moduloRepository, times(1)).findById(moduloIdNoExistente);
        verify(moduloRepository, never()).delete(anyLong());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    // --- Tests para reordenarModulo ---

    @Test
    @DisplayName("Debería reordenar un módulo intercambiando su orden con un adyacente (subir)")
    void dado_modulo_y_nuevo_orden_valido_subir_cuando_reordenar_modulo_entonces_orden_intercambiado() {
        // GIVEN
        // Queremos mover moduloAdyacente (orden 2) a la posición de moduloExistente (orden 1)
        Long moduloIdToReorder = moduloAdyacente.getId(); // Modulo con orden 2
        int nuevoOrden = 1; // Queremos moverlo a la posición del moduloExistente

        // Mockear las llamadas al repositorio
        when(moduloRepository.findById(moduloIdToReorder)).thenReturn(Optional.of(moduloAdyacente));
        when(moduloRepository.listarPorCurso(cursoExistente.getId())).thenReturn(Arrays.asList(moduloExistente, moduloAdyacente, otroModulo));
        doNothing().when(moduloRepository).intercambiarOrdenes(moduloAdyacente.getId(), moduloExistente.getId());

        // WHEN
        moduloService.reordenarModulo(moduloIdToReorder, nuevoOrden);

        // THEN
        // 1. Verificar llamadas al repositorio
        verify(moduloRepository, times(1)).findById(moduloIdToReorder);
        verify(moduloRepository, times(1)).listarPorCurso(cursoExistente.getId());
        verify(moduloRepository, times(1)).intercambiarOrdenes(moduloAdyacente.getId(), moduloExistente.getId());

        // 2. Asegurarse de que no hubo otras interacciones inesperadas
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería reordenar un módulo intercambiando su orden con un adyacente (bajar)")
    void dado_modulo_y_nuevo_orden_valido_bajar_cuando_reordenar_modulo_entonces_orden_intercambiado() {
        // GIVEN
        // Queremos mover moduloExistente (orden 1) a la posición de moduloAdyacente (orden 2)
        Long moduloIdToReorder = moduloExistente.getId(); // Modulo con orden 1
        int nuevoOrden = 2; // Queremos moverlo a la posición del moduloAdyacente

        // Mockear las llamadas al repositorio
        when(moduloRepository.findById(moduloIdToReorder)).thenReturn(Optional.of(moduloExistente));
        when(moduloRepository.listarPorCurso(cursoExistente.getId())).thenReturn(Arrays.asList(moduloExistente, moduloAdyacente, otroModulo));
        doNothing().when(moduloRepository).intercambiarOrdenes(moduloExistente.getId(), moduloAdyacente.getId());

        // WHEN
        moduloService.reordenarModulo(moduloIdToReorder, nuevoOrden);

        // THEN
        // 1. Verificar llamadas al repositorio
        verify(moduloRepository, times(1)).findById(moduloIdToReorder);
        verify(moduloRepository, times(1)).listarPorCurso(cursoExistente.getId());
        verify(moduloRepository, times(1)).intercambiarOrdenes(moduloExistente.getId(), moduloAdyacente.getId());

        // 2. Asegurarse de que no hubo otras interacciones inesperadas
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("No debería hacer nada si el nuevo orden es igual al actual")
    void dado_modulo_y_mismo_orden_cuando_reordenar_modulo_entonces_no_hay_interacciones() {
        // GIVEN
        Long moduloId = moduloExistente.getId();
        int nuevoOrden = moduloExistente.getOrden(); // Mismo orden

        when(moduloRepository.findById(moduloId)).thenReturn(Optional.of(moduloExistente));
        when(moduloRepository.listarPorCurso(cursoExistente.getId())).thenReturn(Arrays.asList(moduloExistente, moduloAdyacente, otroModulo));

        // WHEN
        moduloService.reordenarModulo(moduloId, nuevoOrden);

        // THEN
        verify(moduloRepository, times(1)).findById(moduloId);
        verify(moduloRepository, times(1)).listarPorCurso(cursoExistente.getId());
        verify(moduloRepository, never()).intercambiarOrdenes(anyLong(), anyLong()); // No se llama a intercambiarOrdenes
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el ID del módulo es nulo al reordenar")
    void dado_moduloId_nulo_cuando_reordenar_modulo_entonces_lanza_excepcion() {
        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.reordenarModulo(null, 1));
        assertEquals("El ID del módulo es obligatorio para reordenar.", exception.getMessage());

        verify(moduloRepository, never()).findById(anyLong());
        verify(moduloRepository, never()).listarPorCurso(anyLong());
        verify(moduloRepository, never()).intercambiarOrdenes(anyLong(), anyLong());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el nuevo orden es inválido (cero o negativo)")
    void dado_nuevo_orden_invalido_cuando_reordenar_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Long moduloId = moduloExistente.getId();
        int nuevoOrdenInvalido = 0; // Orden debe ser >= 1

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.reordenarModulo(moduloId, nuevoOrdenInvalido));
        assertEquals("El nuevo orden debe ser un número positivo.", exception.getMessage());

        // VERIFICACIÓN
        verify(moduloRepository, never()).findById(anyLong());
        verify(moduloRepository, never()).listarPorCurso(anyLong());
        verify(moduloRepository, never()).intercambiarOrdenes(anyLong(), anyLong());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el módulo a reordenar no existe")
    void dado_modulo_no_existente_cuando_reordenar_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Long moduloIdNoExistente = 99L;
        int nuevoOrden = 1;

        when(moduloRepository.findById(moduloIdNoExistente)).thenReturn(Optional.empty());

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.reordenarModulo(moduloIdNoExistente, nuevoOrden));
        assertEquals("El módulo con ID "+ moduloIdNoExistente+" no existe.", exception.getMessage());

        verify(moduloRepository, times(1)).findById(moduloIdNoExistente);
        verify(moduloRepository, never()).listarPorCurso(anyLong());
        verify(moduloRepository, never()).intercambiarOrdenes(anyLong(), anyLong());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si la posición de destino está fuera de rango")
    void dado_posicion_destino_fuera_de_rango_cuando_reordenar_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Long moduloId = moduloExistente.getId(); // Orden 1
        int nuevoOrdenFueraDeRango = 5; // Fuera del rango de 3 módulos

        when(moduloRepository.findById(moduloId)).thenReturn(Optional.of(moduloExistente));
        when(moduloRepository.listarPorCurso(cursoExistente.getId())).thenReturn(Arrays.asList(moduloExistente, moduloAdyacente, otroModulo));

        // WHEN & THEN
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> moduloService.reordenarModulo(moduloId, nuevoOrdenFueraDeRango));
        assertEquals("Posición de destino fuera de rango.", exception.getMessage());

        verify(moduloRepository, times(1)).findById(moduloId);
        verify(moduloRepository, times(1)).listarPorCurso(cursoExistente.getId());
        verify(moduloRepository, never()).intercambiarOrdenes(anyLong(), anyLong());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("Debería lanzar IllegalStateException si el módulo no pertenece al curso (no encontrado en la lista)")
    void dado_modulo_no_pertenece_al_curso_cuando_reordenar_modulo_entonces_lanza_excepcion() {
        // GIVEN
        Long moduloId = moduloExistente.getId();
        int nuevoOrden = 2;

        // Mockear que findById lo encuentra, pero listarPorCurso no lo incluye
        when(moduloRepository.findById(moduloId)).thenReturn(Optional.of(moduloExistente));
        when(moduloRepository.listarPorCurso(cursoExistente.getId())).thenReturn(Arrays.asList(moduloAdyacente, otroModulo)); // Lista sin moduloExistente

        // WHEN & THEN
        IllegalStateException exception = assertThrows(IllegalStateException.class,
                () -> moduloService.reordenarModulo(moduloId, nuevoOrden));
        assertEquals("El módulo no pertenece al curso.", exception.getMessage());

        verify(moduloRepository, times(1)).findById(moduloId);
        verify(moduloRepository, times(1)).listarPorCurso(cursoExistente.getId());
        verify(moduloRepository, never()).intercambiarOrdenes(anyLong(), anyLong());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }

    @Test
    @DisplayName("No debería hacer nada si el módulo ya está en su lugar (indiceActual == indiceDestino)")
    void dado_modulo_ya_en_su_lugar_cuando_reordenar_modulo_entonces_no_hay_interacciones() {
        // GIVEN
        Long moduloId = moduloExistente.getId();
        int nuevoOrden = moduloExistente.getOrden(); // Mismo orden que el actual

        when(moduloRepository.findById(moduloId)).thenReturn(Optional.of(moduloExistente));
        when(moduloRepository.listarPorCurso(cursoExistente.getId())).thenReturn(Arrays.asList(moduloExistente, moduloAdyacente, otroModulo));

        // WHEN
        moduloService.reordenarModulo(moduloId, nuevoOrden);

        // THEN
        verify(moduloRepository, times(1)).findById(moduloId);
        verify(moduloRepository, times(1)).listarPorCurso(cursoExistente.getId());
        verify(moduloRepository, never()).intercambiarOrdenes(anyLong(), anyLong());
        verifyNoMoreInteractions(moduloRepository, cursoRepository);
    }
}