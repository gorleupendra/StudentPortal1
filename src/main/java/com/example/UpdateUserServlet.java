package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/updateUser")
public class UpdateUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String password = request.getParameter("password");

        String message = "";
        String status = "error";

        try (Connection con = DbConnection.getConne()) {
            int userId = Integer.parseInt(idParam);
            
            // Check if a new password was provided
            if (password != null && !password.isEmpty()) {
                // Update with new password
                String hashedPassword = HashPassword.hashPassword(password);
                String sql = "UPDATE users SET name = ?, email = ?, role = ?, password = ? WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, role);
                ps.setString(4, hashedPassword);
                ps.setInt(5, userId);
                ps.executeUpdate();
            } else {
                // Update without changing the password
                String sql = "UPDATE users SET name = ?, email = ?, role = ? WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, role);
                ps.setInt(4, userId);
                ps.executeUpdate();
            }

            status = "success";
            message = "User " + userId + " updated successfully.";

        } catch (Exception e) {
            message = "Error updating user: " + e.getMessage();
            e.printStackTrace();
        }

        response.sendRedirect("userManagement.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}