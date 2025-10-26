<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="main-header">
    <nav class="header-nav">
        <%-- Logo --%>
        <div class="logo-container">
            <%-- UPDATED THIS LINE --%>
<img src="https://upload.wikimedia.org/wikipedia/en/c/c7/Andhra_University_logo.png" alt="University Logo" class="logo-img">            <span class="university-name">Andhra University College of Engineering(Msc Computer Science)</span>
        </div>

        <%-- Wrapper for all header buttons/actions --%>
        <div class="header-actions">

            <%-- Main navigation buttons --%>
            <div class="header-buttons">
                <a href="${pageContext.request.contextPath}/homepage.jsp" class="header-button">
                    <i class="fa-solid fa-house"></i>
                    <span>Home</span>
                </a>
                <a href="${pageContext.request.contextPath}/about/about.jsp" class="header-button">
                    <i class="fa-solid fa-circle-info"></i>
                    <span>About Us</span>
                </a>
                <a href="${pageContext.request.contextPath}/contactus.jsp" class="header-button">
                    <i class="fa-solid fa-phone"></i>
                    <span>Contact Us</span>
                </a>
                <%-- NEW: Login button moved and restyled --%>
                <a href="${pageContext.request.contextPath}/login/login.jsp" class="header-button active">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    <span>Login</span>
                </a>
            </div>

            <%-- OLD auth-toggles section has been removed --%>

        </div>
    </nav>
</header>

