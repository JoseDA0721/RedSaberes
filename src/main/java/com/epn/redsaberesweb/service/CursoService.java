package com.epn.redsaberesweb.service;

import com.epn.redsaberesweb.models.Curso;
import com.epn.redsaberesweb.repository.CursoRepository;
import com.epn.redsaberesweb.dto.CourseDetailDTO;

import java.util.List;

public class CursoService {
    private final CursoRepository cursoRepository;

    public CursoService(CursoRepository cursoRepository) {
        this.cursoRepository = cursoRepository;
    }

    public Curso crearCurso(Curso curso) {
        // Validaciones
        if (curso.getTitulo() == null || curso.getTitulo().trim().isEmpty()) {
            throw new IllegalArgumentException("El título del curso es obligatorio.");
        }
        // Validación: Longitud mínima del título
        if (curso.getTitulo().trim().length() < 5) {
            throw new IllegalArgumentException("El título del curso debe tener al menos 5 caracteres.");
        }
        if (curso.getDescripcion() == null || curso.getDescripcion().trim().isEmpty()) {
            throw new IllegalArgumentException("La descripción del curso es obligatoria.");
        }
        if (curso.getCategoria() == null || curso.getCategoria().trim().isEmpty()) {
            throw new IllegalArgumentException("La categoría del curso es obligatoria.");
        }
        // Asumiendo que el creador no puede ser nulo por la relación JPA
        if (curso.getCreador() == null || curso.getCreador().getId() == null) {
            throw new IllegalArgumentException("El creador del curso es obligatorio.");
        }

        cursoRepository.save(curso);
        return curso;
    }

    public CourseDetailDTO obtenerCurso(Long id) {
        return cursoRepository.findById(id);
    }

    public List<Curso> listarCursosPorCreador(Long creadorId) {
        if (creadorId == null) {
            throw new IllegalArgumentException("El ID del creador es obligatorio para listar cursos.");
        }
        return cursoRepository.findByCreator(creadorId);
    }
}