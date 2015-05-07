package org.richPresence.utils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;

import org.json.JSONObject;
import org.richPresence.googleMapAPI.GoogleMapService;
import org.richPresence.googleMapAPI.GooglePlace;
import org.richPresence.utils.RichPresenceCollection;

public class PredictActivity {
  public static Pair<String, String> predict(String userID, ArrayList<RichPresenceCollection> sampleGroup) {
	if (sampleGroup == null || sampleGroup.size() != Config.sampleGroupSize) {
	  throw new IllegalArgumentException();
	}
	
	RichPresenceCollection latestSample = sampleGroup.get(sampleGroup.size()-1);
	float velocity = -1;
	Connection conn = ConnectDB.getConnection();
	if (conn != null) {
	  Statement stmt = null;
	  ResultSet rs = null;
	  try {
	    stmt = conn.createStatement();
		String query = "SELECT * " + 
				       "FROM User_Activity_DB "+
				       "WHERE userID= " + "'" + userID + "' " + 
				       "ORDER by timestamp DESC LIMIT 1";
		rs = stmt.executeQuery(query);
		if (rs.first()) {
		  Timestamp lastTimestamp = rs.getTimestamp("timestamp");
		  float lastLat = rs.getFloat("latitude");
		  float lastLng = rs.getFloat("longitude");
		  //System.out.println("DEBUG: lat-lng: " + lastLat + " " + lastLng);
		  if (latestSample.ts.getTime() - lastTimestamp.getTime() <= Config.velocityMaxTimeInterval_mills) {
			velocity = Utils.getVelocity(lastLat, lastLng, latestSample.lat, latestSample.lng, 
						         	     lastTimestamp, latestSample.ts);
		  }
		} // else, now previous activity for this user. Move on
		conn.close();
	  } catch (SQLException e) {
		e.printStackTrace(); 
	  } 
	}
	
	if (velocity >= Config.transitSpeedCut) {
	  return new Pair<String, String>("in-transit" , "");
	}
	
	boolean active = false;
	boolean athome = false;
	boolean atwork = false;
	
	ArrayList<Float> normAccArray = new ArrayList<Float>();
	for (RichPresenceCollection rpc : sampleGroup) {
      float xAcc = rpc.xAcc;
      float yAcc = rpc.yAcc;
	  float zAcc = 0;
	  float normAcc = Utils.getNorm3D(xAcc, yAcc, zAcc);
	  normAccArray.add(normAcc);
	  if (normAcc >= Config.stallingNormAccCut) {
	    active = true;
	    //System.out.println("DEBUG: active: " + active);
	  }
	}
	
	String homeAddr = ""; 
	String workAddr = "";
    // geolocation base prediction
	conn = ConnectDB.getConnection();
	if (conn != null) {
	  Statement stmt = null;
	  ResultSet rs = null;
	  try {
	    stmt = conn.createStatement();
		String query = "SELECT homeAddress, workAddress " + 
				       "FROM User_Info_DB "+
				       "WHERE userID= " + "'" + userID + "' ";
		rs = stmt.executeQuery(query);
		if (rs.first()) {
		  homeAddr = rs.getString("homeAddress");
		  //System.out.println("DEBUG: homeaddr: " + homeAddr);
		  workAddr = rs.getString("workAddress");
		  conn.close();
		} else {
		  conn.close();
		  return null;  // user not found
		}
	  } catch (SQLException e) {
		e.printStackTrace();
	  }
	}
	
	float latestLat = latestSample.lat;
	float latestLng = latestSample.lng;

	Pair<Float, Float> homeLatlng = GoogleMapService.getLatlngByAddr(homeAddr);
	// fist decide if is at home or at work 
	if (homeLatlng!=null && Utils.getDist(latestLat, latestLng, homeLatlng.first, homeLatlng.second) 
								<= Config.geolocationMaxError) {
	  athome = true;
    } else {
      Pair<Float, Float> workLatlng = GoogleMapService.getLatlngByAddr(workAddr);
      float distWork = Utils.getDist(latestLat, latestLng, workLatlng.first, workLatlng.second);
      System.out.println(latestLat + " " + latestLng + " " + workLatlng.first + " " + workLatlng.second);
      System.out.println("disk from work " + distWork);
      if (workLatlng!=null && Utils.getDist(latestLat, latestLng, workLatlng.first, workLatlng.second) 
    		  <= Config.geolocationMaxError) {
        atwork = true;  	
      }
    }
	
	// some easy-to-see case
	if (atwork && !active) {
	  return new Pair<String, String>("working-studying" , "office or school");
	} 
	if (athome && !active) {
	  if (latestSample.brightness <= Config.sleepBrightnessCut) {
		return new Pair<String, String>("sleeping" , "home");
	  } else {
		return new Pair<String, String>("working-studying" , "home");
	  }
	}
	
	// Other geolocation based if inactive
	// The prediction depends on the prominence rank calculated by Google Map
	GoogleMapService mapService = new GoogleMapService();
	JSONObject jResponse = mapService.searchNearBy(latestLat, latestLng, Config.geolocationMaxError/3);
	ArrayList<GooglePlace> placeList = GoogleMapService.getPlaceArray(jResponse);
	for (GooglePlace place : placeList) {
      ArrayList<String> types = place.typeList;
      for (String type : types) {
    	System.out.println(type);
    	if (Config.GooglePlaceEatHS.contains(type)) {
    	  return new Pair<String, String>("eating", place.name);
    	} else if (Config.GooglePlaceShopHS.contains(type)) {
      	  return new Pair<String, String>("Shopping", place.name);
    	} else if (Config.GooglePlaceEntertainmentHS.contains(type)) {
    	  return new Pair<String, String>("entertaining", place.name);
    	} else if (Config.GooglePlaceShopHS.contains(type)) {
    	  return new Pair<String, String>("worshiping", place.name);
    	} else {
    	  ;   // Go to next place
    	}
      }
	}
	if (placeList.size() >= 1) {
	  String place = placeList.get(0).name;
	  return new Pair<String, String>("Unknown", place);
	}
	
	int count = 0; 
	for (float accNorm : normAccArray) {
	  if (accNorm >= Config.runningNormAccCut) {
		count ++;
	  }
	}
	if (count >= Config.sampleGroupSize/2) {
	  return new Pair<String, String>("running", "Unknown");
	}

	return new Pair<String, String>("Unknown", "Unknown");
  }
}
