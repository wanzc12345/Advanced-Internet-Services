/**
 * 
 */

function userLogin() {
  //alert("haha");
  var userID = $('#userID').val();
  alert(userID);
  var password = $('#password').val();
  $.ajax({
	  url: 'login',
	  type: 'POST',
	  dataType: 'text',
	  data: JSON.stringify({
	    userID : userID,
	    password : password	
	  }),
	  success: function(response) {
	      alert(reponse);
	  }
  });
  return false;
}

function signUpFormSubmit() {
  var userID = document.signUpForm.userID.value;
  var firstName = document.signUpForm.firstName.value;
  var lastName = document.signUpForm.lastName.value;
  var password = document.signUpForm.password.value;
  var passwordRep = document.signUpForm.passwordRepeat.value;
  var homeAddr = document.signUpForm.homeAddr.value;
  var workAddr = document.signUpForm.workAddr.value;
  var data = JSON.stringify({
	userID : userID,
	firstName : firstName,
	lastName : lastName,
	password : password,
	homeAddr : homeAddr,
	workAddr : workAddr
    }
  );
  $.ajax({
	  url: 'sign_up',
	  type: 'POST',
	  dataType: 'text',
	  data: data,
	  success: function(response) {
	      alert(response);
	  }
  });
  return false;
}


function richPresenceFormSubmit() {
	alert("get1");
	var userID = document.richPresenceForm.userID.value;
	//var timestamp = document.richPresenceForm.timestamp.value;
	var timestamp = new Date().getTime().toString();
	alert("get2");
	var latitude = document.richPresenceForm.latitude.value;
	var longitude = document.richPresenceForm.longitude.value;
	var xAcc = document.richPresenceForm.xAcc.value;
	var yAcc = document.richPresenceForm.yAcc.value;
	var zAcc = document.richPresenceForm.zAcc.value;
	var volume = document.richPresenceForm.volume.value;
	var brightness = document.richPresenceForm.brightness.value;
	var batteryLevel = document.richPresenceForm.batteryLevel.value;
	var OSType = document.richPresenceForm.OSType.value;
	var OSVersion = document.richPresenceForm.OSVersion.value;
	var serialNumber = document.richPresenceForm.serialNumber.value;
	alert("get3");
	var data = JSON.stringify({
		userID: userID,
		timestamp: timestamp,
		latitude: latitude,
		longitude: longitude, 
		xAcc: xAcc, 
		yAcc: yAcc, 
		zAcc: zAcc, 
		volume: volume, 
		brightness: brightness, 
		batteryLevel: batteryLevel, 
		OSType: OSType,  
		OSVersion: OSVersion, 
		serialNumber: serialNumber
	    }
	  );
	
	$.ajax({
		url: 'upload_rich_presence',
		type: 'POST',
		dataType: 'text',
		data: data,
		success: function(response) {
		  alert(response);
		}
	});
	return false;
}
