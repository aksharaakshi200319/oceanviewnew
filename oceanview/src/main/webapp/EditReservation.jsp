<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Reservation | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Layout.css">
    <style>
        .edit-wrapper { max-width: 680px; animation: fadeUp 0.35s ease both; }

        .page-heading { margin-bottom: 28px; }
        .page-heading h1 { font-size: 1.4rem; font-weight: 700; margin-bottom: 4px; }
        .page-heading p  { font-size: 0.82rem; color: var(--text-secondary); }

        .form-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 32px;
            animation: fadeUp 0.4s ease both;
            animation-delay: 0.05s;
        }

        .res-id-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(0,212,255,0.08);
            border: 1px solid rgba(0,212,255,0.2);
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 0.85rem;
            color: var(--accent-cyan);
            font-weight: 600;
            margin-bottom: 28px;
        }
        .res-id-badge svg { width: 14px; height: 14px; }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }
        .form-group.full-width { grid-column: 1 / -1; }

        .form-group label {
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.07em;
            text-transform: uppercase;
        }

        .form-group input,
        .form-group select {
            background: #111;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 11px 14px;
            color: var(--text-primary);
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            outline: none;
            transition: border-color 0.15s, box-shadow 0.15s;
            width: 100%;
            box-sizing: border-box;
        }
        .form-group input:focus,
        .form-group select:focus {
            border-color: var(--accent-cyan);
            box-shadow: 0 0 0 3px rgba(0,212,255,0.08);
        }
        /* Readonly bill field styling */
        .form-group input[readonly] {
            opacity: 1;
            cursor: not-allowed;
            color: var(--accent-green);
            font-weight: 700;
            background: rgba(16,185,129,0.05);
            border-color: rgba(16,185,129,0.2);
        }
        .form-group select option { background: #1a1a1a; }

        input[type="date"]::-webkit-calendar-picker-indicator { filter: invert(0.6); cursor: pointer; }

        /* ── BILL PREVIEW PANEL ── */
        .bill-preview {
            grid-column: 1 / -1;
            background: rgba(0,212,255,0.04);
            border: 1px solid rgba(0,212,255,0.15);
            border-radius: 12px;
            padding: 18px 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            transition: border-color 0.3s, background 0.3s;
        }
        .bill-preview.has-value {
            border-color: rgba(16,185,129,0.35);
            background: rgba(16,185,129,0.04);
        }
        .bill-preview.has-value.flash {
            animation: flashPulse 0.5s ease;
        }
        @keyframes flashPulse {
            0%   { box-shadow: 0 0 0 0   rgba(16,185,129,0.4); }
            40%  { box-shadow: 0 0 0 8px rgba(16,185,129,0.1); }
            100% { box-shadow: 0 0 0 0   rgba(16,185,129,0); }
        }

        .bill-left { display: flex; flex-direction: column; gap: 5px; }

        .bill-label {
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .bill-breakdown {
            font-size: 0.8rem;
            color: var(--text-secondary);
            line-height: 1.5;
        }
        .bill-breakdown b { color: var(--text-primary); font-weight: 600; }

        .bill-nights-chip {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: rgba(0,212,255,0.08);
            border: 1px solid rgba(0,212,255,0.15);
            border-radius: 20px;
            padding: 3px 10px;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--accent-cyan);
            margin-top: 4px;
            width: fit-content;
        }
        .bill-nights-chip svg { width: 11px; height: 11px; }

        .bill-total {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--accent-green);
            white-space: nowrap;
            letter-spacing: -0.02em;
        }
        .bill-total.dim {
            font-size: 1.1rem;
            font-weight: 400;
            color: var(--text-muted);
        }

        /* Date error messages */
        .date-error-msg {
            font-size: 0.72rem;
            color: #f87171;
            margin-top: 1px;
            display: none;
        }
        .date-error-msg.active { display: block; }
        .input-error {
            border-color: rgba(239,68,68,0.6) !important;
            box-shadow: 0 0 0 3px rgba(239,68,68,0.08) !important;
        }

        .bill-note {
            font-size: 0.71rem;
            color: var(--text-muted);
            margin-top: 1px;
        }

        .divider { border: none; border-top: 1px solid var(--border); margin: 28px 0; }

        .form-actions { display: flex; gap: 12px; justify-content: flex-end; }

        .btn-save {
            background: var(--accent-cyan); color: #000;
            border: none; padding: 11px 28px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600;
            cursor: pointer; display: flex; align-items: center; gap: 7px;
            transition: opacity 0.15s, transform 0.15s;
        }
        .btn-save:hover { opacity: 0.85; transform: translateY(-1px); }
        .btn-save:disabled { opacity: 0.35; cursor: not-allowed; transform: none; }
        .btn-save svg { width: 15px; height: 15px; }

        .btn-cancel {
            background: transparent; color: var(--text-secondary);
            border: 1px solid var(--border); padding: 11px 22px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 500;
            cursor: pointer; text-decoration: none;
            display: flex; align-items: center; gap: 7px;
            transition: border-color 0.15s, color 0.15s;
        }
        .btn-cancel:hover { border-color: var(--border-hover); color: var(--text-primary); }
        .btn-cancel svg { width: 14px; height: 14px; }

        /* Toast */
        .toast {
            position: fixed; top: 24px; right: 24px;
            padding: 14px 20px; border-radius: 10px;
            font-size: 0.85rem; font-weight: 500;
            display: flex; align-items: center; gap: 10px;
            z-index: 9999; animation: slideIn 0.3s ease both;
            box-shadow: 0 8px 32px rgba(0,0,0,0.4);
        }
        .toast.success { background: rgba(16,185,129,0.15); border: 1px solid rgba(16,185,129,0.3); color: var(--accent-green); }
        .toast.error   { background: rgba(239,68,68,0.15);  border: 1px solid rgba(239,68,68,0.3);  color: var(--accent-red); }
        .toast svg { width: 16px; height: 16px; flex-shrink: 0; }
        @keyframes slideIn { from { opacity:0; transform:translateX(20px); } to { opacity:1; transform:translateX(0); } }

        .empty-state { text-align:center; padding:60px 32px; color:var(--text-muted); }
        .empty-state svg { width:40px; height:40px; margin-bottom:14px; opacity:0.35; display:block; margin-inline:auto; }
        .empty-state .empty-title { font-size:0.95rem; font-weight:600; color:var(--text-secondary); margin-bottom:6px; }
        .empty-state .empty-sub   { font-size:0.8rem; }
    </style>
</head>
<body>

<%@ include file="SideBar.jsp" %>

<div class="main-content">
    <header class="topbar">
        <span class="topbar-title">Edit Reservation</span>
        <a href="LogoutServlet" class="btn-exit">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1"/></svg>
            Exit System
        </a>
    </header>

    <div class="page-body">
        <div class="edit-wrapper">

            <div class="page-heading">
                <h1>Edit Reservation</h1>
                <p>Modify the reservation details below and save your changes.</p>
            </div>

<%
    String msg     = request.getParameter("msg");
    String msgType = request.getParameter("type");
%>
<% if (msg != null && !msg.isEmpty()) { %>
<div class="toast <%= msgType != null ? msgType : "success" %>" id="toast">
    <% if ("error".equals(msgType)) { %>
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
    <% } else { %>
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
    <% } %>
    <%= msg %>
</div>
<script>setTimeout(() => { const t = document.getElementById('toast'); if(t) t.style.display='none'; }, 3500);</script>
<% } %>

<%
    String resId = request.getParameter("resId");
    if (resId == null || resId.trim().isEmpty()) {
%>
            <div class="form-card">
                <div class="empty-state">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="empty-title">No Reservation ID Provided</div>
                    <div class="empty-sub">Please go back to <a href="Records.jsp" style="color:var(--accent-cyan)">Records</a> and click Edit on a reservation.</div>
                </div>
            </div>
<%
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ocean_view_db", "root", "");
            PreparedStatement pst = con.prepareStatement("SELECT * FROM reservations WHERE res_id = ?");
            pst.setString(1, resId.trim());
            ResultSet rs = pst.executeQuery();

            if (!rs.next()) {
%>
            <div class="form-card">
                <div class="empty-state">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2"/></svg>
                    <div class="empty-title">Reservation Not Found</div>
                    <div class="empty-sub">No reservation found with ID <strong><%= resId %></strong>.</div>
                </div>
            </div>
<%
            } else {
                String guestName  = rs.getString("guest_name");
                String roomType   = rs.getString("room_type");
                String checkIn    = rs.getString("check_in");
                String checkOut   = rs.getString("check_out");
                String totalBill  = rs.getString("total_bill");
                rs.close(); pst.close(); con.close();
%>
            <div class="form-card">

                <div class="res-id-badge">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg>
                    Reservation #<%= resId %>
                </div>

                <form method="POST" action="UpdateReservationServlet" id="editForm">
                    <input type="hidden" name="resId" value="<%= resId %>">

                    <div class="form-grid">

                        <!-- Guest Name -->
                        <div class="form-group full-width">
                            <label>Guest Name</label>
                            <input type="text" name="guestName"
                                   value="<%= guestName != null ? guestName : "" %>"
                                   placeholder="Full guest name" required>
                        </div>

                        <!-- Room Type -->
                        <div class="form-group">
                            <label>Room Type</label>
                            <select name="roomType" id="roomType" required>
                                <option value="Standard" data-rate="15000" <%= "Standard".equalsIgnoreCase(roomType) ? "selected" : "" %>>Standard — LKR 15,000 / night</option>
                                <option value="Deluxe"   data-rate="28000" <%= "Deluxe".equalsIgnoreCase(roomType)   ? "selected" : "" %>>Deluxe — LKR 28,000 / night</option>
                                <option value="Suite"    data-rate="55000" <%= "Suite".equalsIgnoreCase(roomType)    ? "selected" : "" %>>Suite — LKR 55,000 / night</option>
                            </select>
                        </div>

                        <!-- Total Bill (auto-calculated, readonly display) -->
                        <div class="form-group">
                            <label>Total Bill (LKR)</label>
                            <input type="number" name="totalBill" id="totalBill"
                                   step="0.01" min="0" readonly
                                   value="<%= totalBill != null ? totalBill : "" %>"
                                   placeholder="Auto-calculated">
                            <span class="bill-note">Calculated automatically from nights × room rate</span>
                        </div>

                        <!-- Check-in -->
                        <div class="form-group">
                            <label>Check-in Date</label>
                            <input type="date" name="checkIn" id="checkIn"
                                   value="<%= checkIn != null ? checkIn : "" %>" required>
                            <span class="date-error-msg" id="checkInError"></span>
                        </div>

                        <!-- Check-out -->
                        <div class="form-group">
                            <label>Check-out Date</label>
                            <input type="date" name="checkOut" id="checkOut"
                                   value="<%= checkOut != null ? checkOut : "" %>" required>
                            <span class="date-error-msg" id="checkOutError"></span>
                        </div>

                        <!-- ── LIVE BILL PREVIEW ── -->
                        <div class="bill-preview" id="billPreview">
                            <div class="bill-left">
                                <div class="bill-label">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" style="display:inline;width:11px;height:11px;margin-right:4px;vertical-align:middle;"><path d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 11h.01M12 11h.01M15 11h.01M4 19h16a2 2 0 002-2V7a2 2 0 00-2-2H4a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                                    Bill Preview
                                </div>
                                <div class="bill-breakdown" id="billBreakdown">
                                    Select valid check-in and check-out dates
                                </div>
                                <div class="bill-nights-chip" id="nightsChip" style="display:none;">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/></svg>
                                    <span id="nightsChipText">0 nights</span>
                                </div>
                            </div>
                            <div class="bill-total dim" id="billTotal">—</div>
                        </div>

                    </div><!-- /form-grid -->

                    <hr class="divider">

                    <div class="form-actions">
                        <a href="Records.jsp" class="btn-cancel">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                            Back to Records
                        </a>
                        <button type="submit" class="btn-save" id="saveBtn">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 13l4 4L19 7"/></svg>
                            Save Changes
                        </button>
                    </div>
                </form>
            </div><!-- /form-card -->

            <script>
            (function () {
                // ── Nightly rates (LKR) — keep in sync with AddReservation.jsp ──
                const RATES = { Standard: 15000, Deluxe: 28000, Suite: 55000 };

                const roomTypeEl    = document.getElementById('roomType');
                const checkInEl     = document.getElementById('checkIn');
                const checkOutEl    = document.getElementById('checkOut');
                const totalBillEl   = document.getElementById('totalBill');
                const billPreview   = document.getElementById('billPreview');
                const billBreakdown = document.getElementById('billBreakdown');
                const billTotal     = document.getElementById('billTotal');
                const nightsChip    = document.getElementById('nightsChip');
                const nightsChipTxt = document.getElementById('nightsChipText');
                const checkInErr    = document.getElementById('checkInError');
                const checkOutErr   = document.getElementById('checkOutError');
                const saveBtn       = document.getElementById('saveBtn');

                function fmtLKR(n) {
                    return 'LKR\u00A0' + n.toLocaleString('en-LK', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                }

                function clearErrors() {
                    checkInEl.classList.remove('input-error');
                    checkOutEl.classList.remove('input-error');
                    checkInErr.textContent  = ''; checkInErr.classList.remove('active');
                    checkOutErr.textContent = ''; checkOutErr.classList.remove('active');
                }

                function setError(inputEl, errorEl, msg) {
                    inputEl.classList.add('input-error');
                    errorEl.textContent = msg;
                    errorEl.classList.add('active');
                }

                function setDim() {
                    billTotal.textContent = '—';
                    billTotal.classList.add('dim');
                    billPreview.classList.remove('has-value', 'flash');
                    nightsChip.style.display = 'none';
                    totalBillEl.value = '';
                }

                function recalculate() {
                    clearErrors();

                    const ciVal = checkInEl.value;
                    const coVal = checkOutEl.value;

                    // Get current rate
                    const opt  = roomTypeEl.options[roomTypeEl.selectedIndex];
                    const room = opt.value;
                    const rate = RATES[room] || 0;

                    if (!ciVal || !coVal) {
                        setDim();
                        billBreakdown.innerHTML = 'Select valid check-in and check-out dates';
                        saveBtn.disabled = false;
                        return;
                    }

                    const checkIn  = new Date(ciVal);
                    const checkOut = new Date(coVal);
                    const today    = new Date(); today.setHours(0, 0, 0, 0);

                    // Validate: check-in not in the past
                    if (checkIn < today) {
                        setError(checkInEl, checkInErr, 'Check-in date cannot be in the past.');
                        setDim();
                        billBreakdown.innerHTML = '<span style="color:#f87171">⚠ Invalid date range</span>';
                        saveBtn.disabled = true;
                        return;
                    }

                    // Validate: check-out after check-in
                    if (checkOut <= checkIn) {
                        setError(checkOutEl, checkOutErr, 'Check-out must be after check-in.');
                        setDim();
                        billBreakdown.innerHTML = '<span style="color:#f87171">⚠ Invalid date range</span>';
                        saveBtn.disabled = true;
                        return;
                    }

                    // ── Calculate ──
                    const MS_DAY = 86400000;
                    const nights = Math.round((checkOut - checkIn) / MS_DAY);
                    const total  = nights * rate;

                    // Write calculated value into the (readonly) hidden-friendly input
                    totalBillEl.value = total.toFixed(2);

                    // Build breakdown text
                    billBreakdown.innerHTML =
                        '<b>' + nights + '</b> night' + (nights !== 1 ? 's' : '') +
                        ' &times; <b>' + fmtLKR(rate) + '</b>' +
                        ' <span style="color:var(--text-muted)">(' + room + ')</span>';

                    // Nights chip
                    nightsChipTxt.textContent = nights + (nights === 1 ? ' night' : ' nights');
                    nightsChip.style.display  = 'inline-flex';

                    // Total amount
                    billTotal.textContent = fmtLKR(total);
                    billTotal.classList.remove('dim');

                    // Flash animation
                    billPreview.classList.remove('flash');
                    void billPreview.offsetWidth; // force reflow
                    billPreview.classList.add('has-value', 'flash');

                    saveBtn.disabled = false;
                }

                // Listen for any change
                roomTypeEl.addEventListener('change', recalculate);
                checkInEl.addEventListener('change',  recalculate);
                checkOutEl.addEventListener('change', recalculate);

                // Run immediately on page load so existing DB dates are shown
                recalculate();
            })();
            </script>

<%
            }
        } catch (Exception e) {
%>
            <div class="form-card">
                <div class="empty-state">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="empty-title" style="color:var(--accent-red)">Database Error</div>
                    <div class="empty-sub"><%= e.getMessage() %></div>
                </div>
            </div>
<%
        }
    }
%>

        </div><!-- /edit-wrapper -->
    </div><!-- /page-body -->
</div><!-- /main-content -->

</body>
</html>