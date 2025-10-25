<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <link rel="stylesheet" href="adminHeaderFooter.css">
    
    <style>
        .page-content {
            padding: 20px;
        }
        .container { 
            max-width: 1200px; 
            margin: 20px auto; 
            background: #fff; 
            padding: 25px; 
            border-radius: 8px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1); 
        }
        .container h1, .container h2 { 
            color: #0056b3;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 6px;
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

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            color: white;
            font-weight: bold;
            text-decoration: none;
            background-color: #0056b3;
            transition: background-color 0.2s;
            border: none;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #004494;
        }
        .search-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .search-bar input[type="search"] {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .students-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 0.9em;
        }
        .students-table th, .students-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
        }
        .students-table thead {
            background-color: #e7f3fe;
        }
        .students-table th {
            color: #0056b3;
        }
        .students-table .actions a {
            text-decoration: none;
            margin-right: 10px;
        }
        .students-table .actions .view-link { color: #0056b3; }
        .students-table .actions .edit-link { color: #ffc107; }
        .students-table .actions .delete-link { color: #dc3545; }
        .no-records {
            text-align: center;
            color: #777;
            padding: 20px;
            font-style: italic;
        }
        .record-count {
            text-align: right;
            margin-top: 15px;
            color: #555;
            font-style: italic;
        }
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %> 
    
    <main class="page-content">
        <div class="container">
            <h1><i class="fas fa-users"></i> Student Management</h1>

            <%
                String status = request.getParameter("status");
                String message = request.getParameter("message");
                if (message != null && !message.isEmpty()) {
                    String alertClass = "success".equals(status) ? "alert-success" : "alert-error";
            %>
                    <div class="alert <%= alertClass %>">
                        <%= message %>
                    </div>
            <%
                }
            %>

            <div class="section-header">
                <h2><i class="fas fa-list-ul"></i> Existing Students</h2>
                <a href="studentregistration.html" class="btn"><i class="fas fa-user-plus"></i> Add New Student</a>
            </div>

            <form action="studentManagement.jsp" method="get" class="search-bar">
                <input type="search" name="search" placeholder="Search by name, regd no, email, phone, or dept..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="btn"><i class="fas fa-search"></i> Search</button>
            </form>

            <table class="students-table">
                <thead>
                    <tr>
                        <th>Regd No.</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Department</th>
                        <th>Class</th>
                        <th>View</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    boolean studentsFound = false;
                    int rowCount = 0;
                    
                    String searchQuery = request.getParameter("search");
                    
                    try {
                        con = DbConnection.getConne();
                        String sql;
                        
                        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                            sql = "SELECT regd_no, name, email, phone, dept, class FROM students WHERE name LIKE ? OR regd_no LIKE ? OR email LIKE ? OR phone LIKE ? OR dept LIKE ? ORDER BY regd_no ASC";
                            ps = con.prepareStatement(sql);
                            String searchPattern = "%" + searchQuery + "%";
                            ps.setString(1, searchPattern);
                            ps.setString(2, searchPattern);
                            ps.setString(3, searchPattern);
                            ps.setString(4, searchPattern);
                            ps.setString(5, searchPattern);
                        } else {
                            sql = "SELECT regd_no, name, email, phone, dept, class FROM students ORDER BY regd_no ASC";
                            ps = con.prepareStatement(sql);
                        }
                        
                        rs = ps.executeQuery();
                        
                        while (rs.next()) {
                            studentsFound = true;
                            rowCount++;
                            String regdNo = rs.getString("regd_no");
                            String name = rs.getString("name");
                            String email = rs.getString("email");
                            String phone = rs.getString("phone");
                            String dept = rs.getString("dept");
                            String studentClass = rs.getString("class");
                %>
                    <tr>
                        <td><%= regdNo %></td>
                        <td><%= name %></td>
                        <td><%= email %></td>
                        <td><%= phone %></td>
                        <td><%= dept %></td>
                        <td><%= studentClass %></td>
                        <td class="actions"><a href="viewStudent?regdno=<%= regdNo %>" class="view-link" title="View Details"><i class="fas fa-eye"></i></a></td>
                        <td class="actions"><a href="editStudent?regdno=<%= regdNo %>" class="edit-link" title="Edit"><i class="fas fa-edit"></i></a></td>
                        <td class="actions"><a href="deleteStudent?regdno=<%= regdNo %>" class="delete-link" title="Delete" onclick="return confirm('Are you sure you want to delete student <%= regdNo %>?');"><i class="fas fa-trash"></i></a></td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) {}
                        if (ps != null) try { ps.close(); } catch (SQLException e) {}
                        if (con != null) try { con.close(); } catch (SQLException e) {}
                    }
                    if (!studentsFound) {
                %>
                        <tr>
                            <td colspan="9" class="no-records">No students found.</td>
                        </tr>
                <%
                    }
                %>
                </tbody>
            </table>

            <% if (studentsFound) { %>
                <p class="record-count">Total Records Found: <%= rowCount %></p>
            <% } %>

        </div>
    </main>

     <%@ include file="footer.jsp" %> 
</body>
</html>