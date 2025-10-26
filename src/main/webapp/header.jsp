<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Renamed variables to avoid conflict if included in other pages
    String studentHeaderUserId = (String) session.getAttribute("regdno");
    String studentHeaderUserName = (String) session.getAttribute("userName");
    String studentHeaderContextPath=request.getContextPath();
    
    // Redirect if not logged in
    if (studentHeaderUserId == null || studentHeaderUserId.isEmpty()) {
        response.sendRedirect(studentHeaderContextPath +"/login/login.jsp");
        return;
    }
    
    // Default name if session attribute is missing
    if (studentHeaderUserName == null || studentHeaderUserName.isEmpty()) {
        studentHeaderUserName = "Student"; 
    }

    // Get current page to highlight active link
    String currentPage = request.getRequestURI();
%>

<header class="main-header">
    <nav class="header-nav">
        <%-- Use context path for links --%>
        <a href="<%= studentHeaderContextPath %>/studentpage.jsp" 
           class="<%= currentPage.endsWith("studentpage.jsp") ? "active" : "" %>">
            <i class="fas fa-home"></i> Home
        </a>	
        <a href="<%= studentHeaderContextPath %>/studentDetails.jsp" 
           class="<%= currentPage.endsWith("studentDetails.jsp") ? "active" : "" %>">
            Student Details
        </a>
        <a href="<%= studentHeaderContextPath %>/results.jsp" 
           class="<%= currentPage.endsWith("results.jsp") ? "active" : "" %>">
            Results
        </a>
    </nav>
    
    <div class="user-info-area">
         <div class="welcome-text">
            Welcome, <strong><%= studentHeaderUserName %></strong>
        </div>
        
        <%-- Use context path for image source --%>
        <img src="<%= studentHeaderContextPath %>/getphoto.jsp?id=<%= studentHeaderUserId %>" 
             alt="User Photo" class="user-photo" 
             onerror="this.onerror=null; this.src='<%= studentHeaderContextPath %>/images/default-avatar.png';">
        
        <%-- Use context path for logout link --%>
        <a href="<%= studentHeaderContextPath %>/logout.jsp" class="logout-button">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</header>
