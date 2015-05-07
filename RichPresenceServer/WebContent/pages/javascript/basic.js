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
                                       "</p>"+
                                    "</div>"+
                                "</li>");
				  $.ajax({
					 url: '../get_user_info?userID='+list[i],
					 type: 'GET',
					 dataType: 'text',
					 success: function(response){
						 var id = '#'+this.url.substr(this.url.indexOf("=")+1).replace('@', '').replace('.', '');
						 var info = jQuery.parseJSON(response);
						 $(id).text(info[0].firstName+" "+info[0].lastName+", "+info[0].homeAddress);
					 }
				  });
			  }
		  }
	  });
	  $.ajax({
		  url: '../get_activity?userID=' + userID,
		  type: 'GET',
		  dataType: 'text',
		  success: function(response) {
			  var d = eval('('+response+')'); 
			  var flag = 0;
			  var line = "";
			  $('#activitytimeline').empty();
			  for (var i in d){
				  
				  if (flag == 0){
					  if (d[i]["activity"] == "eating"){
					  $('#activitytimeline').append('<li><div class="timeline-badge"><i class="fa fa-cutlery" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
					  }
					  else if (d[i]["activity"] == "entertaining"){
						  $('#activitytimeline').append('<li><div class="timeline-badge"><i class="fa fa-gamepad" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
					  }
					  else if (d[i]["activity"] == "in-transit"){
						  $('#activitytimeline').append('<li><div class="timeline-badge"><i class="fa fa-car" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
					  }
					  else if (d[i]["activity"] == "running"){
						  $('#activitytimeline').append('<li><div class="timeline-badge"><i class="fa fa-check" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
					  }
					  else if (d[i]["activity"] == "sleeping"){
						  $('#activitytimeline').append('<li><div class="timeline-badge"><i class="fa fa-bed" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
					  }
					  else if (d[i]["activity"] == "walking"){
						  $('#activitytimeline').append('<li><div class="timeline-badge"><i class="fa fa-paper-plane" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
					  }
					  else if (d[i]["activity"] == "working-studying"){
						  $('#activitytimeline').append('<li><div class="timeline-badge"><i class="fa fa-graduation-cap" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
					  }
					  else if (d[i]["activity"] == "worshiping"){
						  $('#activitytimeline').append('<li><div class="timeline-badge"><i class="fa fa-plus" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
					  }
					  else if (d[i]["activity"] == "shopping"){
						  $('#activitytimeline').append('<li><div class="timeline-badge"><i class="fa fa-credit-card" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
					  }
					  flag = 1;
				  }
				  else{
					  if (d[i]["activity"] == "eating"){
						  $('#activitytimeline').append('<li class="timeline-inverted"><div class="timeline-badge"><i class="fa fa-cutlery" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
						  }
						  else if (d[i]["activity"] == "entertaining"){
							  $('#activitytimeline').append('<li class="timeline-inverted"><div class="timeline-badge"><i class="fa fa-gamepad" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
						  }
						  else if (d[i]["activity"] == "in-transit"){
							  $('#activitytimeline').append('<li class="timeline-inverted"><div class="timeline-badge"><i class="fa fa-car" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
						  }
						  else if (d[i]["activity"] == "running"){
							  $('#activitytimeline').append('<li class="timeline-inverted"><div class="timeline-badge"><i class="fa fa-check" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
						  }
						  else if (d[i]["activity"] == "sleeping"){
							  $('#activitytimeline').append('<li class="timeline-inverted"><div class="timeline-badge"><i class="fa fa-bed" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
						  }
						  else if (d[i]["activity"] == "walking"){
							  $('#activitytimeline').append('<li class="timeline-inverted"><div class="timeline-badge"><i class="fa fa-paper-plane" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
						  }
						  else if (d[i]["activity"] == "working-studying"){
							  $('#activitytimeline').append('<li class="timeline-inverted"><div class="timeline-badge"><i class="fa fa-graduation-cap" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
						  }
						  else if (d[i]["activity"] == "worshiping"){
							  $('#activitytimeline').append('<li class="timeline-inverted"><div class="timeline-badge"><i class="fa fa-plus" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
						  }
						  else if (d[i]["activity"] == "shopping"){
							  $('#activitytimeline').append('<li class="timeline-inverted"><div class="timeline-badge"><i class="fa fa-credit-card" style = "color:yellow"></i></div><div class="timeline-panel"><div class="timeline-heading"><h4 class="timeline-title">'+ d[i]["activity"] +'</h4><p><small class="text-muted"><i class="fa fa-clock-o"></i> '+ d[i]["timestamp"] +'</small></p></div></div></li>');
						  }
					  flag = 0
				  }
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
