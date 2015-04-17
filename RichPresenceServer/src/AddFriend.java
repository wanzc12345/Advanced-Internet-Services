

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
 * Servlet implementation class AddFriend
 */
@WebServlet("/add_friend")
public class AddFriend extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddFriend() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json");
		String userID = request.getParameter("MyUserID");
		String friendID = request.getParameter("FriendUserID");
		Connection conn = ConnectDB.getConnection();
		if (conn == null){
			return;
		}
		Statement stmt = null;
		Statement stmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		  try {
			stmt = conn.createStatement();
			stmt1 = conn.createStatement();
			String query1 = "SELECT * from User_Info_DB WHERE userID = " + "'" + friendID + "'";
			String query = "SELECT friendList from User_Info_DB WHERE userID = " + "'" + userID + "'";
			JSONObject jsonTF = new JSONObject();
			rs1 = stmt1.executeQuery(query1);
			if (rs1.first())
			{
				if (userID.equals(friendID)){
					jsonTF.put("status", "False");
					jsonTF.put("message", "You can not add yourself friend!");
					response.getWriter().write(jsonTF.toString());
				}
				else {
					rs = stmt.executeQuery(query);
					try {
					  while(rs.next()) {
						String friendList = rs.getString("friendList");
						String userslist = new String();
						if (friendList == null || friendList == "" || friendList == " "){
							
						}
						else{
							String[] users = friendList.split(" ");
							for (int i = 0; i < users.length; i++){
								if (users[i].equals(friendID.trim())){
									jsonTF.put("message", "This User is already your friend!");
									jsonTF.put("status", "False");
								}
								else{
									userslist += users[i] + " ";
								}
							}
						}
						if (jsonTF.size() == 0){
							jsonTF.put("status","True");
							userslist += friendID;
							Statement state = conn.createStatement();
							query = "UPDATE User_Info_DB SET friendList = " + "'" + userslist + "'" + "WHERE userID = " + "'" + userID + "'";
							state.executeUpdate(query);
							state.close();
						}
					  }
					  response.getWriter().write(jsonTF.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				stmt.close();
				conn.close();
			}
			else{
				jsonTF.put("message", "The user you want to add does not exists!");
				jsonTF.put("status", "False");
				response.getWriter().write(jsonTF.toString());
			}
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
