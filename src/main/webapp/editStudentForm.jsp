<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%-- Added viewport meta tag for responsiveness --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Edit Student Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Assuming adminHeaderFooter.css provides base styles and variables --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminHeaderFooter.css">
    
    <style>
        /* Inherit variables from adminHeaderFooter.css */
        :root { 
            --primary-blue: #0056b3;
            --primary-blue-hover: #004494; 
            --light-blue-bg: #f0f7ff;
            --border-color: #d1d5db;
            --disabled-bg: #e9ecef;
            --text-dark: #1f2937;
            --text-medium: #4b5563;
            --text-light-gray: #6c757d; /* Added for readonly text */
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
        
        /* Form header styles */
        .form-header {
            display: flex;
            flex-wrap: wrap; /* Allow wrapping on small screens */
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid var(--border-color); 
            padding-bottom: 15px; 
            margin-bottom: 30px;
            gap: 15px; /* Add gap for wrapping */
        }
        .form-header h1 { 
            color: var(--primary-blue); 
            font-size: 1.8em; 
            margin: 0; 
            display: inline-flex; /* Align icon */
            align-items: center;
            gap: 0.75rem;
            font-weight: 600;
        }
        
        /* Form section header */
        .form-section-header {
            font-size: 1.2em; 
            font-weight: 600; 
            color: var(--text-dark); 
            margin-top: 30px;
            margin-bottom: 20px; 
            border-bottom: 1px solid #eee; 
            padding-bottom: 10px;
        }
        
        /* Form grid */
        .form-grid {
            display: grid; 
            grid-template-columns: repeat(2, 1fr); /* Default 2 columns */
            gap: 20px 30px;
        }
        
        /* Form group */
        .form-group { 
            display: flex; 
            flex-direction: column; 
        }
        .form-group label {
            margin-bottom: 8px; 
            font-weight: 500; 
            color: var(--text-medium); 
            font-size: 0.9em;
        }
        .form-group input, .form-group select {
            width: 100%; 
            padding: 12px; 
            border: 1px solid var(--border-color);
            border-radius: 6px; 
            box-sizing: border-box; 
            font-size: 1em;
            font-family: inherit; /* Use body font */
            transition: all 0.2s ease-in-out;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none; 
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.15); /* Adjusted shadow color */
        }
        .form-group input[readonly] {
            background-color: var(--disabled-bg); 
            cursor: not-allowed; 
            color: var(--text-light-gray);
        }
        
        /* Media previews */
        .media-preview-group {
            display: flex; 
            align-items: center; 
            gap: 15px;
            flex-wrap: wrap; /* Allow wrapping */
        }
        .media-preview-group input[type="file"] {
            flex-grow: 1; /* Allow file input to take remaining space */
        }
        .photo-preview {
            width: 80px; 
            height: 80px; 
            border: 1px solid var(--border-color);
            border-radius: 6px; 
            object-fit: cover; 
            flex-shrink: 0; /* Prevent shrinking */
        }
        .signature-preview {
            width: 150px; 
            height: 80px; 
            border: 1px solid var(--border-color);
            border-radius: 6px; 
            object-fit: contain; 
            flex-shrink: 0; /* Prevent shrinking */
            background-color: #f8f9fa; /* Light background for signatures */
        }
        
        /* Button group */
        .button-group {
            grid-column: 1 / -1; /* Span full width */ 
            margin-top: 30px; 
            display: flex;
            justify-content: flex-end; /* Align buttons to the right */ 
            gap: 15px;
        }
        .btn {
            padding: 12px 25px; 
            border: none; 
            border-radius: 6px; 
            font-weight: 500; /* Adjusted weight */
            cursor: pointer; 
            text-decoration: none; 
            display: inline-flex;
            align-items: center; 
            gap: 8px; 
            transition: background-color 0.2s, transform 0.1s ease;
            font-size: 0.95em; /* Slightly smaller button text */
        }
        .btn-primary { 
            background-color: var(--primary-blue); 
            color: white; 
        }
        .btn-primary:hover { 
            background-color: var(--primary-blue-hover); 
            transform: translateY(-1px);
        }
        .btn-secondary { 
            background-color: #e5e7eb; 
            color: var(--text-dark); 
        }
        .btn-secondary:hover { 
            background-color: #d1d5db; 
            transform: translateY(-1px);
        }
         .btn:active {
             transform: translateY(0);
         }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 20px; /* Reduced padding */
                margin: 15px auto;
            }
            .form-header h1 {
                font-size: 1.5em; /* Smaller heading */
            }
            .form-grid {
                grid-template-columns: 1fr; /* Stack to single column */
                gap: 20px; /* Adjust vertical gap */
            }
            .button-group {
                justify-content: center; /* Center buttons on mobile */
            }
             .media-preview-group {
                 flex-direction: column; /* Stack preview and input */
                 align-items: flex-start;
             }
        }
         @media (max-width: 480px) {
             .container h1 { font-size: 1.3em; }
             .btn { padding: 10px 20px; font-size: 0.9em; }
             .button-group {
                 flex-direction: column; /* Stack buttons vertically */
                 align-items: stretch; /* Make buttons full width */
             }
         }

    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    
    <main class="page-content">
        <div class="container">
            <div class="form-header">
                <h1><i class="fas fa-edit"></i> Edit Student Information</h1>
                <a href="studentManagement.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to List</a>
            </div>
            
            <c:if test="${studentData != null}">
                <form action="updateStudent" method="post" enctype="multipart/form-data">
                    
                    <h3 class="form-section-header">Personal Information</h3>
                    <div class="form-grid">
                        <input type="hidden" name="regd_no" value="${studentData.regd_no}">
                        <div class="form-group">
                            <label>Registration No.</label>
                            <input type="text" value="${studentData.regd_no}" readonly>
                        </div>
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="${studentData.name}" required>
                        </div>
                        <div class="form-group">
                            <label for="fathername">Father's Name</label>
                            <input type="text" id="fathername" name="fathername" value="${studentData.fathername}">
                        </div>
                        <div class="form-group">
                            <label for="mothername">Mother's Name</label>
                            <input type="text" id="mothername" name="mothername" value="${studentData.mothername}">
                        </div>
                        <div class="form-group">
                            <label for="dob">Date of Birth</label>
                            <%-- Format date for input type="date" --%>
                            <fmt:formatDate value="${studentData.dob}" pattern="yyyy-MM-dd" var="formattedDob" />
                            <input type="date" id="dob" name="dob" value="${formattedDob}">
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender">
                                <%-- Use JSTL for cleaner conditional selection --%>
                                <option value="MALE" ${studentData.gender == 'MALE' ? 'selected' : ''}>Male</option>
                                <option value="FEMALE" ${studentData.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                                <option value="OTHERS" ${studentData.gender == 'OTHERS' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                    </div>
                    
                    <h3 class="form-section-header">Academic Details</h3>
                    <div class="form-grid">
                         <div class="form-group">
                            <label for="dept">Department</label>
                            <input type="text" id="dept" name="dept" value="${studentData.dept}">
                        </div>
                        <div class="form-group">
                            <label for="class">Class</label>
                            <input type="text" id="class" name="class" value="${studentData.studentClass}">
                        </div>
                        <div class="form-group">
                            <label for="admno">Admission No</label>
                            <input type="text" id="admno" name="admno" value="${studentData.admno}">
                        </div>
                        <div class="form-group">
                            <label for="rank">Rank</label>
                            <input type="text" id="rank" name="rank" value="${studentData.rank}">
                        </div>
                         <div class="form-group">
                            <label for="adtype">Admission Type</label>
                            <input type="text" id="adtype" name="adtype" value="${studentData.adtype}">
                        </div>
                        <div class="form-group">
                            <label for="joindate">Join Category</label> <%-- Corrected label --%>
                            <input type="text" id="joindate" name="joincate" value="${studentData.joincate}"> <%-- Corrected name --%>
                        </div>
                    </div>

                    <h3 class="form-section-header">Contact & Address Information</h3>
                     <div class="form-grid">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${studentData.email}" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="text" id="phone" name="phone" value="${studentData.phone}">
                        </div>
                         <div class="form-group">
                            <label for="village">Village</label>
                            <input type="text" id="village" name="village" value="${studentData.village}">
                        </div>
                         <div class="form-group">
                            <label for="mandal">Mandal</label>
                            <input type="text" id="mandal" name="mandal" value="${studentData.mandal}">
                        </div>
                         <div class="form-group">
                            <label for="dist">District</label>
                            <input type="text" id="dist" name="dist" value="${studentData.dist}">
                        </div>
                         <div class="form-group">
                            <label for="pincode">Pincode</label>
                            <input type="text" id="pincode" name="pincode" value="${studentData.pincode}">
                        </div>
                    </div>

                    <h3 class="form-section-header">Update Photo & Signature</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="photo">New Photo (Optional)</label>
                            <div class="media-preview-group">
                                 <%-- Use JSTL url tag for context path --%>
                                 <c:url var="photoUrl" value="/getphoto.jsp">
                                     <c:param name="id" value="${studentData.regd_no}"/>
                                 </c:url>
                                 <img src="${photoUrl}" class="photo-preview" alt="Current Photo" 
                                      onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-avatar.png';">
                                <input type="file" id="photo" name="photo" accept="image/*">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="sign">New Signature (Optional)</label>
                             <div class="media-preview-group">
                                 <c:url var="signUrl" value="/getSign.jsp">
                                     <c:param name="id" value="${studentData.regd_no}"/>
                                 </c:url>
                                <img src="${signUrl}" class="signature-preview" alt="Current Signature"
                                     onerror="this.onerror=null; this.style.display='none';">
                                <input type="file" id="sign" name="sign" accept="image/*">
                            </div>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group button-group">
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save All Changes</button>
                        </div>
                    </div>
                </form>
            </c:if>
             <c:if test="${studentData == null}">
                 <p style="text-align: center; color: var(--error-color); margin-top: 30px;">Student data not found for the provided Registration Number.</p>
             </c:if>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %> 
</body>
</html>
