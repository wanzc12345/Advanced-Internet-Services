import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.richPresence.utils.ConnectDB;

/**
 * Servlet implementation class GetUserInfo
 */
@WebServlet("/get_user_info")
public class GetUserInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetUserInfo() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	  response.setContentType("application/json");
	  String userID = request.getParameter("userID");
	  Connection conn = ConnectDB.getConnection();
	  if (conn == null) {
		return;
	  }
	  Statement stmt = null;
	  Statement stmt1 = null;
	  ResultSet rs = null;
	  ResultSet rs1 = null;
	  try {
		stmt = conn.createStatement();
		String query = "SELECT * from User_Info_DB WHERE userID = " + "'" + userID + "'";
		rs = stmt.executeQuery(query);
		JSONArray userInfo = new JSONArray();
		try {
		  while(rs.next()) {
			JSONObject a = new JSONObject();
			String password = rs.getString("password");
			String firstName  = rs.getString("firstName");
			String lastName = rs.getString("lastName");
			String homeAddress = rs.getString("homeAddress");
			String workAddress = rs.getString("workAddress");
			a.put("password", password);
			a.put("firstName", firstName);
			a.put("lastName", lastName);
			a.put("homeAddress", homeAddress);
			a.put("workAddress", workAddress);
			userInfo.add(a);
		  }
		  stmt1 = conn.createStatement();
		  String query1 = "SELECT * from Rich_Presence_DB WHERE userID = " + "'" + userID + "'";
		  rs1 = stmt1.executeQuery(query1);
		  while (rs1.next()){
			  JSONObject a = new JSONObject();
			  String timestamp = rs1.getString("timestamp");
			  String latitude = rs1.getString("latitude");
			  String longitude = rs1.getString("longitude");
			  String xAcc = rs1.getString("xAcc");
			  String yAcc = rs1.getString("yAcc");
			  String zAcc = rs1.getString("zAcc");
			  String volume = rs1.getString("volume");
			  String brightness = rs1.getString("brightness");
			  String batteryLevel = rs1.getString("batteryLevel");
			  String OSType = rs1.getString("OSType");
			  String OSVersion = rs1.getString("OSVersion");
			  String serialNumber = rs1.getString("serialNumber");
			  a.put("timestamp", timestamp);
			  a.put("latitude", latitude);
			  a.put("longitude", longitude);
			  a.put("xAcc", xAcc);
			  a.put("yAcc", yAcc);
			  a.put("zAcc", zAcc);
			  a.put("volume", volume);
			  a.put("brightness", brightness);
			  a.put("batteryLevel", batteryLevel);
			  a.put("OSType", OSType);
			  a.put("OSVersion", OSVersion);
			  a.put("serialNumber", serialNumber);
			  userInfo.add(a);
		  }
		  response.getWriter().write(userInfo.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		stmt.close();
		conn.close();
	  } catch (SQLException e) {
		e.printStackTrace();
	  }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
