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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/uploadStudentGradesServlet") // Matches the form action in JSP
@MultipartConfig
public class UploadStudentGradesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Helper class for student grade data
    private static class StudentGradeData {
        String studentRegnNo;
        int semesterNumber;
        int subjectId;
        String grade;
        float gpa;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("studentGradesFile"); // Matches the input name in JSP
        String message = "";
        String status = "error";
        Connection con = null;

        try {
            con = DbConnection.getConne();
            if (con == null) {
                throw new SQLException("Failed to establish database connection.");
            }
            con.setAutoCommit(false); // Start transaction

            List<StudentGradeData> allGrades = new ArrayList<>();

            // --- Read the Student Grades CSV ---
            try (Reader reader = new InputStreamReader(filePart.getInputStream());
                 CSVReader csvReader = new CSVReader(reader)) {

                csvReader.skip(1); // Skip header
                String[] line;
                while ((line = csvReader.readNext()) != null) {
                    // Expecting 5 columns
                    if (line.length < 5) {
                        System.err.println("Skipping malformed row (Grades): Not enough columns. Expected 5, found " + line.length);
                        continue;
                    }
                    try {
                        StudentGradeData data = new StudentGradeData();
                        data.studentRegnNo = line[0].trim();
                        data.semesterNumber = Integer.parseInt(line[1].trim());
                        data.subjectId = Integer.parseInt(line[2].trim());
                        data.grade = line[3].trim();
                        data.gpa = Float.parseFloat(line[4].trim());
                        allGrades.add(data);
                    } catch (NumberFormatException e) {
                        System.err.println("Skipping malformed row (Grades): Error parsing number - " + e.getMessage());
                    } catch (ArrayIndexOutOfBoundsException e) {
                        System.err.println("Skipping malformed row (Grades): Index out of bounds - " + e.getMessage());
                    }
                }
            }
            if (allGrades.isEmpty()) {
                throw new Exception("Student Grades CSV file is empty or contains no valid data rows.");
            }

            // --- Fetch necessary Result IDs from SEMESTER_RESULTS ---
            // Create a map to store fetched result IDs efficiently
            Map<String, Integer> resultIdMap = new HashMap<>();
            String findResultIdSQL = "SELECT RESULT_ID FROM SEMESTER_RESULTS WHERE STUDENT_REGN_NO = ? AND SEMESTER_NUMBER = ?";
            try (PreparedStatement psFind = con.prepareStatement(findResultIdSQL)) {
                // Use a temporary map to avoid redundant lookups for the same student/semester
                Map<String, Boolean> checkedKeys = new HashMap<>();
                for (StudentGradeData gradeData : allGrades) {
                    String resultKey = gradeData.studentRegnNo + ":" + gradeData.semesterNumber;
                    if (!checkedKeys.containsKey(resultKey)) { // Only query if not already checked
                        psFind.setString(1, gradeData.studentRegnNo);
                        psFind.setInt(2, gradeData.semesterNumber);
                        try (ResultSet rs = psFind.executeQuery()) {
                            if (rs.next()) {
                                resultIdMap.put(resultKey, rs.getInt("RESULT_ID"));
                            } else {
                                System.err.println("WARNING: No corresponding SEMESTER_RESULTS record found for student "
                                        + gradeData.studentRegnNo + ", semester " + gradeData.semesterNumber + ". Grades for this entry will be skipped.");
                                // Store null or a special value to indicate missing parent
                                resultIdMap.put(resultKey, null);
                            }
                        }
                        checkedKeys.put(resultKey, true); // Mark this key as checked
                    }
                }
            }

            // --- Reset Sequence for STUDENT_GRADES ---
            String sequenceName = "student_grades_grade_id_seq"; // <<< VERIFY THIS NAME
            long maxGradeId = 0;
            String findMaxGradeIdSQL = "SELECT MAX(grade_id) FROM student_grades";
            // Use coalesce for empty table
            String setGradeSequenceSQL = "SELECT setval(?, COALESCE((SELECT MAX(grade_id) FROM student_grades), 0) + 1, false)";

            System.out.println("Attempting to reset sequence: " + sequenceName);
            try (Statement stmt = con.createStatement();
                 ResultSet rsMax = stmt.executeQuery(findMaxGradeIdSQL)) {
                if (rsMax.next()) {
                    maxGradeId = rsMax.getLong(1);
                }
                System.out.println("Current max grade_id found: " + maxGradeId);

                try (PreparedStatement psSeq = con.prepareStatement(setGradeSequenceSQL)) {
                    psSeq.setString(1, sequenceName);
                    psSeq.execute();
                    System.out.println("Sequence '" + sequenceName + "' reset to start after " + maxGradeId);
                }
            } catch (SQLException seqEx) {
                System.err.println("WARNING: Could not reset sequence '" + sequenceName + "'. Error: " + seqEx.getMessage());
                // Consider making this fatal if needed: throw new SQLException("Failed to reset grade_id sequence.", seqEx);
            }

            // --- Insert all STUDENT_GRADES in a batch ---
            // Added ON CONFLICT clause to handle potential duplicate grades if needed
            // Choose the conflict target carefully (e.g., result_id + subject_id)
            // If grade_id is the ONLY primary key, ON CONFLICT DO NOTHING might not prevent the error fully if sequence fails
            // Consider adding a UNIQUE constraint on (result_id, subject_id) in your DB if grades should be unique per result+subject
            // If using a UNIQUE constraint: ON CONFLICT (result_id, subject_id) DO NOTHING
             String insertGradeSQL = "INSERT INTO STUDENT_GRADES (RESULT_ID, SUBJECT_ID, GRADE, GPA) VALUES (?, ?, ?, ?)"; // Removed ON CONFLICT as sequence reset should handle PK issue

             int skippedCount = 0;
            try (PreparedStatement psInsertGrade = con.prepareStatement(insertGradeSQL)) {
                int gradeCount = 0;
                for (StudentGradeData gradeData : allGrades) {
                    String resultKey = gradeData.studentRegnNo + ":" + gradeData.semesterNumber;
                    Integer resultId = resultIdMap.get(resultKey);

                    if (resultId != null) { // Check if a valid resultId was found
                        psInsertGrade.setInt(1, resultId);
                        psInsertGrade.setInt(2, gradeData.subjectId);
                        psInsertGrade.setString(3, gradeData.grade);
                        psInsertGrade.setFloat(4, gradeData.gpa);
                        psInsertGrade.addBatch();
                        gradeCount++;
                    } else {
                        skippedCount++;
                        // Warning already printed during ID fetching
                    }
                }
                psInsertGrade.executeBatch();
                System.out.println("Student Grades processed: " + gradeCount + " added to batch, " + skippedCount + " skipped due to missing semester result.");
            }

            con.commit(); // Commit transaction
            status = "success";
            message = allGrades.size() + " student grade entries processed successfully.";
             if (skippedCount > 0) {
                 message += " (" + skippedCount + " grades were skipped because the corresponding semester result was not found).";
             }
            System.out.println("Student Grades transaction committed.");

        } catch (IOException | CsvValidationException e) {
            status = "error";
            message = "Error reading or validating Student Grades CSV: " + e.getMessage();
            System.err.println(message);
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { System.err.println("Rollback failed: " + ex.getMessage()); }
        } catch (SQLException e) {
            status = "error";
             // Check for batch update exceptions for more detail
             if (e instanceof java.sql.BatchUpdateException) {
                 message = "Database batch error (Grades): " + e.getMessage();
                 SQLException nextEx = ((java.sql.BatchUpdateException) e).getNextException();
                 while (nextEx != null) {
                      System.err.println("Batch Next Exception: " + nextEx.getMessage());
                      nextEx = nextEx.getNextException();
                 }
             } else {
                  if (e.getMessage().contains("violates unique constraint") && e.getMessage().contains("grade_id")) {
                      message = "Database error (Grades): Primary key conflict on grade_id. Sequence might be out of sync. Error: " + e.getMessage();
                 } else if (e.getMessage().contains("violates foreign key constraint") && e.getMessage().contains("result_id")) {
                     message = "Database error (Grades): Foreign key violation. Make sure all semester results exist before uploading grades. Error: " + e.getMessage();
                 } else if (e.getMessage().contains("violates foreign key constraint") && e.getMessage().contains("subject_id")) {
                      message = "Database error (Grades): Foreign key violation. Make sure all subject IDs exist in the SUBJECTS table. Error: " + e.getMessage();
                 }
                  else {
                      message = "Database SQL error (Grades): " + e.getMessage();
                 }
             }
            System.err.println(message);
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { System.err.println("Rollback failed: " + ex.getMessage()); }
        } catch (Exception e) {
            status = "error";
            message = "An unexpected error occurred (Grades): " + e.getMessage();
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