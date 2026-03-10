<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection, java.util.ArrayList, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Edit Result Details</title>
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
            --disabled-bg: #e9ecef; /* Added for readonly */
            --text-dark: #1f2937;
            --text-medium: #4b5563;
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
            font-size: 1.8rem; /* Adjusted size */
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }
        .container h2, .container h3 { /* Style for subheadings */
             color: var(--text-dark); 
             margin-top: 30px;
             margin-bottom: 15px; 
             font-size: 1.3rem;
             font-weight: 600;
             border-bottom: 1px solid #eee;
             padding-bottom: 8px;
         }
        
        /* Form grid for semester details */
        .form-grid { 
            display: grid; 
            grid-template-columns: 1fr 1fr; /* Default 2 columns */ 
            gap: 20px; 
        }
        
        /* Form group styles */
        .form-group { 
            display: flex; 
            flex-direction: column; 
        }
        .form-group label { 
            margin-bottom: 8px; 
            font-weight: 500; 
            color: var(--text-medium);
            font-size: 0.9em;
        }
        .form-group input { 
            padding: 12px; 
            border: 1px solid var(--border-color); 
            border-radius: 6px; 
            font-size: 1em;
            font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box; /* Include padding in width */
            width: 100%; /* Ensure inputs take full width */
        }
        .form-group input:focus {
             outline: none;
             border-color: var(--primary-blue);
             box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.15);
         }
        .form-group input[readonly] { 
            background-color: var(--disabled-bg); 
            cursor: not-allowed;
            color: var(--text-medium);
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
            min-width: 500px; /* Ensure table scrolls if needed */
        }
        .grades-table th, .grades-table td { 
            padding: 12px 15px; 
            border-bottom: 1px solid var(--border-color); 
            text-align: left; 
            vertical-align: middle;
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
         /* Input fields inside the table */
         .grades-table td input[type="text"] {
             padding: 8px 10px; /* Smaller padding */
             font-size: 0.95em;
             border-radius: 4px;
         }
        
        /* Button styles */
        .btn {
            padding: 10px 20px; 
            border-radius: 6px; 
            color: white; 
            font-weight: 500; 
            text-decoration: none; 
            background-color: var(--primary-blue); 
            border: none; 
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background-color 0.2s, transform 0.1s ease;
            font-size: 0.95em;
        }
        .btn-secondary { 
            background-color: #e5e7eb; 
            color: var(--text-dark); 
        }
         .btn:hover {
             transform: translateY(-1px);
         }
         .btn-primary:hover {
             background-color: var(--primary-blue-hover);
         }
         .btn-secondary:hover {
             background-color: #d1d5db;
         }
         .btn:active {
             transform: translateY(0);
         }
         
         /* Button alignment */
         .button-wrapper {
             margin-top: 30px; 
             text-align: right; /* Align button to the right */
         }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 20px; /* Reduced padding */
                margin: 15px auto;
            }
            .page-header h1 {
                font-size: 1.5em; /* Smaller heading */
            }
            .form-grid {
                grid-template-columns: 1fr; /* Stack to single column */
                gap: 15px; /* Adjust vertical gap */
            }
             .button-wrapper {
                 text-align: center; /* Center button */
             }
             .btn {
                 width: 100%; /* Make button full width */
                 justify-content: center;
             }
              .page-header .btn-secondary { /* Keep back button smaller */
                  width: auto;
              }
        }
         @media (max-width: 480px) {
             .container h1 { font-size: 1.3em; }
             .btn { padding: 10px 15px; font-size: 0.9em; }
             .grades-table th, .grades-table td { padding: 8px 10px; }
         }

    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    <main class="page-content">
        <div class="container">
            <%
                String resultIdStr = request.getParameter("result_id");
                Connection con = null; // Declare con outside try
                PreparedStatement psResult = null;
                ResultSet rsResult = null;
                PreparedStatement psGrades = null; // Declare psGrades outside try
                ResultSet rsGrades = null; // Declare rsGrades outside try

                if (resultIdStr != null && !resultIdStr.trim().isEmpty()) {
                    try {
                        con = DbConnection.getConne();
                        int resultId = Integer.parseInt(resultIdStr);

                        String sqlResult = "SELECT STUDENT_REGN_NO, SEMESTER_NUMBER, SGPA, REMARKS FROM SEMESTER_RESULTS WHERE RESULT_ID = ?"; // Optimized query
                        psResult = con.prepareStatement(sqlResult);
                        psResult.setInt(1, resultId);
                        rsResult = psResult.executeQuery();

                        if (rsResult.next()) {
                            String studentRegnNo = rsResult.getString("STUDENT_REGN_NO");
                            int semesterNumber = rsResult.getInt("SEMESTER_NUMBER");
                            float sgpa = rsResult.getFloat("SGPA");
                            String remarks = rsResult.getString("REMARKS");
            %>
            <div class="page-header">
                <h1><i class="fas fa-edit"></i> Edit Result</h1>
                <a href="viewResultDetails.jsp?result_id=<%= resultId %>" class="btn btn-secondary"><i class="fas fa-times"></i> Cancel</a>
            </div>
            
            <form action="updateResultServlet" method="post">
                <input type="hidden" name="result_id" value="<%= resultId %>">

                <h3>Overall Semester Details</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Student Roll No.</label>
                        <input type="text" value="<%= studentRegnNo %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>Semester</label>
                        <input type="text" value="<%= semesterNumber %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="sgpa">SGPA</label>
                        <input type="number" step="0.01" id="sgpa" name="sgpa" value="<%= sgpa %>" required> <%-- Changed to number --%>
                    </div>
                    <div class="form-group">
                        <label for="remarks">Remarks</label>
                        <input type="text" id="remarks" name="remarks" value="<%= remarks %>">
                    </div>
                </div>

                <h3>Subject-wise Grades</h3>
                <%-- Added table-container wrapper --%>
                <div class="table-container"> 
                    <table class="grades-table">
                        <thead>
                            <tr>
                                <th>Subject</th>
                                <th>Grade</th>
                                <th>GPA</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            String sqlGrades = "SELECT g.GRADE_ID, s.SUBJECT_NAME, g.GRADE, g.GPA " +
                                               "FROM STUDENT_GRADES g JOIN SUBJECTS s ON g.SUBJECT_ID = s.SUBJECT_ID " +
                                               "WHERE g.RESULT_ID = ? ORDER BY s.SUBJECT_ID ASC";
                            psGrades = con.prepareStatement(sqlGrades);
                            psGrades.setInt(1, resultId);
                            rsGrades = psGrades.executeQuery();
                            boolean gradesFound = false; // Flag for grades
                            while(rsGrades.next()) {
                                gradesFound = true;
                        %>
                            <tr>
                                <td>
                                    <%= rsGrades.getString("SUBJECT_NAME") %>
                                    <input type="hidden" name="grade_ids" value="<%= rsGrades.getInt("GRADE_ID") %>">
                                </td>
                                <td><input type="text" name="grades" value="<%= rsGrades.getString("GRADE") %>" required></td>
                                <td><input type="number" step="0.01" name="gpas" value="<%= rsGrades.getFloat("GPA") %>" required></td> <%-- Changed to number --%>
                            </tr>
                        <%
                            }
                            if (!gradesFound) { // Show message if no grades
                        %>
                                <tr><td colspan="3" style="text-align:center; font-style:italic;">No subject grades found for this result.</td></tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                
                <div class="button-wrapper">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Changes</button>
                </div>
            </form>
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
                        // Close resources in reverse order of opening
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

