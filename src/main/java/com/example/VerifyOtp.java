package com.example;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class VerifyOtp extends HttpServlet 
{

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException 
	{

		res.setContentType("text/plain");
		PrintWriter out = res.getWriter();

		String enteredOtp = req.getParameter("otp");
		String sessionOtp = (String) req.getSession().getAttribute("otp");
		String email = (String) req.getSession().getAttribute("email");
		if (sessionOtp != null && sessionOtp.equals(enteredOtp)) {
			out.println("OTP verified Successfully! ");
			// Optionally remove OTP from session
			req.getSession().removeAttribute("otp");
			
			
		} else {
			out.println("Invalid OTP. Try again!");
		}

	}

}
