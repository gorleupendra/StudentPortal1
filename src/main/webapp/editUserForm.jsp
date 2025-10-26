<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Edit User</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Assuming adminHeaderFooter.css provides base styles and variables --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminHeaderFooter.css">
    
    <style>
        /* Inherit variables from adminHeaderFooter.css */
        :root { 
            --primary-blue: #0056b3;
            --primary-blue-hover: #004494; 
            --border-color: #d1d5db;
            --disabled-bg: #e9ecef;
            --text-dark: #1f2937;
            --text-medium: #4b5563;
        }
       
        /* Container styles */
        .container { 
            max-width: 800px; 
            margin: 20px auto; 
            background: #fff; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        }
        
        /* Form Header */
        .form-header {
            display: flex; 
            flex-wrap: wrap; /* Allow wrapping */
            justify-content: space-between; 
            align-items: center;
            border-bottom: 2px solid var(--border-color); 
            padding-bottom: 15px; 
            margin-bottom: 30px;
            gap: 15px; /* Add gap */
        }
        .form-header h1 { 
            color: var(--primary-blue); 
            font-size: 1.8em; 
            margin: 0; 
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        /* Form grid (single column by default) */
        .form-grid {
            display: grid; 
            grid-template-columns: 1fr; /* Default to single column */ 
            gap: 20px;
        }
        
        /* Form group */
        .form-group { 
            display: flex; 
            flex-direction: column; 
        }
        .form-group label {
            margin-bottom: 8px; 
            font-weight: 500; 
            color: var(--text-medium); 
            font-size: 0.9em;
        }
        .form-group input, .form-group select {
            width: 100%; 
            padding: 12px; 
            border: 1px solid var(--border-color);
            border-radius: 6px; 
            box-sizing: border-box; 
            font-size: 1em;
            font-family: inherit;
            transition: all 0.2s ease-in-out;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none; 
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.15); /* Adjusted shadow */
        }
        .form-group input[readonly] {
            background-color: var(--disabled-bg); 
            cursor: not-allowed;
            color: var(--text-medium);
        }
        
        /* Button group */
        .button-group {
            margin-top: 30px; 
            display: flex; 
            justify-content: flex-end; /* Align right on desktop */ 
            gap: 15px;
        }
        .btn {
            padding: 12px 25px; 
            border: none; 
            border-radius: 6px; 
            font-weight: 500; /* Adjusted weight */
            cursor: pointer; 
            text-decoration: none; 
            display: inline-flex;
            align-items: center; 
            gap: 8px; 
            transition: background-color 0.2s, transform 0.1s ease;
            font-size: 0.95em;
        }
        .btn-primary { 
            background-color: var(--primary-blue); 
            color: white; 
        }
        .btn-primary:hover { 
            background-color: var(--primary-blue-hover); 
            transform: translateY(-1px);
        }
        .btn-secondary { 
            background-color: #e5e7eb; 
            color: var(--text-dark); 
        }
        .btn-secondary:hover { 
            background-color: #d1d5db; 
            transform: translateY(-1px);
        }
         .btn:active {
             transform: translateY(0);
         }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 20px; /* Reduced padding */
                margin: 15px auto;
            }
            .form-header h1 {
                font-size: 1.5em; /* Smaller heading */
            }
             .button-group {
                 justify-content: center; /* Center buttons */
             }
             .btn {
                 flex-grow: 1; /* Allow buttons to grow */
                 justify-content: center; /* Center button text/icon */
             }
             .form-header .btn-secondary { /* Keep back button smaller */
                 flex-grow: 0; 
             }
        }
         @media (max-width: 480px) {
             .container h1 { font-size: 1.3em; }
             .btn { padding: 10px 20px; font-size: 0.9em; }
             .button-group {
                 flex-direction: column; /* Stack buttons vertically */
                 align-items: stretch; /* Make buttons full width */
             }
             .form-header .btn-secondary { /* Ensure back button is full width too */
                 width: 100%;
             }
         }
         
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    <main class="page-content">
        <div class="container">
            <div class="form-header">
                <h1><i class="fas fa-user-edit"></i> Edit User</h1>
                <a href="userManagement.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to List</a>
            </div>
            
            <c:if test="${userData != null}">
                <form action="updateUser" method="post">
                    <div class="form-grid">
                        <input type="hidden" name="id" value="${userData.id}">

                        <div class="form-group">
                            <label>User ID</label>
                            <input type="text" value="${userData.id}">
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
                                <%-- Add other roles if needed --%>
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
                <p style="text-align: center; color: var(--error-text); margin-top: 30px;">Could not find user data.</p> {/* Improved message */}
            </c:if>
        </div>
    </main>
    <%@ include file="footer.jsp" %> 
</body>
</html>
