<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>
<%-- FIX: Import SimpleDateFormat for better date and time formatting --%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %> <%-- Explicitly import Timestamp --%>

<%
    // --- 1. Session Security Check ---
    String userId = (String) session.getAttribute("regdno");
    if (userId == null || userId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp"); // Use context path
        return; 
    }
    
    // Get username from session for display (optional)
    String name = (String) session.getAttribute("userName");
    if (name == null || name.isEmpty()) {
        name = "Student"; // Default if name not in session
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>My Results - Student Portal</title>
    
    <%-- Assuming studentHeaderFooter.css provides base styles and variables --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/studentHeaderFooter.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        /* Inherit variables from studentHeaderFooter.css */
        :root { 
            --primary-blue: #0056b3;
            --primary-blue-hover: #004494; 
            --light-blue-bg: #f0f7ff;
            --border-color: #dee2e6; /* Use a lighter border */
            --text-dark: #1f2937;
            --text-medium: #4b5563;
            --text-light: #6c757d;
            --success-color: #28a745; /* Green for GPA */
            --table-header-bg: #0056b3; /* Match primary blue */
            --table-header-text: #ffffff;
            --table-row-even-bg: #f8f9fa;
            --table-row-hover-bg: #e9ecef;
        }
       
       /* Container */
        .container {
            max-width: 1000px;
            margin: 20px auto;
            /* No background/padding here, handled by semester blocks */
        }
        .container h1 {
            color: var(--primary-blue);
            text-align: center;
            margin-bottom: 35px;
            font-size: 1.8rem;
            font-weight: 600;
        }
        
        /* Semester Block */
        .semester-block {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.07); /* Softer shadow */
            margin-bottom: 30px;
            border: 1px solid var(--border-color); /* Subtle border */
        }
        
        /* Semester Header */
        .semester-header {
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 15px;
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap; /* Allow wrapping */
            justify-content: space-between;
            align-items: center;
            gap: 10px; /* Gap for wrapping */
        }
        .semester-header h2 {
            color: var(--text-dark); /* Darker heading */
            margin: 0;
            font-size: 1.4rem; /* Adjusted size */
            font-weight: 600;
        }
        .semester-summary {
            text-align: right;
            flex-shrink: 0; /* Prevent shrinking */
        }
        .semester-summary .sgpa { /* Renamed from cgpa for clarity */
            font-size: 1.2em;
            font-weight: bold;
            color: var(--success-color); /* Use success color */
        }
        .semester-summary .remarks {
            font-size: 0.9em;
            color: var(--text-light); /* Use theme color */
            margin-top: 3px; /* Add space */
        }
        
        /* Results Table */
         .table-container { /* Added wrapper for scrolling */
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--border-color);
            border-radius: 6px;
        }
        .results-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 1rem; /* Adjusted base size */
            min-width: 500px; /* Ensure scrolling */
        }
        .results-table th, .results-table td {
            padding: 12px 15px; /* Adjusted padding */
            text-align: left;
            border-bottom: 1px solid var(--border-color); /* Use theme border color */
            vertical-align: middle; /* Align content */
        }
         .results-table tr:last-child td {
             border-bottom: none; /* Remove border on last row */
         }
        .results-table thead th {
            background-color: var(--table-header-bg); /* Use theme variable */
            color: var(--table-header-text); /* Use theme variable */
            font-weight: 600;
            border-bottom-width: 2px; /* Thicker header border */
        }
        .results-table tbody tr:nth-child(even) {
            background-color: var(--table-row-even-bg); /* Use theme variable */
        }
        .results-table tbody tr:hover {
            background-color: var(--table-row-hover-bg); /* Use theme variable */
        }
        
        /* No Results Message */
        .no-results {
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            text-align: center;
            font-size: 1.1em; /* Adjusted size */
            color: var(--text-light); /* Use theme color */
            border: 2px dashed var(--border-color); /* Dashed border */
            margin-top: 30px; /* Add margin if it's the only element */
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                /* Container takes full width, padding handled by page-content */
                margin: 0; 
                max-width: none;
            }
             .semester-block {
                 padding: 20px; /* Reduced padding */
             }
             .container h1 {
                 font-size: 1.5rem; /* Smaller heading */
                 margin-bottom: 25px;
             }
             .semester-header h2 {
                 font-size: 1.25rem;
             }
             .results-table th, .results-table td {
                 padding: 10px 12px; /* Reduced padding */
                 font-size: 0.95rem; /* Slightly smaller font */
             }
        }
         @media (max-width: 480px) {
             .container h1 { font-size: 1.3em; }
             .semester-header {
                  flex-direction: column; /* Stack header elements */
                  align-items: flex-start; /* Align left */
             }
             .semester-summary {
                 text-align: left; /* Align left */
                 margin-top: 10px;
             }
             .results-table th, .results-table td {
                 font-size: 0.9rem; /* Further reduce font size */
                 padding: 8px 10px;
             }
         }
         
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="page-content">
        <div class="container">
            <h1>My Academic Results</h1>
            
            <%
                Connection con = null;
                PreparedStatement psSemesters = null;
                ResultSet rsSemesters = null;
                boolean resultsFoundOverall = false; // Flag to track if any results exist at all

                try {
                    con = DbConnection.getConne();
                    
                    // Fetch distinct semesters first to loop through them
                    String semestersSQL = "SELECT DISTINCT semester_number FROM semester_results WHERE student_regn_no = ? ORDER BY semester_number";
                    psSemesters = con.prepareStatement(semestersSQL);
                    psSemesters.setString(1, userId);
                    rsSemesters = psSemesters.executeQuery();
                    
                    while (rsSemesters.next()) {
                        resultsFoundOverall = true; // Found at least one semester result
                        int semesterNumber = rsSemesters.getInt("semester_number");
                        
                        // Now fetch the specific semester details (SGPA, remarks, result_id)
                        double sgpa = 0.0;
                        String remarks = "N/A";
                        int resultId = -1; // Default invalid ID

                        PreparedStatement psSemesterDetail = null;
                        ResultSet rsSemesterDetail = null;
                        try {
                             String semesterDetailSQL = "SELECT result_id, sgpa, remarks FROM semester_results WHERE student_regn_no = ? AND semester_number = ?";
                             psSemesterDetail = con.prepareStatement(semesterDetailSQL);
                             psSemesterDetail.setString(1, userId);
                             psSemesterDetail.setInt(2, semesterNumber);
                             rsSemesterDetail = psSemesterDetail.executeQuery();
                             if (rsSemesterDetail.next()) {
                                 resultId = rsSemesterDetail.getInt("result_id");
                                 sgpa = rsSemesterDetail.getDouble("sgpa");
                                 remarks = rsSemesterDetail.getString("remarks");
                             }
                        } finally {
                             // Close detail query resources
                             if (rsSemesterDetail != null) rsSemesterDetail.close();
                             if (psSemesterDetail != null) psSemesterDetail.close();
                        }

            %>
                        <div class="semester-block">
                            <div class="semester-header">
                                <h2>Semester <%= semesterNumber %> Results</h2>
                                <div class="semester-summary">
                                    <div class="sgpa">SGPA: <%= String.format("%.2f", sgpa) %></div>
                                    <div class="remarks"><%= remarks != null ? remarks : "N/A" %></div>
                                </div>
                            </div>
                            
                            <% if (resultId != -1) { // Only show table if we found a valid result_id %>
                                <div class="table-container">
                                    <table class="results-table">
                                        <thead>
                                            <tr>
                                                <th>Subject Name</th>
                                                <th>Grade</th>
                                                <th>GPA</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%
                                            PreparedStatement psGrades = null;
                                            ResultSet rsGrades = null;
                                            boolean gradesFound = false; // Flag for grades within semester
                                            try {
                                                // Fetch grades for this specific result_id
                                                String gradesSQL = "SELECT s.subject_name, sg.grade, sg.gpa " + // Simpler query
                                                                 "FROM student_grades sg JOIN subjects s ON sg.subject_id = s.subject_id " +
                                                                 "WHERE sg.result_id = ? " +
                                                                 "ORDER BY s.subject_id";
                                                                 
                                                psGrades = con.prepareStatement(gradesSQL);
                                                psGrades.setInt(1, resultId);
                                                rsGrades = psGrades.executeQuery();

                                                while (rsGrades.next()) {
                                                    gradesFound = true;
                                        %>
                                                    <tr>
                                                        <td><%= rsGrades.getString("subject_name") %></td>
                                                        <td><%= rsGrades.getString("grade") %></td>
                                                        <%-- Assuming GPA is stored appropriately (e.g., float/decimal) --%>
                                                        <td><%= String.format("%.1f", rsGrades.getFloat("gpa")) %></td> 
                                                    </tr>
                                        <%
                                                }
                                                 if (!gradesFound) { // Show message if no grades for this semester result
                                        %>
                                                     <tr><td colspan="3" style="text-align:center; font-style:italic;">No subject grades recorded for this semester.</td></tr>
                                        <%
                                                 }
                                            } catch (Exception e_grades) { // Catch specific grade errors
                                                e_grades.printStackTrace();
                                                 %> <tr><td colspan="3" style="text-align:center; color:red;">Error loading subject grades.</td></tr> <%
                                            } finally {
                                                // Close grade query resources
                                                if (rsGrades != null) rsGrades.close();
                                                if (psGrades != null) psGrades.close();
                                            }
                                        %>
                                        </tbody>
                                    </table>
                                </div>
                            <% } else { // If resultId was invalid for some reason %>
                                 <p style="text-align:center; font-style:italic; color: #888;">Could not retrieve detailed grades for this semester.</p>
                            <% } %>
                        </div>
            <%
                    } // End semester loop (rsSemesters.next())
                } catch (Exception e) {
                    e.printStackTrace(); // Log the main error
                     %> <p style="text-align:center; color:red;">An error occurred while loading results.</p> <%
                } finally {
                    // Close main query resources
                    if (rsSemesters != null) try { rsSemesters.close(); } catch (SQLException se) {}
                    if (psSemesters != null) try { psSemesters.close(); } catch (SQLException se) {}
                    if (con != null) try { con.close(); } catch (SQLException se) {}
                }
                
                // Show message only if NO results were found for ANY semester
                if (!resultsFoundOverall) {
            %>
                <div class="no-results">
                    <p>No results have been uploaded for your account yet.</p>
                </div>
            <%
                }
            %>
        </div>
    </main>

    <%@ include file="footer.jsp" %>

</body>
</html>

