<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.Year" %>

<footer class="main-footer">
    <div class="footer-content">
        <div class="footer-socials">
            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
            <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
            <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
        </div>
        <p class="footer-copyright">
            &copy; <%= Year.now().getValue() %> Student Portal. All Rights Reserved by Gorle Upendra.
        </p>
    </div>
</footer>