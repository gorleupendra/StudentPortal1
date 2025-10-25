<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection, java.util.ArrayList, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Academic Control</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="adminHeaderFooter.css">
    
    <style>
        /* (Your existing CSS remains the same) */
        :root { 
            --primary-blue: #0056b3;
            --light-blue-bg: #f0f7ff;
            --border-color: #d1d5db;
        }
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; }
        .page-content { padding: 20px; }
        .container { max-width: 900px; margin: 20px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .container h1, .container h2 { color: var(--primary-blue); border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .alert { padding: 15px; margin-bottom: 20px; border: 1px solid transparent; border-radius: 6px; }
        .alert-success { color: #155724; background-color: #d4edda; }
        .alert-error { color: #721c24; background-color: #f8d7da; }
        .form-section { background-color: var(--light-blue-bg); padding: 25px; border-radius: 8px; margin: 30px 0; border: 1px solid #cce5ff; }
        .form-group { display: flex; flex-direction: column; margin-bottom: 20px; }
        .form-group label { margin-bottom: 8px; font-weight: 500; }
        .form-group input, .form-group select { padding: 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 1em; }
        .btn { padding: 10px 20px; border-radius: 6px; color: white; font-weight: 600; text-decoration: none; background-color: var(--primary-blue); border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; }
        .custom-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .custom-table th, .custom-table td { padding: 12px; border: 1px solid var(--border-color); text-align: left; }
        .custom-table thead { background-color: var(--light-blue-bg); }
        .custom-table .actions a { text-decoration: none; margin-right: 15px; }
        .custom-table .actions .edit-link { color: #ffc107; }
        .custom-table .actions .delete-link { color: #dc3545; }
        .info-box {
            background-color: #f8f9fa; border-left: 4px solid var(--primary-blue); padding: 15px;
            margin-top: 10px; font-family: monospace; font-size: 0.9em; color: #333;
            white-space: pre-wrap; border-radius: 0 4px 4px 0;
        }
        .search-bar { display: grid; grid-template-columns: 2fr 1fr auto; gap: 10px; margin-bottom: 20px; align-items: flex-end; }
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
                    <a href="data:text/csv;charset=utf-8,<%= java.net.URLEncoder.encode(sampleCsvContent, "UTF-8") %>" download="sample-results.csv" style="margin-top:10px; display:inline-block;">
                       <i class="fas fa-download"></i> Download Sample Template
                    </a>
                </div>
            </div>
            
            <div class="form-section" style="background-color:#fff; border: 1px solid #ddd;">
                <h2><i class="fas fa-search"></i> View Student Results</h2>
                <form action="academicControl.jsp" method="get" class="search-bar">
                    <div class="form-group" style="margin:0;">
                        <label for="searchRegnNo">Student Roll Number</label>
                        <input type="search" id="searchRegnNo" name="searchRegnNo" placeholder="Enter Roll Number..." 
                               value="<%= request.getParameter("searchRegnNo") != null ? request.getParameter("searchRegnNo") : "" %>" required>
                    </div>
                    <div class="form-group" style="margin:0;">
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
                                <td><a href="viewResultDetails.jsp?result_id=<%= rs.getInt("RESULT_ID") %>" class="btn">View Details</a></td>
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
                <%
                    }
                %>
            </div>

            <div class="form-section">
                <h2><i class="fas fa-book"></i> Manage Subjects</h2>
                <form action="addSubjectServlet" method="post" style="display:grid; grid-template-columns: 1fr 2fr auto; gap: 15px; align-items: flex-end;">
                    <div class="form-group" style="margin:0;">
                        <label for="subjectId">Subject ID</label>
                        <input type="number" id="subjectId" name="subject_id" required>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label for="subjectName">Subject Name</label>
                        <input type="text" id="subjectName" name="subject_name" required>
                    </div>
                    <button type="submit" class="btn"><i class="fas fa-plus-circle"></i> Add</button>
                </form>

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
                            while (rsSubjects.next()) {
                    %>
                        <tr>
                            <td><%= rsSubjects.getInt("SUBJECT_ID") %></td>
                            <td><%= rsSubjects.getString("SUBJECT_NAME") %></td>
                            <td class="actions">
                                <a href="editSubject.jsp?id=<%= rsSubjects.getInt("SUBJECT_ID") %>" class="edit-link" title="Edit"><i class="fas fa-edit"></i> Edit</a>
                                <a href="deleteSubjectServlet?id=<%= rsSubjects.getInt("SUBJECT_ID") %>" class="delete-link" title="Delete" onclick="return confirm('Are you sure?');"><i class="fas fa-trash"></i> Delete</a>
                            </td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) { e.printStackTrace(); }
                    %>
                    </tbody>
                </table>
            </div>

        </div>
    </main>
    <%@ include file="footer.jsp" %> 
</body>
</html>