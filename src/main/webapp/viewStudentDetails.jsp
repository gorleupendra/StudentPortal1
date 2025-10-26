<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- Import all necessary SQL classes --%>
<%@ page import="java.sql.*, com.example.DbConnection, java.util.*, java.text.SimpleDateFormat" %>

<%
    // --- Start of Server-Side Data Fetching ---
    // This is more secure and robust than passing all data in the URL.
    
    // Get the ID from the request
    String regdId = request.getParameter("id");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DbConnection.getConne();
        // Updated query to fetch all details for one student
        String sql = "SELECT *, photo IS NOT NULL as has_photo, sign IS NOT NULL as has_sign FROM students WHERE regd_no = ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, regdId);
        rs = ps.executeQuery();

        if (rs.next()) {
            // Set attributes for the JSTL tags to use
            request.setAttribute("regd_no", rs.getString("regd_no"));
            request.setAttribute("name", rs.getString("name"));
            request.setAttribute("fathername", rs.getString("fathername"));
            request.setAttribute("mothername", rs.getString("mothername"));
            request.setAttribute("email", rs.getString("email"));
            request.setAttribute("phone", rs.getString("phone"));
            request.setAttribute("admno", rs.getString("admno"));
            request.setAttribute("rank", rs.getInt("rank"));
            request.setAttribute("adtype", rs.getString("adtype"));
            request.setAttribute("studentClass", rs.getString("class")); // 'class' is a reserved word
            request.setAttribute("dept", rs.getString("dept"));
            request.setAttribute("joincate", rs.getString("joincate")); // Changed from joindate
            request.setAttribute("dob", rs.getDate("dob"));
            request.setAttribute("gender", rs.getString("gender"));
            
            // Combine address parts
            String address = String.join(", ", 
                rs.getString("village"), 
                rs.getString("mandal"), 
                rs.getString("dist"), 
                rs.getString("pincode"));
            request.setAttribute("address", address);

            request.setAttribute("hasPhoto", rs.getBoolean("has_photo"));
            request.setAttribute("hasSign", rs.getBoolean("has_sign"));
            
        } else {
            // No student found, set a flag
            request.setAttribute("noStudentFound", true);
        }

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("dbError", e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (ps != null) try { ps.close(); } catch (SQLException e) {}
        if (con != null) try { con.close(); } catch (SQLException e) {}
    }
    // --- End of Server-Side Data Fetching ---
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- ADDED: Viewport for mobile responsiveness -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details</title>
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- ADDED: Tailwind CSS for all styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Your existing header/footer CSS -->
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
    </style>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

    <%@ include file="admin_header.jsp" %>
    
    <main class="page-content flex-grow p-4 sm:p-8">
        <!-- 
          MODIFIED: Container is now responsive
          - w-full: Full width on mobile
          - max-w-4xl: Max width on desktop
          - mx-auto: Centered on desktop
        -->
        <div class="container w-full max-w-4xl mx-auto bg-white p-6 sm:p-8 rounded-lg shadow-md">

            <!-- MODIFIED: Page header with responsive padding and font size -->
            <div class="page-header flex flex-col sm:flex-row sm:justify-between sm:items-center border-b border-gray-200 pb-4 mb-6">
                <h2 class="profile-title text-2xl sm:text-3xl font-bold text-gray-800">
                    Student Profile
                </h2>
                <a href="studentManagement.jsp" class="btn w-full sm:w-auto mt-4 sm:mt-0 inline-block text-center px-4 py-2 rounded-md bg-gray-200 text-gray-700 font-medium hover:bg-gray-300 transition-all">
                    <i class="fas fa-arrow-left mr-2"></i>Back to List
                </a>
            </div>

            <!-- Error/Not Found Handling -->
            <c:if test="${not empty noStudentFound}">
                <div class="bg-yellow-50 border-l-4 border-yellow-400 text-yellow-700 p-4" role="alert">
                    <p class="font-bold">Not Found</p>
                    <p>No student was found with the provided Registration ID: ${param.id}</p>
                </div>
            </c:if>
            <c:if test="${not empty dbError}">
                <div class="bg-red-50 border-l-4 border-red-400 text-red-700 p-4" role="alert">
                    <p class="font-bold">Database Error</p>
                    <p>${dbError}</p>
                </div>
            </c:if>

            <!-- 
              MODIFIED: Replaced <table> with a responsive <div> grid
              - Stacks on mobile (1 column)
              - Becomes 2 columns on desktop (md:grid-cols-2)
            -->
            <c:if test="${empty noStudentFound and empty dbError}">
                <div class="profile-data grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-5">
                    
                    <!-- Helper component for data pairs -->
                    <jsp:template prefix="ui" data_label="Registration Number:" data_value="${regd_no}" />
                    <jsp:template prefix="ui" data_label="Name:" data_value="${name}" data_highlight="true" />
                    <jsp:template prefix="ui" data_label="Father's Name:" data_value="${fathername}" />
                    <jsp:template prefix="ui" data_label="Mother's Name:" data_value="${mothername}" />
                    <jsp:template prefix="ui" data_label="Email:" data_value="${email}" />
                    <jsp:template prefix="ui" data_label="Phone Number:" data_value="${phone}" />
                    <jsp:template prefix="ui" data_label="Admission No:" data_value="${admno}" />
                    <jsp:template prefix="ui" data_label="Rank:" data_value="${rank}" />
                    <jsp:template prefix="ui" data_label="Admission Type:" data_value="${adtype}" />
                    <jsp:template prefix="ui" data_label="Class:" data_value="${studentClass}" />
                    <jsp:template prefix="ui" data_label="Department:" data_value="${dept}" />
                    <jsp:template prefix="ui" data_label="Joining Category:" data_value="${joincate}" />
                    
                    <div class="py-3 border-b border-gray-100">
                        <dt class="text-sm font-medium text-gray-600">Date of Birth:</dt>
                        <dd class="text-base text-gray-900 mt-1">
                            <c:if test="${not empty dob}">
                                <fmt:formatDate value="${dob}" pattern="dd-MM-yyyy"/>
                            </c:if>
                            <c:if test="${empty dob}">N/A</c:if>
                        </dd>
                    </div>

                    <jsp:template prefix="ui" data_label="Gender:" data_value="${gender}" />
                    
                    <!-- Full-width address field -->
                    <div class="md:col-span-2 py-3 border-b border-gray-100">
                        <dt class="text-sm font-medium text-gray-600">Address:</dt>
                        <dd class="text-base text-gray-900 mt-1">
                            <c:if test="${not empty address}">${address}</c:if>
                            <c:if test="${empty address}">N/A</c:if>
                        </dd>
                    </div>
                </div>
            
                <!-- 
                  MODIFIED: Media container
                  - Stacks on mobile (flex-col)
                  - Becomes a row on desktop (sm:flex-row)
                -->
                <div class="media-container flex flex-col sm:flex-row justify-around items-center mt-8 pt-6 border-t border-gray-200 gap-6">
                    <div class="media-item text-center">
                        <p class="text-base font-medium text-gray-700 mb-2">Student Photo</p>
                        <div class="w-48 h-48 bg-gray-100 rounded-lg flex items-center justify-center border border-gray-200">
                            <c:choose>
                                <c:when test="${hasPhoto}">
                                    <img src="getphoto.jsp?id=${regd_no}" alt="Student Photo" class="w-full h-full object-contain rounded-lg">
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-500 italic">No Photo</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="media-item text-center">
                        <p class="text-base font-medium text-gray-700 mb-2">Student Signature</p>
                        <div class="w-48 h-48 bg-gray-100 rounded-lg flex items-center justify-center border border-gray-200">
                            <c:choose>
                                <c:when test="${hasSign}">
                                    <img src="getSign.jsp?id=${regd_no}" alt="Student Signature" class="w-full h-full object-contain rounded-lg">
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-500 italic">No Signature</span>
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

<!-- 
  This is a reusable template for displaying data.
  It's defined here and used above with <jsp:template>
-->
<jsp:template prefix="ui" data_label="" data_value="" data_highlight="false">
    <div class="py-3 border-b border-gray-100">
        <dt class="text-sm font-medium text-gray-600">${data_label}</dt>
        <dd class="text-base mt-1 ${data_highlight ? 'font-bold text-indigo-700' : 'text-gray-900'}">
            <c:out value="${data_value}" default="N/A"/>
        </dd>
    </div>
</jsp:template>
