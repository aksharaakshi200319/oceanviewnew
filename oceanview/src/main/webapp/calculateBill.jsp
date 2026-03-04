<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("user") == null) { response.sendRedirect("Login.jsp"); }
    String activePage = "billing";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Billing | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Layout.css">
    <style>
        .billing-wrapper { max-width: 680px; animation: fadeUp 0.35s ease both; }

        .page-heading { margin-bottom: 28px; }
        .page-heading h1 { font-size: 1.4rem; font-weight: 700; margin-bottom: 4px; }
        .page-heading p  { font-size: 0.82rem; color: var(--text-secondary); }

        /* ── SEARCH CARD ── */
        .form-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 20px;
        }

        .form-row   { display: grid; gap: 14px; margin-bottom: 14px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }

        .form-group label {
            font-size: 0.75rem; font-weight: 500;
            color: var(--text-secondary);
            letter-spacing: 0.04em; text-transform: uppercase;
        }

        .input-row { display: flex; gap: 10px; }

        .form-group input {
            flex: 1;
            background: #111;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 10px 14px;
            color: var(--text-primary);
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            outline: none;
            transition: border-color 0.15s, box-shadow 0.15s;
            width: 100%;
        }
        .form-group input:focus {
            border-color: var(--accent-cyan);
            box-shadow: 0 0 0 3px rgba(0,212,255,0.08);
        }
        .form-group input::placeholder { color: var(--text-muted); }

        .btn-search {
            background: var(--accent-cyan); color: #000;
            border: none; padding: 10px 22px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600;
            cursor: pointer; white-space: nowrap;
            transition: opacity .15s, transform .15s;
            display: flex; align-items: center; gap: 6px;
        }
        .btn-search:hover { opacity: 0.85; transform: translateY(-1px); }
        .btn-search svg { width: 15px; height: 15px; }

        /* ── INVOICE CARD ── */
        .invoice-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            animation: fadeUp 0.4s ease both;
        }

        .invoice-header {
            padding: 28px 32px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        .invoice-brand { display: flex; align-items: center; gap: 12px; }

        .invoice-brand-icon {
            width: 36px; height: 36px;
            background: var(--accent-cyan);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 14px; font-weight: 700; color: #000;
        }

        .invoice-brand-text h2 {
            font-size: 1rem; font-weight: 700;
            letter-spacing: 0.02em;
        }
        .invoice-brand-text p { font-size: 0.75rem; color: var(--text-secondary); margin-top: 2px; }

        .invoice-meta { text-align: right; }
        .invoice-meta .invoice-label {
            font-size: 0.68rem; font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.08em; text-transform: uppercase;
            margin-bottom: 4px;
        }
        .invoice-meta .invoice-number { font-size: 1.1rem; font-weight: 700; color: var(--accent-cyan); }
        .invoice-meta .invoice-date   { font-size: 0.75rem; color: var(--text-secondary); margin-top: 4px; }

        /* ── INVOICE BODY ── */
        .invoice-body { padding: 28px 32px; }

        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 28px;
        }

        .detail-item {}
        .detail-item .detail-label {
            font-size: 0.7rem; font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.06em; text-transform: uppercase;
            margin-bottom: 4px;
        }
        .detail-item .detail-value {
            font-size: 0.9rem; font-weight: 500;
            color: var(--text-primary);
        }

        /* ── BILL BREAKDOWN ── */
        .bill-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
        }

        .bill-table th {
            font-size: 0.7rem; font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.06em; text-transform: uppercase;
            text-align: left;
            padding: 8px 0;
            border-bottom: 1px solid var(--border);
        }
        .bill-table th:last-child { text-align: right; }

        .bill-table td {
            padding: 14px 0;
            border-bottom: 1px solid var(--border);
            font-size: 0.875rem;
            color: var(--text-secondary);
        }
        .bill-table td:last-child { text-align: right; color: var(--text-primary); font-weight: 500; }
        .bill-table tr:last-child td { border-bottom: none; }

        /* ── TOTAL ── */
        .invoice-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 32px;
            background: rgba(0,212,255,0.04);
            border-top: 1px solid var(--border);
        }

        .total-label {
            font-size: 0.85rem; font-weight: 600;
            color: var(--text-secondary);
        }
        .total-amount {
            font-size: 1.6rem; font-weight: 700;
            color: var(--accent-cyan);
            letter-spacing: -0.02em;
        }
        .total-currency {
            font-size: 0.75rem; font-weight: 500;
            color: var(--text-muted);
            vertical-align: super;
            margin-right: 4px;
        }

        /* ── INVOICE ACTIONS ── */
        .invoice-actions {
            display: flex;
            gap: 12px;
            padding: 20px 32px;
            border-top: 1px solid var(--border);
        }

        .btn-print {
            flex: 1;
            background: var(--accent-cyan); color: #000;
            border: none; padding: 12px 20px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            transition: opacity .15s, transform .15s;
        }
        .btn-print:hover { opacity: 0.85; transform: translateY(-1px); }
        .btn-print svg { width: 16px; height: 16px; }

        .btn-back {
            background: transparent; color: var(--text-secondary);
            border: 1px solid var(--border); padding: 12px 20px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 500;
            cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center; gap: 8px;
            transition: border-color .15s, color .15s;
        }
        .btn-back:hover { border-color: var(--border-hover); color: var(--text-primary); }
        .btn-back svg { width: 15px; height: 15px; }

        /* ── ERROR / EMPTY STATE ── */
        .empty-state {
            text-align: center;
            padding: 48px 32px;
            color: var(--text-muted);
        }
        .empty-state svg { width: 40px; height: 40px; margin-bottom: 12px; opacity: 0.4; }
        .empty-state p { font-size: 0.875rem; }

        /* ── PRINT STYLES ── */
        @media print {
            .sidebar, .topbar, .form-card,
            .invoice-actions, .btn-print, .btn-back { display: none !important; }
            .main-content { margin-left: 0 !important; }
            .page-body { padding: 0 !important; }
            .invoice-card { border: none; box-shadow: none; }
            body { background: white; color: black; }
            .invoice-header, .invoice-body, .invoice-total { color: black; }
            .invoice-total { background: #f0f0f0; }
        }
    </style>
</head>
<body>

<%@ include file="SideBar.jsp" %>

<div class="main-content">
    <header class="topbar">
        <span class="topbar-title">Billing</span>
        <a href="LogoutServlet" class="btn-exit">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1"/></svg>
            Exit System
        </a>
    </header>

    <div class="page-body">
        <div class="billing-wrapper">

            <div class="page-heading">
                <h1>Billing</h1>
                <p>Search a reservation to compute and print its invoice.</p>
            </div>

            <!-- SEARCH -->
            <div class="form-card">
                <form method="GET" action="calculateBill.jsp">
                    <div class="form-group">
                        <label>Reservation Number</label>
                        <div class="input-row">
                            <input type="text" name="searchID"
                                   placeholder="e.g. OVR-101"
                                   value="<%= request.getParameter("searchID") != null ? request.getParameter("searchID") : "" %>"
                                   required>
                            <button type="submit" class="btn-search">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                                Search
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- INVOICE RESULT -->
            <%
                String id = request.getParameter("searchID");
                if (id != null && !id.trim().isEmpty()) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/ocean_view_db", "root", "");
                        PreparedStatement pst = con.prepareStatement(
                            "SELECT * FROM reservations WHERE res_id = ?");
                        pst.setString(1, id.trim());
                        ResultSet rs = pst.executeQuery();

                        if (rs.next()) {
                            String resId     = rs.getString("res_id");
                            String guestName = rs.getString("guest_name");
                            String roomType  = rs.getString("room_type");
                            String checkIn   = rs.getString("check_in");
                            String checkOut  = rs.getString("check_out");
                            double totalBill = rs.getDouble("total_bill");
                            con.close();
            %>
            <div class="invoice-card">

                <!-- Invoice Header -->
                <div class="invoice-header">
                    <div class="invoice-brand">
                        <div class="invoice-brand-icon">O</div>
                        <div class="invoice-brand-text">
                            <h2>OCEAN VIEW RESORT</h2>
                            <p>Galle, Sri Lanka</p>
                        </div>
                    </div>
                    <div class="invoice-meta">
                        <div class="invoice-label">Invoice</div>
                        <div class="invoice-number">#<%= resId %></div>
                        <div class="invoice-date"><%= new java.util.Date() %></div>
                    </div>
                </div>

                <!-- Invoice Body -->
                <div class="invoice-body">

                    <div class="detail-grid">
                        <div class="detail-item">
                            <div class="detail-label">Guest Name</div>
                            <div class="detail-value"><%= guestName %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Room Type</div>
                            <div class="detail-value"><%= roomType %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Check-in</div>
                            <div class="detail-value"><%= checkIn %></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Check-out</div>
                            <div class="detail-value"><%= checkOut %></div>
                        </div>
                    </div>

                    <table class="bill-table">
                        <thead>
                            <tr>
                                <th>Description</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Room Charge — <%= roomType %></td>
                                <td>LKR <%= String.format("%,.2f", totalBill) %></td>
                            </tr>
                        </tbody>
                    </table>

                </div><!-- /invoice-body -->

                <!-- Total -->
                <div class="invoice-total">
                    <span class="total-label">Total Amount Due</span>
                    <span class="total-amount">
                        <span class="total-currency">LKR</span><%= String.format("%,.2f", totalBill) %>
                    </span>
                </div>

                <!-- Actions -->
                <div class="invoice-actions">
                    <a href="calculateBill.jsp" class="btn-back">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        New Search
                    </a>
                    <button class="btn-print" onclick="window.print()">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M6 9V2h12v7M6 18H4a2 2 0 01-2-2v-5a2 2 0 012-2h16a2 2 0 012 2v5a2 2 0 01-2 2h-2M6 14h12v8H6z"/></svg>
                        Print Invoice
                    </button>
                </div>

            </div><!-- /invoice-card -->
            <%
                        } else {
                            con.close();
            %>
            <div class="invoice-card">
                <div class="empty-state">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                    <p>No reservation found for <strong style="color:var(--text-primary)"><%= id %></strong>.<br>Please check the reservation number and try again.</p>
                </div>
            </div>
            <%
                        }
                    } catch (Exception e) {
            %>
            <div class="invoice-card">
                <div class="empty-state">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <p style="color:var(--accent-red)">Database error: <%= e.getMessage() %></p>
                </div>
            </div>
            <%
                    }
                }
            %>

        </div><!-- /billing-wrapper -->
    </div><!-- /page-body -->
</div><!-- /main-content -->

</body>
</html>
