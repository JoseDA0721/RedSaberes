package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.models.Leccion;
import com.epn.redsaberesweb.models.Modulo;
import com.epn.redsaberesweb.repository.LeccionRepository;
import com.epn.redsaberesweb.repository.ModuloRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests para LeccionService")
class LeccionServiceTest {

    @Mock
    private LeccionRepository leccionRepository;

    @Mock
    private ModuloRepository moduloRepository;

    @InjectMocks
    private LeccionService leccionService;

    private Modulo modulo;
    private Leccion leccion1;
    private Leccion leccion2;
    private Leccion leccion3;

    @BeforeEach
    void setUp() {
        modulo = new Modulo();
        modulo.setId(1L);
        modulo.setTitulo("Módulo 1");

        leccion1 = crearLeccion(1L, 1);
        leccion2 = crearLeccion(2L, 2);
        leccion3 = crearLeccion(3L, 3);
    }

    @Test
    void crear_conTituloValido_asignaSiguienteOrdenYTieneContenidoFalse() {
        when(moduloRepository.findById(1L)).thenReturn(Optional.of(modulo));
        when(leccionRepository.listarPorModulo(1L)).thenReturn(List.of(leccion1, leccion2, leccion3));
        ArgumentCaptor<Leccion> captor = ArgumentCaptor.forClass(Leccion.class);

        leccionService.crear(1, "Nueva lección");

        verify(leccionRepository).save(captor.capture());
        Leccion leccionGuardada = captor.getValue();
        assertEquals(4, leccionGuardada.getOrden());
        assertFalse(leccionGuardada.isTieneContenido());
        assertEquals(modulo, leccionGuardada.getModulo());
    }

    @ParameterizedTest
    @MethodSource("titulosInvalidos")
    void crear_conTitulosInvalidos_lanzaExcepcion(String titulo) {
        assertThrows(IllegalArgumentException.class, () -> leccionService.crear(1, titulo));

        verify(leccionRepository, never()).save(any(Leccion.class));
    }

    @ParameterizedTest
    @MethodSource("titulosLimiteValidos")
    void crear_conTitulosLimiteValidos_creaLeccion(String titulo) {
        when(moduloRepository.findById(1L)).thenReturn(Optional.of(modulo));
        when(leccionRepository.listarPorModulo(1L)).thenReturn(List.of());

        assertDoesNotThrow(() -> leccionService.crear(1, titulo));

        verify(leccionRepository).save(any(Leccion.class));
    }

    @ParameterizedTest
    @MethodSource("titulosInvalidos")
    void editar_conTitulosInvalidos_lanzaExcepcion(String titulo) {
        assertThrows(IllegalArgumentException.class, () -> leccionService.editar(1, titulo));

        verify(leccionRepository, never()).save(any(Leccion.class));
        verify(leccionRepository, never()).update(any(Leccion.class));
    }

    @Test
    void eliminarLeccion_recalculaOrdenesRestantes() {
        when(leccionRepository.findById(2L)).thenReturn(Optional.of(leccion2));
        when(leccionRepository.listarPorModulo(1L)).thenReturn(List.of(leccion1, leccion2, leccion3));

        leccionService.eliminarLeccion(2L);

        verify(leccionRepository).delete(2L);
        verify(leccionRepository).actualizarOrden(3L, 2);
        verify(leccionRepository, never()).actualizarOrden(1L, 1);
    }

    @Test
    @DisplayName("Debería subir una lección intercambiando su orden con la anterior")
    void reordenarLeccion_subirIntercambiaConAnterior() {
        when(leccionRepository.findById(2L)).thenReturn(Optional.of(leccion2));
        when(leccionRepository.listarPorModulo(1L)).thenReturn(List.of(leccion1, leccion2, leccion3));

        leccionService.reordenarLeccion(2L, "SUBIR");

        verify(leccionRepository).intercambiarOrdenes(2L, 1L);
    }

    @Test
    @DisplayName("Debería bajar una lección intercambiando su orden con la siguiente")
    void reordenarLeccion_bajarIntercambiaConSiguiente() {
        when(leccionRepository.findById(2L)).thenReturn(Optional.of(leccion2));
        when(leccionRepository.listarPorModulo(1L)).thenReturn(List.of(leccion1, leccion2, leccion3));

        leccionService.reordenarLeccion(2L, "BAJAR");

        verify(leccionRepository).intercambiarOrdenes(2L, 3L);
    }

    @Test
    @DisplayName("Debería lanzar IllegalStateException al intentar subir la primera lección")
    void reordenarLeccion_subirPrimera_lanzaExcepcion() {
        when(leccionRepository.findById(1L)).thenReturn(Optional.of(leccion1));
        when(leccionRepository.listarPorModulo(1L)).thenReturn(List.of(leccion1, leccion2, leccion3));

        IllegalStateException exception = assertThrows(
                IllegalStateException.class,
                () -> leccionService.reordenarLeccion(1L, "SUBIR")
        );

        assertEquals("No se puede subir la primera lección.", exception.getMessage());
        verify(leccionRepository, never()).intercambiarOrdenes(anyLong(), anyLong());
    }

    @Test
    @DisplayName("Debería lanzar IllegalStateException al intentar bajar la última lección")
    void reordenarLeccion_bajarUltima_lanzaExcepcion() {
        when(leccionRepository.findById(3L)).thenReturn(Optional.of(leccion3));
        when(leccionRepository.listarPorModulo(1L)).thenReturn(List.of(leccion1, leccion2, leccion3));

        IllegalStateException exception = assertThrows(
                IllegalStateException.class,
                () -> leccionService.reordenarLeccion(3L, "BAJAR")
        );

        assertEquals("No se puede bajar la última lección.", exception.getMessage());
        verify(leccionRepository, never()).intercambiarOrdenes(anyLong(), anyLong());
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si la dirección no es válida")
    void reordenarLeccion_direccionInvalida_lanzaExcepcion() {
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> leccionService.reordenarLeccion(2L, "IZQUIERDA")
        );

        assertEquals("La dirección debe ser 'SUBIR' o 'BAJAR'.", exception.getMessage());
        verify(leccionRepository, never()).findById(anyLong());
    }

    @Test
    @DisplayName("Debería reordenar por orden destino usando el patrón de swap")
    void reordenarLeccion_conNuevoOrden_intercambiaConDestino() {
        when(leccionRepository.findById(2L)).thenReturn(Optional.of(leccion2));
        when(leccionRepository.listarPorModulo(1L)).thenReturn(List.of(leccion1, leccion2, leccion3));

        leccionService.reordenarLeccion(2L, 1);

        verify(leccionRepository).intercambiarOrdenes(2L, 1L);
    }

    private Leccion crearLeccion(Long id, int orden) {
        Leccion leccion = new Leccion();
        leccion.setId(id);
        leccion.setModulo(modulo);
        leccion.setTitulo("Lección " + orden);
        leccion.setOrden(orden);
        leccion.setTieneContenido(false);
        return leccion;
    }

    private static Stream<String> titulosInvalidos() {
        return Stream.of(null, "", "   ", "ab", "a".repeat(101));
    }

    private static Stream<String> titulosLimiteValidos() {
        return Stream.of("abc", "a".repeat(100));
    }
}
