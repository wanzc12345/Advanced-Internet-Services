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
@WebServlet("/count_activity")
public class CountActivity extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CountActivity() {
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
		JSONObject userInfo = new JSONObject();
		userInfo.put("eating", 0);
		userInfo.put("walking", 0);
		userInfo.put("working-studying", 0);
		userInfo.put("sleeping", 0);
		userInfo.put("in-transit", 0);
		userInfo.put("worshiping", 0);
		userInfo.put("shopping", 0);
		userInfo.put("entertaining", 0);
		userInfo.put("running", 0);
		try {
		  while(rs.next()) {
			String activity = rs.getString("activity");
			if (userInfo.containsKey(activity)){
				int count = Integer.parseInt(userInfo.get(activity).toString());
				count++;
				userInfo.put(activity, count);
			}
			else{
				userInfo.put(activity, 1);
			}
		  }
		  int count = Integer.parseInt(userInfo.get("in-transit").toString());
		  userInfo.remove("in-transit");
		  userInfo.put("transit", count);
		  count = Integer.parseInt(userInfo.get("working-studying").toString());
		  userInfo.remove("working-studying");
		  userInfo.put("workingstudying", count);
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
