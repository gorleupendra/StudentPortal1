package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/uploadphoto")
@MultipartConfig
public class PhotoFileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        boolean isSuccess = false;
        String message = "";
        String nextRegdNo = null;
        String nextStudentName = null;
        String regdNo = request.getParameter("regd_no");
        String submittedStudentName = request.getParameter("student_name");

        try {
            Part filePart = request.getPart("fileToUpload");

            if (filePart != null && filePart.getSize() > 0 && regdNo != null && !regdNo.isEmpty()) {
                try (InputStream inputStream = filePart.getInputStream();
                     Connection conn = DbConnection.getConne()) {
                    
                    conn.setAutoCommit(false); // Start transaction

                    String sql = "UPDATE students SET photo = ? WHERE regd_no = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                        
                        // CHANGE 1: Use setBinaryStream for PostgreSQL
                        pstmt.setBinaryStream(1, inputStream, filePart.getSize());
                        pstmt.setString(2, regdNo);

                        int rowsAffected = pstmt.executeUpdate();

                        if (rowsAffected > 0) {
                            // Fetch the next student who needs a photo
                            // CHANGE 2: Use length() instead of dbms_lob.getlength()
                            String nextStudentSql = "SELECT regd_no, name FROM students WHERE (photo IS NULL OR length(photo)=0) AND regd_no > ? ORDER BY regd_no ASC";
                            try (PreparedStatement nextStmt = conn.prepareStatement(nextStudentSql)) {
                                nextStmt.setString(1, regdNo);
                                try (ResultSet nextRs = nextStmt.executeQuery()) {
                                    if (nextRs.next()) {
                                        nextRegdNo = nextRs.getString("regd_no");
                                        nextStudentName = nextRs.getString("name");
                                    }
                                }
                            }
                            conn.commit(); // Commit transaction
                            isSuccess = true;
                            message = "Successfully uploaded photo for " + submittedStudentName;
                        } else {
                            conn.rollback();
                            message = "Upload failed. Student with Registration No. " + regdNo + " not found.";
                        }
                    } catch (SQLException e) {
                        conn.rollback();
                        throw e; // Re-throw to be caught by the outer catch block
                    }
                }
            } else {
                message = "Please select a file to upload.";
            }
        } catch (Exception e) {
            message = "DATABASE ERROR: " + e.getMessage();
            e.printStackTrace();
        }

        // Build the redirect URL with status and next student info
        StringBuilder redirectURL = new StringBuilder("photoFileUpload.jsp");
        redirectURL.append("?status=").append(isSuccess ? "success" : "error");
        redirectURL.append("&msg=").append(URLEncoder.encode(message, StandardCharsets.UTF_8));

        if (nextRegdNo != null) {
            redirectURL.append("&nextRegd=").append(URLEncoder.encode(nextRegdNo, StandardCharsets.UTF_8));
            redirectURL.append("&nextName=").append(URLEncoder.encode(nextStudentName, StandardCharsets.UTF_8));
        }

        response.sendRedirect(redirectURL.toString());
    }
}