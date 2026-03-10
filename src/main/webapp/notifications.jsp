<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date, com.example.DbConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Notifications - Admin</title>
    
    <%-- Reusing existing styles --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/header/style.css">
    
    <%-- New CSS for this admin page --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminHeaderFooter.css">
    <style>
    /* * CSS for Admin Panel (notifications.jsp)
 * This reuses variables from your main layout.css
 */

.admin-container {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 2rem;
}

.admin-card {
    background-color: #ffffff;
    border-radius: 0.75rem;
    border: 1px solid var(--border-color, #e5e7eb);
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.05);
    padding: 2rem;
}

.admin-card h1 {
    font-size: 1.75rem;
    font-weight: 600;
    color: var(--text-dark, #1f2937);
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.admin-card h1 i {
    color: var(--primary-blue, #3b82f6);
}

/* Form Styles */
.admin-form {
    display: flex;
    flex-direction: column;
    gap: 1.25rem;
}

.form-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}

.form-group label {
    font-weight: 500;
    color: var(--text-dark, #1f2937);
}

.form-group input[type="text"],
.form-group textarea,
.form-group input[type="file"] {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 1px solid var(--border-color, #d1d5db);
    border-radius: 0.375rem;
    font-size: 1rem;
    font-family: 'Inter', sans-serif;
    transition: border-color 0.2s, box-shadow 0.2s;
}

.form-group input[type="file"] {
    padding: 0.5rem;
    cursor: pointer;
}

.form-group input[type="file"]::file-selector-button {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 0.25rem;
    background-color: var(--text-medium, #6b7280);
    color: white;
    font-weight: 500;
    cursor: pointer;
    margin-right: 0.75rem;
    transition: background-color 0.2s;
}

.form-group input[type="file"]::file-selector-button:hover {
    background-color: var(--text-dark, #1f2937);
}

.form-group input[type="text"]:focus,
.form-group textarea:focus {
    outline: none;
    border-color: var(--primary-blue, #3b82f6);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
}

.form-group-checkbox {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.form-group-checkbox input[type="checkbox"] {
    width: 1.15rem;
    height: 1.15rem;
    accent-color: var(--primary-blue, #3b82f6);
}

/* Button Styles */
.admin-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    padding: 0.75rem 1.25rem;
    border: none;
    border-radius: 0.375rem;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.2s, transform 0.1s;
}

.admin-btn.primary {
    background-color: var(--primary-blue, #3b82f6);
    color: white;
}
.admin-btn.primary:hover {
    background-color: var(--primary-blue-hover, #2563eb);
}

.admin-btn.danger {
    background-color: var(--error-color, #ef4444);
    color: white;
    font-size: 0.875rem; /* Make delete button smaller */
    padding: 0.4rem 0.6rem;
}
.admin-btn.danger:hover {
    background-color: #dc2626; /* Darker red */
}

/* Table Styles */
.notification-table-container {
    width: 100%;
    overflow-x: auto; /* Allow horizontal scroll on small screens */
    border: 1px solid var(--border-color, #d1d5db);
    border-radius: 0.375rem;
}

.notification-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
}

.notification-table th,
.notification-table td {
    padding: 0.75rem 1rem;
    border-bottom: 1px solid var(--border-color, #d1d5db);
    vertical-align: middle;
}

.notification-table th {
    background-color: #f9fafb; /* Light gray header */
    font-weight: 600;
    color: var(--text-medium, #4b5563);
    font-size: 0.875rem;
    text-transform: uppercase;
}

.notification-table td {
    color: var(--text-dark, #1f2937);
    font-size: 0.9rem;
}

.notification-table tr:last-child td {
    border-bottom: none;
}

.notification-table tr:hover {
    background-color: #f9fafb;
}
    
    </style>
</head>
<body>

    <%-- Include the header --%>
    <%@ include file="admin_header.jsp" %>

    <%-- Main content area --%>
    <main class="main-content">
        <div class="admin-container">
            
            <!-- Section 1: Add New Notification -->
            <div class="admin-card">
                <h1><i class="fa-solid fa-plus-circle"></i> Add New Notification</h1>
                
                <form action="${pageContext.request.contextPath}/notificationAdmin" method="POST" enctype="multipart/form-data" class="admin-form">
                    
                    <input type="hidden" name="action" value="add">
                    
                    <div class="form-group">
                        <label for="title">Title</label>
                        <input type="text" id="title" name="title" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="body">Body (Short Description)</label>
                        <textarea id="body" name="body" rows="3"></textarea>
                    </div>

                    <!-- NEW: Link Type Toggle -->
                    <div class="form-group">
                        <label>Link Type</label>
                        <div class="radio-toggle">
                            <input type="radio" id="typeFile" name="linkType" value="file" checked>
                            <label for="typeFile">Upload File</label>
                            <input type="radio" id="typeLink" name="linkType" value="link">
                            <label for="typeLink">External Link</label>
                        </div>
                    </div>

                    <!-- NEW: External Link Field (hidden by default) -->
                    <div class="form-group" id="externalLinkGroup" style="display: none;">
                        <label for="link">External URL (e.g., https://...)</label>
                        <input type="text" id="link" name="link" placeholder="https://example.com/page">
                    </div>
                    
                    <!-- UPDATED: File Upload Field (now toggleable) -->
                    <div class="form-group" id="fileUploadGroup">
                        <label for="fileUpload">Notification File (PDF, JPG, etc.)</label>
                        <input type="file" id="fileUpload" name="fileUpload">
                    </div>
                    
                    <div class="form-group">
                        <label for="link_text">Link Text (e.g., "Download PDF", "Click Here")</label>
                        <input type="text" id="link_text" name="link_text" required>
                    </div>
                    
                    <div class="form-group-checkbox">
                        <input type="checkbox" id="is_new" name="is_new" value="true" checked>
                        <label for="is_new">Mark as "New"</label>
                    </div>
                    
                    <button type="submit" class="admin-btn primary"><i class="fa-solid fa-upload"></i> Upload Notification</button>
                </form>
            </div>
            
            <!-- Section 2: Manage Existing Notifications -->
            <div class="admin-card">
                <h1><i class="fa-solid fa-list-check"></i> Existing Notifications</h1>
                
                <div class="notification-table-container">
                    <table class="notification-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Date</th>
                                <th>Link/File</th>
                                <th>New?</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                Statement stmt = null;
                                ResultSet rs = null;
                                SimpleDateFormat displayDateFormatter = new SimpleDateFormat("MMM dd, yyyy");

                                try {
                                    conn = DbConnection.getConne();
                                    stmt = conn.createStatement();
                                    // UPDATED: Select 'link' and 'file_name'
                                    String sql = "SELECT id, title, date_published, file_name, is_new, link,link_text FROM notification ORDER BY date_published DESC";
                                    rs = stmt.executeQuery(sql);

                                    if (!rs.isBeforeFirst()) {
                            %>
                                        <tr><td colspan="5">No notifications found.</td></tr>
                            <%
                                    } else {
                                        while(rs.next()) {
                                            int id = rs.getInt("id");
                                            String title = rs.getString("title");
                                            Date date = rs.getDate("date_published");
                                            String fileName = rs.getString("file_name");
                                            String link = rs.getString("link");
                                            String linkText = rs.getString("link_text");
                                            boolean isNew = rs.getBoolean("is_new");
                                            
                                            // Show either the link or the file name
                                            String linkDisplay = "";
                                            if (link != null && !link.isEmpty()) {
                                                linkDisplay = link;
                                            } else if (fileName != null && !fileName.isEmpty()) {
                                                linkDisplay = fileName;
                                            } else {
                                                linkDisplay = "N/A";
                                            }
                            %>
                                            <tr>
                                                <td><%= title %></td>
                                                <td><%= displayDateFormatter.format(date) %></td>
                                                <td style="word-break: break-all;"> <%
                                    if (link != null && !link.trim().isEmpty()) {
                                %>
                                        <%-- If YES, show external link in a new tab --%>
                                        <a href="<%= link %>" target="_blank" rel="noopener noreferrer">
                                            <%= linkText %> <i class="fa-solid fa-external-link-alt"></i>
                                        </a>
                                <%
                                    } else {
                                %>
                                        <%-- If NO, show the internal download link --%>
                                        <a href="${pageContext.request.contextPath}/downloadNotification?id=<%= id %>">
                                            <%= linkText %> <i class="fa-solid fa-download"></i>
                                        </a>
                                <%
                                    }
                                %></td>
                                                <td><%= (isNew ? "Yes" : "No") %></td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/notificationAdmin" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="notificationId" value="<%= id %>">
                                                        <button type="submit" class="admin-btn danger"><i class="fa-solid fa-trash-alt"></i></button>
                                                    </form>
                                                </td>
                                            </tr>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                                    if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
            
        </div>
    </main>

    <%-- Include the footer --%>
    <%@ include file="footer.jsp" %>

    <!-- NEW: JavaScript to toggle inputs -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const typeFile = document.getElementById('typeFile');
            const typeLink = document.getElementById('typeLink');
            const fileGroup = document.getElementById('fileUploadGroup');
            const linkGroup = document.getElementById('externalLinkGroup');
            const fileInput = document.getElementById('fileUpload');
            const linkInput = document.getElementById('link');

            function toggleInputs() {
                if (typeFile.checked) {
                    // Show File, Hide Link
                    fileGroup.style.display = 'block';
                    linkGroup.style.display = 'none';
                    fileInput.required = true; // Make file upload required
                    linkInput.required = false; // Make link not required
                    linkInput.value = ''; // Clear the other input
                } else {
                    // Show Link, Hide File
                    fileGroup.style.display = 'none';
                    linkGroup.style.display = 'block';
                    fileInput.required = false; // Make file upload not required
                    linkInput.required = true; // Make link required
                    fileInput.value = ''; // Clear the other input
                }
            }
            
            // Add event listeners to radio buttons
            typeFile.addEventListener('change', toggleInputs);
            typeLink.addEventListener('change', toggleInputs);
            
            // Run on page load to set the correct initial state
            toggleInputs();
        });
    </script>

</body>
</html>

