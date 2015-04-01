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

/**
 * Servlet implementation class GetUserInfo
 */
@WebServlet("/GetUserInfo")
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
	  ResultSet rs = null;
	  try {
		stmt = conn.createStatement();
		String query = "SELECT * from User_Info_DB WHERE userID = " + "'" + userID + "'";
		rs = stmt.executeQuery(query);
		JSONObject userInfo = new JSONObject();
		try {
		  while(rs.next()) {
			String password = rs.getString("password");
			String firstName  = rs.getString("firstName");
			String lastName = rs.getString("lastName");
			String homeAddress = rs.getString("homeAddress");
			String workAddress = rs.getString("workAddress");
			userInfo.put("password", password);
			userInfo.put("firstName", firstName);
			userInfo.put("lastName", lastName);
			userInfo.put("homeAddress", homeAddress);
			userInfo.put("workAddress", workAddress);
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
