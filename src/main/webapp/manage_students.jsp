<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<%
    // --- 1. Security Check ---
    String adminId = (String) session.getAttribute("regdno");
    if (adminId == null || !"admin".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
        response.sendRedirect("login.html?error=auth");
        return;
    }

    // --- 2. Handle DELETE Action ---
    // This code runs before the page loads to process any delete requests.
    String action = request.getParameter("action");
    if ("delete".equals(action)) {
        int recordIdToDelete = Integer.parseInt(request.getParameter("id"));
        
        Connection delCon = null;
        PreparedStatement delPs = null;
        try {
            delCon = DbConnection.getConne();
            String delSql = "DELETE FROM student_records WHERE id = ?";
            delPs = delCon.prepareStatement(delSql);
            delPs.setInt(1, recordIdToDelete);
            delPs.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (delPs != null) delPs.close();
            if (delCon != null) delCon.close();
        }
        
        // Redirect to prevent re-deleting on page refresh
        response.sendRedirect("manage_records.jsp?status=deleted");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Shared Records</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="adminHeaderFooter.css">
    <style>
        :root {
            --primary-color: #2c3e50; --secondary-color: #3498db; --background-color: #ecf0f1;
            --card-bg: #ffffff; --text-color: #34495e; --shadow: 0 4px 15px rgba(0,0,0,0.1);
            --green-action: #27ae60; --red-action: #e74c3c;
        }
        body.admin-body { font-family: 'Roboto', sans-serif; margin: 0; background-color: var(--background-color); }
        .management-container { max-width: 1200px; margin: 30px auto; padding: 30px; background-color: var(--card-bg); border-radius: 10px; box-shadow: var(--shadow); }
        .management-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid var(--background-color); padding-bottom: 20px; }
        .management-header h1 { margin: 0; }
        .btn { text-decoration: none; color: white; padding: 10px 15px; border-radius: 5px; font-weight: 500; display: inline-flex; align-items: center; gap: 8px; border: none; cursor: pointer; }
        .btn-add { background-color: var(--green-action); }
        .btn-small { padding: 6px 12px; font-size: 0.9em; }
        .btn-view { background-color: var(--secondary-color); }
        .btn-delete { background-color: var(--red-action); }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th, .data-table td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        .data-table thead th { background-color: var(--primary-color); color: white; }
        .data-table tbody tr:hover { background-color: #f1f5f8; }
        .actions-cell { display: flex; gap: 10px; }
        .no-data { text-align: center; font-size: 1.2em; color: #777; padding: 40px; }
    </style>
</head>
<body class="admin-body">
    <%@ include file="admin_header.jsp" %>
    <main class="management-container">
        <div class="management-header">
            <h1><i class="fas fa-folder-open"></i> Manage Shared Records</h1>
            <a href="upload_record.jsp" class="btn btn-add"><i class="fas fa-plus"></i> Upload New Record</a>
        </div>

        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Description</th>
                    <th>File Name</th>
                    <th>Upload Date & Time</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                Connection con = null;
                Statement stmt = null;
                ResultSet rs = null;
                boolean recordsFound = false;
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm a");

                try {
                    con = DbConnection.getConne();
                    String sql = "SELECT id, description, file_name, upload_date FROM student_records ORDER BY upload_date DESC";
                    stmt = con.createStatement();
                    rs = stmt.executeQuery(sql);

                    while (rs.next()) {
                        recordsFound = true;
                        int recordId = rs.getInt("id");
            %>
                <tr>
                    <td><%= recordId %></td>
                    <td><%= rs.getString("description") %></td>
                    <td><%= rs.getString("file_name") %></td>
                    <td><%= sdf.format(rs.getTimestamp("upload_date")) %></td>
                    <td class="actions-cell">
                        <a href="downloadStudentRecord?id=<%= recordId %>" class="btn btn-small btn-view" target="_blank"><i class="fas fa-eye"></i> View</a>
                        <a href="manage_records.jsp?action=delete&id=<%= recordId %>" class="btn btn-small btn-delete" onclick="return confirm('Are you sure you want to delete this record?');"><i class="fas fa-trash"></i> Delete</a>
                    </td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                }
                
                if (!recordsFound) {
            %>
                <tr>
                    <td colspan="5" class="no-data">No shared records have been uploaded yet.</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>