

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

/**
 * Servlet implementation class LogOut
 */
@WebServlet("/log_out")
public class LogOut extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LogOut() {
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
			String query = "SELECT userState from User_Info_DB WHERE userID = " + "'" + userID + "'";
			rs = stmt.executeQuery(query);
			JSONArray jsonTF = new JSONArray();
			try {
			  while(rs.next()) {
				int user_state = rs.getInt("userState");
				if (user_state == 0){
					jsonTF.add("false");
				}
				else{
					Statement state = conn.createStatement();
					query = "UPDATE User_Info_DB SET userState = 0 WHERE userID = " + "'" + userID + "'";
					state.executeUpdate(query);
					state.close();
					jsonTF.add("True");
				}
			  }
			  response.getWriter().write(jsonTF.toString());
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
