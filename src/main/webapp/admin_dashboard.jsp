<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<%
    // Fetch counts from the database
    int studentCount = 0;
    int userCount = 0; // Assuming you have a 'users' table
    int recordCount = 0;
    int notificationCount = 0; // Added count for notifications

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        con = DbConnection.getConne();
        stmt = con.createStatement();
        
        // Get student count
        rs = stmt.executeQuery("SELECT COUNT(*) FROM students");
        if (rs.next()) studentCount = rs.getInt(1);
        rs.close(); // Close previous ResultSet
        
        // Get user count (adjust table name if needed)
        // rs = stmt.executeQuery("SELECT COUNT(*) FROM users"); 
        // if (rs.next()) userCount = rs.getInt(1);
        // rs.close(); // Close previous ResultSet
        // Using placeholder for now if 'users' table doesn't exist yet
        userCount = 0; 
        
        // Get records count
        rs = stmt.executeQuery("SELECT COUNT(*) FROM student_records");
        if (rs.next()) recordCount = rs.getInt(1);
        rs.close(); // Close previous ResultSet

        // Get notification count
        rs = stmt.executeQuery("SELECT COUNT(*) FROM notification");
        if (rs.next()) notificationCount = rs.getInt(1);
        
    } catch (Exception e) {
        e.printStackTrace(); // Log the error
    } finally {
        // Clean up resources
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (con != null) try { con.close(); } catch (SQLException e) {}
    }
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Link to the main admin layout CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminHeaderFooter.css">
    
    <style>
        /* Inherit variables from adminHeaderFooter.css */
        :root { 
            --primary-blue: #0056b3;
            --primary-blue-hover: #004494; 
            --light-blue-bg: #f0f7ff;
            --border-color: #d1d5db; 
            --text-dark: #1f2937;
            --text-medium: #4b5563;
            --card-bg: #ffffff; /* White card background */
            --shadow: 0 4px 12px rgba(0,0,0,0.05); /* Soft shadow */
            --secondary-color: #6c757d; /* Color for icons */
        }

        /* Container styles */
        .dashboard-container { 
            max-width: 1200px; /* Wider container for grid */
            margin: 20px auto; 
            padding: 0 15px; /* Add horizontal padding */
        }
        .dashboard-container h1 { 
            color: var(--primary-blue); 
            border-bottom: 2px solid #eee; 
            padding-bottom: 10px; 
            margin-bottom: 30px; 
            font-weight: 600; 
            display: flex;
            align-items: center;
            justify-content: center; /* Center heading */
            gap: 0.75rem;
            font-size: 1.8rem;
            text-align: center;
        }
        
        /* Grid layout for cards */
        .management-sections {
            display: grid;
            /* Creates responsive columns: minimum 200px wide, max 1fr */
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
            gap: 25px; /* Gap between cards */
            margin: 25px 0;
        }

        /* Card styles */
        .management-card {
            background-color: var(--card-bg);
            border-radius: 10px; /* More rounded */
            box-shadow: var(--shadow);
            padding: 25px;
            text-align: center;
            text-decoration: none; /* Remove underline from link */
            color: var(--text-dark); /* Default text color */
            transition: transform 0.2s ease-out, box-shadow 0.2s ease-out; /* Smooth transition */
            display: flex; /* Use flexbox for vertical alignment */
            flex-direction: column;
            justify-content: space-between; /* Space out elements */
            border: 1px solid var(--border-color); /* Subtle border */
        }
        .management-card:hover {
            transform: translateY(-5px); /* Lift effect */
            box-shadow: 0 8px 20px rgba(0,0,0,0.1); /* Stronger shadow on hover */
        }
        .management-card .fas { /* Icon style */
            font-size: 2.5em; /* Larger icon */
            color: var(--primary-blue); /* Use primary color */
            margin-bottom: 15px; /* Space below icon */
        }
        .management-card h3 {
            margin: 10px 0 0 0; /* Adjusted margin */
            font-size: 1.1em;
            font-weight: 600; /* Bolder title */
            color: var(--text-dark); /* Dark text */
            line-height: 1.4; /* Ensure text doesn't clash with count */
        }
        .card-count {
            font-size: 2.5em; /* Large count */
            font-weight: 700;
            color: var(--primary-blue);
            margin: 15px 0 5px 0; /* Space around count */
            line-height: 1.1;
        }
        
        /* Specific adjustments for cards without counts */
        .management-card h3[style*="margin-top"] {
            margin-top: auto; /* Push titles down if no count */
             padding-top: 15px; /* Add some space above */
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .dashboard-container h1 { 
                font-size: 1.5rem; 
                margin-bottom: 25px;
            }
            .management-sections {
                /* Adjust min column width for better fit on tablets */
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); 
                gap: 20px; 
            }
            .management-card {
                padding: 20px; /* Reduced padding */
            }
            .management-card .fas {
                font-size: 2.2em;
            }
            .card-count {
                font-size: 2.2em;
            }
            .management-card h3 {
                font-size: 1em;
            }
        }
         @media (max-width: 480px) {
             .dashboard-container h1 { font-size: 1.3rem; }
             .management-sections {
                 /* Stack cards on very small screens */
                 grid-template-columns: 1fr; 
                 gap: 15px;
             }
              .management-card .fas {
                 font-size: 2em;
             }
              .card-count {
                 font-size: 2em;
             }
         }
         
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    
    <main class="page-content">
        <div class="dashboard-container"> 
            <h1><i class="fas fa-user-cog"></i> Admin Dashboard</h1>
            
            <div class="management-sections">
                <a href="studentManagement.jsp" class="management-card">
                    <i class="fas fa-users"></i>
                    <p class="card-count"><%= studentCount %></p>
                    <h3>Student Management</h3>
                </a>
                
                
                <a href="userManagement.jsp" class="management-card">
                    <i class="fas fa-user-shield"></i>
                    <p class="card-count"><%//= userCount %></p> 
                    <h3>User Management</h3>
                </a> 
            

                <a href="recordsManagement.jsp" class="management-card">
                    <i class="fas fa-file-alt"></i>
                    <p class="card-count"><%= recordCount %></p>
                    <h3>Records Management</h3>
                </a>
                 <a href="academicControl.jsp" class="management-card">
                    <i class="fas fa-university"></i>
                    <%-- Removed count styles as there is no count --%>
                    <h3>Academic Control</h3> 
                </a>
                 <a href="notifications.jsp" class="management-card">
                    <i class="fas fa-bullhorn"></i>
                    <p class="card-count"><%= notificationCount %></p> 
                    <h3>Manage Notifications</h3>
                </a>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
