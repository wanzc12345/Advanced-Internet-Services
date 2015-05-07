package org.richPresence.googleMapAPI;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URLConnection;
import java.net.URL;
import java.util.ArrayList;

import org.json.JSONArray;
//import org.json.JSONException;
import org.json.JSONObject;
import org.richPresence.utils.Pair;

public class GoogleMapService {
  static String APIKEY = "AIzaSyDyq1RS9QO26tq_SXzxD0UCGPQxl4rkfN4";
  static final String NEARBY_SEARCH_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
  static final String GEO_ENCODING_URL = "https://maps.googleapis.com/maps/api/geocode/json";
  static final String CHARSET = "UTF-8";
  
  public static void main(String args[]) {
	// test
	/*
	GoogleMapService mapService = new GoogleMapService();
	
	JSONObject jResponse = mapService.searchNearBy(-33.8670522, 151.1957362, 50);
	ArrayList<GooglePlace> placeList = GoogleMapService.getPlaceArray(jResponse);
	for (GooglePlace gp : placeList) {
	  System.out.println(gp.toString());
	}
	*/
	Pair<Float, Float> latlng = GoogleMapService.getLatlngByAddr("Columbia University, New York, NY, 10027");
	System.out.println(latlng);
  }
  
  public GoogleMapService(String key) {
    APIKEY = key;
  }
  
  public GoogleMapService() {
    // default constructor, using default APIKEY.
  }

/*
   * Search nearby places
   * Parameters: lat, lng, radius in meters
   * Return: The JSONObject representing the HTTP response content
   * Reference: https://developers.google.com/places/webservice/search
   */
  public JSONObject searchNearBy(double latitude, double longitude, int radius) {
	String location = Double.toString(latitude) + ","  + Double.toString(longitude);
    String query = "location=" + location + "&" +
    			   "radius=" + radius + "&" + 
    			   "key=" + APIKEY;
    try {
	  URLConnection conn = new URL(NEARBY_SEARCH_URL + "?" + query).openConnection();
	  //System.out.println(conn.toString());
	  conn.setRequestProperty("Accept-Charset", CHARSET);
	  InputStream response = conn.getInputStream();
	  BufferedReader reader = new BufferedReader(new InputStreamReader(response));
      StringBuilder out = new StringBuilder();
      String line;
      while ((line = reader.readLine()) != null) {
        out.append(line);
      }
      reader.close();
      JSONObject jResponse = new JSONObject(out.toString());
      return jResponse;
	} catch (MalformedURLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    return null;
  }
  
  /*
   * Takes the response JSONObjcet and convert to ArrayList of GooglePlace Object
   */
  public static ArrayList<GooglePlace> getPlaceArray(JSONObject j) {
	if (j == null) {
	  throw new NullPointerException();
	} else {
	  try {
		ArrayList<GooglePlace> placeArray = new ArrayList<GooglePlace>();
		JSONArray results = j.getJSONArray("results");
		for (int i=0; i<results.length(); i++) {
		  JSONObject place = results.getJSONObject(i);
		  GooglePlace gp = new GooglePlace(place);
		  placeArray.add(gp);
		}
		return placeArray;
	  } catch (Exception e) {
		e.printStackTrace();
	  }
	}
	return null;
  }
  
  public static Pair<Float, Float> getLatlngByAddr(String addr) {
    System.out.println("addr:" + addr);
	if (addr.isEmpty()) {
	  return null;
	} 
	String addrURLFormat = addr.trim().replaceAll("\\s+", "+");
	String query = "address=" + addrURLFormat + "&" + "key=" + APIKEY;
    try {
      URLConnection conn = new URL(GEO_ENCODING_URL + "?" + query).openConnection();
      conn.setRequestProperty("Accept-Charset", CHARSET); 
      InputStream response = conn.getInputStream(); 
      BufferedReader reader = new BufferedReader(new InputStreamReader(response));
      StringBuilder out = new StringBuilder();
      String line;
      while ((line = reader.readLine()) != null) {
        out.append(line);
      }
      reader.close();
      JSONObject jResponse = new JSONObject(out.toString());
      JSONArray result = jResponse.getJSONArray("results");
      
      // only accept if unique geolocation is found
      if (result.length() > 1) {
        System.out.println("multiple geolocation found, try be more specific");
        return null;
      } else if (result.length() == 0) {
    	System.out.println("can't locate the address");
        return null;
      } else {
    	// get lat-lng pair
    	JSONObject geometry = result.getJSONObject(0).getJSONObject("geometry");
    	JSONObject location = geometry.getJSONObject("location");
    	Pair<Float, Float> latlng = new Pair<Float, Float>
    								    (Float.parseFloat(location.getString("lat")), 
    									 Float.parseFloat(location.getString("lng")));
    	return latlng;
      }
    } catch (MalformedURLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    return null;
  }
}
