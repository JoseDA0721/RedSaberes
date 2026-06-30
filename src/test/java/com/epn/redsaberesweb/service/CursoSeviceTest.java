package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.domain.EstadoCurso;
import com.epn.redsaberesweb.dto.*;
import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.models.Usuario;
import com.epn.redsaberesweb.repository.CursoRepository;
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

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Stream;
import java.util.Optional; // Importar Optional

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests para CursoService")
class CursoSeviceTest {

    @Mock
    private CursoRepository cursoRepository;

    @InjectMocks
    private CursoService cursoService;

    private Usuario creador;

    @BeforeEach
    void setUp() {
        creador = new Usuario();
        creador.setId(1L);
        creador.setNombres("Juan");
        creador.setApellidos("Perez");
        creador.setCorreo("juan.perez@example.com");
        creador.setPasswordHash("hashedpassword");
        creador.setFechaRegistro(LocalDateTime.now());
        creador.setEstado(true);
    }

    @Test
    @DisplayName("Debería crear un curso con datos válidos")
    void crearCurso_conDatosValidos_guardaYRetornaCurso() {
        Curso cursoInput = new Curso(creador, EstadoCurso.BORRADOR, LocalDateTime.now(),
                "Programación", "Descripción del curso", "Título del Curso", null);
        cursoInput.setCreador(creador);

        // Corrección aquí: Usar doAnswer para métodos void
        doAnswer(invocation -> {
            Curso cursoArg = invocation.getArgument(0); // Captura el objeto Curso que se pasa a save
            cursoArg.setId(1L); // Asigna un ID simulado, como lo haría Hibernate
            return null; // Importante: para métodos void, el doAnswer debe retornar null
        }).when(cursoRepository).save(any(Curso.class));


        Curso resultado = cursoService.crearCurso(cursoInput);

        // Las aserciones ahora verifican el estado del objeto cursoInput después de la llamada
        assertNotNull(resultado.getId()); // Verificar que el ID fue asignado por el mock
        assertEquals(1L, resultado.getId());
        assertEquals("Título del Curso", resultado.getTitulo());
        assertEquals("Programación", resultado.getCategoria());
        assertEquals(creador, resultado.getCreador());
        verify(cursoRepository, times(1)).save(resultado);
    }

    @ParameterizedTest
    @MethodSource("provideInvalidCursoData")
    @DisplayName("Debería lanzar IllegalArgumentException si faltan campos obligatorios al crear curso")
    void crearCurso_conCamposObligatoriosFaltantes_lanzaExcepcion(
            String titulo, String descripcion, String categoria, String expectedMessage) {

        Curso curso = new Curso(creador, EstadoCurso.BORRADOR, LocalDateTime.now(),
                categoria, descripcion, titulo, null);
        curso.setCreador(creador);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> cursoService.crearCurso(curso)
        );

        assertEquals(expectedMessage, exception.getMessage());
        verify(cursoRepository, never()).save(any(Curso.class));
    }

    private static Stream<Arguments> provideInvalidCursoData() {
        return Stream.of(
                Arguments.of(null, "Descripción", "Categoría", "El título del curso es obligatorio."),
                Arguments.of("", "Descripción", "Categoría", "El título del curso es obligatorio."),
                Arguments.of("   ", "Descripción", "Categoría", "El título del curso es obligatorio."),
                Arguments.of("Título", null, "Categoría", "La descripción del curso es obligatoria."),
                Arguments.of("Título", "", "Categoría", "La descripción del curso es obligatoria."),
                Arguments.of("Título", "   ", "Categoría", "La descripción del curso es obligatoria."),
                Arguments.of("Título", "Descripción", null, "La categoría del curso es obligatoria."),
                Arguments.of("Título", "Descripción", "", "La categoría del curso es obligatoria."),
                Arguments.of("Título", "Descripción", "   ", "La categoría del curso es obligatoria."),
                Arguments.of("T", "Descripción", "Categoría", "El título del curso debe tener al menos 5 caracteres.")
        );
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el creador es nulo al crear curso")
    void crearCurso_sinCreador_lanzaExcepcion() {
        Curso curso = new Curso(null, EstadoCurso.BORRADOR, LocalDateTime.now(),
                "Programación", "Descripción del curso", "Título del Curso", null);
        curso.setCreador(null);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> cursoService.crearCurso(curso)
        );

        assertEquals("El creador del curso es obligatorio.", exception.getMessage());
        verify(cursoRepository, never()).save(any(Curso.class));
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el ID del creador es nulo al crear curso")
    void crearCurso_conCreadorIdNulo_lanzaExcepcion() {
        Usuario creadorSinId = new Usuario();
        creadorSinId.setNombres("Test");
        creadorSinId.setApellidos("User");
        creadorSinId.setCorreo("test@example.com");
        creadorSinId.setPasswordHash("pass");
        creadorSinId.setFechaRegistro(LocalDateTime.now());
        creadorSinId.setEstado(true);

        Curso curso = new Curso(creadorSinId, EstadoCurso.BORRADOR, LocalDateTime.now(),
                "Programación", "Descripción del curso", "Título del Curso", null);
        curso.setCreador(creadorSinId);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> cursoService.crearCurso(curso)
        );

        assertEquals("El creador del curso es obligatorio.", exception.getMessage());
        verify(cursoRepository, never()).save(any(Curso.class));
    }


    @Test
    @DisplayName("Debería retornar un Optional con Curso si existe el curso") // Nombre actualizado
    void obtenerCurso_existente_retornaOptionalCurso() {
        Long cursoId = 1L;

        // Crear un objeto Curso para ser retornado por el mock del repositorio
        Curso cursoEsperado = new Curso(creador, EstadoCurso.PUBLICADO, LocalDateTime.now(),
                "Matemáticas", "Curso de matemáticas", "Álgebra", cursoId);
        cursoEsperado.setCreador(creador); // Asegurarse de que el creador esté configurado si es necesario para las aserciones


        when(cursoRepository.findById(cursoId)).thenReturn(Optional.of(cursoEsperado));

        Optional<Curso> resultadoOpt = cursoService.obtenerCurso(cursoId);

        assertTrue(resultadoOpt.isPresent());
        Curso resultado = resultadoOpt.get();

        assertNotNull(resultado);
        assertEquals(cursoId, resultado.getId());
        assertEquals("Álgebra", resultado.getTitulo());
        assertEquals("Matemáticas", resultado.getCategoria());
        assertNotNull(resultado.getCreador());
        assertEquals(creador.getId(), resultado.getCreador().getId());
        assertEquals(creador.getNombres(), resultado.getCreador().getNombres());
        verify(cursoRepository, times(1)).findById(cursoId);
    }

    @Test
    @DisplayName("Debería retornar null si el curso no existe")
    void obtenerCurso_noExistente_retornaNull() {
        Long cursoId = 99L;
        when(cursoRepository.findById(cursoId)).thenReturn(null);

        Optional<Curso> resultado = cursoService.obtenerCurso(cursoId);

        assertNull(resultado);
        verify(cursoRepository, times(1)).findById(cursoId);
    }

    @Test
    @DisplayName("Debería retornar una lista de cursos para un creador existente")
    void listarCursosPorCreador_conCursos_retornaLista() {
        Long creadorId = creador.getId();
        Curso curso1 = new Curso(creador, EstadoCurso.PUBLICADO, LocalDateTime.now(),
                "Programación", "Curso de Java", "Java Básico", 1L);
        Curso curso2 = new Curso(creador, EstadoCurso.BORRADOR, LocalDateTime.now(),
                "Diseño", "Curso de UI/UX", "Figma para Principiantes", 2L);
        List<Curso> cursosEsperados = Arrays.asList(curso1, curso2);

        when(cursoRepository.findByCreator(creadorId)).thenReturn(cursosEsperados);

        List<Curso> resultado = cursoService.listarCursosPorCreador(creadorId);

        assertNotNull(resultado);
        assertFalse(resultado.isEmpty());
        assertEquals(2, resultado.size());
        assertEquals("Java Básico", resultado.get(0).getTitulo());
        verify(cursoRepository, times(1)).findByCreator(creadorId);
    }

    @Test
    @DisplayName("Debería retornar una lista vacía si el creador no tiene cursos")
    void listarCursosPorCreador_sinCursos_retornaListaVacia() {
        Long creadorId = creador.getId();
        when(cursoRepository.findByCreator(creadorId)).thenReturn(Collections.emptyList());

        List<Curso> resultado = cursoService.listarCursosPorCreador(creadorId);

        assertNotNull(resultado);
        assertTrue(resultado.isEmpty());
        verify(cursoRepository, times(1)).findByCreator(creadorId);
    }

    @Test
    @DisplayName("Debería lanzar IllegalArgumentException si el ID del creador es nulo")
    void listarCursosPorCreador_conCreadorIdNulo_lanzaExcepcion() {
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> cursoService.listarCursosPorCreador(null)
        );

        assertEquals("El ID del creador es obligatorio para listar cursos.", exception.getMessage());
        verify(cursoRepository, never()).findByCreator(anyLong());
    }
}