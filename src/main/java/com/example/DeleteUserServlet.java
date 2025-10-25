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

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String message = "";
        String status = "error";

        // 1. Get the user ID from the URL parameter
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            message = "Error: User ID is missing.";
        } else {
            Connection con = null;
            PreparedStatement ps = null;
            try {
                int userId = Integer.parseInt(idParam);
                
                // 2. Connect to the database and prepare the DELETE statement
                con = DbConnection.getConne();
                String sql = "DELETE FROM users WHERE id = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                
                // 3. Execute the deletion
                int rowsAffected = ps.executeUpdate();
                
                // 4. Check if the deletion was successful
                if (rowsAffected > 0) {
                    status = "success";
                    message = "User with ID " + userId + " was deleted successfully.";
                } else {
                    message = "Error: Could not find a user with ID " + userId + ".";
                }
            } catch (NumberFormatException e) {
                message = "Error: Invalid user ID format.";
                e.printStackTrace();
            } catch (SQLException e) {
                message = "Database error: " + e.getMessage();
                e.printStackTrace();
            } catch (Exception e) {
                message = "An unexpected error occurred: " + e.getMessage();
                e.printStackTrace();
            } finally {
                // 5. Clean up database resources
                try { if (ps != null) ps.close(); } catch (SQLException e) {}
                try { if (con != null) con.close(); } catch (SQLException e) {}
            }
        }
        
        // 6. Redirect back to the user management page with a status message
        response.sendRedirect("userManagement.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}