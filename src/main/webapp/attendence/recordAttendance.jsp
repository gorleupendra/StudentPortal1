<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection, java.util.*, java.time.LocalDate" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // --- Fetch filter parameters if they exist ---
    String selectedClass = request.getParameter("studentClass");
    String selectedYearStr = request.getParameter("joiningYear");
    Integer selectedYear = null;
    if (selectedYearStr != null && !selectedYearStr.isEmpty()) {
        try {
            selectedYear = Integer.parseInt(selectedYearStr);
        } catch (NumberFormatException e) {
            // Handle error - invalid year format
        }
    }

    // --- Fetch students based on filters ---
    List<Map<String, String>> studentList = new ArrayList<>();
    if (selectedClass != null && !selectedClass.isEmpty() && selectedYear != null) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DbConnection.getConne(); // Replace with your connection method
            // Adjust the query based on your 'students' table structure
            String sql = "SELECT regd_no, name FROM students WHERE class = ? AND joinyear = ? ORDER BY regd_no ASC";
            ps = con.prepareStatement(sql);
            ps.setString(1, selectedClass);
            ps.setInt(2, selectedYear);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> student = new HashMap<>();
                student.put("regd_no", rs.getString("regd_no"));
                student.put("name", rs.getString("name"));
                studentList.add(student);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log error
            request.setAttribute("errorMessage", "Error fetching student list: " + e.getMessage());
        } finally {
             try { if (rs != null) rs.close(); } catch (SQLException e) {}
             try { if (ps != null) ps.close(); } catch (SQLException e) {}
             try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
    pageContext.setAttribute("studentList", studentList); // Set for JSTL access
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Batch Attendance</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminHeaderFooter.css">
    <style>
        /* Simple table styles */
        .attendance-table { width: 100%; border-collapse: collapse; margin-top: 1.5rem; }
        .attendance-table th, .attendance-table td { border: 1px solid #e5e7eb; padding: 0.75rem; text-align: left; }
        .attendance-table thead { background-color: #f3f4f6; }
        .attendance-table th { font-weight: 600; color: #374151; }
        .radio-group label { margin-right: 1rem; cursor: pointer; }
        .radio-group input { margin-right: 0.25rem; }
    </style>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

    <%@ include file="/admin_header.jsp" %>

    <main class="page-content flex-grow p-4 sm:p-8">
        <div class="container w-full max-w-4xl mx-auto bg-white p-6 sm:p-8 rounded-lg shadow-md">
            <h1 class="text-2xl font-bold text-gray-700 mb-6 border-b pb-3 flex items-center gap-3">
                <i class="fas fa-calendar-check"></i> Record Batch Attendance
            </h1>

            <%-- Display Messages --%>
            <c:if test="${not empty param.status}">
                <div class="mb-4 p-4 rounded-md text-sm ${param.status == 'success' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                    <c:out value="${param.message}"/>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                 <div class="mb-4 p-4 rounded-md text-sm bg-red-100 text-red-700">
                     <c:out value="${errorMessage}"/>
                 </div>
            </c:if>

            <%-- Filter Form (Submits to reload the page with student list) --%>
            <form action="batchAttendance.jsp" method="GET" class="mb-6 bg-gray-50 p-4 rounded-md border">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                    <%-- Class Select --%>
                    <div>
                        <label for="studentClass" class="block text-sm font-medium text-gray-600 mb-1">Class</label>
                        <select id="studentClass" name="studentClass" required
                                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 bg-white">
                            <option value="" disabled ${empty param.studentClass ? 'selected' : ''}>Select Class</option>
                            <option value="MCA" ${param.studentClass == 'MCA' ? 'selected' : ''}>MCA</option>
                            <option value="MSC CS" ${param.studentClass == 'MSC CS' ? 'selected' : ''}>MSc CS</option>
                            <option value="BTECH CSE" ${param.studentClass == 'BTECH CSE' ? 'selected' : ''}>BTech CSE</option>
                            <option value="MTECH SE" ${param.studentClass == 'MTECH SE' ? 'selected' : ''}>MTech SE</option>
                            <%-- Add other class options --%>
                        </select>
                    </div>

                    <%-- Joining Year Select --%>
                    <div>
                        <label for="joiningYear" class="block text-sm font-medium text-gray-600 mb-1">Joining Year</label>
                        <input type="number" id="joiningYear" name="joiningYear" placeholder="YYYY" required
                               min="2015" max="<%= LocalDate.now().getYear() %>"
                               value="${param.joiningYear}"
                               class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                        <%-- Alternatively, use a select dropdown if years are fixed --%>
                    </div>
                </div>
                <button type="submit"
                        class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    <i class="fas fa-filter mr-2"></i> Load Students
                </button>
            </form>

            <%-- Attendance Submission Form (Shown only if students are loaded) --%>
            <c:if test="${not empty studentList}">
                <form action="batchAttendanceServlet" method="POST">
                    <%-- Hidden fields to pass filter criteria and common details --%>
                    <input type="hidden" name="studentClass" value="${param.studentClass}">
                    <input type="hidden" name="joiningYear" value="${param.joiningYear}">

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                         <%-- Date Input --%>
                        <div>
                            <label for="attendanceDate" class="block text-sm font-medium text-gray-600 mb-1">Attendance Date</label>
                            <input type="date" id="attendanceDate" name="attendanceDate"
                                   value="<%= LocalDate.now().toString() %>" required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                        </div>

                         <%-- Timing Slot Select --%>
                         <div>
                            <label for="timing" class="block text-sm font-medium text-gray-600 mb-1">Timing Slot</label>
                            <select id="timing" name="timing" required
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 bg-white">
                                <option value="" disabled selected>Select Time Slot</option>
                                <option value="9:00-10:40">9:00 AM - 10:40 AM</option>
                                <option value="10:40-12:20">10:40 AM - 12:20 PM</option>
                                <option value="1:30-3:10">1:30 PM - 3:10 PM</option>
                                <option value="3:10-4:30">3:10 PM - 4:30 PM</option>
                            </select>
                        </div>

                         <%-- Subject Name Input --%>
                         <div>
                            <label for="subjectName" class="block text-sm font-medium text-gray-600 mb-1">Subject Name</label>
                            <input type="text" id="subjectName" name="subjectName" placeholder="Enter subject name" required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                         </div>
                    </div>

                    <h2 class="text-xl font-semibold text-gray-700 mb-3">Mark Attendance for ${param.studentClass} (${param.joiningYear})</h2>

                    <div class="overflow-x-auto">
                        <table class="attendance-table min-w-full">
                            <thead>
                                <tr>
                                    <th>Regd. No.</th>
                                    <th>Student Name</th>
                                    <th>Status (Present / Absent)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="student" items="${studentList}">
                                    <tr>
                                        <td>
                                            <c:out value="${student.regd_no}"/>
                                            <%-- Include regd_no as a hidden field or part of the radio name --%>
                                            <input type="hidden" name="studentRegdNos" value="${student.regd_no}">
                                        </td>
                                        <td><c:out value="${student.name}"/></td>
                                        <td>
                                            <div class="radio-group">
                                                <%-- Name radio buttons uniquely per student --%>
                                                <label>
                                                    <input type="radio" name="isPresent_${student.regd_no}" value="true" required checked> Present
                                                </label>
                                                <label>
                                                    <input type="radio" name="isPresent_${student.regd_no}" value="false" required> Absent
                                                </label>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <button type="submit"
                            class="mt-6 w-full md:w-auto flex justify-center py-2 px-6 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                        <i class="fas fa-check-double mr-2"></i> Submit Attendance Batch
                    </button>
                </form>
            </c:if> <%-- End check for student list --%>

            <c:if test="${empty studentList and not empty param.studentClass and not empty param.joiningYear}">
                 <p class="mt-6 text-center text-gray-600 italic">No students found for the selected class and joining year.</p>
            </c:if>

        </div> <%-- End container --%>
    </main>

    <%@ include file="/footer.jsp" %>

</body>
</html>