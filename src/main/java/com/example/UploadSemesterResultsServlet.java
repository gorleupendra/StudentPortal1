package com.example; // Make sure this matches your package structure

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
import java.sql.*; // Use specific imports
import java.util.HashMap;
import java.util.Map;

@WebServlet("/uploadSemesterResultsServlet") // Matches the form action in JSP
@MultipartConfig
public class UploadSemesterResultsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Helper class for semester result data
    private static class SemesterResultData {
        String studentRegnNo;
        int semesterNumber;
        float sgpa;
        String remarks;
        float cgpa; // Added CGPA
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("semesterResultsFile"); // Matches the input name in JSP
        String message = "";
        String status = "error";
        Connection con = null;

        try {
            con = DbConnection.getConne();
            if (con == null) {
                throw new SQLException("Failed to establish database connection.");
            }
            con.setAutoCommit(false); // Start transaction

            Map<String, SemesterResultData> uniqueResults = new HashMap<>();

            // --- Read the Semester Results CSV ---
            try (Reader reader = new InputStreamReader(filePart.getInputStream());
                 CSVReader csvReader = new CSVReader(reader)) {

                csvReader.skip(1); // Skip header
                String[] line;
                while ((line = csvReader.readNext()) != null) {
                    // Expecting 5 columns now
                    if (line.length < 5) {
                        System.err.println("Skipping malformed row (Semester Results): Not enough columns. Expected 5, found " + line.length);
                        continue;
                    }
                    try {
                        SemesterResultData data = new SemesterResultData();
                        data.studentRegnNo = line[0].trim();
                        data.semesterNumber = Integer.parseInt(line[1].trim());
                        data.sgpa = Float.parseFloat(line[2].trim());
                        data.remarks = line[3].trim();
                        data.cgpa = Float.parseFloat(line[4].trim()); // Parse CGPA

                        String resultKey = data.studentRegnNo + ":" + data.semesterNumber;
                        uniqueResults.put(resultKey, data); // Store latest data per key
                    } catch (NumberFormatException e) {
                        System.err.println("Skipping malformed row (Semester Results): Error parsing number - " + e.getMessage());
                    } catch (ArrayIndexOutOfBoundsException e) {
                        System.err.println("Skipping malformed row (Semester Results): Index out of bounds - " + e.getMessage());
                    }
                }
            }
            if (uniqueResults.isEmpty()) {
                throw new Exception("Semester Results CSV file is empty or contains no valid data rows.");
            }

            // --- Reset Sequence for SEMESTER_RESULTS ---
            String sequenceName = "semester_results_result_id_seq"; // <<< VERIFY THIS NAME
            long maxResultId = 0;
            String findMaxIdSQL = "SELECT MAX(result_id) FROM semester_results";
            // Use coalesce for empty table
            String setSequenceSQL = "SELECT setval(?, COALESCE((SELECT MAX(result_id) FROM semester_results), 0) + 1, false)";

            System.out.println("Attempting to reset sequence: " + sequenceName);
            try (Statement stmt = con.createStatement();
                 ResultSet rsMax = stmt.executeQuery(findMaxIdSQL)) {
                if (rsMax.next()) {
                    maxResultId = rsMax.getLong(1);
                }
                System.out.println("Current max result_id found: " + maxResultId);

                try (PreparedStatement psSeq = con.prepareStatement(setSequenceSQL)) {
                    psSeq.setString(1, sequenceName);
                    psSeq.execute();
                    System.out.println("Sequence '" + sequenceName + "' reset to start after " + maxResultId);
                }
            } catch (SQLException seqEx) {
                System.err.println("WARNING: Could not reset sequence '" + sequenceName + "'. Error: " + seqEx.getMessage());
                // Consider making this fatal if needed: throw new SQLException("Failed to reset result_id sequence.", seqEx);
            }

            // --- Process SEMESTER_RESULTS (Select then Insert or Update) ---
            String selectResultSQL = "SELECT RESULT_ID FROM SEMESTER_RESULTS WHERE STUDENT_REGN_NO = ? AND SEMESTER_NUMBER = ?";
            // Added CGPA to update
            String updateResultSQL = "UPDATE SEMESTER_RESULTS SET SGPA = ?, REMARKS = ?, CGPA = ? WHERE RESULT_ID = ?";
            // Added CGPA to insert
            String insertResultSQL = "INSERT INTO SEMESTER_RESULTS (STUDENT_REGN_NO, SEMESTER_NUMBER, SGPA, REMARKS, CGPA) VALUES (?, ?, ?, ?, ?) RETURNING RESULT_ID";

            try (PreparedStatement psSelect = con.prepareStatement(selectResultSQL);
                 PreparedStatement psUpdate = con.prepareStatement(updateResultSQL);
                 PreparedStatement psInsert = con.prepareStatement(insertResultSQL)) {

                int updateCount = 0;
                int insertCount = 0;
                for (SemesterResultData data : uniqueResults.values()) {
                    int resultId = -1;

                    psSelect.setString(1, data.studentRegnNo);
                    psSelect.setInt(2, data.semesterNumber);
                    try (ResultSet rs = psSelect.executeQuery()) {
                        if (rs.next()) { // Exists: Update
                            resultId = rs.getInt("RESULT_ID");
                            psUpdate.setFloat(1, data.sgpa);
                            psUpdate.setString(2, data.remarks);
                            psUpdate.setFloat(3, data.cgpa); // Set CGPA for update
                            psUpdate.setInt(4, resultId);
                            psUpdate.addBatch();
                            updateCount++;
                        } else { // Does not exist: Insert
                            psInsert.setString(1, data.studentRegnNo);
                            psInsert.setInt(2, data.semesterNumber);
                            psInsert.setFloat(3, data.sgpa);
                            psInsert.setString(4, data.remarks);
                            psInsert.setFloat(5, data.cgpa); // Set CGPA for insert
                            try (ResultSet rsInsert = psInsert.executeQuery()) { // Execute immediately
                                if (rsInsert.next()) {
                                    resultId = rsInsert.getInt(1); // Get new ID
                                    insertCount++;
                                } else {
                                    con.rollback();
                                    throw new SQLException("Insert into SEMESTER_RESULTS failed, no ID obtained for key: " + data.studentRegnNo + ":" + data.semesterNumber);
                                }
                            }
                        }
                    }
                     // Optional: Could store resultId if needed by another process, but not needed here.
                     // if (resultId == -1) { System.err.println("Warning: result_id not determined for " + data.studentRegnNo + ":" + data.semesterNumber); }
                }
                psUpdate.executeBatch(); // Execute all queued updates
                System.out.println("Semester Results processed: " + insertCount + " inserted, " + updateCount + " updated.");
            }

            con.commit(); // Commit transaction
            status = "success";
            message = uniqueResults.size() + " unique semester results processed successfully.";
            System.out.println("Semester Results transaction committed.");

        } catch (IOException | CsvValidationException e) {
            status = "error";
            message = "Error reading or validating Semester Results CSV: " + e.getMessage();
            System.err.println(message);
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { System.err.println("Rollback failed: " + ex.getMessage()); }
        } catch (SQLException e) {
            status = "error";
            // Check for batch update exceptions for more detail
             if (e instanceof java.sql.BatchUpdateException) {
                 message = "Database batch error (Semester Results): " + e.getMessage();
                 SQLException nextEx = ((java.sql.BatchUpdateException) e).getNextException();
                 while (nextEx != null) {
                      System.err.println("Batch Next Exception: " + nextEx.getMessage());
                      nextEx = nextEx.getNextException();
                 }
             } else {
                 if (e.getMessage().contains("violates unique constraint") && e.getMessage().contains("result_id")) {
                      message = "Database error (Semester Results): Primary key conflict on result_id. Sequence might be out of sync. Error: " + e.getMessage();
                 } else {
                      message = "Database SQL error (Semester Results): " + e.getMessage();
                 }
             }
            System.err.println(message);
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { System.err.println("Rollback failed: " + ex.getMessage()); }
        } catch (Exception e) {
            status = "error";
            message = "An unexpected error occurred (Semester Results): " + e.getMessage();
            System.err.println(message);
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { System.err.println("Rollback failed: " + ex.getMessage()); }
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
                e.printStackTrace();
            }
        }

        response.sendRedirect("academicControl.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}