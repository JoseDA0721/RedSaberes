package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.domain.EstadoCurso;
import com.epn.redsaberesweb.domain.TipoLeccion;
import com.epn.redsaberesweb.dto.CursoEstructuraDTO;
import com.epn.redsaberesweb.dto.CursoEstructuraFilaDTO;
import com.epn.redsaberesweb.repository.CursoRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CursoServiceEstructuraTest {

    @Mock
    private CursoRepository cursoRepository;

    private CursoService cursoService;

    @BeforeEach
    void setUp() {
        cursoService = new CursoService(cursoRepository);
    }

    @Test
    void obtenerEstructuraCompleta_conIdNulo_lanzaExcepcion() {
        IllegalArgumentException excepcion = assertThrows(
                IllegalArgumentException.class,
                () -> cursoService.obtenerEstructuraCompleta(null)
        );

        assertEquals("El ID del curso es obligatorio.", excepcion.getMessage());
        verify(cursoRepository, never()).findEstructuraCompleta(null);
    }

    @Test
    void obtenerEstructuraCompleta_cursoNoExiste_retornaOptionalVacio() {
        when(cursoRepository.findEstructuraCompleta(99L)).thenReturn(List.of());

        Optional<CursoEstructuraDTO> resultado = cursoService.obtenerEstructuraCompleta(99L);

        assertTrue(resultado.isEmpty());
    }

    @Test
    void obtenerEstructuraCompleta_cursoSinModulos_retornaTotalesEnCero() {
        CursoEstructuraFilaDTO filaCurso = fila(null, null, null, null, null, null, null, null);
        when(cursoRepository.findEstructuraCompleta(1L)).thenReturn(List.of(filaCurso));

        CursoEstructuraDTO resultado = cursoService.obtenerEstructuraCompleta(1L).orElseThrow();

        assertTrue(resultado.modulos().isEmpty());
        assertEquals(0, resultado.totalModulos());
        assertEquals(0, resultado.totalLecciones());
    }

    @Test
    void obtenerEstructuraCompleta_armaJerarquiaTotalesEIndicadorDeContenido() {
        CursoEstructuraFilaDTO leccionUno = fila(10L, "Modulo inicial", 1,
                100L, "Introduccion", 1, TipoLeccion.TEXTO, true);
        CursoEstructuraFilaDTO leccionDos = fila(10L, "Modulo inicial", 1,
                101L, "Conceptos", 2, TipoLeccion.TEXTO, false);
        CursoEstructuraFilaDTO leccionTres = fila(20L, "Modulo avanzado", 2,
                200L, "Practica", 1, TipoLeccion.TEXTO, true);

        when(cursoRepository.findEstructuraCompleta(1L))
                .thenReturn(List.of(leccionUno, leccionDos, leccionTres));

        CursoEstructuraDTO resultado = cursoService.obtenerEstructuraCompleta(1L).orElseThrow();

        assertEquals(2, resultado.totalModulos());
        assertEquals(3, resultado.totalLecciones());
        assertEquals(List.of(10L, 20L),
                resultado.modulos().stream().map(modulo -> modulo.id()).toList());
        assertEquals(List.of(100L, 101L),
                resultado.modulos().get(0).lecciones().stream().map(leccion -> leccion.id()).toList());
        assertTrue(resultado.modulos().get(0).lecciones().get(0).tieneContenido());
        assertFalse(resultado.modulos().get(0).lecciones().get(1).tieneContenido());
    }

    private CursoEstructuraFilaDTO fila(
            Long moduloId,
            String moduloTitulo,
            Integer moduloOrden,
            Long leccionId,
            String leccionTitulo,
            Integer leccionOrden,
            TipoLeccion tipo,
            Boolean tieneContenido
    ) {
        return new CursoEstructuraFilaDTO(
                1L,
                "Java desde cero",
                "Curso de Java",
                "Programacion",
                EstadoCurso.BORRADOR,
                LocalDateTime.of(2026, 6, 29, 10, 0),
                "Ana",
                "Perez",
                7L,
                moduloId,
                moduloTitulo,
                moduloOrden,
                leccionId,
                leccionTitulo,
                leccionOrden,
                tipo,
                tieneContenido
        );
    }
}
