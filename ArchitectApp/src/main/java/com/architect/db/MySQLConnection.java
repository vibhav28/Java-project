package com.architect.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MySQLConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/archstudio_users?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    // Using the password you specified for the MySQL root user
    private static final String PASSWORD = "!V4i0b8h2";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
