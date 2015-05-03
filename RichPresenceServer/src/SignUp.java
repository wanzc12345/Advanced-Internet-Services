import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
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
 * Servlet implementation class SignUp
 */
@WebServlet("/sign_up")
public class SignUp extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	  StringBuffer jb = new StringBuffer();
	  String line = null;
	  PrintWriter pw = response.getWriter();
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
		String password = (String) j.get("password");
		String firstName = (String) j.get("firstName");
		String lastName = (String) j.get("lastName");
		String homeAddr = (String) j.get("homeAddr");
		String workAddr = (String) j.get("workAddr");
	    Connection conn = ConnectDB.getConnection();
		if (conn == null) {
		  return;
		}
		Statement stmt = null;
		try {
		  stmt = conn.createStatement();
		  String query = "INSERT INTO User_Info_DB " +
		  				 "(userID, password, firstName, lastName, homeAddress, workAddress)" + 
				  	 	 "VALUES (" + 
				  	 	 "'" + userID + "'," + 
				  	 	 "'" + password + "'," +
				  	 	 "'" + firstName + "'," + 
				  	 	 "'" + lastName + "'," + 
				  	 	 "'" + homeAddr + "'," +
				  	 	 "'" + workAddr + "'" + 
				  	 	 ")";
		  System.out.println(query);
		  stmt.execute(query);	
		  pw.write("true");
		} catch (SQLException e) {
		  pw.write("false");
		  e.printStackTrace();
		}
	  } catch (ParseException e) {
	    // TODO Auto-generated catch block
		  pw.write("false");
		e.printStackTrace();
	  }
    }
}
