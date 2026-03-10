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

@WebServlet("/deleteResultServlet")
public class DeleteResultServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String resultIdStr = request.getParameter("result_id");
        String message = "";
        String status = "error";
        Connection con = null;
        
        try {
            int resultId = Integer.parseInt(resultIdStr);
            
            con = DbConnection.getConne();
            con.setAutoCommit(false); // Start transaction

            // 1. Delete all records from the child table (STUDENT_GRADES)
            String deleteGradesSql = "DELETE FROM STUDENT_GRADES WHERE RESULT_ID = ?";
            try (PreparedStatement psGrades = con.prepareStatement(deleteGradesSql)) {
                psGrades.setInt(1, resultId);
                psGrades.executeUpdate();
            }

            // 2. Delete the record from the parent table (SEMESTER_RESULTS)
            String deleteResultSql = "DELETE FROM SEMESTER_RESULTS WHERE RESULT_ID = ?";
            try (PreparedStatement psResult = con.prepareStatement(deleteResultSql)) {
                psResult.setInt(1, resultId);
                int rowsAffected = psResult.executeUpdate();
                
                if (rowsAffected > 0) {
                    status = "success";
                    message = "Result with ID " + resultId + " and all its grades were deleted.";
                } else {
                    message = "Could not find a result with ID " + resultId + ".";
                }
            }
            
            con.commit(); // Commit the transaction

        } catch (Exception e) {
            message = "Error during deletion: " + e.getMessage();
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) {}
        } finally {
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (SQLException ex) {}
        }
        
        // Redirect back to the main academic control page
        response.sendRedirect("academicControl.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}