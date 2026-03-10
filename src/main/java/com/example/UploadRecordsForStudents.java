package com.example;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UploadRecordsForStudents")
@MultipartConfig
public class UploadRecordsForStudents extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String description = request.getParameter("description");
        Part filePart = request.getPart("recordFile"); 
        
        String fileName = filePart.getSubmittedFileName();
        String fileType = filePart.getContentType();
        InputStream fileContentStream = filePart.getInputStream();
        
        String message = "";
        String status = "error";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DbConnection.getConne();
            String sql = "INSERT INTO student_records (description, file_name, file_content, file_type) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            
            ps.setString(1, description);
            ps.setString(2, fileName);
            
            // CHANGE: Use setBinaryStream for PostgreSQL's BYTEA data type
            ps.setBinaryStream(3, fileContentStream); 
            
            ps.setString(4, fileType);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                status = "success";
                message = "Record '" + fileName + "' was uploaded successfully!";
            } else {
                message = "Failed to save the record to the database.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            message = "An error occurred: " + e.getMessage();
        } finally {
            try { if (fileContentStream != null) fileContentStream.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        
        response.sendRedirect("recordsManagement.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}