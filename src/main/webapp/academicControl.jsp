<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection, java.util.ArrayList, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Academic Control</title>
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
            --success-bg: #d4edda;
            --success-text: #155724;
            --error-bg: #f8d7da;
            --error-text: #721c24;
            --link-edit: #ffc107;
            --link-delete: #dc3545;
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
        .container h1, .container h2 { 
            color: var(--primary-blue); 
            border-bottom: 2px solid #eee; 
            padding-bottom: 10px; 
            margin-bottom: 20px; /* Added consistent margin */
            font-weight: 600; /* Bolder headings */
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
         .container h1 { font-size: 1.8rem; }
         .container h2 { font-size: 1.4rem; }

        /* Alert styles */
        .alert { 
            padding: 15px; 
            margin-bottom: 20px; 
            border: 1px solid transparent; 
            border-radius: 6px; 
        }
        .alert-success { color: var(--success-text); background-color: var(--success-bg); }
        .alert-error { color: var(--error-text); background-color: var(--error-bg); }
        
        /* Form section styles */
        .form-section { 
            background-color: var(--light-blue-bg); 
            padding: 25px; 
            border-radius: 8px; 
            margin: 30px 0; 
            border: 1px solid #cce5ff; 
        }
        .form-section.plain-bg { /* Style for white background section */
             background-color:#fff; 
             border: 1px solid #ddd;
        }

        /* Form group styles */
        .form-group { 
            display: flex; 
            flex-direction: column; 
            margin-bottom: 20px; 
        }
        .form-group label { 
            margin-bottom: 8px; 
            font-weight: 500; 
            color: var(--text-medium); /* Use theme color */
        }
        .form-group input, .form-group select { 
            padding: 12px; 
            border: 1px solid var(--border-color); /* Use theme color */
            border-radius: 6px; 
            font-size: 1em; 
            font-family: inherit; /* Inherit body font */
            transition: border-color 0.2s, box-shadow 0.2s;
        }
         .form-group input:focus, .form-group select:focus {
             outline: none;
             border-color: var(--primary-blue);
             box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.15);
         }

        /* Button styles */
        .btn { 
            padding: 10px 20px; 
            border-radius: 6px; 
            color: white; 
            font-weight: 500; /* Adjusted weight */ 
            text-decoration: none; 
            background-color: var(--primary-blue); 
            border: none; 
            cursor: pointer; 
            display: inline-flex; 
            align-items: center; 
            gap: 8px; 
            transition: background-color 0.2s, transform 0.1s ease;
        }
         .btn:hover {
             background-color: var(--primary-blue-hover);
             transform: translateY(-1px);
         }
         .btn:active {
             transform: translateY(0);
         }

        /* Table styles */
        .table-container { /* Added wrapper for scrolling */
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            margin-top: 20px;
        }
        .custom-table { 
            width: 100%; 
            border-collapse: collapse; 
            min-width: 600px; /* Ensure table scrolls */
        }
        .custom-table th, .custom-table td { 
            padding: 12px 15px; /* Consistent padding */ 
            border-bottom: 1px solid var(--border-color); /* Only bottom border */
            text-align: left; 
            vertical-align: middle; /* Align content nicely */
        }
         .custom-table tr:last-child td {
             border-bottom: none; /* Remove border on last row */
         }
        .custom-table thead { 
            background-color: var(--light-blue-bg); 
        }
         .custom-table th {
             font-weight: 600; /* Bolder header */
             color: var(--primary-blue);
             border-bottom-width: 2px;
         }
         .custom-table tbody tr:hover {
             background-color: #f8f9fa; /* Subtle hover */
         }
        .custom-table .actions a { 
            text-decoration: none; 
            margin-right: 15px; 
            font-size: 1.1em; /* Slightly larger icons */
            transition: opacity 0.2s;
        }
        .custom-table .actions a:last-child { margin-right: 0; }
        .custom-table .actions a:hover { opacity: 0.7; }
        .custom-table .actions .edit-link { color: var(--link-edit); }
        .custom-table .actions .delete-link { color: var(--link-delete); }
        
        /* Info box for CSV format */
        .info-box {
            background-color: #f8f9fa; 
            border-left: 4px solid var(--primary-blue); 
            padding: 15px;
            margin-top: 10px; 
            font-family: monospace; 
            font-size: 0.9em; 
            color: #333;
            white-space: pre-wrap; 
            border-radius: 0 4px 4px 0;
            word-break: break-all; /* Prevent overflow */
        }
        
        /* Search bar styles */
        .search-bar { 
            display: grid; 
            /* Default grid for desktop */
            grid-template-columns: 2fr 1fr auto; 
            gap: 15px; /* Increased gap */ 
            margin-bottom: 25px; /* Increased margin */
            align-items: flex-end; 
        }
        .search-bar .form-group { margin: 0; } /* Remove bottom margin inside grid */

        /* Add Subject Form Styles */
        .add-subject-form {
             display: grid; 
             /* Default grid for desktop */
             grid-template-columns: 1fr 2fr auto; 
             gap: 15px; 
             align-items: flex-end;
        }
         .add-subject-form .form-group { margin: 0; }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 20px; /* Reduced padding */
                margin: 15px auto;
            }
            .container h1 { font-size: 1.5rem; }
            .container h2 { font-size: 1.25rem; }

            .form-section {
                padding: 20px; /* Reduced padding */
            }

            .search-bar, .add-subject-form {
                grid-template-columns: 1fr; /* Stack elements vertically */
            }
             .search-bar button, .add-subject-form button {
                 width: 100%; /* Make buttons full width */
                 justify-content: center;
             }
             
            .custom-table th, .custom-table td {
                padding: 10px 12px; /* Reduced padding */
            }
        }
         @media (max-width: 480px) {
             .container h1 { font-size: 1.3rem; }
             .container h2 { font-size: 1.1rem; }
             .btn { padding: 8px 15px; }
         }

    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %> 
    <main class="page-content">
        <div class="container">
            <h1><i class="fas fa-university"></i> Academic Control</h1>

            <%
                String status = request.getParameter("status");
                String message = request.getParameter("message");
                if (message != null) {
            %>
                    <div class="alert <%= "success".equals(status) ? "alert-success" : "alert-error" %>">
                        <%= message %>
                    </div>
            <%
                }
            %>

            <div class="form-section">
                <h2><i class="fas fa-file-csv"></i> Upload Semester Results</h2>
                <form action="uploadComprehensiveCsvServlet" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="resultsFile">Select Comprehensive CSV File</label>
                        <input type="file" id="resultsFile" name="resultsFile" accept=".csv" required>
                    </div>
                    <button type="submit" class="btn"><i class="fas fa-upload"></i> Upload File</button>
                </form>
                <div style="margin-top:20px;">
                    <p><strong>CSV Format Instructions:</strong> (Header row is required)</p>
                    <div class="info-box">STUDENT_REGN_NO,SEMESTER_NUMBER,SGPA,REMARKS,SUBJECT_ID,SUBJECT_NAME,GRADE,GPA
424207321014,1,9.2,Pass,1,Artificial Intelligence,A+,9.8</div>
                    <%
                        String sampleCsvContent = "STUDENT_REGN_NO,SEMESTER_NUMBER,SGPA,REMARKS,SUBJECT_ID,SUBJECT_NAME,GRADE,GPA\n424207321014,1,9.2,Pass,1,Artificial Intelligence,A+,9.8";
                    %>
                    <a href="data:text/csv;charset=utf-8,<%= java.net.URLEncoder.encode(sampleCsvContent, "UTF-8") %>" download="sample-results.csv" style="margin-top:10px; display:inline-block;" class="btn">
                       <i class="fas fa-download"></i> Download Sample Template
                    </a>
                </div>
            </div>
            
            <%-- Added plain-bg class for white background --%>
            <div class="form-section plain-bg"> 
                <h2><i class="fas fa-search"></i> View Student Results</h2>
                <form action="academicControl.jsp" method="get" class="search-bar">
                    <div class="form-group">
                        <label for="searchRegnNo">Student Roll Number</label>
                        <input type="search" id="searchRegnNo" name="searchRegnNo" placeholder="Enter Roll Number..." 
                               value="<%= request.getParameter("searchRegnNo") != null ? request.getParameter("searchRegnNo") : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="semester">Semester</label>
                        <select id="semester" name="semester">
                            <option value="">All Semesters</option>
                            <% 
                                String selectedSem = request.getParameter("semester");
                                for(int i = 1; i <= 8; i++) {
                                    String selected = (selectedSem != null && selectedSem.equals(String.valueOf(i))) ? "selected" : "";
                            %>
                                    <option value="<%= i %>" <%= selected %>>Semester <%= i %></option>
                            <% } %>
                        </select>
                    </div>
                    <button type="submit" class="btn"><i class="fas fa-search"></i> Search</button>
                </form>

                <%
                    String searchRegnNo = request.getParameter("searchRegnNo");
                    String semesterFilter = request.getParameter("semester");
                    if (searchRegnNo != null && !searchRegnNo.isEmpty()) {
                %>
                    <%-- Added table-container wrapper --%>
                    <div class="table-container"> 
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Result ID</th>
                                    <th>Semester</th>
                                    <th>SGPA</th>
                                    <th>Remarks</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                try (Connection con = DbConnection.getConne()) {
                                    StringBuilder sqlBuilder = new StringBuilder("SELECT RESULT_ID, SEMESTER_NUMBER, SGPA, REMARKS FROM SEMESTER_RESULTS WHERE STUDENT_REGN_NO = ?");
                                    List<Object> params = new ArrayList<>();
                                    params.add(searchRegnNo);

                                    if (semesterFilter != null && !semesterFilter.isEmpty()) {
                                        sqlBuilder.append(" AND SEMESTER_NUMBER = ?");
                                        params.add(Integer.parseInt(semesterFilter));
                                    }
                                    sqlBuilder.append(" ORDER BY SEMESTER_NUMBER ASC");
                                    
                                    PreparedStatement ps = con.prepareStatement(sqlBuilder.toString());
                                    for(int i = 0; i < params.size(); i++) {
                                        ps.setObject(i + 1, params.get(i));
                                    }

                                    ResultSet rs = ps.executeQuery();
                                    boolean resultsFound = false;
                                    while (rs.next()) {
                                        resultsFound = true;
                            %>
                                <tr>
                                    <td><%= rs.getInt("RESULT_ID") %></td>
                                    <td><%= rs.getInt("SEMESTER_NUMBER") %></td>
                                    <td><%= rs.getFloat("SGPA") %></td>
                                    <td><%= rs.getString("REMARKS") %></td>
                                    <%-- Changed button to link for consistency --%>
                                    <td><a href="viewResultDetails.jsp?result_id=<%= rs.getInt("RESULT_ID") %>" class="btn" style="padding: 5px 10px; font-size: 0.9em;">View Details</a></td>
                                </tr>
                            <%
                                    }
                                    if (!resultsFound) {
                            %>
                                    <tr><td colspan="5" style="text-align:center; font-style:italic;">No results found for this criteria.</td></tr>
                            <%
                                    }
                                } catch (Exception e) { e.printStackTrace(); }
                            %>
                            </tbody>
                        </table>
                    </div> {/* End table-container */}
                <%
                    }
                %>
            </div>

            <div class="form-section">
                <h2><i class="fas fa-book"></i> Manage Subjects</h2>
                <form action="addSubjectServlet" method="post" class="add-subject-form">
                    <div class="form-group">
                        <label for="subjectId">Subject ID</label>
                        <input type="number" id="subjectId" name="subject_id" required>
                    </div>
                    <div class="form-group">
                        <label for="subjectName">Subject Name</label>
                        <input type="text" id="subjectName" name="subject_name" required>
                    </div>
                    <button type="submit" class="btn"><i class="fas fa-plus-circle"></i> Add</button>
                </form>

                <%-- Added table-container wrapper --%>
                <div class="table-container"> 
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Subject Name</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            try (Connection con = DbConnection.getConne()) {
                                Statement stmt = con.createStatement();
                                ResultSet rsSubjects = stmt.executeQuery("SELECT SUBJECT_ID, SUBJECT_NAME FROM SUBJECTS ORDER BY SUBJECT_ID ASC");
                                boolean subjectsFound = false; // Added flag
                                while (rsSubjects.next()) {
                                    subjectsFound = true; // Set flag
                        %>
                            <tr>
                                <td><%= rsSubjects.getInt("SUBJECT_ID") %></td>
                                <td><%= rsSubjects.getString("SUBJECT_NAME") %></td>
                                <td class="actions">
                                    <a href="editSubject.jsp?id=<%= rsSubjects.getInt("SUBJECT_ID") %>" class="edit-link" title="Edit"><i class="fas fa-edit"></i> Edit</a>
                                    <a href="deleteSubjectServlet?id=<%= rsSubjects.getInt("SUBJECT_ID") %>" class="delete-link" title="Delete" onclick="return confirm('Are you sure you want to delete this subject?');"><i class="fas fa-trash"></i> Delete</a>
                                </td>
                            </tr>
                        <%
                                }
                                if (!subjectsFound) { // Check flag
                        %>
                                    <tr><td colspan="3" style="text-align:center; font-style:italic;">No subjects found. Add one above.</td></tr>
                        <%
                                }
                            } catch (Exception e) { e.printStackTrace(); }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>
    <%@ include file="footer.jsp" %> 
</body>
</html>
