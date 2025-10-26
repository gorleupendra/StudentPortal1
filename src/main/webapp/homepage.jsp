<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Import necessary Java classes for database connection --%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@ page import="com.example.DbConnection"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - University Portal</title>
    
    <%-- Fonts and Icons --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Stylesheets --%>
    <%-- Main layout CSS (Header/Footer) --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/header/style.css"> 
    
    <%-- Homepage-specific CSS is now included below --%>
    <style>
        /* /home.css */

        /*
          ==========================================================================
          1. Home Page Layout (Single Column)
          ==========================================================================
        */
        .home-layout {
            display: flex;
            justify-content: center; /* Center the single column */
            width: 100%;
        }

        .notifications-column {
            width: 100%;
            max-width: 900px; /* Max width for the notification list */
            min-width: 0; 
        }

        /*
          ==========================================================================
          2. Notifications Column Styling (PROFESSIONAL & ATTRACTIVE)
          ==========================================================================
        */

        .notifications-container {
            background-color: white;
            border-radius: 1rem;
            /* Elevated, softer shadow */
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.08); 
            width: 100%;
            padding: 2.5rem 2.5rem;
            margin: 0 auto; /* Ensure it stays centered */
        }

        .notifications-container h1 {
            text-align: left;
            color: var(--text-dark);
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 2.5rem;
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 0.8rem;
            letter-spacing: -0.02em; 
        }

        .notifications-container h1 i {
            color: var(--primary-blue);
            font-size: 1.8rem;
        }

        .notifications-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 1.2rem; 
        }

        .notification-item {
            border: 1px solid var(--border-color);
            border-radius: 0.75rem;
            padding: 1.5rem;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            position: relative;
            overflow: hidden;
            background-color: #fcfcfc;
        }

        .notification-item:hover {
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.07);
            border-color: var(--primary-blue);
            transform: translateY(-3px); 
            background-color: #ffffff;
        }

        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.8rem;
            gap: 1rem;
            flex-wrap: wrap; 
        }

        .notification-title {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1.15rem; 
            display: flex;
            align-items: center;
            gap: 0.7rem;
        }

        .notification-title i {
            color: var(--primary-blue); 
            font-size: 1.05rem;
        }

        .notification-date {
            font-size: 0.85rem;
            color: var(--text-light);
            white-space: nowrap;
            flex-shrink: 0;
        }

        .notification-body p {
            color: var(--text-medium);
            line-height: 1.65;
            margin-bottom: 1.2rem;
            padding-left: 1.8rem; 
            font-size: 0.95rem; 
        }

        .notification-body a {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            padding-left: 1.8rem; 
            transition: color 0.2s ease, transform 0.2s ease;
            display: inline-flex;
            align-items: center;
        }

        .notification-body a i {
            font-size: 0.8rem;
            margin-left: 0.4rem;
            transition: transform 0.2s ease;
        }

        .notification-body a:hover {
            color: var(--primary-blue-hover);
            transform: translateX(2px);
        }

        .notification-body a:hover i {
            transform: translateX(3px);
        }

        .new-badge {
            position: absolute;
            top: 0; 
            right: 0; 
            background-color: var(--error-color);
            color: white;
            font-size: 0.7rem; 
            font-weight: 700;
            padding: 0.3rem 0.6rem;
            border-bottom-left-radius: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        /*
          ==========================================================================
          3. Responsive for Mobile
          ==========================================================================
        */
        @media (max-width: 768px) {
            .notifications-container {
                padding: 2rem 1.5rem;
            }
            
            .notifications-container h1 {
                font-size: 1.8rem;
                margin-bottom: 2rem;
            }

            .notification-title {
                font-size: 1.05rem;
            }

            .notification-body p {
                padding-left: 0; /* Remove padding for body on mobile */
                font-size: 0.9rem;
            }
            .notification-body a {
                padding-left: 0; /* Remove padding for link on mobile */
                font-size: 0.85rem;
            }
        }

        @media (max-width: 480px) {
            .notifications-container h1 {
                font-size: 1.5rem;
                flex-wrap: wrap;
            }
            .notification-header {
                flex-direction: column; /* Stack title and date */
                align-items: flex-start;
                margin-bottom: 0.5rem;
            }
            .notification-title {
                font-size: 1rem;
            }
            .notification-date {
                font-size: 0.8rem;
            }
        }
    </style>
    
</head>
<body>

    <%-- Include the header --%>
    <%@ include file="/header/header.jsp" %>

    <%-- Main content area --%>
    <main class="main-content">
        
        <div class="home-layout">

            <!-- Column 1: Notifications -->
            <div class="notifications-column">
                <div class="notifications-container">
                    <h1><i class="fa-solid fa-bullhorn"></i> Latest Notifications</h1>
                    <ul class="notifications-list">
                        
                        <%-- 
                          ==========================================================================
                           DYNAMIC NOTIFICATION SECTION
                          ==========================================================================
                        --%>
                        
                        <%
                            Connection conn = null;
                            Statement stmt = null;
                            ResultSet rs = null;
                            
                            // Date formatter to display dates like "Oct 25, 2025"
                            SimpleDateFormat displayDateFormatter = new SimpleDateFormat("MMM dd, yyyy");

                            try {
                            	conn = DbConnection.getConne(); // Using your connection class
                                stmt = conn.createStatement();
                                
                                // Query includes the 'link' column
                                String sql = "SELECT id, title, date_published, body, link_text, is_new, link FROM notification ORDER BY date_published DESC LIMIT 10"; 
                                rs = stmt.executeQuery(sql);

                                // Check if any notifications were returned
                                if (!rs.isBeforeFirst()) { 
                        %>
                                    <p style="padding-left: 1.5rem; color: var(--text-medium);">No new notifications at this time.</p>
                        <%
                                } else {
                                    // Loop through all results
                                    while(rs.next()) {
                                        // Get data from columns
                                        int notificationId = rs.getInt("id");
                                        String title = rs.getString("title");
                                        Date date = rs.getDate("date_published");
                                        String body = rs.getString("body");
                                        String linkText = rs.getString("link_text");
                                        boolean isNew = rs.getBoolean("is_new");
                                        String link = rs.getString("link"); // The external link URL
                                        
                                        String displayDate = displayDateFormatter.format(date);
                        %>
                        
                        <!-- This is the dynamic notification item template -->
                        <li class="notification-item">
                            <% if(isNew) { %>
                                <span class="new-badge">NEW</span>
                            <% } %>
                            <div class="notification-header">
                                <span class="notification-title"><i class="fa-solid fa-calendar-check"></i> <%= title %></span>
                                <span class="notification-date"><%= displayDate %></span>
                            </div>
                            <div class="notification-body">
                                <p><%= body %></p>
                                
                                <%-- This logic checks if an external link exists --%>
                                <%
                                    if (link != null && !link.trim().isEmpty()) {
                                %>
                                        <%-- If YES, show external link in a new tab --%>
                                        <a href="<%= link %>" target="_blank" rel="noopener noreferrer">
                                            <%= linkText %> <i class="fa-solid fa-external-link-alt"></i>
                                        </a>
                                <%
                                    } else {
                                %>
                                        <%-- If NO, show the internal download link --%>
                                        <a href="${pageContext.request.contextPath}/downloadNotification?id=<%= notificationId %>">
                                            <%= linkText %> <i class="fa-solid fa-download"></i>
                                        </a>
                                <%
                                    }
                                %>
                            </div>
                        </li>

                        <%
                                    } // end while loop
                                } // end else
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                                <p style="padding-left: 1.5rem; color: var(--error-color);">Error: Could not load notifications.</p>
                        <%
                            } finally {
                                // Close all database resources
                                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                                if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                                if (conn != null) try { conn.close(); } catch (SQLException e) {}
                            }
                        %>
                        
                    </ul>
                </div>
            </div>

        </div>
    </main>

    <div id="toast"></div>

    <%-- Include the footer --%>
    <%@ include file="/header/footer.jsp" %>

</body>
</html>

