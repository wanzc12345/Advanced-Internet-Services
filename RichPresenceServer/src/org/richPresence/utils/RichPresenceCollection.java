package org.richPresence.utils;

import java.sql.Timestamp;

public class RichPresenceCollection {
  public Timestamp ts;
  public float lat;
  public float lng;
  float xAcc;
  float yAcc;
  float zAcc;
  float volume;
  float brightness;
  //float batteryLevel;
  
  public RichPresenceCollection(Timestamp ts, float lat, float lng, float xAcc, float yAcc,
		  	 float zAcc, float volume, float brightness) {
	this.ts = ts;
	this.lat = lat;
	this.lng = lng;
	this.xAcc = xAcc;
	this.yAcc = yAcc;
	this.zAcc = zAcc;
	this.volume = volume;
	this.brightness = brightness;
  }
}
