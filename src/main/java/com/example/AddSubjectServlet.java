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

@WebServlet("/addSubjectServlet")
public class AddSubjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String message = "";
        String status = "error";
        
        try {
            int subjectId = Integer.parseInt(request.getParameter("subject_id"));
            String subjectName = request.getParameter("subject_name");

            String sql = "INSERT INTO SUBJECTS (SUBJECT_ID, SUBJECT_NAME) VALUES (?, ?)";
            
            try (Connection con = DbConnection.getConne();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                
                ps.setInt(1, subjectId);
                ps.setString(2, subjectName);
                
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    status = "success";
                    message = "Subject '" + subjectName + "' added successfully.";
                } else {
                    message = "Failed to add subject.";
                }
            }
        } catch (NumberFormatException e) {
            message = "Error: Subject ID must be a number.";
        } catch (SQLException e) {
            if (e.getErrorCode() == 1) { // Unique constraint violation
                message = "Error: A subject with this ID already exists.";
            } else {
                message = "Database Error: " + e.getMessage();
            }
            e.printStackTrace();
        } catch (Exception e) {
            message = "An unexpected error occurred.";
            e.printStackTrace();
        }
        
        response.sendRedirect("academicControl.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}