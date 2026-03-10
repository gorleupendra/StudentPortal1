package com.example; // Make sure this package name is correct for your project

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // <-- ADDED
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

// Use @WebServlet annotation for easier mapping
// <-- ADDED: This servlet is now at the URL /verifyEmail
public class VerifyEmail extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/plain; charset=UTF-8");
        PrintWriter out = res.getWriter();

        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("error: Email cannot be empty.");
            out.close();
            return;
        }

        // Assumes you have these helper classes:
        // DbConnection.java - for your database connection
        // GenOtp.java - for generating a random OTP
        // EmailSender.java - for sending emails
        
        // Update the query to match your actual table and column names
        String sql = "SELECT email FROM students WHERE email = ?";

        // Assumes your DbConnection class has 'getConnection'
        try (Connection con = DbConnection.getConne(); 
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    int otp = GenOtp.generateOTP();

                    String subject = "Student Login Password Reset OTP";
                    String body = "Dear Student,\n\n" +
                                  "Your OTP for Password Reset is: " + otp + "\n\n" +
                                  "This OTP is valid for 10 minutes.\n\n" +
                                  "If you didn’t request this, please ignore.";

                    // This now calls the NEW SendGrid version of EmailSender
                    boolean sent = EmailSender.sendEmail(email, subject, body);

                    if (sent) {
                        req.getSession().setAttribute("otp", otp);
                        req.getSession().setAttribute("email", email);
                        out.println("success: An OTP has been sent to "+ email);
                    } else {
                        res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        out.println("error: Failed to send OTP. Please try again later.");
                    }
                } else {
                    res.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.println("error: Email not registered in the Student database.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("error: A database error occurred. Please contact support.");
        }  
    }
}