package org.richPresence.utils;

import java.util.Arrays;
import java.util.HashSet;

public class Config {
  public static final int sampleGroupSize = 5;
  static final float transitSpeedCut = (float) 10.0;
  static final float stallingNormAccCut = (float) 1.0;
  static final int geolocationMaxError = 200;
  static final float sleepBrightnessCut = (float) 0.2;
  static final long velocityMaxTimeInterval_mills = 60000;
  static final float runningNormAccCut = (float) 0.5;
  
  // Category of places
  static final String[] GooglePlaceEat = {"retaurant","bakery", "bar", "cafe","food"};
  static final HashSet<String> GooglePlaceEatHS =  new HashSet<String>(Arrays.asList(GooglePlaceEat));
  static final String[] GooglePlaceShop = {"clothing_store", "convenience_store", "department_store", 
	  						"electronics_store", "furniture_store", "grocery_or_supermarket", "hardware_store",	
	  						"home_goods_store", "pharmacy", "shoe_store", "shopping_mall"};
  static final HashSet<String> GooglePlaceShopHS =  new HashSet<String>(Arrays.asList(GooglePlaceShop));
  static final String[] GooglePlaceEntertainment = {"amusement_park", "aquarium", "art_gallery", "casino", "gym",
	  						"movie_theater", "museum", "night_club", "park", "spa", "stadium", "zoo"};
  static final HashSet<String> GooglePlaceEntertainmentHS = new HashSet<String>(Arrays.asList(GooglePlaceEntertainment));
  static final String[] GooglePlaceWorship = {"chruch", "place_of_worship", "mosque"};
  static final HashSet<String> GooglePlaceWorshipHS =  new HashSet<String>(Arrays.asList(GooglePlaceWorship));
}
