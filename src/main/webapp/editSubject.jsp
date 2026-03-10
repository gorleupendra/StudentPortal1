<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection, java.util.ArrayList, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Edit Subject</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Assuming adminHeaderFooter.css provides base styles and variables --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminHeaderFooter.css">
    
    <style>
        /* Inherit variables from adminHeaderFooter.css */
        :root { 
            --primary-blue: #0056b3;
            --primary-blue-hover: #004494; 
            --border-color: #d1d5db;
            --disabled-bg: #e9ecef; 
            --text-dark: #1f2937;
            --text-medium: #4b5563;
        }
       
        /* Container styles */
        .container { 
            max-width: 800px; 
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
            margin-bottom: 25px; /* Consistent margin */
            font-size: 1.8rem;
            font-weight: 600;
            display: flex; /* Align icon */
            align-items: center;
            gap: 0.75rem;
        }
        
        /* Form group styles */
        .form-group { 
            display: flex; 
            flex-direction: column; 
            margin-bottom: 20px; 
        }
        .form-group label { 
            margin-bottom: 8px; 
            font-weight: 500; 
            color: var(--text-medium);
            font-size: 0.9em;
        }
        .form-group input { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid var(--border-color); 
            border-radius: 6px; 
            font-size: 1em;
            font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box; /* Include padding */
        }
         .form-group input:focus {
             outline: none;
             border-color: var(--primary-blue);
             box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.15);
         }
        .form-group input[readonly] { 
            background-color: var(--disabled-bg); 
            cursor: not-allowed;
            color: var(--text-medium);
        }
        
        /* Button styles */
        .btn { 
            padding: 12px 25px; 
            border-radius: 6px; 
            color: white; 
            font-weight: 500; 
            text-decoration: none; 
            background-color: var(--primary-blue); 
            border: none; 
            cursor: pointer; 
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background-color 0.2s, transform 0.1s ease;
            font-size: 0.95em;
        }
        .btn:hover {
             background-color: var(--primary-blue-hover);
             transform: translateY(-1px);
         }
         .btn:active {
             transform: translateY(0);
         }
         
         /* Button alignment wrapper (optional, helps alignment) */
         .button-wrapper {
             margin-top: 25px; /* Space above button */
             text-align: right; /* Align button to the right */
         }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 20px; /* Reduced padding */
                margin: 15px auto;
            }
            .container h1 {
                font-size: 1.5em; /* Smaller heading */
            }
             .button-wrapper {
                 text-align: center; /* Center button on mobile */
             }
             .btn {
                 width: 100%; /* Make button full width */
                 justify-content: center;
             }
        }
         @media (max-width: 480px) {
             .container h1 { font-size: 1.3em; }
             .btn { padding: 10px 20px; font-size: 0.9em; }
         }

    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    <main class="page-content">
        <div class="container">
            <h1><i class="fas fa-edit"></i> Edit Subject</h1>
            <%
                String subjectIdStr = request.getParameter("id");
                String subjectName = "";
                Connection con = null; // Declare outside try
                PreparedStatement ps = null; // Declare outside try
                ResultSet rs = null; // Declare outside try

                if (subjectIdStr != null && !subjectIdStr.trim().isEmpty()) {
                    try {
                        con = DbConnection.getConne();
                        int subjectId = Integer.parseInt(subjectIdStr); // Convert ID inside try
                        
                        String sql = "SELECT SUBJECT_NAME FROM SUBJECTS WHERE SUBJECT_ID = ?";
                        ps = con.prepareStatement(sql);
                        ps.setInt(1, subjectId);
                        rs = ps.executeQuery();
                        
                        if (rs.next()) {
                            subjectName = rs.getString("SUBJECT_NAME");
                        } else {
                            // Optional: Handle case where ID is valid format but not found
                            %> <p style="color:red;">Subject with ID <%= subjectId %> not found.</p> <%
                        }
                    } catch (NumberFormatException nfe) {
                         // Handle case where ID is not a valid number
                         %> <p style="color:red;">Invalid Subject ID provided.</p> <%
                    } catch (Exception e) { 
                        e.printStackTrace(); 
                        %> <p style="color:red;">Error loading subject data.</p> <%
                    } finally {
                        // Close resources
                        if (rs != null) try { rs.close(); } catch (SQLException e) {}
                        if (ps != null) try { ps.close(); } catch (SQLException e) {}
                        if (con != null) try { con.close(); } catch (SQLException e) {}
                    }
                } else {
                    %> <p style="color:red;">No Subject ID provided.</p> <%
                }
            %>
            
            <%-- Only show form if ID was valid and subject was found (or if you want to allow creating if not found) --%>
            <% if (subjectIdStr != null && !subjectIdStr.trim().isEmpty() && subjectName != null) { // Check if subjectName was potentially found %>
                <form action="updateSubjectServlet" method="post">
                    <input type="hidden" name="subject_id" value="<%= subjectIdStr %>">
                    <div class="form-group">
                        <label>Subject ID</label>
                        <input type="text" value="<%= subjectIdStr %>">
                    </div>
                    <div class="form-group">
                        <label for="subjectName">Subject Name</label>
                        <input type="text" id="subjectName" name="subject_name" value="<%= subjectName %>" required>
                    </div>
                    <div class="button-wrapper">
                        <button type="submit" class="btn"><i class="fas fa-save"></i> Save Changes</button>
                    </div>
                </form>
             <% } %>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>

