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
			String query = "SELECT userID from User_Info_DB";
			rs = stmt.executeQuery(query);
			while (rs.next()){
				String userid = rs.getString("userID");
				al.add(userid);
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
