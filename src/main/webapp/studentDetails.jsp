<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<%
    // --- 1. Session Security Check ---
    String userId = (String) session.getAttribute("regdno");
    if (userId == null || userId.isEmpty()) {
        response.sendRedirect("login.html");
        return; 
    }

    // --- 2. Database Query ---
    String name = "N/A", fatherName = "N/A", motherName = "N/A", admNo = "N/A", rank = "N/A",
           adType = "N/A", joinCate = "N/A", phone = "N/A", dob = "N/A", gender = "N/A",email="N/A",
           village = "N/A", mandal = "N/A", dist = "N/A", pincode = "N/A", regdno = "N/A",clas="N/A",dept="N/A";

    Connection con1 = null;
    PreparedStatement ps1 = null;
    ResultSet rs1 = null;

    try {
        con1 = DbConnection.getConne();
        ps1 = con1.prepareStatement("SELECT * FROM STUDENTS WHERE REGD_NO = ?");
        ps1.setString(1, userId);
        rs1 = ps1.executeQuery();

        if (rs1.next()) {
            regdno = rs1.getString("REGD_NO");
            name = rs1.getString("NAME");
            fatherName = rs1.getString("FATHERNAME");
            motherName = rs1.getString("MOTHERNAME");
            email=rs1.getString("EMAIL");
            admNo = rs1.getString("ADMNO");
            rank = rs1.getString("RANK");
            adType = rs1.getString("ADTYPE");
            clas=rs1.getString("CLASS");
            dept=rs1.getString("DEPT");
            joinCate = rs1.getString("JOINCATE");
            phone = rs1.getString("PHONE");
            dob = rs1.getString("DOB");
            gender = rs1.getString("GENDER");
            village = rs1.getString("VILLAGE");
            mandal = rs1.getString("MANDAL");
            dist = rs1.getString("DIST");
            pincode = rs1.getString("PINCODE");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // --- 3. Close Database Resources ---
        try { if (rs1 != null) rs1.close(); } catch (Exception e) {}
        try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
        try { if (con1 != null) con1.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Details - Student Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="studentHeaderFooter.css">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; display: flex; flex-direction: column; min-height: 100vh; }
        .page-content { flex: 1; padding: 20px 0; }
        .container { max-width: 900px; margin: 50px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .container h1 { color: #0056b3; border-bottom: 2px solid #e0e0e0; padding-bottom: 10px; margin-bottom: 25px; text-align: center; }
        .details-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .details-table td { padding: 12px 8px; border-bottom: 1px solid #eef2f7; font-size: 1.05em; }
        .details-table tr:last-child td { border-bottom: none; }
        .details-table td:first-child { font-weight: 600; color: #555; width: 200px; }
        .images-section { display: flex; justify-content: space-between; padding: 20px 50px; border-top: 2px solid #e0e0e0; margin-top: 20px; }
        .image-box { text-align: center; }
        .image-box img { width: 250px; height: 120px; object-fit: contain; border: none; background-color: #fff; }
        .image-box p { font-weight: 600; color: #555; margin-top: 10px; }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="page-content">
        <div class="container">
            <h1>Student Profile: <%=name %></h1>

            <table class="details-table">
                <tbody>
                    <tr><td>Registration Number:</td><td><%= regdno %></td></tr>
                    <tr><td>Name:</td><td><%= name %></td></tr>
                    <tr><td>Father's Name:</td><td><%= fatherName %></td></tr>
                    <tr><td>Mother's Name:</td><td><%= motherName %></td></tr>
                    <tr><td>Email</td><td><%= email %></td></tr>
                    <tr><td>Phone Number:</td><td><%= phone %></td></tr>
                    <tr><td>Admission No:</td><td><%= admNo %></td></tr>
                    <tr><td>Rank:</td><td><%= rank %></td></tr>
                    <tr><td>Admission Type:</td><td><%= adType %></td></tr>
                    <tr><td>Class:</td><td><%= clas %></td></tr>
                    <tr><td>Department:</td><td><%= dept %></td></tr>
                    <tr><td>Joining Category:</td><td><%= joinCate %></td></tr>
                    <tr><td>Date of Birth:</td><td><%= dob %></td></tr>
                    <tr><td>Gender:</td><td><%= gender %></td></tr>
                    <tr><td>Address:</td><td><%= village %>, <%= mandal %>, <%= dist %> - <%= pincode %></td></tr>
                </tbody>
            </table>

            <div class="images-section">
                <div class="image-box">
                    <img src="getphoto.jsp?id=<%= userId %>" alt="Profile Photo"
                         onerror="this.onerror=null; this.src='images/default-avatar.png';">
                    <p>Student Photo</p>
                </div>
                <div class="image-box">
                     <img src="getSign.jsp?id=<%= userId %>" alt="Signature"
                         onerror="this.onerror=null; this.src='images/default-avatar.png';">
                    <p>Student Signature</p>
                </div>
            </div>

        </div>
    </main>

    <%@ include file="footer.jsp" %>
    <script src="login.js"></script> </body>
</html>