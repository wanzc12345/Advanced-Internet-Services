import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectDB {
  static final String dbName = "AIS";
  static final String userName = "qy2152"; 
  static final String password = "yl3249qy2152"; 
  static final String hostname = "cs4111.ckvasdf4do5w.us-west-2.rds.amazonaws.com";
  static final String port = "3306";
  
  public static Connection getConnection() {
	Connection conn = null;
	
    try {
	  Class.forName("com.mysql.jdbc.Driver");
	} catch (ClassNotFoundException e) {
	  e.printStackTrace();
	}
	  try {
		String jdbcUrl = "jdbc:mysql://" + hostname + ":" + port + "/" + dbName + "?user=" + userName + "&password=" + password;
		conn = DriverManager.getConnection(jdbcUrl);
	} catch (SQLException e) {
		// handle any errors
		System.out.println("SQLException: " + e.getMessage());
	}
	return conn;
  }
}
