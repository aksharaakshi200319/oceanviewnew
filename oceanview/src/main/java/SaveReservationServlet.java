import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/SaveReservationServlet")
public class SaveReservationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String resNo = request.getParameter("resNo");
        String guestName = request.getParameter("guestName");
        String address = request.getParameter("address");
        String contactNo = request.getParameter("contactNo");
        String roomType = request.getParameter("roomType");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");

        // --- CALCULATION LOGIC (Requirement #4) ---
        long nights = ChronoUnit.DAYS.between(LocalDate.parse(checkIn), LocalDate.parse(checkOut));
        double rate = 0;
        if(roomType.equalsIgnoreCase("Standard")) rate = 15000;
        else if(roomType.equalsIgnoreCase("Deluxe")) rate = 28000;
        else if(roomType.equalsIgnoreCase("Suite")) rate = 55000;
        double totalBill = nights * rate;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ocean_view_db", "root", "");
            
            String sql = "INSERT INTO reservations VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, resNo);
            pst.setString(2, guestName);
            pst.setString(3, address);
            pst.setString(4, contactNo);
            pst.setString(5, roomType);
            pst.setString(6, checkIn);
            pst.setString(7, checkOut);
            pst.setDouble(8, totalBill);

            pst.executeUpdate();
            con.close();
            response.sendRedirect("Dashboard.jsp?msg=Reservation Saved Successfully!");
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}