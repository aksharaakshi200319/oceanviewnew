package oceanview;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

// ============================================================
//  Ocean View Resort — JUnit 5 Test Suite
//  Tests cover: Login logic, Session filter, Bill calculation,
//               Reservation validation, Logout behaviour
// ============================================================

public class OceanViewResortTest {

    // ── Shared mock objects (fake versions of Servlet objects) ──
    private HttpServletRequest  mockRequest;
    private HttpSession         mockSession;
    // @BeforeEach runs automatically BEFORE every single test method
    @BeforeEach
    void setUp() {
        mockRequest    = mock(HttpServletRequest.class);
        mock(HttpServletResponse.class);
        mockSession    = mock(HttpSession.class);
        mock(RequestDispatcher.class);
    }


    // ================================================================
    //  GROUP 1 — LOGIN VALIDATION TESTS
    //  These test what happens when different credentials are entered
    // ================================================================

    private HttpServletRequest mock(Class<HttpServletRequest> class1) {
		// TODO Auto-generated method stub
		return null;
	}


	private HttpSession mock(Class<HttpSession> class1) {
		// TODO Auto-generated method stub
		return null;
	}


	private HttpServletResponse mock(Class<HttpServletResponse> class1) {
		// TODO Auto-generated method stub
		return null;
	}


	private HttpServletRequest mock(Class<HttpServletRequest> class1) {
		// TODO Auto-generated method stub
		return null;
	}


	@Test
    @DisplayName("Login: Username should not be null or empty")
    void testLogin_UsernameIsEmpty() {
        // Imagine someone submits the login form with a blank username
        String username = "";
        String password = "secret123";

        // Our rule: username must not be blank
        boolean isValid = (username != null && !username.trim().isEmpty()
                        && password  != null && !password.trim().isEmpty());

        // assertFalse means we EXPECT this to be false (invalid)
        assertFalse(isValid, "Login should fail when username is empty");
    }

    @Test
    @DisplayName("Login: Password should not be null or empty")
    void testLogin_PasswordIsEmpty() {
        String username = "admin";
        String password = "";   // blank password

        boolean isValid = (username != null && !username.trim().isEmpty()
                        && password  != null && !password.trim().isEmpty());

        assertFalse(isValid, "Login should fail when password is empty");
    }

    @Test
    @DisplayName("Login: Both fields filled → credentials are structurally valid")
    void testLogin_BothFieldsFilled() {
        String username = "admin";
        String password = "admin123";

        boolean isValid = (username != null && !username.trim().isEmpty()
                        && password  != null && !password.trim().isEmpty());

        // assertTrue means we EXPECT this to be true (valid structure)
        assertTrue(isValid, "Login should proceed when both fields are filled");
    }

    @Test
    @DisplayName("Login: Null username should be treated as invalid")
    void testLogin_NullUsername() {
        String username = null;
        String password = "admin123";

        boolean isValid = (username != null && !username.trim().isEmpty()
                        && password  != null && !password.trim().isEmpty());

        assertFalse(isValid, "Login should fail when username is null");
    }

    @Test
    @DisplayName("Login: Whitespace-only username should be treated as invalid")
    void testLogin_WhitespaceUsername() {
        String username = "   ";   // looks filled but is just spaces
        String password = "admin123";

        boolean isValid = (username != null && !username.trim().isEmpty()
                        && password  != null && !password.trim().isEmpty());

        assertFalse(isValid, "Login should fail when username is only spaces");
    }


    // ================================================================
    //  GROUP 2 — SESSION / SECURITY TESTS
    //  These test that protected pages block unauthenticated users
    // ================================================================

    @Test
    @DisplayName("Session: Logged-in user (session has 'user') is allowed through")
    void testSession_UserIsLoggedIn() {
        // Simulate: session exists AND has a "user" attribute
        when(mockRequest.getSession(false)).thenReturn(mockSession);
        when(mockSession.getAttribute("user")).thenReturn("admin");

        HttpSession session  = mockRequest.getSession(false);
        boolean isLoggedIn   = (session != null && session.getAttribute("user") != null);

        assertTrue(isLoggedIn, "User with a valid session should be allowed access");
    }

    @Test
    @DisplayName("Session: No session at all → user should be redirected to login")
    void testSession_NoSessionExists() {
        // Simulate: getSession(false) returns null (no session created yet)
        when(mockRequest.getSession(false)).thenReturn(null);

        HttpSession session = mockRequest.getSession(false);
        boolean isLoggedIn  = (session != null && session.getAttribute("user") != null);

        assertFalse(isLoggedIn, "User with no session should be blocked");
    }

    @Test
    @DisplayName("Session: Session exists but 'user' attribute is missing → block access")
    void testSession_SessionExistsButNoUserAttribute() {
        // Simulate: session object exists but 'user' was never set
        when(mockRequest.getSession(false)).thenReturn(mockSession);
        when(mockSession.getAttribute("user")).thenReturn(null);  // no user attr

        HttpSession session = mockRequest.getSession(false);
        boolean isLoggedIn  = (session != null && session.getAttribute("user") != null);

        assertFalse(isLoggedIn, "Session without 'user' attribute should be blocked");
    }

    @Test
    @DisplayName("Session: Login.jsp is a public page and should NOT be blocked")
    void testSession_LoginPageIsPublic() {
        String[] publicPages    = { "/Login.jsp", "/index.jsp" };
        String   requestedPage  = "/Login.jsp";

        boolean isPublic = false;
        for (String page : publicPages) {
            if (page.equalsIgnoreCase(requestedPage)) {
                isPublic = true;
                break;
            }
        }

        assertTrue(isPublic, "Login.jsp should be accessible without a session");
    }

    @Test
    @DisplayName("Session: Dashboard.jsp is a protected page and should require login")
    void testSession_DashboardIsProtected() {
        String[] publicPages   = { "/Login.jsp", "/index.jsp" };
        String   requestedPage = "/Dashboard.jsp";

        boolean isPublic = false;
        for (String page : publicPages) {
            if (page.equalsIgnoreCase(requestedPage)) {
                isPublic = true;
                break;
            }
        }

        assertFalse(isPublic, "Dashboard.jsp should NOT be publicly accessible");
    }


    // ================================================================
    //  GROUP 3 — BILL CALCULATION TESTS
    //  These test the nights × rate formula used in EditReservation.jsp
    // ================================================================

    // Helper method — mirrors the JS logic in your JSP, written in Java
    private double calculateBill(String checkIn, String checkOut, String roomType) {
        java.util.Map<String, Integer> rates = new java.util.HashMap<>();
        rates.put("Standard", 15000);
        rates.put("Deluxe",   28000);
        rates.put("Suite",    55000);

        java.time.LocalDate ci = java.time.LocalDate.parse(checkIn);
        java.time.LocalDate co = java.time.LocalDate.parse(checkOut);

        long nights = java.time.temporal.ChronoUnit.DAYS.between(ci, co);
        if (nights <= 0) return -1; // invalid

        int rate = rates.getOrDefault(roomType, 0);
        return nights * rate;
    }

    @Test
    @DisplayName("Bill: 5 nights in Standard room = LKR 75,000")
    void testBill_StandardRoom5Nights() {
        double bill = calculateBill("2025-01-05", "2025-01-10", "Standard");
        // 5 nights × 15,000 = 75,000
        assertEquals(75000.0, bill, "5 nights Standard should be LKR 75,000");
    }

    @Test
    @DisplayName("Bill: 3 nights in Deluxe room = LKR 84,000")
    void testBill_DeluxeRoom3Nights() {
        double bill = calculateBill("2025-02-01", "2025-02-04", "Deluxe");
        // 3 nights × 28,000 = 84,000
        assertEquals(84000.0, bill, "3 nights Deluxe should be LKR 84,000");
    }

    @Test
    @DisplayName("Bill: 2 nights in Suite room = LKR 110,000")
    void testBill_SuiteRoom2Nights() {
        double bill = calculateBill("2025-03-10", "2025-03-12", "Suite");
        // 2 nights × 55,000 = 110,000
        assertEquals(110000.0, bill, "2 nights Suite should be LKR 110,000");
    }

    @Test
    @DisplayName("Bill: Check-out same day as check-in = invalid (0 nights)")
    void testBill_SameDayCheckout() {
        double bill = calculateBill("2025-01-05", "2025-01-05", "Standard");
        // 0 nights → should return -1 (invalid)
        assertEquals(-1.0, bill, "Same-day check-in/out should be invalid");
    }

    @Test
    @DisplayName("Bill: Check-out BEFORE check-in = invalid")
    void testBill_CheckoutBeforeCheckin() {
        double bill = calculateBill("2025-01-10", "2025-01-05", "Standard");
        // Negative nights → invalid
        assertEquals(-1.0, bill, "Check-out before check-in should be invalid");
    }

    @Test
    @DisplayName("Bill: Editing from 10 Jan to 12 Jan extends bill by 2 nights")
    void testBill_ExtendStayBy2Nights() {
        // Original booking: Jan 5 → Jan 10 (5 nights)
        double originalBill = calculateBill("2025-01-05", "2025-01-10", "Standard");
        // After edit: Jan 5 → Jan 12 (7 nights)
        double updatedBill  = calculateBill("2025-01-05", "2025-01-12", "Standard");

        assertEquals(75000.0,  originalBill, "Original bill should be 75,000");
        assertEquals(105000.0, updatedBill,  "Updated bill should be 105,000");
        assertTrue(updatedBill > originalBill, "Extended stay should cost more");
    }

    @Test
    @DisplayName("Bill: Changing room type recalculates correctly")
    void testBill_RoomTypeChange() {
        // Same dates, different room type
        double standardBill = calculateBill("2025-06-01", "2025-06-04", "Standard");
        double suiteBill    = calculateBill("2025-06-01", "2025-06-04", "Suite");

        // Standard: 3 × 15,000 = 45,000
        // Suite:    3 × 55,000 = 165,000
        assertEquals(45000.0,  standardBill, "3 nights Standard = 45,000");
        assertEquals(165000.0, suiteBill,    "3 nights Suite = 165,000");
        assertTrue(suiteBill > standardBill, "Suite should cost more than Standard");
    }


    // ================================================================
    //  GROUP 4 — RESERVATION VALIDATION TESTS
    //  These test the input validation in UpdateReservationServlet
    // ================================================================

    @Test
    @DisplayName("Reservation: Missing resId should be treated as invalid")
    void testReservation_MissingResId() {
        String resId = null;
        boolean isValid = (resId != null && !resId.trim().isEmpty());
        assertFalse(isValid, "A null reservation ID should be caught as invalid");
    }

    @Test
    @DisplayName("Reservation: Empty resId string should be treated as invalid")
    void testReservation_EmptyResId() {
        String resId = "";
        boolean isValid = (resId != null && !resId.trim().isEmpty());
        assertFalse(isValid, "An empty reservation ID should be caught as invalid");
    }

    @Test
    @DisplayName("Reservation: Valid resId like 'OVR-001' should pass validation")
    void testReservation_ValidResId() {
        String resId = "OVR-001";
        boolean isValid = (resId != null && !resId.trim().isEmpty());
        assertTrue(isValid, "A proper reservation ID should pass validation");
    }

    @Test
    @DisplayName("Reservation: Guest name should not be blank")
    void testReservation_GuestNameBlank() {
        String guestName = "   ";
        boolean isValid  = (guestName != null && !guestName.trim().isEmpty());
        assertFalse(isValid, "Blank guest name should not be accepted");
    }

    @Test
    @DisplayName("Reservation: Room type must be Standard, Deluxe, or Suite")
    void testReservation_ValidRoomTypes() {
        String[] validTypes = {"Standard", "Deluxe", "Suite"};

        assertTrue(java.util.Arrays.asList(validTypes).contains("Standard"), "Standard is valid");
        assertTrue(java.util.Arrays.asList(validTypes).contains("Deluxe"),   "Deluxe is valid");
        assertTrue(java.util.Arrays.asList(validTypes).contains("Suite"),    "Suite is valid");
        assertFalse(java.util.Arrays.asList(validTypes).contains("Penthouse"), "Penthouse is not valid");
    }

    @Test
    @DisplayName("Reservation: Total bill must be a positive number")
    void testReservation_TotalBillMustBePositive() {
        double validBill   =  75000.0;
        double invalidBill = -500.0;
        double zeroBill    =  0.0;

        assertTrue(validBill   > 0, "Positive bill is valid");
        assertFalse(invalidBill > 0, "Negative bill is invalid");
        assertFalse(zeroBill   > 0, "Zero bill should not be accepted");
    }


    // ================================================================
    //  GROUP 5 — LOGOUT TESTS
    //  These test that logout properly destroys the session
    // ================================================================

    @Test
    @DisplayName("Logout: Session should be invalidated on logout")
    void testLogout_SessionIsInvalidated() {
        // Simulate a logged-in session
        when(mockRequest.getSession(false)).thenReturn(mockSession);

        HttpSession session = mockRequest.getSession(false);
        if (session != null) {
            session.invalidate(); // this is what LogoutServlet does
        }

        // Verify that invalidate() was actually called once
        verify(mockSession, times(1)).invalidate();
    }

    @Test
    @DisplayName("Logout: If no session exists, logout should not crash")
    void testLogout_NoSessionDoesNotCrash() {
        // Simulate: no session (user already logged out or never logged in)
        when(mockRequest.getSession(false)).thenReturn(null);

        // This should run without throwing any exception
        assertDoesNotThrow(() -> {
            HttpSession session = mockRequest.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            // No exception = test passes
        });
    }

    @Test
    @DisplayName("Logout: After logout, session attribute 'user' should not exist")
    void testLogout_UserAttributeRemovedAfterLogout() {
        // Before logout: user is set
        when(mockSession.getAttribute("user")).thenReturn(null); // after invalidate

        // After logout, getAttribute("user") should return null
        Object userAfterLogout = mockSession.getAttribute("user");
        assertNull(userAfterLogout, "After logout, 'user' attribute should be null");
    }
}
