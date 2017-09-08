<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name = "viewport" content = "width = device-width, initial-scale = 1">
		<title>User Register</title>
		<!-- Bootstrap -->
		<link href = "bootstrap-3.3.7/css/bootstrap.min.css" rel = "stylesheet">
		<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
		<script src = "jQuery/jquery-3.2.1.min.js"></script>
		<!-- Include all compiled plugins (below), or include individual files as needed -->
		<script src = "bootstrap-3.3.7/js/bootstrap.min.js"></script>
      
		<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
		<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->

		<!--[if lt IE 9]>
		<script src = "https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		<script src = "https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->
	</head>
	<body>
		<form action="doRegistration.jsp" method="post">
			<div class="container">
	  			<h1>Register User</h1>
	  			<hr/>
	  			<table>
		  			<tr>
		    			<td>Full Name &nbsp;&nbsp;&nbsp;</td>
		    			<td><input type="text" size="40" placeholder="Enter your full name here" name="txtFullName" required /></td> 
		  			</tr>
		  			<tr>
		    			<td>ATT UID &nbsp;&nbsp;&nbsp;</td>
		    			<td><input type="text" size="40" maxlength="6" placeholder="Enter your ATT UID here" name="txtATTUID" required /></td> 
		  			</tr>
		  			<tr>
		    			<td>Password &nbsp;&nbsp;&nbsp;</td>
		    			<td><input type="password" size="40" maxlength="30" name="txtPassword" required/></td> 
		  			</tr>
		  			<tr>
		    			<td><hr/></td>
		    			<td><hr/></td>
		    		</tr>
		  			<tr>
		    			<td></td>
		    			<td>
		    			<input type="submit" value="Register" style="width:120px;" />
		    			<input type="button" value="Reset Password" style="width:120px;" />
		    			</td> 
		  			</tr>
	  			</table>
			</div>
     	</form>
	</body>
</html>