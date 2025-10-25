<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Result Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="adminHeaderFooter.css">
    <style>
        :root { 
            --primary-blue: #0056b3;
            --light-blue-bg: #f0f7ff;
            --border-color: #d1d5db;
            --edit-color: #ffc107;
            --delete-color: #dc3545;
        }
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; }
        .page-content { padding: 20px; }
        .container { max-width: 900px; margin: 20px auto; background: #fff; padding: 30px; border-radius: 8px; }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .header-actions {
            display: flex;
            gap: 10px;
        }
        .container h1, .container h2 { color: var(--primary-blue); margin: 0; }
        .summary-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .summary-item { 
            background-color: var(--light-blue-bg); padding: 20px; border-radius: 8px; 
            text-align: center; border: 1px solid #cce5ff;
        }
        .summary-item strong { display: block; font-size: 1.2em; color: var(--primary-blue); margin-top: 5px; }
        .grades-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grades-table th, .grades-table td { padding: 12px; border: 1px solid var(--border-color); text-align: left; }
        .grades-table thead { background-color: var(--light-blue-bg); }
        .btn {
            padding: 8px 15px; border-radius: 6px; font-weight: 600; text-decoration: none;
            display: inline-flex; align-items: center; gap: 8px; border: 1px solid transparent;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-secondary { background-color: #e5e7eb; color: #374151; border-color: var(--border-color); }
        .btn-secondary:hover { background-color: #d1d5db; }
        .btn-edit { background-color: var(--edit-color); color: white; }
        .btn-edit:hover { background-color: #e0a800; }
        .btn-delete { background-color: var(--delete-color); color: white; }
        .btn-delete:hover { background-color: #c82333; }
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    <main class="page-content">
        <div class="container">
            <%
                String resultIdStr = request.getParameter("result_id");
                if (resultIdStr != null && !resultIdStr.isEmpty()) {
                    Connection con = null;
                    PreparedStatement psResult = null;
                    ResultSet rsResult = null;
                    PreparedStatement psGrades = null;
                    ResultSet rsGrades = null;

                    try {
                        con = DbConnection.getConne();
                        int resultId = Integer.parseInt(resultIdStr);

                        String sqlResult = "SELECT * FROM SEMESTER_RESULTS WHERE RESULT_ID = ?";
                        psResult = con.prepareStatement(sqlResult);
                        psResult.setInt(1, resultId);
                        rsResult = psResult.executeQuery();

                        if (rsResult.next()) {
                            String studentRegNo = rsResult.getString("STUDENT_REGN_NO");
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
                <div class="summary-item">Semester <strong><%= rsResult.getInt("SEMESTER_NUMBER") %></strong></div>
                <div class="summary-item">Overall SGPA <strong><%= rsResult.getFloat("SGPA") %></strong></div>
                <div class="summary-item">Remarks <strong><%= rsResult.getString("REMARKS") %></strong></div>
            </div>

            <h2><i class="fas fa-book-open"></i> Subject-wise Grades</h2>
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
                    String sqlGrades = "SELECT DISTINCT s.SUBJECT_ID, s.SUBJECT_NAME, g.GRADE, g.GPA " +
                                       "FROM STUDENT_GRADES g " +
                                       "JOIN SUBJECTS s ON g.SUBJECT_ID = s.SUBJECT_ID " +
                                       "WHERE g.RESULT_ID = ? ORDER BY s.SUBJECT_ID ASC";
                    psGrades = con.prepareStatement(sqlGrades);
                    psGrades.setInt(1, resultId);
                    rsGrades = psGrades.executeQuery();
                    while (rsGrades.next()) {
                %>
                    <tr>
                        <td><%= rsGrades.getInt("SUBJECT_ID") %></td>
                        <td><%= rsGrades.getString("SUBJECT_NAME") %></td>
                        <td><%= rsGrades.getString("GRADE") %></td>
                        <td><%= rsGrades.getFloat("GPA") %></td>
                    </tr>
                <%
                    } // End of grades while loop
                %>
                </tbody>
            </table>
            <%
                        } else {
                            out.println("<p>No result found for the given ID.</p>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>An error occurred while fetching data.</p>");
                    } finally {
                        if (rsGrades != null) try { rsGrades.close(); } catch (SQLException e) {}
                        if (psGrades != null) try { psGrades.close(); } catch (SQLException e) {}
                        if (rsResult != null) try { rsResult.close(); } catch (SQLException e) {}
                        if (psResult != null) try { psResult.close(); } catch (SQLException e) {}
                        if (con != null) try { con.close(); } catch (SQLException e) {}
                    }
                } else {
                    out.println("<p>Result ID is missing.</p>");
                }
            %>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>