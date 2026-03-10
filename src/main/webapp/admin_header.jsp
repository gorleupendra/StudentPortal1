<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminName = (String) session.getAttribute("userName");
    // Redirect to logout if session is invalid or user is not an admin
    if (adminName == null || "student".equals(adminName)) {
        response.sendRedirect("logout.jsp");
        return;
    }
%>

<header class="admin-header">
    <div class="header-title">
        <i class="fas fa-shield-alt"></i>
        <h1>Admin Portal</h1>
    </div>
    <div class="header-user-info">
        <a href="admin_dashboard.jsp" class="header-button">
            <i class="fas fa-home"></i> Home
        </a>
        <span class="welcome-message">Welcome, <strong><%= adminName %></strong></span>
        <a href="logout.jsp" class="header-button logout-button">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</header>