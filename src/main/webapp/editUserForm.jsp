<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit User</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="adminHeaderFooter.css">
    <style>
        /* (Your existing admin theme styles go here) */
        :root { 
            --primary-blue: #0056b3;
            --border-color: #d1d5db;
            --disabled-bg: #e9ecef;
            --text-dark: #1f2937;
            --text-medium: #4b5563;
        }
        body { font-family: Arial, sans-serif; margin: 0; display: flex; flex-direction: column; background-color: #f4f4f4; color: #333; }
        .page-content { flex: 1; padding: 20px; }
        .container { 
            max-width: 800px; margin: 20px auto; background: #fff; padding: 30px; 
            border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        }
        .form-header {
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 2px solid var(--border-color); padding-bottom: 15px; margin-bottom: 30px;
        }
        .form-header h1 { color: var(--primary-blue); font-size: 1.8em; margin: 0; }
        .form-grid {
            display: grid; grid-template-columns: 1fr; gap: 20px;
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
        .form-group input[readonly] {
            background-color: var(--disabled-bg); cursor: not-allowed;
        }
        .button-group {
            margin-top: 30px; display: flex; justify-content: flex-end; gap: 15px;
        }
        .btn {
            padding: 12px 25px; border: none; border-radius: 6px; font-weight: 600;
            cursor: pointer; text-decoration: none; display: inline-flex;
            align-items: center; gap: 8px; transition: background-color 0.2s;
        }
        .btn-primary { background-color: var(--primary-blue); color: white; }
        .btn-primary:hover { background-color: #004494; }
        .btn-secondary { background-color: #e5e7eb; color: var(--text-dark); }
        .btn-secondary:hover { background-color: #d1d5db; }
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    <main class="page-content">
        <div class="container">
            <div class="form-header">
                <h1><i class="fas fa-edit"></i> Edit User</h1>
                <a href="userManagement.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to List</a>
            </div>
            
            <c:if test="${userData != null}">
                <form action="updateUser" method="post">
                    <div class="form-grid">
                        <input type="hidden" name="id" value="${userData.id}">

                        <div class="form-group">
                            <label>User ID</label>
                            <input type="text" value="${userData.id}" readonly>
                        </div>
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="${userData.name}" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${userData.email}" required>
                        </div>
                        <div class="form-group">
                            <label for="role">Role</label>
                            <select id="role" name="role" required>
                                <option value="admin" ${userData.role == 'admin' ? 'selected' : ''}>Admin</option>
                                <option value="staff" ${userData.role == 'staff' ? 'selected' : ''}>Staff</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="password">New Password (Optional)</label>
                            <input type="password" id="password" name="password" placeholder="Leave blank to keep current password">
                        </div>
                    </div>
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Changes</button>
                    </div>
                </form>
            </c:if>
            <c:if test="${userData == null}">
                <p>Could not find user data.</p>
            </c:if>
        </div>
    </main>
    <%@ include file="footer.jsp" %> 
</body>
</html>