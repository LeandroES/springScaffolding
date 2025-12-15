package com.ulasalle.iw.springscaffolding_grupob.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Service
public class DatabaseService {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<String> listarTablas() throws SQLException {
        List<String> tablas = new ArrayList<>();
        try (Connection conn = dataSource.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tables = metaData.getTables(conn.getCatalog(), null, "%", new String[]{"TABLE"});
            while (tables.next()) {
                tablas.add(tables.getString("TABLE_NAME"));
            }
        }
        return tablas;
    }

    public List<Map<String, Object>> listarColumnas(String tabla) throws SQLException {
        List<Map<String, Object>> columnas = new ArrayList<>();
        try (Connection conn = dataSource.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet columns = metaData.getColumns(conn.getCatalog(), null, tabla, null);
            while (columns.next()) {
                Map<String, Object> columna = new HashMap<>();
                columna.put("nombre", columns.getString("COLUMN_NAME"));
                columna.put("tipo", columns.getString("TYPE_NAME"));
                columnas.add(columna);
            }
        }
        return columnas;
    }

    public List<Map<String, Object>> listarDatos(String tabla) {
        return jdbcTemplate.queryForList("SELECT * FROM " + tabla);
    }

    public void insertar(String tabla, Map<String, Object> datos) {
        String columnas = String.join(", ", datos.keySet());
        String valores = String.join(", ", Collections.nCopies(datos.size(), "?"));
        String sql = "INSERT INTO " + tabla + " (" + columnas + ") VALUES (" + valores + ")";
        jdbcTemplate.update(sql, datos.values().toArray());
    }

    public void actualizar(String tabla, String idColumna, Object idValor, Map<String, Object> datos) {
        String sets = String.join(", ", datos.keySet().stream().map(k -> k + " = ?").toList());
        String sql = "UPDATE " + tabla + " SET " + sets + " WHERE " + idColumna + " = ?";
        List<Object> valores = new ArrayList<>(datos.values());
        valores.add(idValor);
        jdbcTemplate.update(sql, valores.toArray());
    }

    public void eliminar(String tabla, String idColumna, Object idValor) {
        String sql = "DELETE FROM " + tabla + " WHERE " + idColumna + " = ?";
        jdbcTemplate.update(sql, idValor);
    }
}
