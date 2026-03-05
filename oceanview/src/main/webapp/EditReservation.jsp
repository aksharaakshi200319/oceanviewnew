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
        .form-group input[readonly] {
            opacity: 0.5;
            cursor: not-allowed;
        }
        .form-group select option { background: #1a1a1a; }

        .bill-note {
            font-size: 0.72rem;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .divider {
            border: none;
            border-top: 1px solid var(--border);
            margin: 28px 0;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }

        .btn-save {
            background: var(--accent-cyan);
            color: #000;
            border: none;
            padding: 11px 28px;
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 7px;
            transition: opacity 0.15s, transform 0.15s;
        }
        .btn-save:hover { opacity: 0.85; transform: translateY(-1px); }
        .btn-save svg { width: 15px; height: 15px; }

        .btn-cancel {
            background: transparent;
            color: var(--text-secondary);
            border: 1px solid var(--border);
            padding: 11px 22px;
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 7px;
            transition: border-color 0.15s, color 0.15s;
        }
        .btn-cancel:hover { border-color: var(--border-hover); color: var(--text-primary); }
        .btn-cancel svg { width: 14px; height: 14px; }

        /* Success / Error toast */
        .toast {
            position: fixed;
            top: 24px;
            right: 24px;
            padding: 14px 20px;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            z-index: 9999;
            animation: slideIn 0.3s ease both;
            box-shadow: 0 8px 32px rgba(0,0,0,0.4);
        }
        .toast.success { background: rgba(16,185,129,0.15); border: 1px solid rgba(16,185,129,0.3); color: var(--accent-green); }
        .toast.error   { background: rgba(239,68,68,0.15);  border: 1px solid rgba(239,68,68,0.3);  color: var(--accent-red); }
        .toast svg { width: 16px; height: 16px; flex-shrink: 0; }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(20px); }
            to   { opacity: 1; transform: translateX(0); }
        }

        .empty-state {
            text-align: center;
            padding: 60px 32px;
            color: var(--text-muted);
        }
        .empty-state svg { width: 40px; height: 40px; margin-bottom: 14px; opacity: 0.35; display: block; margin-inline: auto; }
        .empty-state .empty-title { font-size: 0.95rem; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px; }
        .empty-state .empty-sub   { font-size: 0.8rem; }
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
    /* ── Show success/error message from redirect ── */
    String msg     = request.getParameter("msg");
    String msgType = request.getParameter("type"); // "success" | "error"
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

                <form method="POST" action="UpdateReservationServlet">
                    <input type="hidden" name="resId" value="<%= resId %>">

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label>Guest Name</label>
                            <input type="text" name="guestName"
                                   value="<%= guestName != null ? guestName : "" %>"
                                   placeholder="Full guest name" required>
                        </div>

                        <div class="form-group">
                            <label>Room Type</label>
                            <select name="roomType" required>
                                <option value="Standard" <%= "Standard".equalsIgnoreCase(roomType) ? "selected" : "" %>>Standard</option>
                                <option value="Deluxe"   <%= "Deluxe".equalsIgnoreCase(roomType)   ? "selected" : "" %>>Deluxe</option>
                                <option value="Suite"    <%= "Suite".equalsIgnoreCase(roomType)    ? "selected" : "" %>>Suite</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Total Bill (LKR)</label>
                            <input type="number" name="totalBill" step="0.01" min="0"
                                   value="<%= totalBill != null ? totalBill : "" %>"
                                   placeholder="0.00">
                            <span class="bill-note">Leave blank to keep existing value</span>
                        </div>

                        <div class="form-group">
                            <label>Check-in Date</label>
                            <input type="date" name="checkIn"
                                   value="<%= checkIn != null ? checkIn : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label>Check-out Date</label>
                            <input type="date" name="checkOut"
                                   value="<%= checkOut != null ? checkOut : "" %>" required>
                        </div>

                    </div>

                    <hr class="divider">

                    <div class="form-actions">
                        <a href="Records.jsp" class="btn-cancel">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                            Back to Records
                        </a>
                        <button type="submit" class="btn-save">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M5 13l4 4L19 7"/></svg>
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
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