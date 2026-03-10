<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- Import all necessary SQL classes --%>
<%@ page import="java.sql.*, com.example.DbConnection, java.util.*, java.text.SimpleDateFormat" %>

<%
    // --- Start of Server-Side Data Fetching ---
    String regdId = request.getParameter("regdno");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DbConnection.getConne();
        if (con == null) {
             throw new SQLException("Database connection failed.");
        }
        String sql = "SELECT *, photo IS NOT NULL as has_photo, sign IS NOT NULL as has_sign FROM students WHERE regd_no = ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, regdId);
        rs = ps.executeQuery();

        if (rs.next()) {
            request.setAttribute("regd_no", rs.getString("regd_no"));
            request.setAttribute("name", rs.getString("name"));
            request.setAttribute("fathername", rs.getString("fathername"));
            request.setAttribute("mothername", rs.getString("mothername"));
            request.setAttribute("email", rs.getString("email"));
            request.setAttribute("phone", rs.getString("phone"));
            request.setAttribute("admno", rs.getString("admno"));
            request.setAttribute("rank", rs.getInt("rank"));
            request.setAttribute("adtype", rs.getString("adtype"));
            request.setAttribute("studentClass", rs.getString("class"));
            request.setAttribute("dept", rs.getString("dept"));
            request.setAttribute("joincate", rs.getString("joincate"));
            request.setAttribute("dob", rs.getDate("dob"));
            request.setAttribute("gender", rs.getString("gender"));

            // Combine address parts safely, handling nulls
            List<String> addressParts = new ArrayList<>();
            String village = rs.getString("village");
            String mandal = rs.getString("mandal");
            String dist = rs.getString("dist");
            String pincode = rs.getString("pincode");
            if (village != null && !village.isEmpty()) addressParts.add(village);
            if (mandal != null && !mandal.isEmpty()) addressParts.add(mandal);
            if (dist != null && !dist.isEmpty()) addressParts.add(dist);
            if (pincode != null && !pincode.isEmpty()) addressParts.add(pincode);
            request.setAttribute("address", String.join(", ", addressParts));

            request.setAttribute("hasPhoto", rs.getBoolean("has_photo"));
            request.setAttribute("hasSign", rs.getBoolean("has_sign"));
        } else {
            request.setAttribute("noStudentFound", true);
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("dbError", e.getMessage());
    } finally {
        // Safe closing of resources
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    // --- End of Server-Side Data Fetching ---
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details - ${regd_no}</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="adminHeaderFooter.css">

   <style>
        :root { 
            --primary-blue: #0056b3;
            --border-color: #e5e7eb;
            --text-label: #374151;
            --text-data: #4b5563;
        }
        .container { 
            max-width: 1000px; 
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
        :root {
            --primary-blue: #0056b3;
            --border-color: #e5e7eb; /* Tailwind gray-200 */
            --text-label: #374151;   /* Tailwind gray-700 */
            --text-data: #4b5563;    /* Tailwind gray-600 */
        }
        body {
             background-color: #f3f4f6; /* Tailwind gray-100 */
        }
        /* Style for the back button - using Tailwind is preferred, but this works too */
        .btn-back {
            padding: 8px 15px;
            border-radius: 6px;
            color: var(--text-label);
            font-weight: 600;
            text-decoration: none;
            background-color: #e5e7eb; /* Tailwind gray-200 */
            transition: background-color 0.2s;
            border: 1px solid var(--border-color);
            display: inline-flex; /* Align icon and text */
            align-items: center;
        }
        .btn-back:hover {
            background-color: #d1d5db; /* Tailwind gray-300 */
        }
        .btn-back i {
             margin-right: 0.5rem; /* Tailwind mr-2 */
        }
        /* Specific styles for the dt/dd structure if needed */
        .profile-data dt {
             /* Tailwind class: text-sm font-medium text-gray-600 */
             font-size: 0.875rem;
             font-weight: 500;
             color: var(--text-label); /* Adjusted to gray-700 equivalent */
        }
         .profile-data dd {
              /* Tailwind class: text-base text-gray-900 mt-1 */
              font-size: 1rem;
              color: var(--text-data); /* Adjusted to gray-600 equivalent */
              margin-top: 0.25rem;
         }
         /* Highlight style */
         .profile-data .highlight dd {
              /* Tailwind classes: font-bold text-indigo-700 */
              font-weight: 700;
              color: #4338ca; /* Tailwind indigo-700 */
         }
         /* Add bottom border to each item */
         .profile-data > div {
             /* Tailwind classes: py-3 border-b border-gray-100 */
             padding-top: 0.75rem;
             padding-bottom: 0.75rem;
             border-bottom: 1px solid #f3f4f6; /* Tailwind gray-100 */
         }
          /* Address spanning two columns needs slightly different border handling in grid */
          .profile-data > .address-item {
              /* Tailwind classes: md:col-span-2 */
              grid-column: span 2 / span 2;
          }
           /* Remove bottom border from the very last item */
           .profile-data > div:last-child {
                border-bottom: none;
           }
            @media (min-width: 768px) {
                /* On medium screens and up (md: grid), remove border from second-to-last if last is full span */
                 .profile-data > .address-item:last-child {
                     border-bottom: none;
                 }
                 .profile-data > div:nth-last-child(2):not(.address-item) {
                    /* Only remove border if the last item spans columns */
                     border-bottom: none;
                 }
                 .profile-data > div:nth-last-child(2).address-item ~ div {
                     /* If address is second to last, remove border from actual last */
                      border-bottom: none;
                 }
            }
    </style>
</head>
<body class="flex flex-col min-h-screen">

    <%@ include file="admin_header.jsp" %>

    <main class="page-content flex-grow p-4 sm:p-8">
        <div class="container w-full max-w-4xl mx-auto bg-white p-6 sm:p-8 rounded-lg shadow-md">

            <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center border-b border-gray-200 pb-4 mb-6">
                <h2 class="text-2xl sm:text-3xl font-bold text-gray-800">
                    Student Profile
                </h2>
                <%-- Using Tailwind for the back button now --%>
                <a href="studentManagement.jsp" class="btn-back mt-4 sm:mt-0">
                    <i class="fas fa-arrow-left"></i>Back to List
                </a>
            </div>

            <c:if test="${not empty noStudentFound}">
                <div class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-6" role="alert">
                    <p class="font-bold">Not Found</p>
                    <p>No student was found with the provided Registration ID: <c:out value="${param.id}"/></p>
                </div>
            </c:if>
            <c:if test="${not empty dbError}">
                <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
                    <p class="font-bold">Database Error</p>
                    <p><c:out value="${dbError}"/></p>
                </div>
            </c:if>

            <c:if test="${empty noStudentFound and empty dbError}">
                <%-- FIXED: Changed wrapping div to dl and added class --%>
                <dl class="profile-data grid grid-cols-1 md:grid-cols-2 gap-x-8"> <%-- Removed gap-y, handled by item padding/border --%>

                    <%-- Reusable structure using div/dt/dd --%>
                    <div>
                        <dt>Registration Number:</dt>
                        <dd><c:out value="${regd_no}" default="N/A"/></dd>
                    </div>

                    <div class="highlight"> <%-- Added highlight class --%>
                        <dt>Name:</dt>
                        <dd><c:out value="${name}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Father's Name:</dt>
                        <dd><c:out value="${fathername}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Mother's Name:</dt>
                        <dd><c:out value="${mothername}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Email:</dt>
                        <dd><c:out value="${email}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Phone Number:</dt>
                        <dd><c:out value="${phone}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Admission No:</dt>
                        <dd><c:out value="${admno}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Rank:</dt>
                        <dd><c:out value="${rank}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Admission Type:</dt>
                        <dd><c:out value="${adtype}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Class:</dt>
                        <dd><c:out value="${studentClass}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Department:</dt>
                        <dd><c:out value="${dept}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Joining Category:</dt>
                        <dd><c:out value="${joincate}" default="N/A"/></dd>
                    </div>

                    <div>
                        <dt>Date of Birth:</dt>
                        <dd>
                            <c:choose>
                                <c:when test="${not empty dob}">
                                    <fmt:formatDate value="${dob}" pattern="dd-MM-yyyy"/>
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                             </c:choose>
                        </dd>
                    </div>

                    <div>
                        <dt>Gender:</dt>
                        <dd><c:out value="${gender}" default="N/A"/></dd>
                    </div>

                    <%-- Full-width address field --%>
                    <div class="address-item"> <%-- Added address-item class --%>
                        <dt>Address:</dt>
                        <dd><c:out value="${address}" default="N/A"/></dd>
                    </div>
                </dl> <%-- FIXED: Closing dl tag --%>

                <%-- Media container for Photo and Signature --%>
                <div class="flex flex-col sm:flex-row justify-around items-center mt-8 pt-6 border-t border-gray-200 gap-6">
                    <div class="text-center">
                        <p class="text-base font-medium text-gray-700 mb-2">Student Photo</p>
                        <div class="w-48 h-48 bg-gray-100 rounded-lg flex items-center justify-center border border-gray-200 overflow-hidden">
                            <c:choose>
                                <c:when test="${hasPhoto}">
                                    <img src="getphoto.jsp?id=${regd_no}" alt="Student Photo" class="w-full h-full object-contain">
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-500 italic text-sm">No Photo Available</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="text-center">
                        <p class="text-base font-medium text-gray-700 mb-2">Student Signature</p>
                        <div class="w-48 h-48 bg-gray-100 rounded-lg flex items-center justify-center border border-gray-200 overflow-hidden">
                            <c:choose>
                                <c:when test="${hasSign}">
                                    <img src="getSign.jsp?id=${regd_no}" alt="Student Signature" class="w-full h-full object-contain">
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-500 italic text-sm">No Signature Available</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:if>

        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>