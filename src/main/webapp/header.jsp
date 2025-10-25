<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId1 = (String) session.getAttribute("regdno");
    String userName1 = (String) session.getAttribute("userName");
    if (userId1 == null || userId1.isEmpty()) {
        response.sendRedirect("login.html");
        return;
    }

    String currentPage = request.getRequestURI();
%>

<header class="main-header">
    <nav class="header-nav">
        <a href="studentpage.jsp" class="<%= currentPage.endsWith("studentpage.jsp") ? "active" : "" %>">
            <i class="fas fa-home"></i> Home
        </a>	
        <a href="studentDetails.jsp" class="<%= currentPage.endsWith("studentDetails.jsp") ? "active" : "" %>">
            Student Details
        </a>
        <a href="results.jsp" class="<%= currentPage.endsWith("results.jsp") ? "active" : "" %>">
            Results
        </a>
    </nav>
    
    <div class="welcome-text">
        <h2><strong><%= userName1 %></strong></h2>
    </div>

    <div class="user-info-area">
        <img src="getphoto.jsp?id=<%= userId1 %>" alt="User Photo" class="user-photo" 
             onerror="this.onerror=null; this.src='images/default-avatar.png';">
        
        <a href="logout.jsp" class="logout-button">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</header>