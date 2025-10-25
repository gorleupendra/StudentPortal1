<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="adminHeaderFooter.css">
    
    <style>
        :root { 
            --primary-blue: #0056b3;
            --light-blue-bg: #f0f7ff;
            --border-color: #d1d5db;
            --text-dark: #1f2937;
            --text-medium: #4b5563;
        }
        html, body { height: 100%; }
        body { font-family: Arial, sans-serif; margin: 0; display: flex; flex-direction: column; background-color: #f4f4f4; color: #333; }
        .page-content { flex: 1; padding: 20px; }
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
        }
        .alert {
            padding: 15px; margin-bottom: 20px; border: 1px solid transparent;
            border-radius: 6px; font-size: 1em;
        }
        .alert-success { color: #155724; background-color: #d4edda; border-color: #c3e6cb; }
        .alert-error { color: #721c24; background-color: #f8d7da; border-color: #f5c6cb; }
        .form-section {
            background-color: var(--light-blue-bg); padding: 25px; border-radius: 8px;
            margin: 30px 0; border: 1px solid #cce5ff;
        }
        .form-grid {
            display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px 30px;
        }
        .form-group { display: flex; flex-direction: column; }
        .form-group label {
            margin-bottom: 8px; font-weight: 500; color: var(--text-medium); font-size: 0.9em;
        }
        .form-group input, .form-group select {
            width: 100%; padding: 12px; border: 1px solid var(--border-color);
            border-radius: 6px; box-sizing: border-box; font-size: 1em;
            transition: all 0.2s ease-in-out;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none; border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }
        .section-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;
        }
        .btn {
            padding: 10px 20px; border-radius: 6px; color: white; font-weight: 600;
            text-decoration: none; background-color: var(--primary-blue);
            transition: background-color 0.2s; border: none; cursor: pointer;
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn:hover { background-color: #004494; }
        .search-bar { display: flex; gap: 10px; margin-bottom: 20px; }
        .search-bar input[type="search"] {
            flex-grow: 1; padding: 10px; border: 1px solid var(--border-color); border-radius: 5px;
        }
        .users-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .users-table th, .users-table td {
            padding: 12px; border: 1px solid var(--border-color);
            text-align: left; vertical-align: middle;
        }
        .users-table thead { background-color: var(--light-blue-bg); }
        .users-table th { color: var(--primary-blue); }
        .users-table .actions a {
            text-decoration: none; margin-right: 15px; white-space: nowrap;
        }
        .users-table .actions .edit-link { color: #ffc107; }
        .users-table .actions .delete-link { color: #dc3545; }
        .no-records { text-align: center; color: #777; padding: 20px; font-style: italic; }
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %> 
    
    <main class="page-content">
        <div class="container">
            <h1><i class="fas fa-user-shield"></i> User Management</h1>

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

            <div class="form-section">
                <h2><i class="fas fa-user-plus"></i> Add New User</h2>
                <form action="addUserServlet" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="id">User ID</label>
                            <input type="text" id="id" name="id" required>
                        </div>
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" required>
                        </div>
                        <div class="form-group">
                            <label for="role">Role</label>
                            <select id="role" name="role" required>
                                <option value="admin">Admin</option>
                                <option value="staff">Staff</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required>
                        </div>
                    </div>
                     <div style="margin-top: 20px;">
                         <button type="submit" class="btn"><i class="fas fa-check-circle"></i> Add User</button>
                    </div>
                </form>
            </div>

            <div class="section-header">
                <h2><i class="fas fa-list-ul"></i> Existing Users</h2>
            </div>
            
            <form action="userManagement.jsp" method="get" class="search-bar">
                <input type="search" name="search" placeholder="Search by Id, name, or email..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="btn"><i class="fas fa-search"></i> Search</button>
            </form>

            <table class="users-table">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    boolean usersFound = false;
                    
                    String searchQuery = request.getParameter("search");
                    
                    try {
                        con = DbConnection.getConne();
                        String sql;
                        
                        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                            // CORRECTED: Search uses 'id' instead of 'regd_no'
                            sql = "SELECT id, name, email, role FROM users WHERE name LIKE ? OR email LIKE ? OR id LIKE ? ORDER BY id ASC";
                            ps = con.prepareStatement(sql);
                            String searchPattern = "%" + searchQuery + "%";
                            ps.setString(1, searchPattern);
                            ps.setString(2, searchPattern);
                            ps.setString(3, searchPattern);
                        } else {
                            // CORRECTED: Selects 'id' and orders by 'id'
                            sql = "SELECT id, name, email, role FROM users ORDER BY id ASC";
                            ps = con.prepareStatement(sql);
                        }
                        
                        rs = ps.executeQuery();
                        
                        while (rs.next()) {
                            usersFound = true;
                            // CORRECTED: Gets 'id' as an integer
                            int id = rs.getInt("id");
                            String name = rs.getString("name");
                            String email = rs.getString("email");
                            String role = rs.getString("role");
                %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= name %></td>
                        <td><%= email %></td>
                        <td><%= role %></td>
                        <td class="actions">
                            <a href="editUser?id=<%= id %>" class="edit-link" title="Edit"><i class="fas fa-edit"></i></a>
                            <a href="deleteUser?id=<%= id %>" class="delete-link" title="Delete" onclick="return confirm('Are you sure you want to delete user <%= name %>?');"><i class="fas fa-trash"></i></a>
                        </td>
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
                    if (!usersFound) {
                %>
                        <tr>
                            <td colspan="5" class="no-records">No users found.</td>
                        </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </main>

     <%@ include file="footer.jsp" %> 
</body>
</html>