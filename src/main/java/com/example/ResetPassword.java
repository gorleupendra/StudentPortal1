package com.example; // Make sure this package name matches your project structure

import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Important: Make sure this is imported
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * Handles the final step of the password reset process.
 * Verifies the OTP from the session and updates the user's password in the database.
 * This servlet is designed to be called via an AJAX (fetch) request.
 */
 // Modern way to map the servlet to the URL pattern /ResetPassword
public class ResetPassword extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/plain; charset=UTF-8");
        PrintWriter out = res.getWriter();
        HttpSession session = req.getSession(false); // Get the existing session, do not create a new one.

        // --- 1. Session Validation ---
        // First, check if a valid session exists. If not, the user hasn't generated an OTP yet.
        if (session == null) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("error: Your session has expired. Please request a new OTP.");
            out.close();
            return;
        }

        // --- 2. Retrieve Attributes from Session ---
        // Get the email and OTP that were stored by the VerifyEmail servlet.
        String email = (String) session.getAttribute("email");
        Integer storedOtp = (Integer) session.getAttribute("otp");

        // Check if the required attributes are actually in the session.
        if (email == null || storedOtp == null) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("error: Invalid session data. Please request a new OTP.");
            out.close();
            return;
        }
        
        try {
            // --- 3. Get Parameters from the Form ---
            int enteredOtp = Integer.parseInt(req.getParameter("enteredotp"));
            String newPassword = req.getParameter("newpassword");

            // --- 4. Verify OTP ---
            // This is a direct comparison. A more advanced system might check for an expiry timestamp.
            if (storedOtp.intValue() != enteredOtp) {
                res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("error: The OTP you entered is incorrect.");
                out.close();
                return; // Stop execution
            }

            // --- 5. Update Password in Database ---
            // OTP is correct, so hash the new password and update the database.
            // Assumes you have helper classes for hashing passwords and database connections.
            String passwordHash = HashPassword.hashPassword(newPassword); 
            
            // The SQL query to update the password for the specific user.
   
            String sql = "UPDATE students SET password = ? WHERE email = ?";
            

            // Use try-with-resources to automatically manage and close the connection and statement.
            // This is the best practice to prevent "Closed connection" errors.
            try (Connection con = DbConnection.getConne();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, passwordHash);
                ps.setString(2, email);
                int updateCount = ps.executeUpdate();
                

                if (updateCount > 0) {
                    // --- 6. Clean Up Session and Send Success Response ---
                    // Important: Invalidate the OTP and email from the session to prevent reuse.
                    session.removeAttribute("otp");
                    session.removeAttribute("email");
                    // session.invalidate(); // Alternatively, invalidate the entire session.

                    // Send a clear success message for the JavaScript to display in the toast.
                    out.println("success: Password has been updated successfully!");
                } else {
                    // This case might happen in a rare race condition.
                    res.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.println("error: Failed to update password. User not found.");
                }
            }

        } catch (NumberFormatException e) {
            // This catches errors if the 'enteredotp' parameter is not a valid number.
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("error: Invalid OTP format. Please enter numbers only.");
        } catch (Exception e) {
            // General catch-all for other exceptions (e.g., database connection issues).
            e.printStackTrace(); // Log the full error to the server console for debugging.
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("error: An internal server error occurred. Please try again later.");
        } finally {
            // Ensure the PrintWriter is always closed.
            if (out != null) {
                out.close();
            }
        }
    }	
}