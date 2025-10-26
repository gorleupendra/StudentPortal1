<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection, java.util.ArrayList, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>View Result Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Assuming adminHeaderFooter.css provides base styles and variables --%>
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
            --edit-color: #ffc107;
            --edit-hover: #e0a800;
            --delete-color: #dc3545;
            --delete-hover: #c82333;
            --secondary-bg: #e5e7eb;
            --secondary-hover: #d1d5db;
        }
        
        /* Container styles */
        .container { 
            max-width: 900px; 
            margin: 20px auto; 
            background: #fff; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        }
        
        /* Page Header */
        .page-header {
            display: flex; 
            flex-wrap: wrap; /* Allow wrapping */
            justify-content: space-between; 
            align-items: center;
            border-bottom: 2px solid #eee; 
            padding-bottom: 15px; 
            margin-bottom: 25px;
            gap: 15px; /* Add gap */
        }
        .container h1 { 
            color: var(--primary-blue); 
            margin: 0; 
            font-size: 1.8rem; 
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            flex-grow: 1; /* Allow title to take space */
        }
        .header-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap; /* Allow buttons to wrap if needed */
        }
        
        /* Summary Grid */
        .summary-grid { 
            display: grid; 
            grid-template-columns: repeat(4, 1fr); /* Default 4 columns */ 
            gap: 20px; 
            margin-bottom: 30px; 
        }
        .summary-item { 
            background-color: var(--light-blue-bg); 
            padding: 20px; 
            border-radius: 8px; 
            text-align: center; 
            border: 1px solid #cce5ff;
            color: var(--text-medium); /* Label color */
            font-size: 0.9em;
        }
        .summary-item strong { 
            display: block; 
            font-size: 1.3em; /* Relative to parent */ 
            color: var(--primary-blue); 
            margin-top: 5px; 
            font-weight: 600;
            word-break: break-word; /* Prevent long text overflow */
        }
        
        /* Subheading for table */
         .container h2 { 
             color: var(--text-dark); 
             margin-top: 30px;
             margin-bottom: 15px; 
             font-size: 1.4rem;
             font-weight: 600;
             border-bottom: 1px solid #eee;
             padding-bottom: 8px;
             display: flex;
             align-items: center;
             gap: 0.75rem;
         }
         .container h2 i {
             color: var(--primary-blue);
         }
        
        /* Table styles */
        .table-container { /* Added wrapper for scrolling */
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            margin-top: 20px;
        }
        .grades-table { 
            width: 100%; 
            border-collapse: collapse; 
            min-width: 600px; /* Ensure table scrolls */
        }
        .grades-table th, .grades-table td { 
            padding: 12px 15px; 
            border-bottom: 1px solid var(--border-color); 
            text-align: left; 
            vertical-align: middle;
            white-space: nowrap; /* Prevent wrapping */
        }
         .grades-table tr:last-child td {
             border-bottom: none;
         }
        .grades-table thead { 
            background-color: var(--light-blue-bg); 
        }
         .grades-table th {
             font-weight: 600;
             color: var(--primary-blue);
             border-bottom-width: 2px;
         }
         .grades-table tbody tr:hover {
             background-color: #f8f9fa;
         }
        
        /* Button styles */
        .btn {
            padding: 8px 15px; 
            border-radius: 6px; 
            font-weight: 500; /* Adjusted weight */ 
            text-decoration: none;
            display: inline-flex; 
            align-items: center; 
            gap: 8px; 
            border: 1px solid transparent;
            cursor: pointer; 
            transition: all 0.2s;
            font-size: 0.9em; /* Smaller buttons */
            white-space: nowrap; /* Prevent wrapping */
        }
        .btn-secondary { background-color: var(--secondary-bg); color: var(--text-dark); border-color: var(--border-color); }
        .btn-secondary:hover { background-color: var(--secondary-hover); }
        .btn-edit { background-color: var(--edit-color); color: var(--text-dark); } /* Dark text for yellow */
        .btn-edit:hover { background-color: var(--edit-hover); }
        .btn-delete { background-color: var(--delete-color); color: white; }
        .btn-delete:hover { background-color: var(--delete-hover); }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 20px; /* Reduced padding */
                margin: 15px auto;
            }
            .page-header h1 {
                font-size: 1.5em; /* Smaller heading */
                flex-basis: 100%; /* Title takes full width */
                margin-bottom: 10px; /* Space below title */
            }
            .header-actions {
                 flex-basis: 100%; /* Actions take full width */
                 justify-content: center; /* Center buttons */
            }
            .summary-grid {
                grid-template-columns: repeat(2, 1fr); /* 2 columns on tablet */
                gap: 15px;
            }
            .summary-item { padding: 15px; }
            .container h2 { font-size: 1.25rem; }
            .grades-table th, .grades-table td { padding: 10px 12px; }
        }
         @media (max-width: 480px) {
             .container h1 { font-size: 1.3em; }
             .summary-grid {
                 grid-template-columns: 1fr; /* Stack summary items */
             }
             .btn { padding: 8px 12px; font-size: 0.85em; } /* Smaller buttons */
             .header-actions { flex-direction: column; align-items: stretch; } /* Stack buttons */
             .header-actions .btn { justify-content: center; } /* Center button text */
         }
         
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    <main class="page-content">
        <div class="container">
            <%
                String resultIdStr = request.getParameter("result_id");
                Connection con = null; // Declare outside try
                PreparedStatement psResult = null;
                ResultSet rsResult = null;
                PreparedStatement psGrades = null;
                ResultSet rsGrades = null;

                if (resultIdStr != null && !resultIdStr.trim().isEmpty()) {
                    try {
                        con = DbConnection.getConne();
                        int resultId = Integer.parseInt(resultIdStr);

                        // Fetch result details
                        String sqlResult = "SELECT STUDENT_REGN_NO, SEMESTER_NUMBER, SGPA, REMARKS FROM SEMESTER_RESULTS WHERE RESULT_ID = ?";
                        psResult = con.prepareStatement(sqlResult);
                        psResult.setInt(1, resultId);
                        rsResult = psResult.executeQuery();

                        if (rsResult.next()) {
                            String studentRegNo = rsResult.getString("STUDENT_REGN_NO");
                            int semesterNumber = rsResult.getInt("SEMESTER_NUMBER");
                            float sgpa = rsResult.getFloat("SGPA");
                            String remarks = rsResult.getString("REMARKS");
            %>
            <div class="page-header">
                <h1><i class="fas fa-poll"></i> Result Details</h1>
                <div class="header-actions">
                    <a href="editResult.jsp?result_id=<%= resultId %>" class="btn btn-edit"><i class="fas fa-edit"></i> Edit</a>
                    <a href="deleteResultServlet?result_id=<%= resultId %>" class="btn btn-delete" 
                       onclick="return confirm('Are you sure you want to delete this entire result entry?');">
                       <i class="fas fa-trash"></i> Delete
                    </a>
                    <a href="academicControl.jsp?searchRegnNo=<%= studentRegNo %>" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back</a>
                </div>
            </div>

            <div class="summary-grid">
                <div class="summary-item">Student Roll No <strong><%= studentRegNo %></strong></div>
                <div class="summary-item">Semester <strong><%= semesterNumber %></strong></div>
                <div class="summary-item">Overall SGPA <strong><%= sgpa %></strong></div>
                <div class="summary-item">Remarks <strong><%= remarks != null ? remarks : "N/A" %></strong></div>
            </div>

            <h2><i class="fas fa-book-open"></i> Subject-wise Grades</h2>
            <%-- Added table-container wrapper --%>
            <div class="table-container"> 
                <table class="grades-table">
                    <thead>
                        <tr>
                            <th>Subject ID</th>
                            <th>Subject Name</th>
                            <th>Grade</th>
                            <th>GPA</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        // Fetch grades
                        String sqlGrades = "SELECT s.SUBJECT_ID, s.SUBJECT_NAME, g.GRADE, g.GPA " + // Removed DISTINCT as RESULT_ID + SUBJECT_ID should be unique in STUDENT_GRADES
                                           "FROM STUDENT_GRADES g " +
                                           "JOIN SUBJECTS s ON g.SUBJECT_ID = s.SUBJECT_ID " +
                                           "WHERE g.RESULT_ID = ? ORDER BY s.SUBJECT_ID ASC";
                        psGrades = con.prepareStatement(sqlGrades);
                        psGrades.setInt(1, resultId);
                        rsGrades = psGrades.executeQuery();
                        boolean gradesFound = false; // Flag for grades
                        while (rsGrades.next()) {
                            gradesFound = true;
                    %>
                        <tr>
                            <td><%= rsGrades.getInt("SUBJECT_ID") %></td>
                            <td><%= rsGrades.getString("SUBJECT_NAME") %></td>
                            <td><%= rsGrades.getString("GRADE") %></td>
                            <td><%= rsGrades.getFloat("GPA") %></td>
                        </tr>
                    <%
                        } // End of grades while loop
                        
                        if (!gradesFound) { // Show message if no grades
                    %>
                            <tr><td colspan="4" style="text-align:center; font-style:italic;">No subject grades found for this result.</td></tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div> {/* End table-container */}
            <%
                        } else { // If rsResult has no next()
            %>
                 <p style="text-align: center; color: var(--error-text); margin-top: 30px;">Result not found for the provided ID.</p>
            <%            
                        }
                    } catch (NumberFormatException nfe) {
                         // Handle invalid result_id parameter
            %>
                 <p style="text-align: center; color: var(--error-text); margin-top: 30px;">Invalid Result ID provided.</p>
            <%
                    } catch (Exception e) { 
                        e.printStackTrace(); 
            %>
                 <p style="text-align: center; color: var(--error-text); margin-top: 30px;">An error occurred while retrieving result details.</p>
            <%
                    } finally {
                        // Close resources in reverse order
                        if (rsGrades != null) try { rsGrades.close(); } catch (SQLException e) {}
                        if (psGrades != null) try { psGrades.close(); } catch (SQLException e) {}
                        if (rsResult != null) try { rsResult.close(); } catch (SQLException e) {}
                        if (psResult != null) try { psResult.close(); } catch (SQLException e) {}
                        if (con != null) try { con.close(); } catch (SQLException e) {}
                    }
                } else { // If resultIdStr is null or empty
            %>
                 <p style="text-align: center; color: var(--error-text); margin-top: 30px;">No Result ID provided.</p>
            <%
                }
            %>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>

