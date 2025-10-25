package com.example; // Make sure this matches your project's package name

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * This servlet handles the user logout process.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get the current session, but don't create one if it doesn't exist.
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Invalidate the session, which removes all its attributes.
            session.invalidate();
        }
        
        // Redirect the user back to the login page.
        response.sendRedirect("login.html");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // It's good practice to have the doPost method call the doGet method.
        doGet(request, response);
    }
}