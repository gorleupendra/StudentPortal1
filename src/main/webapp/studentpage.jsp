<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.example.DbConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Timestamp"%>
<%-- FIX: Import SimpleDateFormat for better date and time formatting --%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    // Get user details from the session
    String regdno = (String) session.getAttribute("regdno");
    String name = "Student"; // Default value
		
    if (regdno == null || regdno.isEmpty()) {
        response.sendRedirect("login.html");

        return; 
    }

    String sessionName = (String) session.getAttribute("userName");
    if (sessionName != null && !sessionName.isEmpty()) {
        name = sessionName;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="studentHeaderFooter.css">
    <style>
        :root { 
            --header-bg: #ffffff; 
            --primary-blue: #0056b3;
            --light-blue-bg: #e7f3fe;
            --border-color: #ddd;
        }
        html, body { height: 100%; }
        body { font-family: Arial, sans-serif; margin: 0; display: flex; flex-direction: column; background-color: #f4f4f4; color: #333; }
        .page-content { flex: 1; padding: 20px; }
        .container { max-width: 800px; margin: 20px auto; background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .container h1 { color: var(--primary-blue); }
        .info { background-color: var(--light-blue-bg); border-left: 6px solid #2196F3; padding: 15px; margin: 20px 0; font-size: 1.1em; }
        .notices-section { margin-top: 40px; }
        .notices-section h3 { border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 20px; font-size: 1.4em; color: #333; }
        .notice-list { list-style: none; padding: 0; margin: 0; }
        .notice-item { display: flex; justify-content: space-between; align-items: center; padding: 15px; border-bottom: 1px solid var(--border-color); }
        .notice-item:last-child { border-bottom: none; }
        .notice-item:hover { background-color: var(--light-blue-bg); }
        .notice-details { display: flex; align-items: center; gap: 15px; }
        .notice-icon { font-size: 1.5em; color: var(--primary-blue); }
        .notice-title { font-weight: 500; font-size: 1.1em; color: #333; }
        .notice-meta { font-size: 0.9em; color: #777; }
        .download-link { background-color: #27ae60; color: white; text-decoration: none; padding: 8px 15px; border-radius: 5px; font-weight: 500; transition: background-color 0.2s; white-space: nowrap; }
        .download-link:hover { background-color: #219d52; }
        .no-notices { text-align: center; color: #888; padding: 20px; font-style: italic; }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <main class="page-content">
        <div class="container">
            <h1><strong>Welcome, <%= name %></strong><br>
            ID: <%= regdno %></h1>
            <hr>
            <div class="info"><p>Please make sure to followed documents</p><br><p>The Below files are WaterMarked files <strong>Don't share</strong>	 those files to any one</p></div>
            
            

            <div class="notices-section">
                <h3><i class="fas fa-bullhorn"></i> Shared Records & Announcements</h3>
                <ul class="notice-list">
                <%
               
                    Connection con = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    boolean recordsFound = false;
                    
                    // FIX: Create a formatter for the date and time.
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm a");

                    try {
                        con = DbConnection.getConne();
                        String sql = "SELECT id, description, file_name, upload_date FROM student_records ORDER BY upload_date DESC";
                        stmt = con.createStatement();
                        rs = stmt.executeQuery(sql);

                        while (rs.next()) {
                            recordsFound = true;
                            int recordId = rs.getInt("id");
                            String description = rs.getString("description");
                            String fileName = rs.getString("file_name");
                            Timestamp uploadTimestamp = rs.getTimestamp("upload_date");
                            
                            // FIX: Format the timestamp into a readable string.
                            String uploadDate = sdf.format(uploadTimestamp);
                %>
                    <li class="notice-item">
                        <div class="notice-details">
                            <i class="fas fa-file-alt notice-icon"></i>
                            <div>
                                <div class="notice-title"><%= description %></div>
                                <div class="notice-meta">File: <%= fileName %> | Published on: <%= uploadDate %></div>
                            </div>
                        </div>
                        <%-- FIX: Added target="_blank" to open in a new tab --%>
                        <a href="downloadStudentRecord?id=<%= recordId %>" class="download-link" target="_blank">
                            <i class="fas fa-eye"></i> View File
                        </a>
                    </li>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) {}
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                        if (con != null) try { con.close(); } catch (SQLException e) {}
                    }
                    
                    if (!recordsFound) {
                %>
                        <p class="no-notices">No new records or announcements have been published yet.</p>
                <%
                    }
                %>
                </ul>
            </div>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
    <script src="login.js"></script> 
</body>
</html>