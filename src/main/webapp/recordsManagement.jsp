<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, com.example.DbConnection, java.text.SimpleDateFormat, java.util.Date"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Records Management</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="adminHeaderFooter.css">

<style>
:root {

	--primary-blue: #0056b3;
	--light-blue-bg: #e7f3fe;
	--border-color: #ddd;
}

.page-content {
	flex: 1;
	padding: 20px;
}

.container {
	max-width: 900px;
	margin: 20px auto;
	background: #fff;
	padding: 25px;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.container h1, .container h2 {
	color: var(--primary-blue);
	border-bottom: 2px solid #eee;
	padding-bottom: 10px;
}

.alert {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px;
	font-size: 1em;
}

.alert-success {
	color: #155724;
	background-color: #d4edda;
	border-color: #c3e6cb;
}

.alert-error {
	color: #721c24;
	background-color: #f8d7da;
	border-color: #f5c6cb;
}

.form-section {
	background-color: var(--light-blue-bg);
	padding: 25px;
	border-radius: 8px;
	margin: 30px 0;
	border: 1px solid #cce5ff;
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
	color: #555;
}

.form-group input[type="text"], .form-group input[type="file"] {
	width: 100%;
	padding: 10px;
	border: 1px solid var(--border-color);
	border-radius: 5px;
	box-sizing: border-box;
}

.btn {
	padding: 10px 20px;
	border: none;
	border-radius: 5px;
	color: white;
	font-weight: bold;
	cursor: pointer;
	transition: background-color 0.2s;
	background-color: var(--primary-blue);
}

.btn:hover {
	background-color: #004494;
}

.records-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

.records-table th, .records-table td {
	padding: 12px;
	border: 1px solid var(--border-color);
	text-align: left;
	vertical-align: middle;
}

.records-table thead {
	background-color: var(--light-blue-bg);
}

.records-table th {
	color: var(--primary-blue);
}

.records-table .actions a {
	text-decoration: none;
	margin-right: 15px;
	white-space: nowrap;
}
/* Style for the new "View" link */
.records-table .actions .view-link {
	color: var(--primary-blue);
}
/* Style for the existing "Delete" link */
.records-table .actions .delete-link {
	color: #dc3545;
}

.no-records {
	text-align: center;
	color: #777;
	padding: 20px;
	font-style: italic;
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
						<label for="recordFile">Select File</label> <input type="file"
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
		</div>
	</main>

	<%@ include file="footer.jsp"%>
</body>
</html>