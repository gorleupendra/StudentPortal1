package com.example;

public class CheckOtp 
{
public static boolean verifyOtp(int oldotp,int newotp)
{
	if(oldotp==newotp)
	{
		return true;
	}
	else
	{
		return false;
	}
}
}
