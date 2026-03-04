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
        
        String guestName = request.getParameter("guestName");
        String address = request.getParameter("address");
        String contactNo = request.getParameter("contactNo");
        String roomType = request.getParameter("roomType");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        
     // ✅ ADD THIS DEBUG BLOCK TEMPORARILY
        System.out.println("=== DEBUG ===");
        System.out.println("guestName: " + guestName);
        System.out.println("address: " + address);
        System.out.println("contactNo: " + contactNo);
        System.out.println("roomType: " + roomType);
        System.out.println("checkIn: " + checkIn);
        System.out.println("checkOut: " + checkOut);
        System.out.println("=============");

        // Set a hard-coded default to ensure it is NEVER null
        String resNo = "OVR-1001"; 

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ocean_view_db", "root", "")) {
                
            	// 1. GENERATE ID - Fixed with a safer query
            	String lastIdQuery = "SELECT res_id FROM reservations WHERE res_id LIKE 'OVR-%' ORDER BY CAST(SUBSTRING(res_id, 5) AS UNSIGNED) DESC LIMIT 1";
            	try (Statement st = con.createStatement();
            	     ResultSet rs = st.executeQuery(lastIdQuery)) {

            	    if (rs.next()) {
            	        String lastId = rs.getString("res_id");
            	        if (lastId != null && lastId.startsWith("OVR-")) {
            	            try {
            	                int idNum = Integer.parseInt(lastId.substring(4)); // "OVR-1001" → "1001"
            	                resNo = "OVR-" + (idNum + 1);
            	            } catch (NumberFormatException nfe) {
            	                resNo = "OVR-1001"; // fallback if parsing fails
            	            }
            	        }
            	    }
            	    // If table is empty, resNo stays as the default "OVR-1001"
            	}

                // 2. CALCULATION LOGIC
                long nights = ChronoUnit.DAYS.between(LocalDate.parse(checkIn), LocalDate.parse(checkOut));
                // Ensure nights is at least 1 to avoid 0 or negative bills
                nights = (nights <= 0) ? 1 : nights; 
                
                double rate = switch (roomType) {
                    case "Standard" -> 15000.0;
                    case "Deluxe" -> 28000.0;
                    case "Suite" -> 55000.0;
                    default -> 0.0;
                };
                double totalBill = nights * rate;

                // 3. DATABASE INSERT
                String sql = "INSERT INTO reservations (res_id, guest_name, address, contact_no, room_type, check_in, check_out, total_bill) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setString(1, resNo);
                    pst.setString(2, guestName);
                    pst.setString(3, address);
                    pst.setString(4, contactNo);
                    pst.setString(5, roomType);
                    pst.setString(6, checkIn);
                    pst.setString(7, checkOut);
                    pst.setDouble(8, totalBill);

                    pst.executeUpdate();
                }
                
                
                response.sendRedirect("Dashboard.jsp?msg=Saved Successfully! ID: " + resNo);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Printing the error to the response helps you see the REAL culprit in the browser
            response.getWriter().println("Detailed Error: " + e.getMessage());
        }
    }
}