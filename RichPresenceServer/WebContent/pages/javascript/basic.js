/**
 * 
 */
function specific(data){
	var userID = $('#user'+data).children()[0].text;
	  $.ajax({
		  url: '../get_user_info?userID=' + userID,
		  type: 'GET',
		  dataType: 'text',
		  success: function(response) {
			  var d = eval('('+response+')'); 
			  $('#deviceinformationlist').empty();
			  
				  for (var key in d[0]){
				  $('#deviceinformationlist').append('<li>' + key + ':' + d[0][key] + '</li>');
				  }			  
			  $('#informationtbody').empty();
			  for (var i in d){
				  if (i == 0){
					  continue;
				  }
				  var row = "<tr>";
				  row += "'<td>'" + i + "'</td>'";
				  for (var value in d[i]){
					  row += "'<td>'" + d[i][value] + "'</td>'";
				  }
				  row += "</tr>";
				  $('#informationtbody').append(row);
			  }
			 
		  }
	  });
	  $.ajax({
		  url: '../get_friends_list?userID='+userID,
		  type: 'GET',
		  dataType: 'text',
		  success: function(response){
			  $('#friendlist').empty();
			  
			  var list = jQuery.parseJSON(response);

			  for(var i = 0; i<list.length; i++){
				  $('#friendlist').append("<li class='"+(i%2==0?"left":"right")+" clearfix'>"+
                                    "<span class='chat-img pull-"+(i%2==0?"left":"right")+"'>"+
                                        "<img src='http://placehold.it/50/55C1E7/fff' alt='User Avatar' class='img-circle' />"+
                                    "</span>"+
                                    "<div class='chat-body clearfix'>"+
                                        "<div class='header'>"+
                                            "<strong class='primary-font'>"+list[i]+"</strong>"+
                                            "<small class='pull-right text-muted'>"+
                                            "</small>"+
                                        "</div>"+
                                        "<p id='"+list[i].replace('@', '').replace('.', '')+"'>"+
                                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur bibendum ornare dolor, quis ullamcorper ligula sodales."+
                                       "</p>"+
                                    "</div>"+
                                "</li>");
				  $.ajax({
					 url: '../get_user_info?userID='+list[i],
					 type: 'GET',
					 dataType: 'text',
					 success: function(response){
						 var id = '#'+this.url.substr(this.url.indexOf("=")+1).replace('@', '').replace('.', '');
						 $(id).text(response);
					 }
				  });
			  }
		  }
	  });
}
function userLogin() {
	//alert("haha");
  var userID = $('#userID').val();
  var password = $('#password').val();
  //alert(userID);
  var rightID = "admin";
  var rightpsw = "admin";
  if (rightID.test(userID) && rightpsw.test(password)){
	  return true;
  }
  else{
	  false;
  }
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
