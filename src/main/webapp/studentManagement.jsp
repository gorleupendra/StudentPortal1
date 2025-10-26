<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.DbConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Assuming adminHeaderFooter.css is at the root --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminHeaderFooter.css"> 
    
    <%-- Include fonts from your main layout for consistency --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Inherit variables from main CSS if possible, define fallbacks */
        :root {
            --primary-blue: #0056b3; /* Original color */
            --primary-blue-hover: #004494; /* Original color */
            --text-dark: #1f2937;
            --text-medium: #4b5563;
            --text-light: #6c757d; /* Slightly darker light text */
            --border-color: #dee2e6; /* Lighter border */
            --header1-bg: #e7f3fe; /* Original color */
            --success-bg: #d4edda;
            --success-text: #155724;
            --success-border: #c3e6cb;
            --error-bg: #f8d7da;
            --error-text: #721c24;
            --error-border: #f5c6cb;
            --hover-bg: #e9ecef; /* Consistent hover background */
            --link-view: #17a2b8;
            --link-edit: #ffc107;
            --link-delete: #dc3545;
        }

        /* --- BODY and PAGE-CONTENT styles removed from here --- */
        /* --- They should be placed in adminHeaderFooter.css --- */

        .container { 
            max-width: 1200px; 
            margin: 20px auto; 
            background: #fff; 
            padding: 30px; /* Increased padding */
            border-radius: 8px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.07); /* Softer shadow */
        }
        .container h1, .container h2 { 
            color: var(--primary-blue);
            border-bottom: 2px solid #eee;
            padding-bottom: 12px; /* Slightly more padding */
            margin-bottom: 25px; /* Added margin */
            display: flex; /* Align icon and text */
            align-items: center;
            gap: 0.75rem;
            font-weight: 600; /* Bolder headings */
        }
        .container h1 { font-size: 1.8rem; }
        .container h2 { font-size: 1.4rem; }
        
        .alert {
            padding: 15px;
            margin-bottom: 25px; /* Increased margin */
            border: 1px solid transparent;
            border-radius: 6px;
            font-size: 1em;
        }
        .alert-success {
            color: var(--success-text);
            background-color: var(--success-bg);
            border-color: var(--success-border);
        }
        .alert-error {
            color: var(--error-text);
            background-color: var(--error-bg);
            border-color: var(--error-border);
        }

        .section-header {
            display: flex;
            flex-wrap: wrap; /* Allow wrapping on small screens */
            justify-content: space-between;
            align-items: center;
            gap: 15px; /* Add gap for wrapping */
            margin-bottom: 25px; /* Increased margin */
        }
        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            color: white;
            font-weight: 500; /* Adjusted font weight */
            text-decoration: none;
            background-color: var(--primary-blue);
            transition: background-color 0.2s, box-shadow 0.2s, transform 0.1s ease; /* Added transform */
            border: none;
            cursor: pointer;
            display: inline-flex; /* Align icon and text */
            align-items: center;
            gap: 0.5rem;
        }
        .btn:hover {
            background-color: var(--primary-blue-hover);
            box-shadow: 0 4px 8px rgba(0, 86, 179, 0.2); /* Subtle shadow on hover */
            transform: translateY(-1px); /* Slight lift effect */
        }
        .btn:active {
            transform: translateY(0); /* Press effect */
            box-shadow: none;
        }

        .search-bar {
            display: flex;
            flex-wrap: wrap; /* Allow wrapping */
            gap: 10px;
            margin-bottom: 25px; /* Increased margin */
        }
        .search-bar input[type="search"] {
            flex-grow: 1;
            min-width: 200px; /* Prevent input from becoming too small */
            padding: 10px 12px; /* Adjusted padding */
            border: 1px solid var(--border-color);
            border-radius: 5px;
            font-size: 0.95rem; /* Consistent font size */
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .search-bar input[type="search"]:focus {
             outline: none;
             border-color: var(--primary-blue);
             box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.15);
        }
        .search-bar button {
             flex-shrink: 0; /* Prevent button from shrinking */
        }

        /* Responsive Table Container */
        .table-container {
            width: 100%;
            overflow-x: auto; /* Enable horizontal scroll on small screens */
            border: 1px solid var(--border-color); /* Add border around scroll area */
            border-radius: 5px;
        }
        
        .students-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9em;
            min-width: 800px; /* Set a min-width so it scrolls nicely */
        }
        .students-table th, .students-table td {
            padding: 12px 15px; /* Increased padding */
            /* Removed border from here, handled by container */
            border-bottom: 1px solid var(--border-color); /* Only bottom border */
            text-align: left;
            vertical-align: middle;
            white-space: nowrap; /* Prevent text wrapping in cells */
        }
         .students-table td:last-child,
         .students-table th:last-child {
            padding-right: 15px; /* Ensure padding on last cell */
         }
         .students-table tr:last-child td {
             border-bottom: none; /* Remove border on last row */
         }

        .students-table thead {
            background-color: var(--header1-bg);
        }
        .students-table th {
            color: var(--primary-blue);
            font-weight: 600; /* Bolder header */
            border-bottom-width: 2px; /* Thicker border below header */
        }
        /* Style rows for better readability */
        .students-table tbody tr:nth-of-type(even) {
            background-color: #f8f9fa; /* Subtle striping */
        }
        .students-table tbody tr:hover {
            background-color: var(--hover-bg); /* Consistent Hover effect */
        }

        .students-table .actions {
            white-space: nowrap; /* Keep action icons together */
        }
        .students-table .actions a {
            text-decoration: none;
            margin-right: 12px; /* Increased spacing */
            font-size: 1.1em; /* Slightly larger icons */
            transition: opacity 0.2s;
        }
         .students-table .actions a:last-child {
             margin-right: 0; /* Remove margin on last icon */
         }
        .students-table .actions a:hover {
             opacity: 0.7;
        }
        .students-table .actions .view-link { color: var(--link-view); }
        .students-table .actions .edit-link { color: var(--link-edit); }
        .students-table .actions .delete-link { color: var(--link-delete); }
        
        .no-records {
            text-align: center;
            color: var(--text-light); /* Use theme color */
            padding: 25px; /* Increased padding */
            font-style: italic;
        }
        .record-count {
            text-align: right;
            margin-top: 15px;
            color: var(--text-medium); /* Use theme color */
            font-style: italic;
            font-size: 0.9em;
        }

        /* Mobile Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 15px;
                margin: 15px auto; /* Reduced margin */
            }
            .container h1 {
                font-size: 1.5rem;
            }
             .container h2 {
                font-size: 1.25rem;
            }
            .section-header {
                 flex-direction: column; /* Stack header elements */
                 align-items: stretch; /* Make button full width */
            }
             
             .search-bar,.section-header .btn {
                 flex-direction: column; /* Stack search elements */
            }
             .search-bar button {
                 width: 100%;
                 justify-content: center;
            }
            .students-table th, .students-table td {
                 padding: 10px 12px; /* Reduced padding on mobile */
                 white-space: normal; /* Allow wrapping on mobile */
            }
             .students-table .actions {
                 white-space: nowrap; /* Keep actions on one line */
             }
            .record-count {
                 text-align: center; /* Center count on mobile */
                 margin-top: 20px;
            }
        }

        @media (max-width: 480px) {
            .container h1 { font-size: 1.3rem; }
            .container h2 { font-size: 1.1rem; }
            .btn { padding: 8px 15px; }
            .search-bar input[type="search"] { font-size: 0.9rem; padding: 8px 10px; }
        }

    </style>
</head>
<body>
    <%-- Assuming admin_header.jsp is at the root or adjust path --%>
    <%@ include file="/admin_header.jsp" %> 
    
    <main class="page-content">
        <div class="container">
            <h1><i class="fas fa-users"></i> Student Management</h1>

            <%
                String status = request.getParameter("status");
                String message = request.getParameter("message");
                if (message != null && !message.isEmpty()) {
                    String alertClass = "success".equals(status) ? "alert-success" : "alert-error";
            %>
                    <div class="alert <%= alertClass %>">
                        <%= message %>
                    </div>
            <%
                }
            %>

            <div class="section-header">
                <h2><i class="fas fa-list-ul"></i> Existing Students</h2>
                <%-- Corrected context path case --%>
                <a href="${pageContext.request.contextPath}/studentregistration.jsp" class="btn" target="_blank"><i class="fas fa-user-plus"></i> Add New Student</a>
            </div>

            <form action="studentManagement.jsp" method="get" class="search-bar">
                <input type="search" name="search" placeholder="Search by name, regd no, email, phone, or dept..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="btn"><i class="fas fa-search"></i> Search</button>
            </form>
            
            <%-- Added container for horizontal scroll --%>
            <div class="table-container"> 
                <table class="students-table">
                    <thead>
                        <tr>
                            <th>Regd No.</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Department</th>
                            <th>Class</th>
                            <th>View</th>
                            <th>Edit</th>
                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        Connection con = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        boolean studentsFound = false;
                        int rowCount = 0;
                        
                        String searchQuery = request.getParameter("search");
                        
                        try {
                            con = DbConnection.getConne();
                            String sql;
                            
                            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                                sql = "SELECT regd_no, name, email, phone, dept, class FROM students WHERE name ILIKE ? OR regd_no ILIKE ? OR email ILIKE ? OR phone ILIKE ? OR dept ILIKE ? ORDER BY regd_no ASC"; // Use ILIKE for case-insensitive search in PostgreSQL
                                ps = con.prepareStatement(sql);
                                String searchPattern = "%" + searchQuery + "%";
                                ps.setString(1, searchPattern);
                                ps.setString(2, searchPattern);
                                ps.setString(3, searchPattern);
                                ps.setString(4, searchPattern);
                                ps.setString(5, searchPattern);
                            } else {
                                sql = "SELECT regd_no, name, email, phone, dept, class FROM students ORDER BY regd_no ASC";
                                ps = con.prepareStatement(sql);
                            }
                            
                            rs = ps.executeQuery();
                            
                            while (rs.next()) {
                                studentsFound = true;
                                rowCount++;
                                String regdNo = rs.getString("regd_no");
                                String name = rs.getString("name");
                                String email = rs.getString("email");
                                String phone = rs.getString("phone");
                                String dept = rs.getString("dept");
                                String studentClass = rs.getString("class");
                    %>
                        <tr>
                            <td><%= regdNo %></td>
                            <td><%= name %></td>
                            <td><%= email %></td>
                            <td><%= phone %></td>
                            <td><%= dept %></td>
                            <td><%= studentClass %></td>
                            <td class="actions"><a href="viewStudent?regdno=<%= regdNo %>" class="view-link" title="View Details"><i class="fas fa-eye"></i></a></td>
                            <td class="actions"><a href="editStudent?regdno=<%= regdNo %>" class="edit-link" title="Edit"><i class="fas fa-edit"></i></a></td>
                            <td class="actions"><a href="deleteStudent?regdno=<%= regdNo %>" class="delete-link" title="Delete" onclick="return confirm('Are you sure you want to delete student <%= regdNo %>?');"><i class="fas fa-trash"></i></a></td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) {}
                            if (ps != null) try { ps.close(); } catch (SQLException e) {}
                            if (con != null) try { con.close(); } catch (SQLException e) {}
                        }
                        if (!studentsFound) {
                    %>
                            <tr>
                                <td colspan="9" class="no-records">No students found<%=(searchQuery != null && !searchQuery.trim().isEmpty() ? " matching your search." : ".")%></td> <%-- Improved 'not found' message --%>
                            </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div> 

            <% if (studentsFound) { %>
                <p class="record-count">Total Records Found: <%= rowCount %></p>
            <% } %>

        </div>
    </main>

    <%-- Assuming footer.jsp is at the root or adjust path --%>
    <%@ include file="/footer.jsp" %> 
</body>
</html>

