package com.example;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginPage")
public class Login extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String input = request.getParameter("emailid");
        String password = request.getParameter("password");

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DbConnection.getConne();
            String hashedPassword = HashPassword.hashPassword(password);
            
            // --- Step 1: Attempt to log in as a student from the 'students' table ---
            String studentSql = input.contains("@")
                ? "SELECT * FROM students WHERE email = ? AND password = ?"
                : "SELECT * FROM students WHERE regd_no = ? AND password = ?";
            
            ps = con.prepareStatement(studentSql);
            ps.setString(1, input);
            ps.setString(2, hashedPassword);
            rs = ps.executeQuery();

            if (rs.next()) {
                // STUDENT LOGIN SUCCESS
                handleLoginSuccess(request, rs, "student");
                out.print("success:studentpage.jsp"); // Redirect URL for students
                return; 
            }
            
            // Close resources before the next query
            rs.close();
            ps.close();

            // --- Step 2: If not a student, attempt to log in as a user from the 'users' table ---
            String userSql;
            if (input.contains("@")) {
                userSql = "SELECT * FROM users WHERE email = ? AND password = ?";
                ps = con.prepareStatement(userSql);
                ps.setString(1, input);
                ps.setString(2, hashedPassword);
            } else if (input.matches("\\d+")) { // Check if the input is a number (for user ID)
                // CORRECTED: Handle numeric ID for PostgreSQL
                userSql = "SELECT * FROM users WHERE id = ? AND password = ?";
                ps = con.prepareStatement(userSql);
                ps.setInt(1, Integer.parseInt(input));
                ps.setString(2, hashedPassword);
            } else {
                // If input is not email or number, it cannot match a user, so fail early.
                ps = null; 
            }

            if (ps != null) {
                rs = ps.executeQuery();
                if (rs.next()) {
                    // USER/ADMIN LOGIN SUCCESS
                    String role = rs.getString("role");
                    handleLoginSuccess(request, rs, role);
                    String redirectUrl = "admin".equalsIgnoreCase(role) ? "admin_dashboard.jsp" : "studentpage.jsp";
                    out.print("success:" + redirectUrl);
                    return;
                }
            }
            
            // --- Step 3: If neither query found a match, it's a failure ---
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("Login Failed! Invalid ID/Email or password.");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("An internal server error occurred.");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
            out.flush();
        }
    }

    /**
     * Simplified helper method to create a session and set user attributes.
     */
    private void handleLoginSuccess(HttpServletRequest request, ResultSet rs, String role) throws SQLException {
        HttpSession session = request.getSession(true);
        String name = rs.getString("name");
        String userId;

        // Use a single, consistent session attribute for the user's ID
        if ("student".equalsIgnoreCase(role)) {
            userId = rs.getString("regd_no");
        } else {
            userId = String.valueOf(rs.getInt("id"));
        }
        
        session.setAttribute("regdno", userId); // Use a generic name like "userId"
        session.setAttribute("userName", name);
        session.setAttribute("userRole", role);
    }
}