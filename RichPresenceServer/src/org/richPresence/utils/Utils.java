package org.richPresence.utils;

import java.sql.Timestamp;

public class Utils {
  //Return velocity in m/s	
  public static float getVelocity(float lat1, float lng1, float lat2, float lng2,
		  						  Timestamp start, Timestamp end) {
	float dist = getDist(lat1, lng1, lat2, lng2);
	float timeSec = (end.getTime() - start.getTime()) / (float)1000.0;
	return (dist / timeSec);
  }
  
  //Return distance on earch surface betwwen 2 lat-lng geo-point
  public static float getDist(float lat1, float lng1, float lat2, float lng2) {
	double earthRadius = 6371000; //meters
	double dLat = Math.toRadians(lat2-lat1);
    double dLng = Math.toRadians(lng2-lng1);
	double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
	Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
	Math.sin(dLng/2) * Math.sin(dLng/2);
	double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
	float dist = (float) (earthRadius * c);
    return dist;
  }
  
  public static float getNorm3D(float x, float y, float z) {
	float norm = (float) (Math.pow(x, 2) + Math.pow(y, 2) + Math.pow(z, 2));
	return norm;
  }
}
