

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.richPresence.utils.Config;
import org.richPresence.utils.RichPresenceCollection;

/**
 * Servlet implementation class SVMTrain
 */
@WebServlet("/SVM_train_data")
public class SVMTrain extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SVMTrain() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter pw = response.getWriter();
		  StringBuffer jb = new StringBuffer();
		  String line = null;
	      try {
		    BufferedReader reader = request.getReader();
			while ((line = reader.readLine()) != null) {
			  jb.append(line);
			}
		  } catch (Exception e) { 
			pw.write("false");
			return;
		  }
	      
		  JSONParser parser = new JSONParser();
		  String[] sampleGroup = jb.toString().split("#dean#");
		  if (sampleGroup.length != Config.sampleGroupSize) {
			pw.write("false");
			return;
		  } 
		  
		  Connection conn = ConnectDB.getConnection();
	      if (conn == null) {
	    	pw.write("false");
	    	System.out.println("conncetion null");
			return;
	      }
			
	      // read a group of samples and save them in the Rich_Presence_DB
		  String userID = "";
	      int i = 0;
		  for (String sample : sampleGroup) {
			try {
			  JSONObject j = (JSONObject) parser.parse(sample);
			  userID = (String) j.get("userID");
			  long timestamp_millis = Long.parseLong((String) j.get("timestamp")) + i;
			  i++;
			  Timestamp timestamp = new Timestamp(timestamp_millis);
			  float latitude = Float.parseFloat((String) j.get("latitude"));
			  float longitude = Float.parseFloat((String) j.get("longitude"));
			  float xAcc = Float.parseFloat((String) j.get("xAcc"));
			  float yAcc = Float.parseFloat((String) j.get("yAcc"));
			  float zAcc = Float.parseFloat((String) j.get("zAcc"));
			  float volume = Float.parseFloat((String) j.get("volume"));
			  float brightness = Float.parseFloat((String) j.get("brightness"));
			  float batteryLevel = Float.parseFloat((String) j.get("batteryLevel"));
			  String OSType = (String) j.get("OSType");
			  String OSVersion = (String) j.get("OSVersion");
			  String serialNumber = (String) j.get("serialNumber");
				
			  PreparedStatement stmt = null;
			  String insertPresence = "INSERT INTO SVM_Train_DB " +
										"VALUES (" + 
										"'" + userID + "'," + 
										"? ," +
										latitude + "," +
										longitude + "," +
										xAcc + "," +
										yAcc + "," +
										zAcc + "," +
										volume + "," +
										brightness + "," +
										batteryLevel + "," +
										"'" + OSType + "'," + 
										"'" + OSVersion + "'," + 
										"'" + serialNumber + "')";
			  stmt = conn.prepareStatement(insertPresence);
			  stmt.setTimestamp(1, timestamp);
		      System.out.println(stmt.toString());
			  stmt.executeUpdate();
			} catch (ParseException e) {
			  // TODO Auto-generated catch block
			  e.printStackTrace();
			  pw.write("false");
			  return;
			} catch (SQLException e) {
			  e.printStackTrace();
			  pw.write("false");
			  return;
			}
		 } 
		  
		 // Now all samples have been saved in DB. OK to reply client
		 pw.write("true");
	}
}
