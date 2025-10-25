<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<%
    // Fetch counts from the database
    int studentCount = 0;
    int userCount = 0;
    int recordCount = 0;

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        con = DbConnection.getConne();
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT COUNT(*) FROM students");
        if (rs.next()) studentCount = rs.getInt(1);
        rs.close();
        rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
        if (rs.next()) userCount = rs.getInt(1);
        rs.close();
        rs = stmt.executeQuery("SELECT COUNT(*) FROM student_records");
        if (rs.next()) recordCount = rs.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (con != null) try { con.close(); } catch (SQLException e) {}
    }
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <link rel="stylesheet" href="adminHeaderFooter.css">
    
    <style>
        .page-content {
            padding: 20px;
        }
        .container { 
            max-width: 900px; 
            margin: 20px auto; 
            background: #fff; 
            padding: 25px; 
            border-radius: 8px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1); 
        }
        .container h1 { 
            color: #0056b3; /* Or use your CSS variables */
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        .management-sections {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
            margin: 25px 0;
            text-align: center;
        }
        .management-card {
            flex-basis: 200px;
            padding: 25px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .management-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-color: #0056b3;
        }
        .management-card .fas {
            font-size: 2em;
            color: #0056b3;
            margin-bottom: 10px;
        }
        .management-card h3 {
            margin: 0;
            font-size: 1.1em;
            color: #333;
        }
        .card-count {
            font-size: 2.5em;
            font-weight: 700;
            color: #0056b3;
            margin: 15px 0 5px 0;
        }
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    
    <main class="page-content">
        <div class="container">
            <h1><i class="fas fa-user-cog"></i> Admin Dashboard</h1>
            
            <div class="management-sections">
                <a href="studentManagement.jsp" class="management-card">
                    <i class="fas fa-users"></i>
                    <p class="card-count"><%= studentCount %></p>
                    <h3>Student Management</h3>
                </a>
                <a href="userManagement.jsp" class="management-card">
                    <i class="fas fa-user-shield"></i>
                    <p class="card-count"><%= userCount %></p>
                    <h3>User Management</h3>
                </a>
                <a href="recordsManagement.jsp" class="management-card">
                    <i class="fas fa-file-alt"></i>
                    <p class="card-count"><%= recordCount %></p>
                    <h3>Records Management</h3>
                </a>
                 <a href="academicControl.jsp" class="management-card">
                    <i class="fas fa-university"></i>
                    <h3 style="margin-top: 15px;">Academic Control</h3>
                </a>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>