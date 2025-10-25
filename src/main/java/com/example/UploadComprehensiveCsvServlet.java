package com.example;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/uploadComprehensiveCsvServlet")
@MultipartConfig
public class UploadComprehensiveCsvServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // A helper class to store data from each CSV row
    private static class CsvRow {
        String studentRegnNo;
        int semesterNumber;
        float sgpa;
        String remarks;
        int subjectId;
        String subjectName;
        String grade;
        float gpa;
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("resultsFile");
        String message = "";
        String status = "error";
        Connection con = null;

        try {
            con = DbConnection.getConne();
            con.setAutoCommit(false); // Start transaction

            List<CsvRow> allRows = new ArrayList<>();
            Map<Integer, String> uniqueSubjects = new HashMap<>();
            Map<String, CsvRow> uniqueSemesterResults = new HashMap<>();

            // --- STEP 1: Read the CSV file ONCE and store data in memory ---
            try (Reader reader = new InputStreamReader(filePart.getInputStream());
                 CSVReader csvReader = new CSVReader(reader)) {
                
                csvReader.skip(1); // Skip header
                String[] line;
                while ((line = csvReader.readNext()) != null) {
                    CsvRow row = new CsvRow();
                    row.studentRegnNo = line[0];
                    row.semesterNumber = Integer.parseInt(line[1]);
                    row.sgpa = Float.parseFloat(line[2]);
                    row.remarks = line[3];
                    row.subjectId = Integer.parseInt(line[4]);
                    row.subjectName = line[5];
                    row.grade = line[6];
                    row.gpa = Float.parseFloat(line[7]);
                    allRows.add(row);

                    // Collect unique subjects and semester results to avoid redundant operations
                    uniqueSubjects.put(row.subjectId, row.subjectName);
                    String resultKey = row.studentRegnNo + ":" + row.semesterNumber;
                    uniqueSemesterResults.put(resultKey, row);
                }
            }

            // --- STEP 2: Upsert all unique SUBJECTS in a batch ---
            // FIX: Replaced Oracle's MERGE with PostgreSQL's INSERT ... ON CONFLICT
            String upsertSubjectSQL = "INSERT INTO SUBJECTS (SUBJECT_ID, SUBJECT_NAME) VALUES (?, ?) ON CONFLICT (SUBJECT_ID) DO UPDATE SET SUBJECT_NAME = EXCLUDED.SUBJECT_NAME";
            try (PreparedStatement ps = con.prepareStatement(upsertSubjectSQL)) {
                for (Map.Entry<Integer, String> entry : uniqueSubjects.entrySet()) {
                    ps.setInt(1, entry.getKey());
                    ps.setString(2, entry.getValue());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // --- STEP 3: Upsert all unique SEMESTER_RESULTS in a batch ---
            // FIX: Replaced Oracle's MERGE with PostgreSQL's INSERT ... ON CONFLICT
            String upsertResultSQL = "INSERT INTO SEMESTER_RESULTS (STUDENT_REGN_NO, SEMESTER_NUMBER, SGPA, REMARKS) VALUES (?, ?, ?, ?) ON CONFLICT (STUDENT_REGN_NO, SEMESTER_NUMBER) DO UPDATE SET SGPA = EXCLUDED.SGPA, REMARKS = EXCLUDED.REMARKS";
            try (PreparedStatement ps = con.prepareStatement(upsertResultSQL)) {
                for (CsvRow row : uniqueSemesterResults.values()) {
                    ps.setString(1, row.studentRegnNo);
                    ps.setInt(2, row.semesterNumber);
                    ps.setFloat(3, row.sgpa);
                    ps.setString(4, row.remarks);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // --- STEP 4: Insert all STUDENT_GRADES in a batch ---
            String findResultIdSQL = "SELECT RESULT_ID FROM SEMESTER_RESULTS WHERE STUDENT_REGN_NO = ? AND SEMESTER_NUMBER = ?";
            String insertGradeSQL = "INSERT INTO STUDENT_GRADES (RESULT_ID, SUBJECT_ID, GRADE, GPA) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psFind = con.prepareStatement(findResultIdSQL);
                 PreparedStatement psInsert = con.prepareStatement(insertGradeSQL)) {
                
                // OPTIMIZATION: Loop through the 'allRows' list in memory instead of reading the file again
                for (CsvRow row : allRows) {
                    psFind.setString(1, row.studentRegnNo);
                    psFind.setInt(2, row.semesterNumber);
                    try (ResultSet rs = psFind.executeQuery()) {
                        if (rs.next()) {
                            int resultId = rs.getInt("RESULT_ID");
                            psInsert.setInt(1, resultId);
                            psInsert.setInt(2, row.subjectId);
                            psInsert.setString(3, row.grade);
                            psInsert.setFloat(4, row.gpa);
                            psInsert.addBatch();
                        }
                    }
                }
                psInsert.executeBatch();
            }

            con.commit(); // Commit the entire transaction
            status = "success";
            message = "Comprehensive results for " + allRows.size() + " grade entries processed successfully.";

        } catch (IOException | CsvValidationException e) {
            message = "Error reading CSV file: " + e.getMessage();
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) {}
        } catch (Exception e) {
            message = "Database error during processing: " + e.getMessage();
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) {}
        } finally {
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (SQLException e) {}
        }

        response.sendRedirect("academicControl.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}