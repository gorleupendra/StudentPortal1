package com.example;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

// This annotation is crucial for file uploads
@MultipartConfig
// This maps the servlet to the URL used in the form's "action" attribute
@WebServlet("/notificationAdmin")
public class notificationAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles all POST requests from the notifications.jsp form.
     * Differentiates between "add" and "delete" actions.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Get the hidden 'action' parameter to decide what to do
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addNotification(request, response);
        } else if ("delete".equals(action)) {
            deleteNotification(request, response);
        }

        // After the action is complete, redirect back to the management page
        response.sendRedirect(request.getContextPath() + "/notifications.jsp");
    }

    /**
     * Adds a new notification to the database.
     * Handles both file uploads and external links.
     */
    private void addNotification(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        InputStream fileStream = null;
        
        try {
            // Get common form fields
            String title = request.getParameter("title");
            String body = request.getParameter("body");
            String linkText = request.getParameter("link_text");
            boolean isNew = "true".equals(request.getParameter("is_new"));
            
            // Get the "linkType" radio button value ("file" or "link")
            String linkType = request.getParameter("linkType");

            conn = DbConnection.getConne();
            
            // This SQL query includes the 'link' column for external links
            String sql = "INSERT INTO notification " +
                         "(title, body, link_text, is_new, date_published, " +
                         "file_name, file_mime_type, file_data, link) " +
                         "VALUES (?, ?, ?, ?, CURRENT_DATE, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            
            // Set the common parameters
            pstmt.setString(1, title);
            pstmt.setString(2, body);
            pstmt.setString(3, linkText);
            pstmt.setBoolean(4, isNew);
            
            // --- Logic to handle EITHER file OR link ---
            
            if ("file".equals(linkType)) {
                // 1. "Upload File" was selected
                Part filePart = request.getPart("fileUpload");
                
                if (filePart != null && filePart.getSize() > 0) {
                    // File was provided
                    String fileName = filePart.getSubmittedFileName();
                    String fileMimeType = filePart.getContentType();
                    fileStream = filePart.getInputStream();

                    pstmt.setString(5, fileName);
                    pstmt.setString(6, fileMimeType);
                    pstmt.setBinaryStream(7, fileStream);
                } else {
                    // No file was uploaded, set file columns to null
                    pstmt.setNull(5, java.sql.Types.VARCHAR);
                    pstmt.setNull(6, java.sql.Types.VARCHAR);
                    pstmt.setNull(7, java.sql.Types.BINARY);
                }
                
                // Set the external 'link' column to null
                pstmt.setNull(8, java.sql.Types.VARCHAR);
                
            } else if ("link".equals(linkType)) {
                // 2. "External Link" was selected
                String link = request.getParameter("link");
                
                // Set all file-related columns to null
                pstmt.setNull(5, java.sql.Types.VARCHAR);
                pstmt.setNull(6, java.sql.Types.VARCHAR);
                pstmt.setNull(7, java.sql.Types.BINARY);
                
                // Set the external 'link' column
                pstmt.setString(8, link);
            }
            
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            // You could set an error message in the session here
        } finally {
            // Close all resources
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
            if (fileStream != null) fileStream.close();
        }
    }

    /**
     * Deletes a notification from the database based on its ID.
     */
    private void deleteNotification(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Get the ID of the notification to delete from the hidden form field
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));

            conn = DbConnection.getConne();
            
            String sql = "DELETE FROM notification WHERE id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, notificationId);
            
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            // You could set an error message in the session here
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
}

