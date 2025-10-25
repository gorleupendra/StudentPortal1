<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // --- Security Check ---
    String adminId = (String) session.getAttribute("regdno");
    if (adminId == null || !"admin".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
        response.sendRedirect("login.html?error=auth");
        return;
    }
    
    // To display messages after submission
    String message = request.getParameter("message");
    String status = request.getParameter("status");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Shared Record - Admin</title>
    <link rel="stylesheet" href="adminHeaderFooter.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .form-container { max-width: 700px; margin: 30px auto; padding: 0 20px; }
        .form-card { background-color: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); padding: 35px; }
        .form-card h1 { text-align: center; color: #2c3e50; margin-top: 0; margin-bottom: 25px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; }
        .form-group textarea, .form-group input[type="file"] {
            width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 5px; font-size: 1em; box-sizing: border-box;
        }
        .form-group textarea { resize: vertical; min-height: 100px; }
        .submit-btn {
            width: 100%; padding: 15px; background-color: #27ae60; color: white; border: none;
            border-radius: 5px; font-size: 1.1em; font-weight: 700; cursor: pointer; transition: opacity 0.2s;
            display: flex; align-items: center; justify-content: center; gap: 10px;
        }
        .submit-btn:hover { opacity: 0.9; }
        .message { text-align: center; padding: 15px; margin-bottom: 20px; border-radius: 5px; font-weight: 500; }
        .message.success { background-color: #d4edda; color: #155724; }
        .message.error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body class="admin-body">
    <%@ include file="admin_header.jsp" %>
    <main class="form-container">
        <div class="form-card">
            <h1><i class="fas fa-cloud-upload-alt"></i> Upload Shared Record</h1>
            
            <% if (message != null) { %>
                <div class="message <%= "success".equals(status) ? "success" : "error" %>">
                    <%= message %>
                </div>
            <% } %>

            <form action="uploadSharedRecord" method="post" enctype="multipart/form-data">
                
                <div class="form-group">
                    <label for="description">Record Description</label>
                    <textarea id="description" name="description" required placeholder="e.g., General Timetable, List of Holidays..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="file">Select File</label>
                    <input type="file" id="file" name="file" required>
                </div>
                
                <button type="submit" class="submit-btn">
                    <i class="fas fa-upload"></i> Upload Record
                </button>
            </form>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>