<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) { response.sendRedirect("Login.jsp"); }
    String activePage = "reservation";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Reservation | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Layout.css">
    <style>
        .form-page  { max-width: 580px; animation: fadeUp 0.35s ease both; }

        .page-heading { margin-bottom: 28px; }
        .page-heading h1 { font-size: 1.4rem; font-weight: 700; margin-bottom: 4px; }
        .page-heading p  { font-size: 0.82rem; color: var(--text-secondary); }

        .form-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 32px;
        }

        .form-row         { display: grid; gap: 14px; margin-bottom: 14px; }
        .form-row.two-col { grid-template-columns: 1fr 1fr; }

        .form-group       { display: flex; flex-direction: column; gap: 6px; }

        .form-group label {
            font-size: 0.75rem; font-weight: 500;
            color: var(--text-secondary);
            letter-spacing: 0.04em; text-transform: uppercase;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            background: #111;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 10px 14px;
            color: var(--text-primary);
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            width: 100%;
            outline: none;
            transition: border-color 0.15s, box-shadow 0.15s;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: var(--accent-cyan);
            box-shadow: 0 0 0 3px rgba(0,212,255,0.08);
        }
        .form-group input::placeholder,
        .form-group textarea::placeholder { color: var(--text-muted); }
        .form-group select option { background: #1a1a1a; }
        .form-group textarea { resize: vertical; min-height: 80px; }

        /* date input calendar icon color fix */
        input[type="date"]::-webkit-calendar-picker-indicator { filter: invert(0.6); cursor: pointer; }

        .form-divider { border: none; border-top: 1px solid var(--border); margin: 20px 0; }

        .form-actions { display: flex; gap: 12px; margin-top: 24px; }

        .btn-primary {
            flex: 1;
            background: var(--accent-cyan); color: #000;
            border: none; padding: 12px 20px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600;
            cursor: pointer; transition: opacity .15s, transform .15s;
        }
        .btn-primary:hover { opacity: 0.85; transform: translateY(-1px); }

        .btn-secondary {
            background: transparent; color: var(--text-secondary);
            border: 1px solid var(--border); padding: 12px 20px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 500;
            cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center;
            transition: border-color .15s, color .15s;
        }
        .btn-secondary:hover { border-color: var(--border-hover); color: var(--text-primary); }
        
        /* Add this to your existing <style> block */
        .error-msg {
            color: #ff4d4d;
            font-size: 0.75rem;
            margin-top: 4px;
            display: none; /* Hidden by default */
            animation: fadeUp 0.2s ease;
        }
        .error-msg.active {
            display: block;
        }
        .input-error {
            border-color: #ff4d4d !important;
            box-shadow: 0 0 0 3px rgba(255, 77, 77, 0.1) !important;
        }
    </style>
</head>
<body>

<%@ include file="SideBar.jsp" %>

<div class="main-content">
    <header class="topbar">
        <span class="topbar-title">Add Reservation</span>
        <a href="LogoutServlet" class="btn-exit">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1"/></svg>
            Exit System
        </a>
    </header>

    <div class="page-body">
        <div class="form-page">

            <div class="page-heading">
                <h1>Add Reservation</h1>
                <p>Register a new guest and assign a room.</p>
            </div>

            <div class="form-card">
                <form id="reservationForm" action="SaveReservationServlet" method="POST">

                  <div class="form-row">
					    <div class="form-group">
					        <label>Reservation Number</label>
					        <input type="text" name="res_id" value="Auto-Generated" disabled style="background: #222; cursor: not-allowed; color: var(--accent-cyan); font-weight: bold;">
					        <p style="font-size: 0.7rem; color: var(--text-muted);">The system will assign the next OVR-ID upon saving.</p>
					    </div>
					</div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Guest Full Name</label>
                            <input type="text" name="guestName" placeholder="Full name" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Address</label>
                            <textarea name="address" placeholder="Guest address" required></textarea>
                        </div>
                    </div>

                    <div class="form-row two-col">
                       <div class="form-group">
    <label>Contact Number</label>
    <input type="text" id="contactNo" name="contactNo" placeholder="e.g. 0712345678" required>
    <span class="error-msg" id="contactError"></span>
</div>
                        <div class="form-group">
                            <label>Room Type</label>
                            <select name="roomType">
                                <option value="Standard">Standard — 15,000 LKR</option>
                                <option value="Deluxe">Deluxe — 28,000 LKR</option>
                                <option value="Suite">Suite — 55,000 LKR</option>
                            </select>
                        </div>
                    </div>

                    <hr class="form-divider">

                <div class="form-row two-col">
    <div class="form-group">
        <label>Check-in Date</label>
        <input type="date" id="checkIn" name="checkIn" required>
        <span class="error-msg" id="checkInError"></span>
    </div>
    <div class="form-group">
        <label>Check-out Date</label>
        <input type="date" id="checkOut" name="checkOut" required>
        <span class="error-msg" id="checkOutError"></span>
    </div>
</div>

                    <div class="form-actions">
                        <a href="Dashboard.jsp" class="btn-secondary">Cancel</a>
                        <button type="submit" class="btn-primary">Confirm &amp; Save</button>
                    </div>

                </form>
            </div>

        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const form = document.getElementById('reservationForm');
        
        // Inputs
        const contactInput = document.getElementById('contactNo');
        const checkInInput = document.getElementById('checkIn');
        const checkOutInput = document.getElementById('checkOut');
        
        // Error Message Spans
        const contactError = document.getElementById('contactError');
        const checkInError = document.getElementById('checkInError');
        const checkOutError = document.getElementById('checkOutError');

        // Helper function to show/hide errors
        function showError(inputEl, errorEl, message) {
            errorEl.textContent = message;
            errorEl.classList.add('active');
            inputEl.classList.add('input-error');
        }

        function clearError(inputEl, errorEl) {
            errorEl.textContent = '';
            errorEl.classList.remove('active');
            inputEl.classList.remove('input-error');
        }

        // 1. Real-time Contact Number Validation (While typing)
        contactInput.addEventListener('input', function() {
            // Strip spaces to check the raw number
            const phoneVal = this.value.replace(/\s+/g, ''); 
            // Regex for Sri Lankan numbers: starts with 0 or +94, followed by 9 digits
            const phoneRegex = /^(\+94|0)\d{9}$/;

            if (phoneVal.length === 0) {
                clearError(contactInput, contactError);
            } else if (!phoneRegex.test(phoneVal)) {
                showError(contactInput, contactError, "Contact number should be within 10 digit and Number only");
            } else {
                clearError(contactInput, contactError);
            }
        });

        // 2. Set Minimum Check-in Date to Today
        const today = new Date();
        const formattedToday = today.toISOString().split('T')[0];
        checkInInput.min = formattedToday;

        // 3. Real-time Date Validation (While selecting)
        function validateDates() {
            clearError(checkInInput, checkInError);
            clearError(checkOutInput, checkOutError);

            if (checkInInput.value) {
                // Prevent past dates in Check-in (if they manually type it)
                if (checkInInput.value < formattedToday) {
                    showError(checkInInput, checkInError, "Check-in cannot be in the past.");
                }

                // Dynamically set minimum Check-out date to 1 day after Check-in
                const checkInDate = new Date(checkInInput.value);
                checkInDate.setDate(checkInDate.getDate() + 1);
                const minCheckOut = checkInDate.toISOString().split('T')[0];
                checkOutInput.min = minCheckOut;

                // Validate Check-out against Check-in
                if (checkOutInput.value) {
                    if (checkOutInput.value <= checkInInput.value) {
                        showError(checkOutInput, checkOutError, "Check-out must be after Check-in.");
                    } else {
                        clearError(checkOutInput, checkOutError);
                    }
                }
            }
        }

        // Trigger date validation whenever either date is changed
        checkInInput.addEventListener('change', validateDates);
        checkOutInput.addEventListener('change', validateDates);

        // 4. Final safety check on Form Submit
        form.addEventListener('submit', function(e) {
            // Trigger all validations one last time
            const inputEvent = new Event('input');
            contactInput.dispatchEvent(inputEvent);
            validateDates();

            // If any error span is currently active, stop the form from submitting
            const hasErrors = document.querySelectorAll('.error-msg.active').length > 0;
            
            if (hasErrors) {
                e.preventDefault(); // Stop submission
                // Focus on the first invalid field
                document.querySelector('.input-error').focus();
            }
        });
    });
</script>
</body>
</html>
