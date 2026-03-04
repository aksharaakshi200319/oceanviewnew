import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uname = request.getParameter("username");
        String upass = request.getParameter("password");
        
        // Database credentials - Check these carefully!
        String dbUrl = "jdbc:mysql://localhost:3306/ocean_view_db";
        String dbUser = "root";
        String dbPass = ""; // Your MySQL password

        try {
            // 1. Load Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2. Connect
            Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            
            // 3. Query
            String sql = "SELECT * FROM users WHERE username=? AND password=?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, uname);
            pst.setString(2, upass);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                // Success
                HttpSession session = request.getSession();
                session.setAttribute("user", uname);
                response.sendRedirect("Dashboard.jsp");
            } else {
                // Invalid credentials
                request.setAttribute("errorMessage", "Invalid username or password.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }
            con.close();
            
        } catch (ClassNotFoundException e) {
            request.setAttribute("errorMessage", "Driver Error: MySQL Connector not found!");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "DB Connection Error: " + e.getMessage());
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "System Error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}