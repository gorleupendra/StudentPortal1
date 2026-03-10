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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date; // Make sure to import java.sql.Date
import java.text.SimpleDateFormat;

@WebServlet("/updateStudent")
@MultipartConfig
public class UpdateStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // --- 1. Get all form data ---
        String regdNo = request.getParameter("regd_no");
        String name = request.getParameter("name");
        String fathername = request.getParameter("fathername");
        String mothername = request.getParameter("mothername");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dept = request.getParameter("dept");
        String studentClass = request.getParameter("class");
        String dobString = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String admno = request.getParameter("admno");
        String rank = request.getParameter("rank");
        String adtype = request.getParameter("adtype");
        String joincate = request.getParameter("joincate"); // ADDED
        String village = request.getParameter("village");
        String mandal = request.getParameter("mandal");
        String dist = request.getParameter("dist");
        String pincode = request.getParameter("pincode");

        Part photoPart = request.getPart("photo");
        Part signPart = request.getPart("sign");

        String message = "";
        String status = "error";

        try {
            // Convert the DOB string to a java.sql.Date object
            java.sql.Date dob = null;
            if (dobString != null && !dobString.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date utilDate = sdf.parse(dobString);
                dob = new java.sql.Date(utilDate.getTime());
            }

            // --- 2. Build the UPDATE SQL statement dynamically ---
            // ADDED joindate=? to the SQL string
            StringBuilder sql = new StringBuilder("UPDATE students SET name=?, fathername=?, mothername=?, email=?, phone=?, dept=?, class=?, dob=?, gender=?, admno=?, rank=?, adtype=?, joincate=?, village=?, mandal=?, dist=?, pincode=?");
            
            InputStream photoStream = (photoPart != null && photoPart.getSize() > 0) ? photoPart.getInputStream() : null;
            InputStream signStream = (signPart != null && signPart.getSize() > 0) ? signPart.getInputStream() : null;
            
            if (photoStream != null) {
                sql.append(", photo=?");
            }
            if (signStream != null) {
                sql.append(", sign=?");
            }
            sql.append(" WHERE regd_no=?");

            // --- 3. Execute the update with specific setters ---
            try (Connection con = DbConnection.getConne();
                 PreparedStatement ps = con.prepareStatement(sql.toString())) {
                
                int paramIndex = 1;
                
                // Set all the string and date values explicitly
                ps.setString(paramIndex++, name);
                ps.setString(paramIndex++, fathername);
                ps.setString(paramIndex++, mothername);
                ps.setString(paramIndex++, email);
                ps.setString(paramIndex++, phone);
                ps.setString(paramIndex++, dept);
                ps.setString(paramIndex++, studentClass);
                ps.setDate(paramIndex++, dob);
                ps.setString(paramIndex++, gender);
                ps.setString(paramIndex++, admno);
                ps.setString(paramIndex++, rank);
                ps.setString(paramIndex++, adtype);
                ps.setString(paramIndex++, joincate); // ADDED
                ps.setString(paramIndex++, village);
                ps.setString(paramIndex++, mandal);
                ps.setString(paramIndex++, dist);
                ps.setString(paramIndex++, pincode);

                // If a new photo was uploaded, set it using setBinaryStream
                if (photoStream != null) {
                    ps.setBinaryStream(paramIndex++, photoStream, photoPart.getSize());
                }
                // If a new signature was uploaded, set it using setBinaryStream
                if (signStream != null) {
                    ps.setBinaryStream(paramIndex++, signStream, signPart.getSize());
                }
                
                // Finally, set the WHERE clause parameter
                ps.setString(paramIndex++, regdNo);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    status = "success";
                    message = "Student " + regdNo + " was updated successfully.";
                } else {
                    message = "Failed to update student " + regdNo + ". Record not found.";
                }
            }
        } catch (Exception e) {
            message = "Error updating student: " + e.getMessage();
            e.printStackTrace();
        }

        // --- 4. Redirect back ---
        response.sendRedirect("studentManagement.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}