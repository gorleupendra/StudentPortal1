<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Fonts and Icons --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- 
      !! UPDATE THIS PART !!
      Link both stylesheets, layout first.
    --%>
    <%-- Assuming you have a layout.css, if not, just login.css is fine --%>
    <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/header/style.css"> --%>
    <link rel="stylesheet" href="login.css">
    
    <style>
        /* Add this for the loading spinner animation */
        .loading-icon {
            animation: fa-spin 1s infinite linear;
        }
        .hidden {
            display: none;
        }
        .submit-btn:disabled {
             opacity: 0.7;
             cursor: not-allowed;
        }
    </style>
</head>
<body>
    <%-- The rest of your file remains the same --%>
    <%@ include file="/header/header.jsp" %>
    <main class="main-content">
        <div id="app" class="app-container">
            <div class="login-card">
                <div class="header">
                    <h1 class="title">Student/Admin Portal</h1>
                    <p class="subtitle">Sign in to access your dashboard</p>
                </div>
                <form id="login-form" action="${pageContext.request.contextPath}/LoginPage" method="post" >
                    <div class="input-group">
                        <label for="student-id">Enter ID or Email</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-user input-icon"></i>
                            <input id="student-id" name="emailid" type="text" required class="form-input" placeholder="Enter your ID or Email">
                        </div>
                    </div>
                    <div class="input-group">
                        <label for="login-password">Password</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input id="login-password" name="password" type="password" autocomplete="current-password" required class="form-input" placeholder="Enter your password">
                            <div class="password-toggle">
                                <i class="fa-solid fa-eye eye-icon"></i>
                                <!-- ADDED: eye-off-icon for toggling -->
                                <i class="fa-solid fa-eye-slash eye-off-icon hidden"></i>
                            </div>
                        </div>
                    </div>
                    <div class="links-container">
                        <%-- This link is now also in the header, but good to keep here too --%>
                        <a href="${pageContext.request.contextPath}/StudentRegistration/studentregistration.jsp" class="link">New Student? Register</a>
                        <a href="${pageContext.request.contextPath}/resetpassword.jsp" class="link">Forgot password?</a>
                    </div>
                    <div class="button-group">
                        <!-- MODIFIED: Added spinner and text spans -->
                        <button type="submit" class="submit-btn" id="login-submit-btn">
                            <i class="fa-solid fa-spinner loading-icon hidden"></i>
                            <i class="fa-solid fa-right-to-bracket default-icon"></i>
                            <span class="btn-text">Sign In</span> 
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    <div id="toast"></div>
    <%@ include file="/header/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/login/login.js"></script>
</body>
</html>
