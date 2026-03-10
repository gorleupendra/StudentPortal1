<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.example.DbConnection" %><%--
NOTE: There must be NO whitespace or characters before this line.
--%><%
    String regdno = request.getParameter("id");
    if (regdno == null || regdno.isEmpty()) {
        return; // Exit if no ID is provided
    }

    // Use try-with-resources for automatic and safe closing of database resources
    try (Connection con = DbConnection.getConne();
         PreparedStatement ps = con.prepareStatement("SELECT photo FROM STUDENTS WHERE regd_no=?")) {

        ps.setString(1, regdno);
        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                // CHANGE: Get the binary data directly as an InputStream from the BYTEA column
                InputStream inputStream = rs.getBinaryStream("photo");
                
                if (inputStream != null && inputStream.available() > 0) {
                    // Set the content type to tell the browser this is an image
                    response.setContentType("image/jpeg"); // Or image/png, etc.

                    OutputStream outputStream = response.getOutputStream();
                    
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    
                    // Write the image data to the browser's output stream
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                    
                    inputStream.close();
                    outputStream.flush();
                }
            }
        }
    } catch (Exception e) {
        // This will print the error to your server's console (e.g., Tomcat logs)
        e.printStackTrace();
    }
    // The 'finally' block is no longer needed because try-with-resources handles closing.
%>