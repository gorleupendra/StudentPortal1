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

@WebServlet("/deleteStudent")
public class DeleteStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = "";
        String status = "error";
        String regdNo = request.getParameter("regdno");

        if (regdNo == null || regdNo.isEmpty()) {
            message = "Error: Registration number is missing.";
        } else {
            Connection con = null;
            try {
                con = DbConnection.getConne();
                // --- Start Transaction ---
                con.setAutoCommit(false);

                // Step 1: Delete all grades associated with the student's results
                // This deletes from the "grandchild" table first.
                String deleteGradesSql = "DELETE FROM student_grades WHERE result_id IN (SELECT result_id FROM semester_results WHERE student_regn_no = ?)";
                try (PreparedStatement psGrades = con.prepareStatement(deleteGradesSql)) {
                    psGrades.setString(1, regdNo);
                    psGrades.executeUpdate();
                }

                // Step 2: Delete all of the student's semester results
                // This deletes from the "child" table.
                String deleteResultsSql = "DELETE FROM semester_results WHERE student_regn_no = ?";
                try (PreparedStatement psResults = con.prepareStatement(deleteResultsSql)) {
                    psResults.setString(1, regdNo);
                    psResults.executeUpdate();
                }

                // Step 3: Finally, delete the student from the "parent" table
                String deleteStudentSql = "DELETE FROM students WHERE regd_no = ?";
                try (PreparedStatement psStudent = con.prepareStatement(deleteStudentSql)) {
                    psStudent.setString(1, regdNo);
                    int rowsAffected = psStudent.executeUpdate();

                    if (rowsAffected > 0) {
                        status = "success";
                        message = "Student with Registration No. " + regdNo + " and all associated data were deleted successfully.";
                    } else {
                        message = "Error: Could not find a student with Registration No. " + regdNo + ".";
                    }
                }
                
                // --- If all deletes succeed, commit the changes ---
                con.commit();

            } catch (SQLException e) {
                message = "Database error during deletion: " + e.getMessage();
                e.printStackTrace();
                // --- If any step fails, roll back all changes ---
                try {
                    if (con != null) {
                        con.rollback();
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            } finally {
                // --- Clean up the connection ---
                try {
                    if (con != null) {
                        con.setAutoCommit(true); // Return connection to its default state
                        con.close();
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        
        // Redirect back to the student management page with a message
        response.sendRedirect("studentManagement.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}