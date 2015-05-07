package org.richPresence.googleMapAPI;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/*
 * Class: GooglePlace
 * Description: A wrapper over Google Place in JSON representation.
 * 				Filtering out extraneous fields.
 */
public class GooglePlace {
  public String name;
  public double lat;
  public double lng;
  public ArrayList<String> typeList;
  public String vicinity;
  
  /*
   * Build a GooglePlace object from a JSONObject
   */
  public GooglePlace(JSONObject jPlace) {
    if (jPlace == null) {
      throw new NullPointerException();
    }
	try { 
	  typeList = new ArrayList<String>();
	  name = jPlace.getString("name");
	  lat = jPlace.getJSONObject("geometry").getJSONObject("location").getDouble("lat");
	  lng = jPlace.getJSONObject("geometry").getJSONObject("location").getDouble("lng");
	  JSONArray types = jPlace.getJSONArray("types");
	  for (int i=0; i<types.length(); i++) {
		String type = types.getString(i);
		typeList.add(type);
	  }
	  vicinity = jPlace.getString("vicinity");
	} catch (JSONException e) {
	  e.printStackTrace();
	}
  }
  
  public String toString() {
	String s = name + "  "  + 
	  		   lat + "," + lng + "  " + 
	           typeList.toString() + "  " + 
	  		   vicinity;
	return s;
  }
}
