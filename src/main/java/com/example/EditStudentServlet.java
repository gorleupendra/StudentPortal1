package com.example;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/editStudent")
public class EditStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String regdNo = request.getParameter("regdno");
        
        // Use try-with-resources for all database objects to ensure they are closed
        try (Connection con = DbConnection.getConne();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM students WHERE regd_no = ?")) {
            
            ps.setString(1, regdNo);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student student = new Student();
                    
                    // Populate the student object with ALL data from the ResultSet
                    student.setRegd_no(rs.getString("regd_no"));
                    student.setName(rs.getString("name"));
                    student.setFathername(rs.getString("fathername"));
                    student.setMothername(rs.getString("mothername"));
                    student.setEmail(rs.getString("email"));
                    student.setPhone(rs.getString("phone"));
                    student.setDept(rs.getString("dept"));
                    student.setStudentClass(rs.getString("class"));
                    student.setDob(rs.getDate("dob"));
                    student.setGender(rs.getString("gender"));
                    student.setAdmno(rs.getString("admno"));
                    student.setRank(rs.getString("rank"));
                    student.setAdtype(rs.getString("adtype"));
                    
                    // --- FIX: Uncommented this line to fetch the join date ---
                    student.setJoincate(rs.getString("joincate")); 
                    
                    student.setVillage(rs.getString("village"));
                    student.setMandal(rs.getString("mandal"));
                    student.setDist(rs.getString("dist"));
                    student.setPincode(rs.getString("pincode"));
                    
                    request.setAttribute("studentData", student);
                }
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("editStudentForm.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Optionally, handle the error by forwarding to an error page
        }
    }
}