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

@WebServlet("/deleteSubjectServlet")
public class DeleteSubjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String message = "";
        String status = "error";
        Connection con = null;
        
        try {
            int subjectId = Integer.parseInt(request.getParameter("id"));
            
            con = DbConnection.getConne();
            // --- Start Transaction ---
            con.setAutoCommit(false);

            // 1. Delete all records from the child table (STUDENT_GRADES) first
            String deleteGradesSql = "DELETE FROM STUDENT_GRADES WHERE SUBJECT_ID = ?";
            try (PreparedStatement psGrades = con.prepareStatement(deleteGradesSql)) {
                psGrades.setInt(1, subjectId);
                psGrades.executeUpdate(); // It's okay if this affects 0 rows
            }

            // 2. Delete the record from the parent table (SUBJECTS)
            String deleteSubjectSql = "DELETE FROM SUBJECTS WHERE SUBJECT_ID = ?";
            try (PreparedStatement psSubject = con.prepareStatement(deleteSubjectSql)) {
                psSubject.setInt(1, subjectId);
                int rowsAffected = psSubject.executeUpdate();
                
                if (rowsAffected > 0) {
                    status = "success";
                    message = "Subject with ID " + subjectId + " and all its associated grades were deleted.";
                } else {
                    message = "Could not find subject with ID " + subjectId + ".";
                }
            }
            
            // --- If both operations succeed, commit the transaction ---
            con.commit();

        } catch (NumberFormatException e) {
            message = "Error: Invalid Subject ID.";
            e.printStackTrace();
        } catch (SQLException e) {
            message = "Database Error: " + e.getMessage();
            e.printStackTrace();
            // --- If an error occurs, roll back all changes ---
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            // --- Clean up resources ---
            try {
                if (con != null) {
                    con.setAutoCommit(true); // Return connection to default state
                    con.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        
        response.sendRedirect("academicControl.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}