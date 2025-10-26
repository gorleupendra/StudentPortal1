package com.example.manageNotifications;
import com.example.DbConnection;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * This servlet handles file downloads from the 'notification' table.
 * It reads the 'id' from the URL, fetches the corresponding file from the database,
 * and streams it to the client's browser.
 */
@WebServlet("/downloadNotification")
public class downloadNotification extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get the Notification ID from the URL parameter
        int notificationId = 0;
        try {
            notificationId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid notification ID.");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConne();
            
            // 2. Prepare SQL to select the file data based on ID
            // We select the file data, its name, and its MIME type
            String sql = "SELECT file_name, file_mime_type, file_data FROM notification WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, notificationId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                // 3. Retrieve file details from the database
                String fileName = rs.getString("file_name");
                String fileMimeType = rs.getString("file_mime_type");
                InputStream fileStream = rs.getBinaryStream("file_data");

                if (fileStream == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "File data not found in database.");
                    return;
                }

                // 4. Set HTTP Headers for the Response
                
                // Set the content type (e.g., "application/pdf", "image/jpeg")
                if (fileMimeType != null) {
                    response.setContentType(fileMimeType);
                } else {
                    // Fallback if MIME type is not stored
                    response.setContentType("application/octet-stream");
                }
                
                // Set the "Content-Disposition" header.
                // "inline" tries to display it in the browser.
                // "attachment" forces a "Save As..." dialog.
                response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");

                // 5. Stream the file data to the user
                OutputStream outStream = response.getOutputStream();
                byte[] buffer = new byte[4096]; // 4KB buffer
                int bytesRead = -1;

                while ((bytesRead = fileStream.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }

                fileStream.close();
                outStream.close();

            } else {
                // No notification found with that ID
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Notification not found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An unexpected error occurred.");
        } finally {
            // 6. Close all database resources
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
}

