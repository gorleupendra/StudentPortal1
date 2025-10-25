<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Student Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="adminHeaderFooter.css">
    
    <style>
        :root { 
            --primary-blue: #0056b3;
            --light-blue-bg: #f0f7ff;
            --border-color: #d1d5db;
            --disabled-bg: #e9ecef;
            --text-dark: #1f2937;
            --text-medium: #4b5563;
        }
        html, body { height: 100%; }
        body { font-family: Arial, sans-serif; margin: 0; display: flex; flex-direction: column; background-color: #f4f4f4; color: #333; }
        .page-content { flex: 1; padding: 20px; }
        .container { 
            max-width: 900px; margin: 20px auto; background: #fff; padding: 30px; 
            border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        }
        .form-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid var(--border-color); padding-bottom: 15px; margin-bottom: 30px;
        }
        .form-header h1 { color: var(--primary-blue); font-size: 1.8em; margin: 0; }
        .form-section-header {
            font-size: 1.2em; font-weight: 600; color: var(--text-dark); margin-top: 30px;
            margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px;
        }
        .form-grid {
            display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px 30px;
        }
        .form-group { display: flex; flex-direction: column; }
        .form-group label {
            margin-bottom: 8px; font-weight: 500; color: var(--text-medium); font-size: 0.9em;
        }
        .form-group input, .form-group select {
            width: 100%; padding: 12px; border: 1px solid var(--border-color);
            border-radius: 6px; box-sizing: border-box; font-size: 1em;
            transition: all 0.2s ease-in-out;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none; border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }
        .form-group input[readonly] {
            background-color: var(--disabled-bg); cursor: not-allowed; color: #6c757d;
        }
        .media-preview-group {
            display: flex; align-items: center; gap: 15px;
        }
        /* --- IMPROVED CSS for Photo and Signature --- */
        .photo-preview {
            width: 80px; height: 80px; border: 1px solid var(--border-color);
            border-radius: 6px; object-fit: cover; /* 'cover' is better for photos */
        }
        .signature-preview {
            width: 150px; height: 80px; border: 1px solid var(--border-color);
            border-radius: 6px; object-fit: contain; /* 'contain' is better for signatures */
        }
        .button-group {
            grid-column: 1 / -1; margin-top: 30px; display: flex;
            justify-content: flex-end; gap: 15px;
        }
        .btn {
            padding: 12px 25px; border: none; border-radius: 6px; font-weight: 600;
            cursor: pointer; text-decoration: none; display: inline-flex;
            align-items: center; gap: 8px; transition: background-color 0.2s;
        }
        .btn-primary { background-color: var(--primary-blue); color: white; }
        .btn-primary:hover { background-color: #004494; }
        .btn-secondary { background-color: #e5e7eb; color: var(--text-dark); }
        .btn-secondary:hover { background-color: #d1d5db; }
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
                            <fmt:formatDate value="${studentData.dob}" pattern="yyyy-MM-dd" var="formattedDob" />
                            <input type="date" id="dob" name="dob" value="${formattedDob}">
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender">
                                <option value="Male" ${studentData.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${studentData.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${studentData.gender == 'Other' ? 'selected' : ''}>Other</option>
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
                            <label for="joindate">Join Category</label>
                            <input type="text" id="joindate" name="joindate" value="${studentData.joincate}">
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
                                 <img src="getphoto.jsp?id=${studentData.regd_no}" class="photo-preview" alt="Current Photo">
                                <input type="file" id="photo" name="photo">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="sign">New Signature (Optional)</label>
                             <div class="media-preview-group">
                                <img src="getSign.jsp?id=${studentData.regd_no}" class="signature-preview" alt="Current Signature">
                                <input type="file" id="sign" name="sign">
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
        </div>
    </main>
    
    <%@ include file="footer.jsp" %> 
</body>
</html>