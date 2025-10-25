<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Invalidate the user's session
    // This removes all attributes stored in the session, including "userId" and "name"
    session.invalidate();

    // Set headers to prevent caching of the page
    // This is a security measure to stop a user from clicking the browser's "back" button
    // and seeing a cached version of a protected page.
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.

    // Redirect the user to the login page
    response.sendRedirect("login.html");
%>