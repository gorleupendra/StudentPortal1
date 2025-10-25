<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="adminHeaderFooter.css">
    <style>
        :root { 
            --primary-blue: #0056b3;
            --border-color: #e5e7eb;
            --text-label: #374151;
            --text-data: #4b5563;
        }
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; display: flex; flex-direction: column; min-height: 100vh; }
        .page-content { flex: 1; padding: 20px; }
        .container { 
            max-width: 800px; 
            margin: 20px auto; 
            background: #fff; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        }
        /* NEW: Header for title and back button */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .profile-title {
            font-size: 1.75em;
            font-weight: 600;
            color: var(--text-label);
            margin: 0;
        }
        .profile-title .student-name {
            color: var(--primary-blue);
        }
        .profile-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 1em;
        }
        .profile-table td {
            padding: 15px 10px;
            border-bottom: 1px solid var(--border-color);
        }
        .profile-table tr:last-child td {
            border-bottom: none;
        }
        .profile-table td:first-child {
            width: 35%;
            font-weight: 600;
            color: var(--text-label);
        }
        .profile-table td:last-child {
            color: var(--text-data);
        }
        .media-container {
            display: flex;
            justify-content: space-around;
            align-items: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid var(--border-color);
            gap: 20px;
        }
        .media-item {
            text-align: center;
        }
        .media-item img {
            width: 150px;
            height: 150px;
            border-radius: 8px;
            object-fit: contain;
            border: none;
        }
        .media-item .profile-photo {
             object-fit: contain;
        }
        .media-item p {
            margin-top: 10px;
            font-weight: 600;
            color: var(--text-label);
        }
        /* Style for the back button */
        .btn {
            padding: 8px 15px;
            border-radius: 6px;
            color: var(--text-label);
            font-weight: 600;
            text-decoration: none;
            background-color: #e5e7eb;
            transition: background-color 0.2s;
            border: 1px solid var(--border-color);
        }
        .btn:hover {
            background-color: #d1d5db;
        }
    </style>
</head>
<body>
    <%@ include file="admin_header.jsp" %>
    <main class="page-content">
        <div class="container">

            <div class="page-header">
                <h2 class="profile-title">
                    Student Profile
                </h2>
                <a href="studentManagement.jsp" class="btn"><i class="fas fa-arrow-left"></i> Back to List</a>
            </div>

            <table class="profile-table">
                <tbody>
                    <tr>
                        <td>Registration Number:</td>
                        <td>${regd_no}</td>
                    </tr>
                    <tr>
                        <td>Name:</td>
                        <td style="font-weight: bold; color: var(--primary-blue);">${name}</td>
                    </tr>
                    <tr>
                        <td>Father's Name:</td>
                        <td><c:out value="${fathername}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <td>Mother's Name:</td>
                        <td><c:out value="${mothername}" default="N/A"/></td>
                    </tr>
                    <%-- (The rest of your table data remains the same) --%>
                    <tr>
                        <td>Email:</td>
                        <td>${email}</td>
                    </tr>
                    <tr>
                        <td>Phone Number:</td>
                        <td><c:out value="${phone}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <td>Admission No:</td>
                        <td><c:out value="${admno}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <td>Rank:</td>
                        <td><c:out value="${rank}" default="N/A"/></td>
                    </tr>
                     <tr>
                        <td>Admission Type:</td>
                        <td><c:out value="${adtype}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <td>Class:</td>
                        <td><c:out value="${studentClass}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <td>Department:</td>
                        <td><c:out value="${dept}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <td>Joining Category:</td>
                        <td><c:out value="${joindate}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <td>Date of Birth:</td>
                        <td>
                            <c:if test="${not empty dob}">
                                <fmt:formatDate value="${dob}" pattern="yyyy-MM-dd"/>
                            </c:if>
                            <c:if test="${empty dob}">N/A</c:if>
                        </td>
                    </tr>
                    <tr>
                        <td>Gender:</td>
                        <td><c:out value="${gender}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <td>Address:</td>
                        <td>
                            <c:set var="addressParts" value="${address}" />
                            <c:set var="formattedAddress" value="" />
                            <c:forEach items="${addressParts}" var="part" varStatus="status">
                                <c:if test="${not empty part}">
                                    <c:set var="formattedAddress" value="${formattedAddress}${part}" />
                                    <c:if test="${not status.last}">
                                        <c:set var="formattedAddress" value="${formattedAddress}, " />
                                    </c:if>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty formattedAddress}">N/A</c:if>
                            <c:if test="${not empty formattedAddress}">${formattedAddress}</c:if>
                        </td>
                    </tr>
                </tbody>
            </table>
            
            <div class="media-container">
                 <div class="media-item">
                    <c:choose>
                        <c:when test="${hasPhoto}">
                            <img src="getphoto.jsp?id=${regd_no}" alt="Student Photo" class="profile-photo">
                        </c:when>
                        <c:otherwise>
                            <div class="no-media">No Photo</div>
                        </c:otherwise>
                    </c:choose>
                    <p>Student Photo</p>
                </div>
                <div class="media-item">
                    <c:choose>
                        <c:when test="${hasSign}">
                            <img src="getSign.jsp?id=${regd_no}" alt="Student Signature" class="profile-sign">
                        </c:when>
                        <c:otherwise>
                            <div class="no-media">No Signature</div>
                        </c:otherwise>
                    </c:choose>
                    <p>Student Signature</p>
                </div>
            </div>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>