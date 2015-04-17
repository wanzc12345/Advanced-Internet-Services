

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 * Servlet implementation class GetFriendsList
 */
@WebServlet("/get_friends_list")
public class GetFriendsList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetFriendsList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json");
		String userID = request.getParameter("userID");
		Connection conn = ConnectDB.getConnection();
		if (conn == null){
			return;
		}
		Statement stmt = null;
		ResultSet rs = null;
		  try {
			stmt = conn.createStatement();
			String query = "SELECT friendList from User_Info_DB WHERE userID = " + "'" + userID + "'";
			rs = stmt.executeQuery(query);
			JSONArray jsonUsers = new JSONArray();
			try {
			  while(rs.next()) {
				String friendList = rs.getString("friendList");
				String[] users = friendList.split(" ");
				for (int i = 0; i < users.length; i++){
					jsonUsers.add(users[i]);
				}
			  }
			  response.getWriter().write(jsonUsers.toString());
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
