package com.epn.redsaberesweb.service;

import jakarta.servlet.http.Part;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Pruebas unitarias para {@link AlmacenamientoService}.
 *
 * Estrategia:
 *  - Se usa un directorio temporal (JUnit @TempDir) como base de uploads,
 *    configurado vía la propiedad de sistema "redsaberes.uploads.dir" ANTES
 *    de instanciar el servicio (la propiedad se lee en el constructor).
 *  - Part (de jakarta.servlet.http) se mockea con Mockito ya que es una
 *    interfaz del contenedor de Servlets.
 *  - Cada prueba crea su propia instancia de AlmacenamientoService apuntando
 *    al mismo directorio temporal raíz, para mantener el aislamiento entre
 *    pruebas (subdirectorios separados por nombre de prueba cuando aplica).
 */
class AlmacenamientoServiceTest {

    @TempDir
    static Path tempDir;

    private static String originalProperty;

    private AlmacenamientoService service;

    @BeforeAll
    static void guardarPropiedadOriginal() {
        originalProperty = System.getProperty("redsaberes.uploads.dir");
    }

    @AfterAll
    static void restaurarPropiedadOriginal() {
        if (originalProperty != null) {
            System.setProperty("redsaberes.uploads.dir", originalProperty);
        } else {
            System.clearProperty("redsaberes.uploads.dir");
        }
    }

    @BeforeEach
    void setUp() {
        System.setProperty("redsaberes.uploads.dir", tempDir.toAbsolutePath().toString());
        service = new AlmacenamientoService();
    }

    @AfterEach
    void limpiar() throws IOException {
        // Limpieza recursiva del directorio temporal entre pruebas para evitar
        // interferencias (no se puede limpiar tempDir en sí porque JUnit lo gestiona).
        Path imagenesLecciones = tempDir.resolve("imagenes-lecciones");
        if (Files.exists(imagenesLecciones)) {
            try (var walk = Files.walk(imagenesLecciones)) {
                walk.sorted((a, b) -> b.compareTo(a)) // borrar hijos antes que padres
                        .forEach(p -> {
                            try {
                                Files.deleteIfExists(p);
                            } catch (IOException ignored) {
                                // best-effort en limpieza de prueba
                            }
                        });
            }
        }
    }

    // ─── guardarArchivo ─────────────────────────────────────────────────────

    @Test
    void guardarArchivo_debeGuardarElArchivoYRetornarRutaRelativaCorrecta() throws IOException {
        byte[] contenido = "contenido-de-prueba".getBytes(StandardCharsets.UTF_8);
        Part part = mockPart("imagen.png", contenido);
        Long leccionId = 42L;

        String rutaRelativa = service.guardarArchivo(part, leccionId);

        assertNotNull(rutaRelativa);
        assertTrue(rutaRelativa.startsWith("imagenes-lecciones/42/"));
        assertTrue(rutaRelativa.endsWith(".png"));

        Path archivoFisico = tempDir.resolve(rutaRelativa);
        assertTrue(Files.exists(archivoFisico), "El archivo físico debería existir en disco");
        assertArrayEquals(contenido, Files.readAllBytes(archivoFisico));
    }

    @Test
    void guardarArchivo_debeGenerarNombresUnicosParaLlamadasSucesivas() throws IOException {
        Part part1 = mockPart("foto.jpg", "a".getBytes(StandardCharsets.UTF_8));
        Part part2 = mockPart("foto.jpg", "b".getBytes(StandardCharsets.UTF_8));

        String ruta1 = service.guardarArchivo(part1, 1L);
        String ruta2 = service.guardarArchivo(part2, 1L);

        assertNotEquals(ruta1, ruta2, "Cada archivo guardado debe tener un nombre UUID distinto");
        assertTrue(Files.exists(tempDir.resolve(ruta1)));
        assertTrue(Files.exists(tempDir.resolve(ruta2)));
    }

    @Test
    void guardarArchivo_debeUsarExtensionBinCuandoNoHayPunto() throws IOException {
        Part part = mockPart("archivoSinExtension", "x".getBytes(StandardCharsets.UTF_8));

        String rutaRelativa = service.guardarArchivo(part, 7L);

        assertTrue(rutaRelativa.endsWith(".bin"));
    }

    @Test
    void guardarArchivo_debeUsarExtensionBinCuandoNombreEsNulo() throws IOException {
        Part part = mock(Part.class);
        when(part.getSubmittedFileName()).thenReturn(null);
        when(part.getInputStream()).thenReturn(new ByteArrayInputStream("z".getBytes(StandardCharsets.UTF_8)));

        String rutaRelativa = service.guardarArchivo(part, 7L);

        assertTrue(rutaRelativa.endsWith(".bin"));
    }

    @Test
    void guardarArchivo_debeNormalizarExtensionAMinusculas() throws IOException {
        Part part = mockPart("imagen.PNG", "x".getBytes(StandardCharsets.UTF_8));

        String rutaRelativa = service.guardarArchivo(part, 3L);

        assertTrue(rutaRelativa.endsWith(".png"), "La extensión debe normalizarse a minúsculas");
    }

    @Test
    void guardarArchivo_debeCrearSubdirectorioPorLeccionSiNoExiste() throws IOException {
        Path dirLeccion = tempDir.resolve("imagenes-lecciones").resolve("99");
        assertFalse(Files.exists(dirLeccion));

        Part part = mockPart("img.gif", "x".getBytes(StandardCharsets.UTF_8));
        service.guardarArchivo(part, 99L);

        assertTrue(Files.exists(dirLeccion), "El subdirectorio de la lección debe crearse automáticamente");
    }

    @Test
    void guardarArchivo_debePropagarIOExceptionSiFallaLaLecturaDelInputStream() throws IOException {
        Part part = mock(Part.class);
        when(part.getSubmittedFileName()).thenReturn("doc.pdf");
        when(part.getInputStream()).thenThrow(new IOException("fallo simulado de lectura"));

        assertThrows(IOException.class, () -> service.guardarArchivo(part, 5L));
    }

    // ─── eliminarArchivo ────────────────────────────────────────────────────

    @Test
    void eliminarArchivo_debeEliminarElArchivoFisicoExistente() throws IOException {
        Part part = mockPart("borrar.txt", "contenido".getBytes(StandardCharsets.UTF_8));
        String rutaRelativa = service.guardarArchivo(part, 10L);
        Path archivoFisico = tempDir.resolve(rutaRelativa);
        assertTrue(Files.exists(archivoFisico));

        service.eliminarArchivo(rutaRelativa);

        assertFalse(Files.exists(archivoFisico), "El archivo debería haberse eliminado del disco");
    }

    @Test
    void eliminarArchivo_noDebeLanzarExcepcionSiElArchivoNoExiste() {
        assertDoesNotThrow(() -> service.eliminarArchivo("imagenes-lecciones/999/no-existe.png"));
    }

    @Test
    void eliminarArchivo_noDebeLanzarExcepcionConRutaNula() {
        assertDoesNotThrow(() -> service.eliminarArchivo(null));
    }

    @Test
    void eliminarArchivo_noDebeLanzarExcepcionConRutaEnBlanco() {
        assertDoesNotThrow(() -> service.eliminarArchivo("   "));
    }

    // ─── eliminarArchivosDeRollback ─────────────────────────────────────────

    @Test
    void eliminarArchivosDeRollback_debeEliminarTodosLosArchivosDeLaLista() throws IOException {
        Part part1 = mockPart("a.txt", "a".getBytes(StandardCharsets.UTF_8));
        Part part2 = mockPart("b.txt", "b".getBytes(StandardCharsets.UTF_8));
        String ruta1 = service.guardarArchivo(part1, 20L);
        String ruta2 = service.guardarArchivo(part2, 20L);

        service.eliminarArchivosDeRollback(List.of(ruta1, ruta2));

        assertFalse(Files.exists(tempDir.resolve(ruta1)));
        assertFalse(Files.exists(tempDir.resolve(ruta2)));
    }

    @Test
    void eliminarArchivosDeRollback_debeManejarListaVaciaSinErrores() {
        assertDoesNotThrow(() -> service.eliminarArchivosDeRollback(List.of()));
    }

    @Test
    void eliminarArchivosDeRollback_debeContinuarSiAlgunaRutaEsInvalida() throws IOException {
        Part part = mockPart("valido.txt", "x".getBytes(StandardCharsets.UTF_8));
        String rutaValida = service.guardarArchivo(part, 30L);

        List<String> rutas = List.of(rutaValida, "imagenes-lecciones/30/inexistente.txt", "");

        assertDoesNotThrow(() -> service.eliminarArchivosDeRollback(rutas));
        assertFalse(Files.exists(tempDir.resolve(rutaValida)));
    }

    // ─── Utilidades de prueba ───────────────────────────────────────────────

    private Part mockPart(String nombreArchivo, byte[] contenido) throws IOException {
        Part part = mock(Part.class);
        when(part.getSubmittedFileName()).thenReturn(nombreArchivo);
        InputStream inputStream = new ByteArrayInputStream(contenido);
        when(part.getInputStream()).thenReturn(inputStream);
        return part;
    }
}