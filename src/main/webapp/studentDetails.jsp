<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<%
    // --- 1. Session Security Check ---
    // Renamed variables to avoid conflict with potential header includes
    String studentUserId = (String) session.getAttribute("regdno"); 
    String studentUserName = (String) session.getAttribute("userName");
    
    if (studentUserId == null || studentUserId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp"); // Use context path for redirect
        return; 
    }

    // --- 2. Database Query ---
    String name = "N/A", fatherName = "N/A", motherName = "N/A", admNo = "N/A", rank = "N/A",
           adType = "N/A", joinCate = "N/A", phone = "N/A", dob = "N/A", gender = "N/A", email="N/A",
           village = "N/A", mandal = "N/A", dist = "N/A", pincode = "N/A", regdno = "N/A", clas="N/A", dept="N/A";

    Connection con1 = null;
    PreparedStatement ps1 = null;
    ResultSet rs1 = null;

    try {
        con1 = DbConnection.getConne();
        ps1 = con1.prepareStatement("SELECT * FROM STUDENTS WHERE REGD_NO = ?");
        ps1.setString(1, studentUserId); // Use the session variable
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
            // Assuming DOB is stored as DATE or VARCHAR, adjust if necessary
            // If it's stored as DATE: dob = rs1.getDate("DOB").toString(); 
            dob = rs1.getString("DOB"); 
            gender = rs1.getString("GENDER");
            village = rs1.getString("VILLAGE");
            mandal = rs1.getString("MANDAL");
            dist = rs1.getString("DIST");
            pincode = rs1.getString("PINCODE");
        } else {
             // Handle case where student not found, maybe show an error
             name = "Student Not Found";
        }
    } catch (Exception e) {
        e.printStackTrace();
        name = "Error loading data"; // Show error on page
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
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>My Details - Student Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Link to the STUDENT header/footer CSS (assuming it exists) --%>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/studentHeaderFooter.css">
    		
    <style>
        /* Inherit variables from studentHeaderFooter.css if defined */
        :root { 
            --primary-blue: #0056b3;
            --primary-blue-hover: #004494; 
            --border-color: #d1d5db;
            --text-dark: #1f2937;
            --text-medium: #4b5563;
            --light-gray-bg: #f8f9fa; /* Light background for table rows */
        }

        /* Container styles */
        .container { 
            max-width: 900px; 
            margin: 20px auto; 
            background: #fff; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        }
        .container h1 { 
            color: var(--primary-blue); 
            border-bottom: 2px solid #eee; 
            padding-bottom: 10px; 
            margin-bottom: 25px; 
            text-align: center; 
            font-size: 1.8rem;
            font-weight: 600;
        }
        
        /* Details table styles */
        .details-table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-bottom: 30px; 
        }
        .details-table td { 
            padding: 12px 8px; 
            border-bottom: 1px solid #eef2f7; 
            font-size: 1rem; /* Adjusted size */
            vertical-align: top; /* Align top for multi-line content */
        }
        .details-table tr:last-child td { 
            border-bottom: none; 
        }
        .details-table td:first-child { 
            font-weight: 600; 
            color: var(--text-medium); 
            width: 180px; /* Fixed width for labels */
        }
         /* Add subtle striping for readability */
         .details-table tr:nth-child(even) {
             background-color: var(--light-gray-bg);
         }
        
        /* Images section styles */
        .images-section { 
            display: flex; 
            justify-content: space-around; /* Space out items */
            flex-wrap: wrap; /* Allow wrapping on mobile */
            padding: 25px 0; /* Adjusted padding */
            border-top: 2px solid #eee; 
            margin-top: 20px; 
            gap: 20px; /* Add gap between items */
        }
        .image-box { 
            text-align: center; 
            flex-basis: 250px; /* Set a base width */
            max-width: 90%; /* Prevent exceeding container on very small screens */
        }
        .image-box img { 
            max-width: 100%; /* Make image responsive */
            height: 120px; /* Fixed height */
            object-fit: contain; 
            border: 1px solid var(--border-color); /* Add subtle border */
            background-color: #fff; 
            border-radius: 4px; /* Slightly rounded */
            padding: 5px; /* Add padding around image */
            box-shadow: 0 2px 4px rgba(0,0,0,0.05); /* Subtle shadow */
        }
        .image-box p { 
            font-weight: 600; 
            color: var(--text-medium); 
            margin-top: 10px; 
            font-size: 0.9em;
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 20px; /* Reduced padding */
                margin: 15px auto;
            }
            .container h1 {
                font-size: 1.5rem; /* Smaller heading */
            }
             /* Stack table cells vertically */
             .details-table, .details-table tbody, .details-table tr, .details-table td {
                 display: block;
                 width: 100%;
             }
             .details-table tr {
                 margin-bottom: 15px; /* Space between stacked rows */
                 border-bottom: 2px solid #eee; /* Separator */
             }
             .details-table td {
                 border: none; /* Remove inner borders */
                 padding: 8px 0; /* Adjust padding */
             }
             .details-table td:first-child {
                 width: auto; /* Allow label width to adjust */
                 padding-bottom: 2px; /* Space below label */
                 color: var(--primary-blue); /* Highlight label */
                 font-size: 0.85em; /* Smaller label */
                 text-transform: uppercase;
             }
             .details-table tr:last-child {
                 margin-bottom: 0;
                 border-bottom: none;
             }
             .images-section {
                 flex-direction: column; /* Stack images vertically */
                 align-items: center; /* Center items */
                 padding: 20px 0;
             }
             .image-box {
                 flex-basis: auto; /* Reset basis */
                 width: 100%; /* Full width */
                 max-width: 250px; /* Limit max width */
             }
        }
         @media (max-width: 480px) {
             .container h1 { font-size: 1.3em; }
         }
         
    </style>
</head>
<body>

    <%-- Assuming header.jsp is for the STUDENT portal --%>
    <%@ include file="header.jsp" %>

    <main class="page-content">
        <div class="container">
            <h1>Student Profile: <%= name %></h1>

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
                    <img src="getphoto.jsp?id=<%= studentUserId %>" alt="Profile Photo"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-avatar.png';">
                    <p>Student Photo</p>
                </div>
                <div class="image-box">
                     <img src="getSign.jsp?id=<%= studentUserId %>" alt="Signature"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/placeholder-sign.png';"> 
                    <p>Student Signature</p>
                </div>
            </div>

        </div>
    </main>

    <%-- Assuming footer.jsp is for the STUDENT portal --%>
    <%@ include file="footer.jsp" %>
    
    <%-- Removed login.js, assuming it's not needed here --%>
    <%-- <script src="login.js"></script> --%> 
</body>
</html>

