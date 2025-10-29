<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Include Font Awesome library for icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<%-- Link to your CSS file --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/header/style.css">

<header class="main-header">
    <nav class="header-nav">
        <%-- Logo --%>
        <div class="logo-container">
            <img src="https://upload.wikimedia.org/wikipedia/en/c/c7/Andhra_University_logo.png" alt="University Logo" class="logo-img">
            <span class="university-name">Andhra University (MSc Computer Science)</span>
        </div>

        <%-- Hamburger Menu Button (Visible only on mobile) --%>
        <button class="mobile-menu-toggle" aria-label="Toggle navigation" aria-expanded="false">
            <i class="fa-solid fa-bars"></i> <%-- Hamburger Icon --%>
        </button>

        <%-- Wrapper for all header buttons/actions - This will be toggled on mobile --%>
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
                <a href="${pageContext.request.contextPath}/login/login.jsp" class="header-button active">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    <span>Login</span>
                </a>
            </div>
        </div>
    </nav>
</header>

<%-- Simple JavaScript for Mobile Menu Toggle --%>
<script>
    const menuToggle = document.querySelector('.mobile-menu-toggle');
    const headerActions = document.querySelector('.header-actions');
    const headerNav = document.querySelector('.header-nav'); // Get the parent nav

    if (menuToggle && headerActions && headerNav) {
        menuToggle.addEventListener('click', () => {
            const isExpanded = menuToggle.getAttribute('aria-expanded') === 'true';
            menuToggle.setAttribute('aria-expanded', !isExpanded);
            // Toggle a class on the PARENT NAV element to control layout/visibility
            headerNav.classList.toggle('mobile-menu-open'); 
        });
    }
</script>
