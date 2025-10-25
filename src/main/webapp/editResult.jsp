<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection, java.util.ArrayList, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Result Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="adminHeaderFooter.css">
    <style>
        :root { 
            --primary-blue: #0056b3;
            --light-blue-bg: #f0f7ff;
            --border-color: #d1d5db;
        }
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; }
        .page-content { padding: 20px; }
        .container { max-width: 900px; margin: 20px auto; background: #fff; padding: 30px; border-radius: 8px; }
        .page-header {
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 25px;
        }
        .container h1, .container h2 { color: var(--primary-blue); margin: 0; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { margin-bottom: 8px; font-weight: 500; }
        .form-group input { padding: 12px; border: 1px solid #d1d5db; border-radius: 6px; }
        .form-group input[readonly] { background-color: #e9ecef; }
        .grades-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grades-table th, .grades-table td { padding: 12px; border: 1px solid var(--border-color); text-align: left; }
        .grades-table thead { background-color: var(--light-blue-bg); }
        .btn {
            padding: 10px 20px; border-radius: 6px; color: white; font-weight: 600; 
            text-decoration: none; background-color: var(--primary-blue); border: none; cursor: pointer;
        }
        .btn-secondary { background-color: #e5e7eb; color: #374151; }
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    <main class="page-content">
        <div class="container">
            <%
                String resultIdStr = request.getParameter("result_id");
                if (resultIdStr != null) {
                    Connection con = null;
                    PreparedStatement psResult = null;
                    ResultSet rsResult = null;
                    try {
                        con = DbConnection.getConne();
                        int resultId = Integer.parseInt(resultIdStr);

                        String sqlResult = "SELECT * FROM SEMESTER_RESULTS WHERE RESULT_ID = ?";
                        psResult = con.prepareStatement(sqlResult);
                        psResult.setInt(1, resultId);
                        rsResult = psResult.executeQuery();

                        if (rsResult.next()) {
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
                        <input type="text" value="<%= rsResult.getString("STUDENT_REGN_NO") %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>Semester</label>
                        <input type="text" value="<%= rsResult.getInt("SEMESTER_NUMBER") %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="sgpa">SGPA</label>
                        <input type="text" id="sgpa" name="sgpa" value="<%= rsResult.getFloat("SGPA") %>">
                    </div>
                    <div class="form-group">
                        <label for="remarks">Remarks</label>
                        <input type="text" id="remarks" name="remarks" value="<%= rsResult.getString("REMARKS") %>">
                    </div>
                </div>

                <h3 style="margin-top:30px;">Subject-wise Grades</h3>
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
                        PreparedStatement psGrades = con.prepareStatement(sqlGrades);
                        psGrades.setInt(1, resultId);
                        ResultSet rsGrades = psGrades.executeQuery();
                        while(rsGrades.next()) {
                    %>
                        <tr>
                            <td>
                                <%= rsGrades.getString("SUBJECT_NAME") %>
                                <input type="hidden" name="grade_ids" value="<%= rsGrades.getInt("GRADE_ID") %>">
                            </td>
                            <td><input type="text" name="grades" value="<%= rsGrades.getString("GRADE") %>"></td>
                            <td><input type="text" name="gpas" value="<%= rsGrades.getFloat("GPA") %>"></td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
                <div style="margin-top:30px; text-align:right;">
                    <button type="submit" class="btn"><i class="fas fa-save"></i> Save Changes</button>
                </div>
            </form>
            <%
                        }
                    } catch (Exception e) { e.printStackTrace(); }
                }
            %>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>