<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("user") == null) { response.sendRedirect("Login.jsp"); }
    String activePage = "records";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Records | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Layout.css">
    <style>
        .records-wrapper { max-width: 1000px; animation: fadeUp 0.35s ease both; }

        .page-heading { margin-bottom: 28px; }
        .page-heading h1 { font-size: 1.4rem; font-weight: 700; margin-bottom: 4px; }
        .page-heading p  { font-size: 0.82rem; color: var(--text-secondary); }

        /* ── SEARCH BAR ── */
        .search-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 20px 24px;
            margin-bottom: 20px;
            display: flex;
            gap: 12px;
            align-items: flex-end;
        }

        .search-group {
            display: flex; flex-direction: column; gap: 6px;
            flex: 1;
        }

        .search-group label {
            font-size: 0.72rem; font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.07em; text-transform: uppercase;
        }

        .search-group input,
        .search-group select {
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
        .search-group input:focus,
        .search-group select:focus {
            border-color: var(--accent-cyan);
            box-shadow: 0 0 0 3px rgba(0,212,255,0.08);
        }
        .search-group input::placeholder { color: var(--text-muted); }
        .search-group select option { background: #1a1a1a; }

        .btn-search {
            background: var(--accent-cyan); color: #000;
            border: none; padding: 10px 22px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600;
            cursor: pointer; white-space: nowrap; height: 40px;
            display: flex; align-items: center; gap: 6px;
            transition: opacity .15s, transform .15s;
        }
        .btn-search:hover { opacity: 0.85; transform: translateY(-1px); }
        .btn-search svg { width: 15px; height: 15px; }

        .btn-reset {
            background: transparent; color: var(--text-secondary);
            border: 1px solid var(--border); padding: 10px 18px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 500;
            cursor: pointer; white-space: nowrap; height: 40px;
            display: flex; align-items: center; gap: 6px;
            text-decoration: none;
            transition: border-color .15s, color .15s;
        }
        .btn-reset:hover { border-color: var(--border-hover); color: var(--text-primary); }
        .btn-reset svg { width: 14px; height: 14px; }

        /* ── RESULTS META ── */
        .results-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .results-count {
            font-size: 0.8rem;
            color: var(--text-muted);
        }
        .results-count span { color: var(--text-primary); font-weight: 600; }

        /* ── TABLE CARD ── */
        .table-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            animation: fadeUp 0.4s ease both;
            animation-delay: 0.05s;
        }

        .table-scroll { overflow-x: auto; }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead tr {
            background: rgba(255,255,255,0.02);
            border-bottom: 1px solid var(--border);
        }

        thead th {
            padding: 14px 20px;
            text-align: left;
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.08em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        tbody tr {
            border-bottom: 1px solid var(--border);
            transition: background 0.15s;
        }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: rgba(255,255,255,0.02); }

        tbody td {
            padding: 16px 20px;
            font-size: 0.85rem;
            color: var(--text-secondary);
            white-space: nowrap;
        }

        /* first column (Reservation No) stands out */
        tbody td:first-child {
            color: var(--text-primary);
            font-weight: 600;
            font-family: 'Inter', monospace;
        }

        /* Guest name column */
        tbody td:nth-child(2) {
            color: var(--text-primary);
        }

        /* Room type badge */
        .room-badge {
            display: inline-flex;
            align-items: center;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.72rem;
            font-weight: 600;
        }
        .room-badge.standard { background: rgba(0,212,255,.1);  color: var(--accent-cyan); }
        .room-badge.deluxe   { background: rgba(168,85,247,.1); color: var(--accent-purple); }
        .room-badge.suite    { background: rgba(245,158,11,.1); color: var(--accent-amber); }

        /* Bill amount */
        .bill-amount {
            color: var(--accent-green) !important;
            font-weight: 600 !important;
        }

        /* Action buttons in table */
        .action-btn {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 5px 12px; border-radius: 6px;
            font-size: 0.75rem; font-weight: 500;
            text-decoration: none; cursor: pointer;
            border: 1px solid var(--border);
            color: var(--text-secondary);
            transition: border-color .15s, color .15s, background .15s;
            font-family: 'Inter', sans-serif;
        }
        .action-btn:hover { border-color: var(--accent-cyan); color: var(--accent-cyan); background: rgba(0,212,255,.05); }
        .action-btn svg { width: 12px; height: 12px; }

        /* ── EMPTY / ERROR STATES ── */
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
        <span class="topbar-title">Records</span>
        <a href="LogoutServlet" class="btn-exit">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1"/></svg>
            Exit System
        </a>
    </header>

    <div class="page-body">
        <div class="records-wrapper">

            <div class="page-heading">
                <h1>Guest Records</h1>
                <p>Search and view all reservation details.</p>
            </div>

            <!-- ── SEARCH BAR ── -->
            <form method="GET" action="Records.jsp">
                <div class="search-card">
                    <div class="search-group">
                        <label>Search</label>
                        <input type="text" name="query"
                               placeholder="Reservation No. or Guest Name"
                               value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
                    </div>
                    <div class="search-group" style="max-width:180px;">
                        <label>Room Type</label>
                        <select name="roomFilter">
                            <option value="">All Rooms</option>
                            <option value="Standard"  <%= "Standard".equals(request.getParameter("roomFilter"))  ? "selected" : "" %>>Standard</option>
                            <option value="Deluxe"    <%= "Deluxe".equals(request.getParameter("roomFilter"))    ? "selected" : "" %>>Deluxe</option>
                            <option value="Suite"     <%= "Suite".equals(request.getParameter("roomFilter"))     ? "selected" : "" %>>Suite</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-search">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        Search
                    </button>
                    <a href="viewReservations.jsp" class="btn-reset">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
                        Reset
                    </a>
                </div>
            </form>

            <!-- ── RESULTS ── -->
<%
    String query      = request.getParameter("query");
    String roomFilter = request.getParameter("roomFilter");
    int rowCount = 0;

    // ✅ FIXED: Use LOWER() for case-insensitive search
    StringBuilder sql = new StringBuilder("SELECT * FROM reservations WHERE 1=1");
    if (query != null && !query.trim().isEmpty()) {
        sql.append(" AND (LOWER(res_id) LIKE LOWER(?) OR LOWER(guest_name) LIKE LOWER(?))");
    }
    if (roomFilter != null && !roomFilter.trim().isEmpty()) {
        sql.append(" AND room_type = ?");
    }
    sql.append(" ORDER BY check_in DESC");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/ocean_view_db", "root", "");
        PreparedStatement pst = con.prepareStatement(sql.toString());

        int paramIdx = 1;
        if (query != null && !query.trim().isEmpty()) {
            // ✅ FIXED: trim() the like pattern properly
            String like = "%" + query.trim().toLowerCase() + "%";
            pst.setString(paramIdx++, like);
            pst.setString(paramIdx++, like);
        }
        if (roomFilter != null && !roomFilter.trim().isEmpty()) {
            pst.setString(paramIdx++, roomFilter.trim()); // ✅ trim() added
        }

        ResultSet rs = pst.executeQuery();

        java.util.List<java.util.Map<String,String>> rows = new java.util.ArrayList<>();
        while (rs.next()) {
            java.util.Map<String,String> row = new java.util.LinkedHashMap<>();
            row.put("res_id",     rs.getString("res_id"));
            row.put("guest_name", rs.getString("guest_name"));
            row.put("room_type",  rs.getString("room_type"));
            row.put("check_in",   rs.getString("check_in"));
            row.put("check_out",  rs.getString("check_out"));
            row.put("total_bill", rs.getString("total_bill"));
            rows.add(row);
        }
        rowCount = rows.size();
        rs.close();       // ✅ Close ResultSet
        pst.close();      // ✅ Close PreparedStatement
        con.close();
%>
            <!-- result count -->
            <div class="results-meta">
                <span class="results-count">
                    Showing <span><%= rowCount %></span> reservation<%= rowCount != 1 ? "s" : "" %>
                    <% if ((query != null && !query.trim().isEmpty()) || (roomFilter != null && !roomFilter.trim().isEmpty())) { %>
                        matching your filter
                    <% } %>
                </span>
            </div>

            <div class="table-card">
                <% if (rowCount == 0) { %>
                <div class="empty-state">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                    <div class="empty-title">No reservations found</div>
                    <div class="empty-sub">Try a different search term or reset the filters.</div>
                </div>
                <% } else { %>
                <div class="table-scroll">
                    <table>
                        <thead>
                            <tr>
                                <th>Res. No.</th>
                                <th>Guest Name</th>
                                <th>Room Type</th>
                                <th>Check-in</th>
                                <th>Check-out</th>
                                <th>Total Bill</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (java.util.Map<String,String> row : rows) {
                               String rt = row.get("room_type");
                               String badgeClass = "standard";
                               if ("Deluxe".equalsIgnoreCase(rt)) badgeClass = "deluxe";
                               else if ("Suite".equalsIgnoreCase(rt)) badgeClass = "suite";
                               String bill = row.get("total_bill");
                               String formattedBill = "—";
                               try {
                                   formattedBill = "LKR " + String.format("%,.2f", Double.parseDouble(bill));
                               } catch (Exception ignored) {}
                        %>
                            <tr>
                                <td><%= row.get("res_id") %></td>
                                <td><%= row.get("guest_name") %></td>
                                <td><span class="room-badge <%= badgeClass %>"><%= rt %></span></td>
                                <td><%= row.get("check_in") %></td>
                                <td><%= row.get("check_out") %></td>
                                <td class="bill-amount"><%= formattedBill %></td>
                                <td>
                                    <a href="calculateBill.jsp?searchID=<%= row.get("res_id") %>" class="action-btn">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg>
                                        Invoice
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>

            <%
                } catch (Exception e) {
            %>
            <div class="table-card">
                <div class="empty-state">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="empty-title" style="color:var(--accent-red)">Database Error</div>
                    <div class="empty-sub"><%= e.getMessage() %></div>
                </div>
            </div>
            <%
                }
            %>

        </div><!-- /records-wrapper -->
    </div><!-- /page-body -->
</div><!-- /main-content -->

</body>
</html>
