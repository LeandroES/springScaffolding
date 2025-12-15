package com.ulasalle.iw.springscaffolding_grupob.controller;

import com.ulasalle.iw.springscaffolding_grupob.service.DatabaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class DatabaseController {

    @Autowired
    private DatabaseService databaseService;

    @GetMapping("/tablas")
    public List<String> listarTablas() throws SQLException {
        return databaseService.listarTablas();
    }

    @GetMapping("/tablas/{tabla}/columnas")
    public List<Map<String, Object>> listarColumnas(@PathVariable String tabla) throws SQLException {
        return databaseService.listarColumnas(tabla);
    }

    @GetMapping("/tablas/{tabla}")
    public List<Map<String, Object>> listarDatos(@PathVariable String tabla) {
        return databaseService.listarDatos(tabla);
    }

    @PostMapping("/tablas/{tabla}")
    public void insertar(@PathVariable String tabla, @RequestBody Map<String, Object> datos) {
        databaseService.insertar(tabla, datos);
    }

    @PutMapping("/tablas/{tabla}/{idColumna}/{id}")
    public void actualizar(@PathVariable String tabla, @PathVariable String idColumna, @PathVariable Object id, @RequestBody Map<String, Object> datos) {
        databaseService.actualizar(tabla, idColumna, id, datos);
    }

    @DeleteMapping("/tablas/{tabla}/{idColumna}/{id}")
    public void eliminar(@PathVariable String tabla, @PathVariable String idColumna, @PathVariable Object id) {
        databaseService.eliminar(tabla, idColumna, id);
    }
}