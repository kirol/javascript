<%@page import="controller.Utils"%>
<%@page import="controller.DatabaseProcessing"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String txtATTUID = request.getParameter("txtYourATTUID");
	String txtPassword = request.getParameter("txtPassword");
	
	String unhashedPassword = "$" + txtATTUID + "$" + txtPassword;
	
	out.println("ATT UID: " + txtATTUID + "<br/>");
	out.println("Password: " + txtPassword + "<br/>");
	
	DatabaseProcessing.getInstance();
	String hashedPassword = DatabaseProcessing.getMemberHashedPassword(txtATTUID);
	
	if (hashedPassword.length() == 0)
	{
		out.println("There is no user with ATT UID like '" + txtATTUID + "'!");
	} else
	{
		if (hashedPassword.equals(Utils.hashMD5Password(unhashedPassword)))
		{
			out.print("Login successful!");
			response.sendRedirect("manageTimeSheet.jsp");
		} else
		{
			out.print("Login incorrect!");
		}
	}
%>