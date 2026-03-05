import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/UpdateReservationServlet")
public class UpdateReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String resId     = request.getParameter("resId");
        String guestName = request.getParameter("guestName");
        String roomType  = request.getParameter("roomType");
        String checkIn   = request.getParameter("checkIn");
        String checkOut  = request.getParameter("checkOut");
        String totalBill = request.getParameter("totalBill");

        // Basic validation
        if (resId == null || resId.trim().isEmpty()) {
            response.sendRedirect("Records.jsp?msg=Missing+reservation+ID&type=error");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ocean_view_db", "root", "");

            // Build update — total_bill is optional
            StringBuilder sql = new StringBuilder(
                "UPDATE reservations SET guest_name=?, room_type=?, check_in=?, check_out=?");

            boolean hasBill = (totalBill != null && !totalBill.trim().isEmpty());
            if (hasBill) sql.append(", total_bill=?");
            sql.append(" WHERE res_id=?");

            PreparedStatement pst = con.prepareStatement(sql.toString());
            int idx = 1;
            pst.setString(idx++, guestName.trim());
            pst.setString(idx++, roomType.trim());
            pst.setString(idx++, checkIn.trim());
            pst.setString(idx++, checkOut.trim());
            if (hasBill) {
                pst.setDouble(idx++, Double.parseDouble(totalBill.trim()));
            }
            pst.setString(idx, resId.trim());

            int rows = pst.executeUpdate();
            pst.close();
            con.close();

            if (rows > 0) {
                response.sendRedirect("Records.jsp?msg=Reservation+" + encodeURIComponent(resId)
                        + "+updated+successfully&type=success");
            } else {
                response.sendRedirect("EditReservation.jsp?resId=" + encodeURIComponent(resId)
                        + "&msg=No+changes+were+made&type=error");
            }

        } catch (Exception e) {
            response.sendRedirect("EditReservation.jsp?resId=" + encodeURIComponent(resId)
                    + "&msg=" + encodeURIComponent("Error: " + e.getMessage()) + "&type=error");
        }
    }

    private String encodeURIComponent(String s) {
        try {
            return java.net.URLEncoder.encode(s, "UTF-8").replace("+", "%20");
        } catch (Exception e) {
            return s;
        }
    }
}