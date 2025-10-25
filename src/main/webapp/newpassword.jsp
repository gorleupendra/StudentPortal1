<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Password</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <!-- Display email (readonly) -->
    <p>Email: <b><%= request.getAttribute("email") %></b></p>
    
    <form action="ChangePasswordServlet" method="post">
        <!-- Hidden input to send email to servlet -->
        <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
        
        <h2>New Password</h2>
        <input type="password" name="newpass" placeholder="Enter new password" required>
        <input type="password" name="currpass" placeholder="Retype the password" required>
        <input type="submit" value="Change Password">
    </form>
</div>
</body>
</html>
