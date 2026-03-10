package com.example;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/addUserServlet")
public class AddUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // 1. Get user details from the form, including the new ID
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String password = request.getParameter("password");

        String message = "";
        String status = "error";

        if (idParam == null || name == null || email == null || role == null || password == null || 
            idParam.isEmpty() || name.isEmpty() || email.isEmpty() || role.isEmpty() || password.isEmpty()) {
            
            message = "All fields are required.";
        } else {
            Connection con = null;
            PreparedStatement ps = null;
            try {
                int userId = Integer.parseInt(idParam);
                String hashedPassword = HashPassword.hashPassword(password);

                con = DbConnection.getConne();
                // Updated SQL to include the ID
                String sql = "INSERT INTO users (id, name, email, role, password) VALUES (?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                
                ps.setInt(1, userId);
                ps.setString(2, name);
                ps.setString(3, email);
                ps.setString(4, role);
                ps.setString(5, hashedPassword);
                
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    status = "success";
                    message = "User '" + name + "' was added successfully.";
                } else {
                    message = "Failed to add the new user.";
                }
            } catch (NumberFormatException e) {
                message = "Error: User ID must be a number.";
            } catch (SQLException e) {
                if (e.getErrorCode() == 1) { // ORA-00001: unique constraint violated
                    message = "Error: A user with this ID or email already exists.";
                } else {
                    message = "Database error: " + e.getMessage();
                }
                e.printStackTrace();
            } catch (Exception e) {
                message = "An unexpected error occurred: " + e.getMessage();
                e.printStackTrace();
            } finally {
                try { if (ps != null) ps.close(); } catch (SQLException e) {}
                try { if (con != null) con.close(); } catch (SQLException e) {}
            }
        }
        
        response.sendRedirect("userManagement.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}