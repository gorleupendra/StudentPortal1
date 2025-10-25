package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/updateSubjectServlet")
public class UpdateSubjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = "";
        String status = "error";
        
        try {
            int subjectId = Integer.parseInt(request.getParameter("subject_id"));
            String subjectName = request.getParameter("subject_name");

            String sql = "UPDATE SUBJECTS SET SUBJECT_NAME = ? WHERE SUBJECT_ID = ?";
            
            try (Connection con = DbConnection.getConne();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, subjectName);
                ps.setInt(2, subjectId);
                
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    status = "success";
                    message = "Subject " + subjectId + " updated successfully.";
                } else {
                    message = "Failed to update subject. ID not found.";
                }
            }
        } catch (NumberFormatException e) {
            message = "Error: Invalid Subject ID.";
        } catch (SQLException e) {
            message = "Database Error: " + e.getMessage();
            e.printStackTrace();
        }
        
        response.sendRedirect("academicControl.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}