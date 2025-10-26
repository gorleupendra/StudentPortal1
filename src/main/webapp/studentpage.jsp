<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>
<%-- FIX: Import SimpleDateFormat for better date and time formatting --%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %> <%-- Explicitly import Timestamp --%>

<%
    // Get user details from the session
    String regdno = (String) session.getAttribute("regdno");
    String name = "Student"; // Default value
		
    if (regdno == null || regdno.isEmpty()) {
        // Use context path for redirect
        response.sendRedirect(request.getContextPath() + "/login/login.jsp"); 
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
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Assuming studentHeaderFooter.css provides base styles and variables --%>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/studentHeaderFooter.css">
    
    <style>
        /* Inherit variables from studentHeaderFooter.css */
        :root { 
            --primary-blue: #0056b3;
            --primary-blue-hover: #004494; 
            --light-blue-bg: #e7f3fe;
            --border-color: #dee2e6; /* Use a lighter border */
            --text-dark: #1f2937;
            --text-medium: #4b5563;
            --text-light: #6c757d;
            --success-color: #27ae60;
            --success-hover: #219d52;
        }
       
       /* Container */
        .container { 
            max-width: 800px; 
            margin: 20px auto; 
            background: #fff; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        }
        .container h1 { 
            color: var(--primary-blue); 
            font-size: 1.6rem; /* Adjusted size */
            font-weight: 600;
            margin-bottom: 10px; /* Reduced margin */
            text-align: center;
        }
        .container h1 strong {
            display: block; /* Make name appear below welcome */
            font-size: 1.2em;
            margin-top: 5px;
        }
         .container hr {
             border: none;
             border-top: 1px solid #eee;
             margin: 15px 0 25px 0;
         }

        /* Info box */
        .info { 
            background-color: var(--light-blue-bg); 
            border-left: 5px solid var(--primary-blue); /* Thicker border */ 
            padding: 15px 20px; /* Adjusted padding */ 
            margin: 25px 0; /* Consistent margin */ 
            font-size: 1rem; /* Adjusted size */
            border-radius: 0 4px 4px 0; /* Add slight rounding */
            color: var(--text-medium);
        }
         .info p { margin: 5px 0; } /* Spacing for paragraphs inside */
         .info strong { color: var(--text-dark); } /* Darker bold text */

        /* Notices Section */
        .notices-section { 
            margin-top: 40px; 
        }
        .notices-section h3 { 
            border-bottom: 2px solid #eee; 
            padding-bottom: 10px; 
            margin-bottom: 20px; 
            font-size: 1.4em; 
            color: var(--text-dark); /* Darker heading */
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
         .notices-section h3 i {
             color: var(--primary-blue); /* Icon color */
         }

        /* Notice List */
        .notice-list { 
            list-style: none; 
            padding: 0; 
            margin: 0; 
        }
        .notice-item { 
            display: flex; 
            flex-wrap: wrap; /* Allow wrapping on small screens */
            justify-content: space-between; 
            align-items: center; 
            padding: 15px; 
            border-bottom: 1px solid var(--border-color); 
            transition: background-color 0.2s ease-in-out;
            gap: 10px; /* Add gap for wrapping */
        }
        .notice-item:last-child { border-bottom: none; }
        .notice-item:hover { background-color: #f8f9fa; /* Lighter hover */ }
        
        /* Notice Details (Left Side) */
        .notice-details { 
            display: flex; 
            align-items: center; 
            gap: 15px; 
            flex-grow: 1; /* Allow details to take up space */
            min-width: 250px; /* Prevent excessive shrinking */
        }
        .notice-icon { 
            font-size: 1.5em; 
            color: var(--primary-blue); 
            flex-shrink: 0; /* Prevent icon shrinking */
        }
         .notice-text { /* Wrapper for title and meta */
             display: flex;
             flex-direction: column;
         }
        .notice-title { 
            font-weight: 500; 
            font-size: 1.05em; /* Adjusted size */ 
            color: var(--text-dark); 
            margin-bottom: 3px; /* Space below title */
        }
        .notice-meta { 
            font-size: 0.85em; /* Smaller meta */ 
            color: var(--text-light); 
        }
        
        /* Download Link (Right Side) */
        .download-link { 
            background-color: var(--success-color); 
            color: white; 
            text-decoration: none; 
            padding: 8px 15px; 
            border-radius: 5px; 
            font-weight: 500; /* Adjusted weight */
            transition: background-color 0.2s; 
            white-space: nowrap; 
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.9em; /* Smaller button text */
            flex-shrink: 0; /* Prevent button shrinking */
        }
        .download-link:hover { background-color: var(--success-hover); }
        
        /* No Notices Message */
        .no-notices { 
            text-align: center; 
            color: var(--text-light); /* Use theme color */ 
            padding: 25px; /* Increased padding */ 
            font-style: italic; 
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 20px; /* Reduced padding */
                margin: 15px auto;
            }
            .container h1 {
                font-size: 1.5rem; /* Smaller heading */
            }
            .notices-section h3 {
                 font-size: 1.25rem;
             }
             .notice-item {
                 padding: 12px; /* Reduce padding */
             }
             .notice-title { font-size: 1em; }
             .notice-meta { font-size: 0.8em; }
             .download-link { padding: 6px 12px; font-size: 0.85em; }
        }
         @media (max-width: 480px) {
             .container h1 { font-size: 1.3em; }
             .notices-section h3 { font-size: 1.1rem; }
             .notice-item {
                 flex-direction: column; /* Stack details and link */
                 align-items: flex-start; /* Align items left */
             }
             .download-link {
                 margin-top: 10px; /* Add space above button when stacked */
                 align-self: flex-start; /* Align button left */
             }
         }
         
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <main class="page-content">
        <div class="container">
            <h1>Welcome, <strong><%= name %></strong>
            ID: <%= regdno %></h1>
            <hr>
            <div class="info">
                <p>Please review the documents shared below.</p><br>
                <p><strong>Note:</strong> The files available for download are watermarked. <strong>Do not share</strong> these files.</p>
            </div>
            
            <div class="notices-section">
                <h3><i class="fas fa-bullhorn"></i> Shared Records & Announcements</h3>
                <ul class="notice-list">
                <%
               
                    Connection con = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    boolean recordsFound = false;
                    
                    // Formatter for date and time
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");

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
                            
                            // Format the timestamp
                            String uploadDate = (uploadTimestamp != null) ? sdf.format(uploadTimestamp) : "N/A"; 
                %>
                    <li class="notice-item">
                        <div class="notice-details">
                            <i class="fas fa-file-alt notice-icon"></i>
                            <div class="notice-text">
                                <div class="notice-title"><%= description %></div>
                                <div class="notice-meta">File: <%= fileName != null ? fileName : "N/A" %> | Published on: <%= uploadDate %></div>
                            </div>
                        </div>
                        <%-- Added target="_blank" to open in a new tab --%>
                        <a href="downloadStudentRecord?id=<%= recordId %>" class="download-link" target="_blank">
                            <i class="fas fa-eye"></i> View File
                        </a>
                    </li>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace(); // Log error to server console
                    } finally {
                        // Close resources
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
    <%-- Removed login.js, assuming it's not needed for the dashboard --%>
    <%-- <script src="login.js"></script> --%> 
</body>
</html>

