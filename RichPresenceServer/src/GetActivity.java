import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

/**
 * Servlet implementation class GetUserInfo
 */
@WebServlet("/get_activity")
public class GetActivity extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetActivity() {
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
	  ResultSet rs = null;
	  try {
		stmt = conn.createStatement();
		
		String query = "SELECT * from User_Activity_DB WHERE userID = " + "'" + userID + "'";
		rs = stmt.executeQuery(query);
		JSONArray userInfo = new JSONArray();
		try {
		  while(rs.next()) {
			JSONObject a = new JSONObject();
			Timestamp timestamp = rs.getTimestamp("timestamp");
			String activity = rs.getString("activity");
			a.put("timestamp", timestamp.toString());
			a.put("activity", activity);
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
