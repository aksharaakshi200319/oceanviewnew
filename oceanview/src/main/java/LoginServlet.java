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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uname = request.getParameter("username");
        String upass = request.getParameter("password");

        String dbUrl  = "jdbc:mysql://localhost:3306/ocean_view_db";
        String dbUser = "root";
        String dbPass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            String sql = "SELECT * FROM users WHERE username=? AND password=?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, uname);
            pst.setString(2, upass);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // ── Invalidate any old session first, then create a fresh one ──
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) oldSession.invalidate();

                HttpSession session = request.getSession(true);
                session.setAttribute("user", uname);
                session.setMaxInactiveInterval(30 * 60); // 30-minute timeout

                // Prevent caching of the login response
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma",        "no-cache");
                response.setDateHeader("Expires",   0);

                rs.close(); pst.close(); con.close();
                response.sendRedirect("Dashboard.jsp");
            } else {
                rs.close(); pst.close(); con.close();
                request.setAttribute("errorMessage", "Invalid username or password.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }

        } catch (ClassNotFoundException e) {
            request.setAttribute("errorMessage", "Driver Error: MySQL Connector not found!");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "DB Connection Error: " + e.getMessage());
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "System Error: " + e.getMessage());
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}