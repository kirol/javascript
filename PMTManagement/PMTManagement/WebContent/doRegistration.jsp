<%@page import="controller.Utils"%>
<%@page import="controller.DatabaseProcessing"%>
<%@ page import="java.security.*" %>
<%@ page import="java.math.BigInteger" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	String txtFullName = request.getParameter("txtFullName");
	String txtATTUID = request.getParameter("txtATTUID");
	String txtPassword = request.getParameter("txtPassword");
	
	out.println("Full name: " + txtFullName + "<br/>");
	out.println("ATT UID: " + txtATTUID + "<br/>");
	out.println("Password: " + txtPassword + "<br/>");

	//hashing password with ATT UID as salt
	String plainPasswordWithSalt = "$" + txtATTUID + "$" + txtPassword;
	String hashedPassword = Utils.hashMD5Password(plainPasswordWithSalt);
	
	out.println("Hashed Password: " + hashedPassword + "<br/>");
	DatabaseProcessing.getInstance();
	int statusCode = DatabaseProcessing.doRegisterUser(txtFullName, txtATTUID, hashedPassword);
	
	if (statusCode == -1)
	{
		out.println("User registration is not successful. ATT UID is already existed." + "<br/>");
	}
%>
