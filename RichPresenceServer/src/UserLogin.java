import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 * Servlet implementation class UserLogin
 */
@WebServlet("/login")
public class UserLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	  StringBuffer jb = new StringBuffer();
	  String line = null;
	  try {
	    BufferedReader reader = request.getReader();
		while ((line = reader.readLine()) != null)
		  jb.append(line);
	  } catch (Exception e) { 
		/*report an error*/ 
	  }
	  JSONParser parser = new JSONParser();
	  try {
		JSONObject j = (JSONObject) parser.parse(jb.toString());
		String userID = (String) j.get("userID");
		String password = (String) j.get("password");
		PrintWriter pw = response.getWriter();
		
		Connection conn = ConnectDB.getConnection();
		if (conn == null) {
		  return;
		}
		Statement stmt = null;
		ResultSet rs = null;
		try {
		  stmt = conn.createStatement();
		  String query = "SELECT * from User_Info_DB WHERE userID=" + "'" + userID + "'" +
				  		 " AND password=" + "'" + password + "'";
		  rs = stmt.executeQuery(query);
		  if (!rs.next()) {
			pw.write("false");
		  } else {
			query = "UPDATE User_Info_DB SET userState = 1 WHERE userID = " + "'" + userID + "'" ;
			stmt.execute(query);			
			pw.write("true");
		  }
		} catch (SQLException e) {
			e.printStackTrace();
		}
	  } catch (ParseException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	  }
	}
}
