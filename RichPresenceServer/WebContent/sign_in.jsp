<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Test Sign In</title>
<script src="javascript/basic.js"></script>
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
</head>
<body>
  <div id="logIn">
	userID: <input type="text" id="userID" name="userID">
	password: <input type="password" id="password" name="password">
	<button onclick="userLogin()"> sign in </button>
  </div>
  <br />
  <br />
  <form name="signUpForm" onsubmit="return signUpFormSubmit();" method="post">
    email: <input type="text" name="userID">              <br />
    Your First Name: <input type="text" name="firstName"> <br />
    Your Last Name: <input type="text" name="lastName">   <br />
    Create Password: <input type="text" name="password">  <br />
    Repeat Password: <input type="text" name="passwordRepeat"> <br />
    Home Address: <input type="text" name="homeAddr">     <br />
    Work Address: <input type="text" name="workAddr">     <br />
    <input type="submit" name="signUpSubmit" />			  <br />
  </form>
  
  <br /> <br />
  
  <form name="richPresenceForm" onsubmit="return richPresenceFormSubmit();" method="post">
    userID: <input type="text" name="userID"> <br />
    timestamp: <input type="text" name="timestamp"> <br />
    latitude: <input type="text" name="latitude"> <br />
    longitude: <input type="text" name="longitude"> <br />
    xAcc: <input type="text" name="xAcc"> <br />
    yAcc: <input type="text" name="yAcc"> <br />
    zAcc: <input type="text" name="zAcc"> <br />
    volume: <input type="text" name="volume"> <br />
    brightness: <input type="text" name="brightness"> <br />
    batteryLevel: <input type="text" name="batteryLevel"> <br />
    OSType: <input type="text" name="OSType"> <br />
    OSVersion: <input type="text" name="OSVersion"> <br />
	serialNumber: <input type="text" name="serialNumber"> <br />
	<input type="submit" name="richPresenceSubmit" />
  </form>
</body>
</html>