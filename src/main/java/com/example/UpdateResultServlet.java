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

@WebServlet("/updateResultServlet")
public class UpdateResultServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get main result details
        String resultIdStr = request.getParameter("result_id");
        String sgpaStr = request.getParameter("sgpa");
        String remarks = request.getParameter("remarks");

        // Get arrays of subject grade details
        String[] gradeIds = request.getParameterValues("grade_ids");
        String[] grades = request.getParameterValues("grades");
        String[] gpas = request.getParameterValues("gpas");

        String message = "";
        String status = "error";
        Connection con = null;

        try {
            int resultId = Integer.parseInt(resultIdStr);
            con = DbConnection.getConne();
            con.setAutoCommit(false); // Start transaction

            // 1. Update the main SEMESTER_RESULTS table
            String sqlResult = "UPDATE SEMESTER_RESULTS SET SGPA = ?, REMARKS = ? WHERE RESULT_ID = ?";
            try (PreparedStatement psResult = con.prepareStatement(sqlResult)) {
                psResult.setFloat(1, Float.parseFloat(sgpaStr));
                psResult.setString(2, remarks);
                psResult.setInt(3, resultId);
                psResult.executeUpdate();
            }

            // 2. Update the individual STUDENT_GRADES records in a batch
            String sqlGrades = "UPDATE STUDENT_GRADES SET GRADE = ?, GPA = ? WHERE GRADE_ID = ?";
            try (PreparedStatement psGrades = con.prepareStatement(sqlGrades)) {
                for (int i = 0; i < gradeIds.length; i++) {
                    psGrades.setString(1, grades[i]);
                    psGrades.setFloat(2, Float.parseFloat(gpas[i]));
                    psGrades.setInt(3, Integer.parseInt(gradeIds[i]));
                    psGrades.addBatch();
                }
                psGrades.executeBatch();
            }

            con.commit(); // Commit transaction if all is successful
            status = "success";
            message = "Result ID " + resultId + " was updated successfully.";

        } catch (Exception e) {
            message = "Error updating result: " + e.getMessage();
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) {}
        } finally {
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (SQLException ex) {}
        }

        // Redirect back to the details page to show the changes
        response.sendRedirect("viewResultDetails.jsp?result_id=" + resultIdStr + "&status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}