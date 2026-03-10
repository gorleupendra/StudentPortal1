<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.DbConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>System Diagnostic Test</title>
    <style>
        body { font-family: sans-serif; padding: 20px; line-height: 1.6; }
        .status { padding: 10px; margin: 10px 0; border-radius: 5px; font-weight: bold; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        pre { background: #eee; padding: 10px; overflow-x: auto; }
    </style>
</head>
<body>
    <h2>Backend Diagnostic Test</h2>
    <hr>

    <h3>1. Class Visibility Test</h3>
    <%
        try {
            // This line tests if Tomcat can actually see your class
            String className = com.example.DbConnection.class.getName();
            out.println("<div class='status success'>SUCCESS: Found class: " + className + "</div>");
        } catch (Throwable t) {
            out.println("<div class='status error'>ERROR: Cannot find com.example.DbConnection class.</div>");
            out.println("<pre>");
            t.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>

    <h3>2. Database Connection Test</h3>
    <%
        try {
            Connection conn = com.example.DbConnection.getConne();
            if (conn != null && !conn.isClosed()) {
                out.println("<div class='status success'>SUCCESS: Database connection established!</div>");
                
                // Show metadata for extra confirmation
                DatabaseMetaData meta = conn.getMetaData();
                out.println("<ul>");
                out.println("<li><b>DB Product:</b> " + meta.getDatabaseProductName() + "</li>");
                out.println("<li><b>DB Version:</b> " + meta.getDatabaseProductVersion() + "</li>");
                out.println("<li><b>Driver Name:</b> " + meta.getDriverName() + "</li>");
                out.println("</ul>");
                
                conn.close();
            } else {
                out.println("<div class='status error'>ERROR: Connection object is null or closed.</div>");
            }
        } catch (Exception e) {
            out.println("<div class='status error'>ERROR: Connection failed.</div>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>

    <h3>3. Environment Variable Check</h3>
    <ul>
        <li><b>RENDER_DB_HOST set:</b> <%= (System.getenv("RENDER_DB_HOST") != null) ? "Yes" : "No" %></li>
        <li><b>RENDER_DB_PASSWORD set:</b> <%= (System.getenv("RENDER_DB_PASSWORD") != null) ? "Yes" : "No" %></li>
    </ul>

    <p><small>Note: If Test 1 fails, the class isn't in your WAR file. If Test 2 fails, check your Neon DB settings/IP whitelist.</small></p>
</body>
</html>