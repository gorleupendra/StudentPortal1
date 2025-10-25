package com.example;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.StringJoiner;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/viewStudent")
public class ViewStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String regdNo = request.getParameter("regdno");

        // Use try-with-resources for automatic closing of all resources
        try (Connection con = DbConnection.getConne();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM students WHERE regd_no = ?")) {

            ps.setString(1, regdNo);
            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    // Set each piece of data as a request attribute
                    request.setAttribute("regd_no", rs.getString("regd_no"));
                    request.setAttribute("name", rs.getString("name"));
                    request.setAttribute("fathername", rs.getString("fathername"));
                    request.setAttribute("mothername", rs.getString("mothername"));
                    request.setAttribute("admno", rs.getString("admno"));
                    request.setAttribute("rank", rs.getString("rank"));
                    request.setAttribute("adtype", rs.getString("adtype"));
                    
                    // CORRECTED: Fetching from 'joindate' column instead of 'dob'
                    request.setAttribute("joindate", rs.getString("joincate"));
                    
                    request.setAttribute("email", rs.getString("email"));
                    request.setAttribute("phone", rs.getString("phone"));
                    request.setAttribute("dob", rs.getDate("dob"));
                    request.setAttribute("gender", rs.getString("gender"));
                    request.setAttribute("dept", rs.getString("dept"));
                    
                    // CORRECTED: Use a clearer name to avoid keyword conflicts in JSP
                    request.setAttribute("studentClass", rs.getString("class"));

                    // --- NEW: Safely build the address string ---
                    StringJoiner addressJoiner = new StringJoiner(", ");
                    String village = rs.getString("village");
                    if (village != null && !village.isEmpty()) addressJoiner.add(village);
                    
                    String mandal = rs.getString("mandal");
                    if (mandal != null && !mandal.isEmpty()) addressJoiner.add(mandal);

                    String dist = rs.getString("dist");
                    if (dist != null && !dist.isEmpty()) addressJoiner.add(dist);
                    
                    String pincode = rs.getString("pincode");
                    if (pincode != null && !pincode.isEmpty()) addressJoiner.add(pincode);

                    request.setAttribute("address", addressJoiner.toString());

                    // --- CORRECTED: Check for photo/sign from BYTEA column ---
                    byte[] photoBytes = rs.getBytes("photo");
                    boolean hasPhoto = (photoBytes != null && photoBytes.length > 0);
                    request.setAttribute("hasPhoto", hasPhoto);

                    byte[] signBytes = rs.getBytes("sign");
                    boolean hasSign = (signBytes != null && signBytes.length > 0);
                    request.setAttribute("hasSign", hasSign);
                }
            }
            
            // Forward the request to the JSP page
            RequestDispatcher dispatcher = request.getRequestDispatcher("viewStudentDetails.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Optionally, forward to an error page
            response.getWriter().println("An error occurred while fetching student data.");
        }
    }
}