package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.models.Modulo;
import com.epn.redsaberesweb.repository.CursoRepository;
import com.epn.redsaberesweb.repository.ModuloRepository;

import java.util.List;

public class ModuloService {
    private final ModuloRepository moduloRepository;
    private final CursoRepository cursoRepository;

    public ModuloService(ModuloRepository moduloRepository, CursoRepository cursoRepository){
        this.moduloRepository = moduloRepository;
        this.cursoRepository = cursoRepository;
    }

    public void crearModulo(Modulo nuevoModulo) {
        // Validaciones
        validarDatosModulo(nuevoModulo);
        moduloRepository.save(nuevoModulo);

    }

    public List<Modulo> listarModulosPorCurso(Long id) {
        if(id == null){
            throw new  IllegalArgumentException("El ID del curso es obligatorio para listar módulos.");
        }
        return moduloRepository.listarPorCurso(id);
    }

    public void editarModulo(Modulo moduloActualizado) {
        if (moduloRepository.findById(moduloActualizado.getId()).isEmpty()){
            throw new IllegalArgumentException("El módulo a editar no existe.");
        }
        validarDatosModulo(moduloActualizado);
        moduloRepository.update(moduloActualizado);
    }

    public void eliminarModulo(Long moduloIdAEliminar) {
        if (moduloIdAEliminar == null){
            throw new IllegalArgumentException("El ID del módulo a eliminar es obligatorio.");
        }
        if (moduloRepository.findById(moduloIdAEliminar).isEmpty()){
            throw new IllegalArgumentException("El módulo a eliminar no existe.");
        }
        moduloRepository.delete(moduloIdAEliminar);
    }

    public void reordenarModulo(Long moduloId, int nuevoOrden) {
        if (moduloId == null)
            throw new IllegalArgumentException("El ID del módulo es obligatorio para reordenar.");
        if (nuevoOrden <= 0)
            throw new IllegalArgumentException("El nuevo orden debe ser un número positivo.");

        Modulo moduloActual = obtenerModulo(moduloId);
        List<Modulo> modulos = moduloRepository.listarPorCurso(moduloActual.getCurso().getId());

        // Buscar el módulo vecino al que hay que intercambiar
        int indiceActual = -1;
        for (int i = 0; i < modulos.size(); i++) {
            if (modulos.get(i).getId().equals(moduloId)) {
                indiceActual = i;
                break;
            }
        }
        if (indiceActual < 0)
            throw new IllegalStateException("El módulo no pertenece al curso.");

        int indiceDestino = nuevoOrden - 1;
        if (indiceDestino < 0 || indiceDestino >= modulos.size())
            throw new IllegalArgumentException("Posición de destino fuera de rango.");
        if (indiceActual == indiceDestino)
            return; // Ya está en su lugar

        Modulo moduloVecino = modulos.get(indiceDestino);
        moduloRepository.intercambiarOrdenes(moduloActual.getId(), moduloVecino.getId());
    }

    private void validarDatosModulo(Modulo nuevoModulo) {
        if (nuevoModulo.getCurso() == null || nuevoModulo.getCurso().getId() == null){
            throw new IllegalArgumentException("El curso asociado al módulo es obligatorio.");
        }
        if (cursoRepository.findById(nuevoModulo.getCurso().getId()).isEmpty()){
            throw new IllegalArgumentException("El curso asociado al módulo no existe.");
        }
        if (nuevoModulo.getTitulo() == null || nuevoModulo.getTitulo().trim().isEmpty()) {
            throw new IllegalArgumentException("El título del módulo es obligatorio.");
        }
        if (nuevoModulo.getTitulo().trim().length() < 3 || nuevoModulo.getTitulo().trim().length() > 100){
            throw new IllegalArgumentException("El título del módulo debe tener entre 3 y 100 caracteres.");
        }
    }

    public Modulo obtenerModulo(Long moduloId) {
        if (moduloId == null)
            throw new IllegalArgumentException("El ID del módulo es obligatorio.");
        return moduloRepository.findById(moduloId)
                .orElseThrow(() -> new IllegalArgumentException("El módulo con ID " + moduloId + " no existe."));
    }

}
