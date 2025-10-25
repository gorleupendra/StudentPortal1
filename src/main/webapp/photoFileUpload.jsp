<%@ page import="java.sql.*, com.example.DbConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String status = request.getParameter("status");
    String displayMessage = request.getParameter("msg");
    String nextRegdNoFromUrl = request.getParameter("nextRegd");
    String nextStudentNameFromUrl = request.getParameter("nextName");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Student Photo Upload</title>
    <style>
        body { font-family: sans-serif; display: flex; flex-direction: column; align-items: center; padding-top: 20px; background-color: #f0f2f5; }
        .page-container { width: 90%; max-width: 700px; }
        .container { text-align: center; margin-bottom: 2rem; padding: 1.5rem; background-color: white; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        h1, h2 { color: #1c1e21; }
        h3 { color: #606770; margin-top: 0; }
        input[type="file"] { display: block; margin: 1rem auto; }
        input[type="submit"] { width: 100%; padding: 12px; background-color: #1877f2; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; }
        .completion-message { font-size: 1.5rem; color: #4CAF50; }
        .message-box { padding: 15px; margin-bottom: 20px; border-radius: 5px; font-weight: bold; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
    </style>
    <script>
        window.addEventListener("DOMContentLoaded", () => {
            const status = "<%= status %>";
            const nextRegd = "<%= nextRegdNoFromUrl != null ? nextRegdNoFromUrl : "" %>";
            const nextName = "<%= nextStudentNameFromUrl != null ? nextStudentNameFromUrl : "" %>";

            if (status === "success" && nextRegd) {
                setTimeout(() => {
                    window.location.href = "photoFileUpload.jsp?nextRegd=" + nextRegd + "&nextName=" + encodeURIComponent(nextName);
                }, 1500);
            }
        });
    </script>
</head>
<body>
    <div class="page-container">
        <h1>Student Document Upload</h1>

        <% if (displayMessage != null && !displayMessage.isEmpty()) { %>
            <div class="message-box <%= "success".equals(status) ? "success" : "error" %>">
                <%= displayMessage %>
            </div>
        <% } %>

        <%
            boolean foundStudent = false;
            String studentRegdNo = null;
            String studentName = null;

            // Use try-with-resources for automatic resource management
            try (Connection conn_fetch = DbConnection.getConne()) {
                if (nextRegdNoFromUrl != null && !"null".equals(nextRegdNoFromUrl)) {
                    studentRegdNo = nextRegdNoFromUrl;
                    studentName = nextStudentNameFromUrl;
                    foundStudent = true;
                } else {
                    // CHANGED: Use PostgreSQL's length() function for BYTEA columns
                    String fetchSql = "SELECT regd_no, name FROM students WHERE photo IS NULL OR length(photo) = 0 ORDER BY regd_no ASC";
                    
                    try (PreparedStatement pstmt_fetch = conn_fetch.prepareStatement(fetchSql);
                         ResultSet rs = pstmt_fetch.executeQuery()) {
                        
                        if (rs.next()) {
                            studentRegdNo = rs.getString("regd_no");
                            studentName = rs.getString("name");
                            foundStudent = true;
                        }
                    }
                }

                if (foundStudent) {
        %>
        <div class="container">
            <h3>Student: <%= studentName %> (<%= studentRegdNo %>)</h3>
            <%-- The form now POSTs to the '/uploadphoto' servlet URL --%>
            <form method="post" action="uploadphoto" enctype="multipart/form-data">
                <input type="hidden" name="regd_no" value="<%= studentRegdNo %>">
                <input type="hidden" name="student_name" value="<%= studentName %>">
                <input type="file" name="fileToUpload" required>
                <input type="submit" value="Upload">
            </form>
        </div>
        <%
                } else {
        %>
            <div class="container">
                <h2 class="completion-message">✅ All Uploads Are Complete!</h2>
            </div>
        <%
                }
            } catch (Exception e) {
                out.println("<div class='message-box error'>Error fetching student data: " + e.getMessage() + "</div>");
                e.printStackTrace();
            }
        %>
    </div>
</body>
</html>