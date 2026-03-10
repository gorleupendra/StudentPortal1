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

@WebServlet("/deleteRecord")
public class DeleteRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String message = "";
        String status = "error";

        // 1. Get the record ID from the URL parameter
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            message = "Error: Record ID is missing.";
        } else {
            Connection con = null;
            PreparedStatement ps = null;
            try {
                int recordId = Integer.parseInt(idParam);
                
                // 2. Connect to the database and prepare the DELETE statement
                con = DbConnection.getConne();
                String sql = "DELETE FROM student_records WHERE id = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, recordId);
                
                // 3. Execute the deletion
                int rowsAffected = ps.executeUpdate();
                
                // 4. Check if the deletion was successful
                if (rowsAffected > 0) {
                    status = "success";
                    message = "Record with ID " + recordId + " was deleted successfully.";
                } else {
                    message = "Error: Could not find a record with ID " + recordId + ". No rows were deleted.";
                }
            } catch (NumberFormatException e) {
                message = "Error: Invalid record ID format.";
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
        
        // 6. Redirect back to the records management page with a status message
        response.sendRedirect("recordsManagement.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}