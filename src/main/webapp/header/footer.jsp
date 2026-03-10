<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.Year" %>

<footer class="main-footer">
    <div class="footer-content">
        <div class="footer-socials">
            <a href="https://www.facebook.com/profile.php?id=61583033962192" aria-label="Facebook" target="_blank"><i class="fab fa-facebook-f"></i></a>
            <a href="https://x.com/home/@UpendraGorle2/" aria-label="Twitter" target="_blank"><i class="fab fa-twitter" ></i></a>
            <a href="https://www.instagram.com/upendra_gorle_/" aria-label="Instagram" target="_blank"><i class="fab fa-instagram"></i></a>
            <a href="https://www.linkedin.com/in/upendra-gorle/" aria-label="LinkedIn" target="_blank"><i class="fab fa-linkedin-in" ></i></a>
        </div>
        <p class="footer-copyright">
            &copy; <%= Year.now().getValue() %> Student Portal. All Rights Reserved by Gorle Upendra.
        </p>
    </div>
</footer>