package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types; // Import for setting NULL values

@WebServlet("/studentRegistration") // Ensure the URL mapping is correct
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1MB
    maxFileSize = 1024 * 1024 * 5,     // 5MB
    maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class StudentRegistration extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/plain");
        PrintWriter out = res.getWriter();

        String regdno = req.getParameter("regdno");
        String name = req.getParameter("fullname");
        String fathername = req.getParameter("fathername");
        String mothername = req.getParameter("mothername");
        String admno = req.getParameter("admno");
        String rank = req.getParameter("rank");
        String adtype = req.getParameter("admtype");
        String joincate = req.getParameter("joincate"); // Kept as per your instruction
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String gender = req.getParameter("gender");
        String village = req.getParameter("village");
        String mandal = req.getParameter("mandal");
        String dist = req.getParameter("dist");
        String dept = req.getParameter("dept");
        String clas = req.getParameter("class");
        String pincode = req.getParameter("pincode");
        String password = req.getParameter("password");
        
        Part photoPart = req.getPart("photo");
        Part signPart = req.getPart("sign");

        // Use try-with-resources for automatic closing of streams and connections
        try (Connection con = DbConnection.getConne();
             InputStream photoStream = (photoPart != null && photoPart.getSize() > 0) ? photoPart.getInputStream() : null;
             InputStream signStream = (signPart != null && signPart.getSize() > 0) ? signPart.getInputStream() : null) {

            con.setAutoCommit(false); // Start transaction

            String sqlStudentDetails = "INSERT INTO STUDENTS (REGD_NO, NAME, FATHERNAME, MOTHERNAME, ADMNO, RANK, ADTYPE, JOINCATE, EMAIL, PHONE, DOB, GENDER, VILLAGE, MANDAL, DIST, PINCODE, PHOTO, SIGN, PASSWORD, DEPT, CLASS) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement psStudentDetails = con.prepareStatement(sqlStudentDetails)) {
                psStudentDetails.setString(1, regdno);
                psStudentDetails.setString(2, name);
                psStudentDetails.setString(3, fathername);
                psStudentDetails.setString(4, mothername);
                psStudentDetails.setString(5, admno);
                psStudentDetails.setString(6, rank);
                psStudentDetails.setString(7, adtype);
                psStudentDetails.setString(8, joincate);
                psStudentDetails.setString(9, email);
                psStudentDetails.setString(10, phone);

                int day = Integer.parseInt(req.getParameter("date"));
                int month = Integer.parseInt(req.getParameter("month"));
                int year = Integer.parseInt(req.getParameter("year"));
                String dobStr = String.format("%04d-%02d-%02d", year, month, day);
                java.sql.Date sqlDate = java.sql.Date.valueOf(dobStr);
                psStudentDetails.setDate(11, sqlDate);
                
                psStudentDetails.setString(12, gender);
                psStudentDetails.setString(13, village);
                psStudentDetails.setString(14, mandal);
                psStudentDetails.setString(15, dist);
                psStudentDetails.setString(16, pincode);

                // --- CONVERSION: Use setBinaryStream for PostgreSQL ---
                if (photoStream != null) {
                    psStudentDetails.setBinaryStream(17, photoStream, photoPart.getSize());
                } else {
                    psStudentDetails.setNull(17, Types.BINARY);
                }
                
                if (signStream != null) {
                    psStudentDetails.setBinaryStream(18, signStream, signPart.getSize());
                } else {
                    psStudentDetails.setNull(18, Types.BINARY);
                }

                String passwordHash = HashPassword.hashPassword(password);
                psStudentDetails.setString(19, passwordHash);
                psStudentDetails.setString(20, dept);
                psStudentDetails.setString(21, clas);
                
                int studentDetailRows = psStudentDetails.executeUpdate();

                if (studentDetailRows > 0) {
                    con.commit();
                    out.write("Successfully registered!");
                } else {
                    con.rollback();
                    out.write("Registration failed. Please contact support.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("An error occurred during registration. Please check the details and try again.");
            // No need to manually rollback here, as the connection will be closed by try-with-resources
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }
}