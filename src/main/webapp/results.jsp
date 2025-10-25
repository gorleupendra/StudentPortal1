<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<%
    // --- 1. Session Security Check ---
    String userId = (String) session.getAttribute("regdno");
    if (userId == null || userId.isEmpty()) {
        response.sendRedirect("login.html");
        return; 
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Results - Student Portal</title>
    <link rel="stylesheet" href="studentHeaderFooter.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
        }
        .page-content {
            padding: 100px 20px 20px 20px;
            min-height: calc(100vh - 180px);
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .container h1 {
            color: #0056b3;
            text-align: center;
            margin-bottom: 35px;
        }
        .semester-block {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .semester-header {
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 15px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .semester-header h2 {
            color: #343a40;
            margin: 0;
        }
        .semester-summary {
            text-align: right;
        }
        .semester-summary .cgpa {
            font-size: 1.2em;
            font-weight: bold;
            color: #28a745;
        }
        .semester-summary .remarks {
            font-size: 0.9em;
            color: #6c757d;
        }
        .results-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 1.1em;
        }
        .results-table th, .results-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .results-table thead th {
            background-color: #0056b3;
            color: white;
            font-weight: 600;
        }
        .results-table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .results-table tbody tr:hover {
            background-color: #e9ecef;
        }
        .no-results {
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            font-size: 1.2em;
            color: #6c757d;
            border: 2px dashed #ddd;
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
                boolean resultsFound = false;

                try {
                    con = DbConnection.getConne();
                    
                    String semestersSQL = "SELECT result_id, semester_number, sgpa, remarks FROM semester_results WHERE student_regn_no = ? ORDER BY semester_number";
                    psSemesters = con.prepareStatement(semestersSQL);
                    psSemesters.setString(1, userId);
                    rsSemesters = psSemesters.executeQuery();
                    
                    while (rsSemesters.next()) {
                        resultsFound = true;
                        int resultId = rsSemesters.getInt("result_id");
                        int semesterNumber = rsSemesters.getInt("semester_number");
                        double sgpa = rsSemesters.getDouble("sgpa");
                        String remarks = rsSemesters.getString("remarks");
            %>
                        <div class="semester-block">
                            <div class="semester-header">
                                <h2>Semester <%= semesterNumber %> Results</h2>
                                <div class="semester-summary">
                                    <div class="cgpa">SGPA: <%= String.format("%.2f", sgpa) %></div>
                                    <div class="remarks"><%= remarks %></div>
                                </div>
                            </div>
                            
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
                                    try {
                                        // FIX: Replaced DISTINCT with GROUP BY and MAX() for a more robust solution
                                        String gradesSQL = "SELECT s.subject_name, MAX(sg.grade) AS grade, MAX(sg.gpa) AS gpa " +
                                                         "FROM student_grades sg JOIN subjects s ON sg.subject_id = s.subject_id " +
                                                         "WHERE sg.result_id = ? " +
                                                         "GROUP BY s.subject_id, s.subject_name " +
                                                         "ORDER BY s.subject_id";
                                                         
                                        psGrades = con.prepareStatement(gradesSQL);
                                        psGrades.setInt(1, resultId);
                                        rsGrades = psGrades.executeQuery();

                                        while (rsGrades.next()) {
                                %>
                                            <tr>
                                                <td><%= rsGrades.getString("subject_name") %></td>
                                                <td><%= rsGrades.getString("grade") %></td>
                                                <td><%= rsGrades.getInt("gpa") %></td>
                                            </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (rsGrades != null) rsGrades.close();
                                        if (psGrades != null) psGrades.close();
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
            <%
                    } 
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rsSemesters != null) rsSemesters.close();
                    if (psSemesters != null) psSemesters.close();
                    if (con != null) con.close();
                }
                
                if (!resultsFound) {
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