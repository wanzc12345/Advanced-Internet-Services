

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 * Servlet implementation class UploadRichPresence
 */
@WebServlet("/upload_rich_presence")
public class UploadRichPresence extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	  StringBuffer jb = new StringBuffer();
	  String line = null;
      try {
	    BufferedReader reader = request.getReader();
		while ((line = reader.readLine()) != null) {
		  jb.append(line);
		}
	  } catch (Exception e) { 
		//TODO
	  }
	  JSONParser parser = new JSONParser();
	  try {
		JSONObject j = (JSONObject) parser.parse(jb.toString());
		String userID = (String) j.get("userID");
		long timestamp_millis = Long.parseLong((String) j.get("timestamp"));
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
		
		Connection conn = ConnectDB.getConnection();
		if (conn == null) {
		  //TODO 
		  return;
		}
		PreparedStatement stmt = null;
		String insertPresence = "INSERT INTO Rich_Presence_DB " +
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
		System.out.println(insertPresence);
		try {
		  stmt = conn.prepareStatement(insertPresence);
		  stmt.setTimestamp(1, timestamp);
		  System.out.println(stmt.toString());
		  stmt.executeUpdate();
		  PrintWriter pw = response.getWriter();
		  pw.write("true");
	    } catch (SQLException e) {
		  e.printStackTrace();
		}
	} catch (ParseException e) {
	  // TODO Auto-generated catch block
	  e.printStackTrace();
	}
  }
}
