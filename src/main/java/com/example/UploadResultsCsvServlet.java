package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/uploadResultsCsvServlet")
@MultipartConfig
public class UploadResultsCsvServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("resultsFile");
        InputStream fileContent = filePart.getInputStream();
        BufferedReader reader = new BufferedReader(new InputStreamReader(fileContent));
        
        Connection con = null;
        String message = "";
        String status = "error";

        try {
            con = DbConnection.getConne();
            con.setAutoCommit(false); // Start transaction

            String line;
            reader.readLine(); // Skip header row

            while ((line = reader.readLine()) != null) {
                String[] data = line.split(",");

                // 1. Insert into SEMESTER_RESULTS
                String sqlResult = "INSERT INTO SEMESTER_RESULTS (STUDENT_REGN_NO, SEMESTER_NUMBER, CGPA, REMARKS) VALUES (?, ?, ?, ?)";
                PreparedStatement psResult = con.prepareStatement(sqlResult, Statement.RETURN_GENERATED_KEYS);
                psResult.setString(1, data[0]); // STUDENT_REGN_NO
                psResult.setInt(2, Integer.parseInt(data[1])); // SEMESTER_NUMBER
                psResult.setFloat(3, Float.parseFloat(data[2])); // CGPA
                psResult.setString(4, data[3]); // REMARKS
                psResult.executeUpdate();

                ResultSet generatedKeys = psResult.getGeneratedKeys();
                int newResultId;
                if (generatedKeys.next()) {
                    newResultId = generatedKeys.getInt(1);
                } else {
                    throw new Exception("Failed to create semester result.");
                }
                psResult.close();

                // 2. Insert into STUDENT_GRADES
                String sqlGrades = "INSERT INTO STUDENT_GRADES (RESULT_ID, SUBJECT_ID, GRADE, GPA) VALUES (?, ?, ?, ?)";
                PreparedStatement psGrades = con.prepareStatement(sqlGrades);

                // Loop through the subject grade sets (each set has 3 columns)
                for (int i = 4; i < data.length; i += 3) {
                    psGrades.setInt(1, newResultId);
                    psGrades.setInt(2, Integer.parseInt(data[i])); // SUBJECT_ID
                    psGrades.setString(3, data[i + 1]); // GRADE
                    psGrades.setFloat(4, Float.parseFloat(data[i + 2])); // GPA
                    psGrades.addBatch();
                }
                psGrades.executeBatch();
                psGrades.close();
            }

            con.commit();
            status = "success";
            message = "Results CSV uploaded and processed successfully.";

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            message = "Error processing CSV: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (Exception e) {}
        }

        response.sendRedirect("academicControl.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}