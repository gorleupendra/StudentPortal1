<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, com.example.DbConnection, java.text.SimpleDateFormat, java.util.Date"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- Added viewport meta tag for responsiveness --%>
<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
<title>Records Management</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
<%-- Assuming adminHeaderFooter.css provides base styles and variables --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/adminHeaderFooter.css">

<style>
/* Inherit variables from adminHeaderFooter.css */
:root { 
    --primary-blue: #0056b3;
    --primary-blue-hover: #004494; 
    --light-blue-bg: #f0f7ff;
    --border-color: #d1d5db; /* Lighter border */
    --text-dark: #1f2937;
    --text-medium: #4b5563;
    --success-bg: #d4edda;
    --success-text: #155724;
    --error-bg: #f8d7da;
    --error-text: #721c24;
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
    margin-bottom: 20px; 
    font-weight: 600; 
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
.alert-success { color: var(--success-text); background-color: var(--success-bg); border-color: #c3e6cb; }
.alert-error { color: var(--error-text); background-color: var(--error-bg); border-color: #f5c6cb; }

/* Form section styles */
.form-section { 
    background-color: var(--light-blue-bg); 
    padding: 25px; 
    border-radius: 8px; 
    margin: 30px 0; 
    border: 1px solid #cce5ff; 
}

/* Form group styles */
.form-group { 
    margin-bottom: 15px; /* Reduced margin */
}
.form-group label { 
    display: block;
    margin-bottom: 8px; /* Increased space */ 
    font-weight: 500; /* Adjusted weight */ 
    color: var(--text-medium); 
}
.form-group input[type="text"], .form-group input[type="file"] { 
    width: 100%; 
    padding: 12px; /* Increased padding */ 
    border: 1px solid var(--border-color); 
    border-radius: 6px; /* Rounded corners */
    box-sizing: border-box; 
    font-size: 1em;
    font-family: inherit;
    transition: border-color 0.2s, box-shadow 0.2s;
}
.form-group input:focus {
     outline: none;
     border-color: var(--primary-blue);
     box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.15);
}

/* Button styles */
.btn { 
    padding: 10px 20px; 
    border: none; 
    border-radius: 6px; 
    color: white; 
    font-weight: 500; 
    cursor: pointer; 
    transition: background-color 0.2s, transform 0.1s ease; 
    background-color: var(--primary-blue); 
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-decoration: none; /* Ensure links styled as buttons are consistent */
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
.records-table { 
    width: 100%; 
    border-collapse: collapse; 
    min-width: 700px; /* Ensure table scrolls on smaller screens */
}
.records-table th, .records-table td { 
    padding: 12px 15px; 
    border-bottom: 1px solid var(--border-color); 
    text-align: left; 
    vertical-align: middle; 
    white-space: nowrap; /* Prevent wrapping by default */
}
.records-table tr:last-child td {
     border-bottom: none; 
 }
.records-table thead { 
    background-color: var(--light-blue-bg); 
}
.records-table th { 
    color: var(--primary-blue); 
    font-weight: 600;
     border-bottom-width: 2px;
}
.records-table tbody tr:hover {
     background-color: #f8f9fa;
 }
.records-table .actions a { 
    text-decoration: none; 
    margin-right: 15px; 
    font-size: 1.1em;
    transition: opacity 0.2s;
}
 .records-table .actions a:last-child { margin-right: 0; }
 .records-table .actions a:hover { opacity: 0.7; }
.records-table .actions .view-link { color: var(--primary-blue); }
.records-table .actions .delete-link { color: var(--link-delete); }

.no-records { 
    text-align: center; 
    color: var(--text-medium); /* Use theme color */
    padding: 20px; 
    font-style: italic; 
}

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
     
    .records-table th, .records-table td {
        padding: 10px 12px; /* Reduced padding */
        /* Allow wrapping on mobile if needed, though scroll is primary */
        /* white-space: normal; */ 
    }
}
 @media (max-width: 480px) {
     .container h1 { font-size: 1.3rem; }
     .container h2 { font-size: 1.1rem; }
     .btn { padding: 8px 15px; font-size: 0.9em;}
     .form-group input, .form-group select { padding: 10px; }
 }
 
</style>
</head>
<body>
	<%@ include file="admin_header.jsp"%>

	<main class="page-content">
		<div class="container">
			<h1>
				<i class="fas fa-file-alt"></i> Records Management
			</h1>

			<%
			String status = request.getParameter("status");
			String message = request.getParameter("message");

			if (message != null && !message.isEmpty()) {
				String alertClass = "success".equals(status) ? "alert-success" : "alert-error";
			%>
			<div class="alert <%=alertClass%>">
				<%=message%>
			</div>
			<%
			}
			%>

			<div class="form-section">
				<h2>
					<i class="fas fa-upload"></i> Upload a New Record
				</h2>
				<form action="UploadRecordsForStudents" method="post"
					enctype="multipart/form-data">
					<div class="form-group">
						<label for="description">File Description</label> <input
							type="text" id="description" name="description"
							placeholder="e.g., Semester 1 Marksheet" required>
					</div>
					<div class="form-group">
						<label for="recordFile">Select File (PDF, Images recommended)</label> <input type="file"
							id="recordFile" name="recordFile" required>
					</div>
					<button type="submit" class="btn">
						<i class="fas fa-check-circle"></i> Submit Record
					</button>
				</form>
			</div>

			<h2>
				<i class="fas fa-list-ul"></i> Existing Records
			</h2>
            <%-- Added table-container wrapper for horizontal scroll --%>
			<div class="table-container"> 
                <table class="records-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Description</th>
                            <th>File Name</th>
                            <th>Upload Date & Time</th>
                            <th>View</th>
                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        Connection con = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        boolean recordsFound = false;
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");

                        try {
                            con = DbConnection.getConne();
                            String sql = "SELECT id, description, file_name, upload_date FROM student_records ORDER BY upload_date DESC";
                            stmt = con.createStatement();
                            rs = stmt.executeQuery(sql);

                            while (rs.next()) {
                                recordsFound = true;
                                int id = rs.getInt("id");
                                String description = rs.getString("description");
                                String fileName = rs.getString("file_name");
                                Timestamp uploadTimestamp = rs.getTimestamp("upload_date");
                                String formattedDate = sdf.format(uploadTimestamp);
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=description%></td>
                            <td><%=fileName%></td>
                            <td><%=formattedDate%></td>
                            <td class="actions"><a
                                href="downloadStudentRecord?id=<%=id%>" class="view-link"
                                target="_blank"><i class="fas fa-eye"></i> View</a></td>
                            <td class="actions"><a href="deleteRecord?id=<%=id%>"
                                class="delete-link"
                                onclick="return confirm('Are you sure you want to delete this record?');"><i
                                    class="fas fa-trash"></i> Delete</a></td>
                        </tr>
                        <%
                        }
                        } catch (Exception e) {
                        e.printStackTrace();
                        } finally {
                        if (rs != null)
                        try {
                            rs.close();
                        } catch (SQLException e) {
                        }
                        if (stmt != null)
                        try {
                            stmt.close();
                        } catch (SQLException e) {
                        }
                        if (con != null)
                        try {
                            con.close();
                        } catch (SQLException e) {
                        }
                        }

                        if (!recordsFound) {
                        %>
                        <tr>
                            <td colspan="6" class="no-records">No records found in the
                                database.</td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
            </div> {/* End table-container */}
		</div>
	</main>

	<%@ include file="footer.jsp"%>
</body>
</html>

