package newnew;


import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class GetUsers {
	@SuppressWarnings("finally")
	public ArrayList<String> get_users(){
		Connection conn = ConnectDB.getConnection();
		if (conn == null){
			return null;
		}
		Statement stmt = null;
		ResultSet rs = null;
		ArrayList<String> al = new ArrayList<String>();
		try {
			stmt = conn.createStatement();
			String userID = "zw2291@columbia.edu";
			String query = "SELECT friendList from User_Info_DB WHERE userID = " + "'" + userID + "'";
			rs = stmt.executeQuery(query);
			while (rs.next()){
				String userid = rs.getString("friendList");
				String[] part = userid.split(" ");
				for (int i = 0;i < part.length; i++){
					al.add(part[i]);
				}
			}
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally{
			return al;
		}
	}
}
