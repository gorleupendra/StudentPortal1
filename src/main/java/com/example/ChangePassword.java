package com.example;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ChangePassword extends HttpServlet 
{
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		String email=request.getParameter("email");
		String newpass=request.getParameter("newpass");
		try
		{
			Connection con=DbConnection.getConne();
			String sql = "UPDATE users SET password=? WHERE email=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newpass);
            ps.setString(2, email);
            int updated = ps.executeUpdate();
            if(updated>0)
            {
            	String sq="Select role from users where email=?";
            	ps=con.prepareStatement(sq);
            	ps.setString(1,email);
            	ResultSet rs=ps.executeQuery();
            	if(rs.next())
            	{
            		if(rs.getString("role").equals("student"))
            		{
            			request.getRequestDispatcher("studentpage.html").forward(request,response);            			
            			
            		}else
            		{
            			request.getRequestDispatcher("adminpage.html").forward(request,response);  
            		}
            	}
            }
			
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		
	}

}
