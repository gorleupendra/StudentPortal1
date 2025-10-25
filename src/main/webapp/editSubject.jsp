<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Subject</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="adminHeaderFooter.css">
    <style>
        /* (Your standard admin theme CSS goes here) */
         body { font-family: Arial, sans-serif; background-color: #f4f4f4; }
        .page-content { flex: 1; padding: 20px; }
        .container { max-width: 800px; margin: 20px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .container h1 { color: #0056b3; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .form-group { display: flex; flex-direction: column; margin-bottom: 20px; }
        .form-group label { margin-bottom: 8px; font-weight: 500; }
        .form-group input { width: 100%; padding: 12px; border: 1px solid #d1d5db; border-radius: 6px; }
        .btn { padding: 12px 25px; border-radius: 6px; color: white; font-weight: 600; text-decoration: none; background-color: #0056b3; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    <main class="page-content">
        <div class="container">
            <h1><i class="fas fa-edit"></i> Edit Subject</h1>
            <%
                String subjectId = request.getParameter("id");
                String subjectName = "";
                try (Connection con = DbConnection.getConne()) {
                    String sql = "SELECT SUBJECT_NAME FROM SUBJECTS WHERE SUBJECT_ID = ?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(subjectId));
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        subjectName = rs.getString("SUBJECT_NAME");
                    }
                } catch (Exception e) { e.printStackTrace(); }
            %>
            <form action="updateSubjectServlet" method="post">
                <input type="hidden" name="subject_id" value="<%= subjectId %>">
                <div class="form-group">
                    <label>Subject ID</label>
                    <input type="text" value="<%= subjectId %>" readonly>
                </div>
                <div class="form-group">
                    <label for="subjectName">Subject Name</label>
                    <input type="text" id="subjectName" name="subject_name" value="<%= subjectName %>" required>
                </div>
                <button type="submit" class="btn"><i class="fas fa-save"></i> Save Changes</button>
            </form>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>