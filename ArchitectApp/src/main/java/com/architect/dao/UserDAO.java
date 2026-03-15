package com.architect.dao;

import com.architect.db.MySQLConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public boolean register(String username, String email, String passwordPlain) {
        String sql = "INSERT INTO users (username, email, password, created_at) VALUES (?, ?, ?, NOW())";
        String hashed = BCrypt.hashpw(passwordPlain, BCrypt.gensalt());

        try (Connection conn = MySQLConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, hashed);
            return stmt.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Integer login(String username, String passwordPlain) {
        String sql = "SELECT id, password FROM users WHERE username = ?";

        try (Connection conn = MySQLConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hashed = rs.getString("password");
                    if (BCrypt.checkpw(passwordPlain, hashed)) {
                        return rs.getInt("id");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Return null on failure
    }
}
