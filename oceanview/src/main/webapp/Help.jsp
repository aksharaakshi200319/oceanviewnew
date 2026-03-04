<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) { response.sendRedirect("Login.jsp"); }
    String activePage = "help";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Help Center | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Layout.css">
    <style>
        .help-wrapper { max-width: 780px; animation: fadeUp 0.35s ease both; }

        .page-heading { margin-bottom: 28px; }
        .page-heading h1 { font-size: 1.4rem; font-weight: 700; margin-bottom: 4px; }
        .page-heading p  { font-size: 0.82rem; color: var(--text-secondary); }

        /* ── SECTION CARDS ── */
        .help-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 20px;
        }

        .help-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 28px;
            transition: border-color 0.2s, transform 0.2s;
            animation: fadeUp 0.4s ease both;
            position: relative;
            overflow: hidden;
        }
        .help-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: var(--card-accent, transparent);
        }
        .help-card:hover { border-color: var(--border-hover); transform: translateY(-2px); }

        .help-card:nth-child(1) { --card-accent: var(--accent-cyan);   animation-delay: .05s; }
        .help-card:nth-child(2) { --card-accent: var(--accent-amber);  animation-delay: .10s; }
        .help-card:nth-child(3) { --card-accent: var(--accent-purple); animation-delay: .15s; }
        .help-card:nth-child(4) { --card-accent: var(--accent-green);  animation-delay: .20s; }

        .help-card-icon {
            width: 38px; height: 38px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 16px;
        }
        .help-card-icon svg { width: 19px; height: 19px; }
        .icon-cyan   { background: rgba(0,212,255,.1);  color: var(--accent-cyan); }
        .icon-amber  { background: rgba(245,158,11,.1); color: var(--accent-amber); }
        .icon-purple { background: rgba(168,85,247,.1); color: var(--accent-purple); }
        .icon-green  { background: rgba(34,197,94,.1);  color: var(--accent-green); }

        .help-card h3 {
            font-size: 0.92rem; font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 10px;
        }

        .help-card p {
            font-size: 0.82rem;
            color: var(--text-secondary);
            line-height: 1.7;
        }

        .help-card p strong { color: var(--text-primary); }

        /* ── ROOM RATES TABLE ── */
        .rates-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            margin-bottom: 20px;
            animation: fadeUp 0.4s ease both;
            animation-delay: .25s;
        }

        .rates-header {
            padding: 20px 28px;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 10px;
        }
        .rates-header .rates-icon {
            width: 38px; height: 38px;
            border-radius: 10px;
            background: rgba(245,158,11,.1); color: var(--accent-amber);
            display: flex; align-items: center; justify-content: center;
        }
        .rates-header .rates-icon svg { width: 19px; height: 19px; }
        .rates-header h3 { font-size: 0.92rem; font-weight: 600; }

        .rates-table {
            width: 100%;
            border-collapse: collapse;
        }
        .rates-table thead tr { background: rgba(255,255,255,0.02); }
        .rates-table th {
            padding: 12px 28px;
            text-align: left;
            font-size: 0.7rem; font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 0.07em; text-transform: uppercase;
            border-bottom: 1px solid var(--border);
        }
        .rates-table th:last-child { text-align: right; }

        .rates-table td {
            padding: 16px 28px;
            font-size: 0.85rem;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border);
        }
        .rates-table tr:last-child td { border-bottom: none; }
        .rates-table td:first-child { color: var(--text-primary); font-weight: 500; }
        .rates-table td:last-child  { text-align: right; color: var(--accent-green); font-weight: 600; }

        .room-badge {
            display: inline-flex; align-items: center;
            padding: 3px 10px; border-radius: 20px;
            font-size: 0.72rem; font-weight: 600;
        }
        .room-badge.standard { background: rgba(0,212,255,.1);  color: var(--accent-cyan); }
        .room-badge.deluxe   { background: rgba(168,85,247,.1); color: var(--accent-purple); }
        .room-badge.suite    { background: rgba(245,158,11,.1); color: var(--accent-amber); }

        /* ── CONTACT CARD ── */
        .contact-card {
            background: rgba(0,212,255,0.04);
            border: 1px solid rgba(0,212,255,0.15);
            border-radius: 16px;
            padding: 24px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            animation: fadeUp 0.4s ease both;
            animation-delay: .30s;
        }

        .contact-text h3 { font-size: 0.92rem; font-weight: 600; margin-bottom: 4px; }
        .contact-text p  { font-size: 0.8rem; color: var(--text-secondary); }

        .btn-dashboard {
            background: var(--accent-cyan); color: #000;
            border: none; padding: 10px 20px; border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.82rem; font-weight: 600;
            cursor: pointer; text-decoration: none; white-space: nowrap;
            display: inline-flex; align-items: center; gap: 6px;
            transition: opacity .15s, transform .15s;
        }
        .btn-dashboard:hover { opacity: 0.85; transform: translateY(-1px); }
        .btn-dashboard svg { width: 14px; height: 14px; }
    </style>
</head>
<body>

<%@ include file="SideBar.jsp" %>

<div class="main-content">
    <header class="topbar">
        <span class="topbar-title">Help Center</span>
        <a href="LogoutServlet" class="btn-exit">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1"/></svg>
            Exit System
        </a>
    </header>

    <div class="page-body">
        <div class="help-wrapper">

            <div class="page-heading">
                <h1>Help Center</h1>
                <p>System guidelines and instructions for Ocean View staff.</p>
            </div>

            <!-- ── GUIDE CARDS ── -->
            <div class="help-grid">

                <div class="help-card">
                    <div class="help-card-icon icon-cyan">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                    </div>
                    <h3>Creating a Reservation</h3>
                    <p>Go to <strong>Reservations</strong> from the sidebar. Fill in the guest name, address, contact, and select a room type. Set accurate check-in and check-out dates — the system will calculate the bill automatically.</p>
                </div>

                <div class="help-card">
                    <div class="help-card-icon icon-amber">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                    </div>
                    <h3>Searching Records</h3>
                    <p>Navigate to <strong>Records</strong> to find guests by their reservation number (e.g. <strong>OVR-101</strong>) or by guest name. You can also filter results by room type using the dropdown.</p>
                </div>

                <div class="help-card">
                    <div class="help-card-icon icon-purple">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg>
                    </div>
                    <h3>Billing &amp; Invoices</h3>
                    <p>Go to <strong>Billing</strong> and enter the reservation number to compute the total stay cost. Click <strong>Print Invoice</strong> to generate a printable receipt for the guest.</p>
                </div>

                <div class="help-card">
                    <div class="help-card-icon icon-green">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    </div>
                    <h3>Reservation Numbers</h3>
                    <p>Each reservation must have a unique ID in the format <strong>OVR-XXX</strong> (e.g. OVR-101, OVR-202). This ID is used across Records and Billing, so make sure it's entered correctly.</p>
                </div>

            </div>

            <!-- ── ROOM RATES TABLE ── -->
            <div class="rates-card">
                <div class="rates-header">
                    <div class="rates-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
                    </div>
                    <h3>Room Rates</h3>
                </div>
                <table class="rates-table">
                    <thead>
                        <tr>
                            <th>Room Type</th>
                            <th>Description</th>
                            <th>Rate per Night</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span class="room-badge standard">Standard</span></td>
                            <td>Comfortable room with garden view</td>
                            <td>LKR 15,000.00</td>
                        </tr>
                        <tr>
                            <td><span class="room-badge deluxe">Deluxe</span></td>
                            <td>Spacious room with ocean-facing balcony</td>
                            <td>LKR 28,000.00</td>
                        </tr>
                        <tr>
                            <td><span class="room-badge suite">Suite</span></td>
                            <td>Premium suite with private pool access</td>
                            <td>LKR 55,000.00</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- ── CONTACT BANNER ── -->
            <div class="contact-card">
                <div class="contact-text">
                    <h3>Need further assistance?</h3>
                    <p>Contact the system administrator or refer to the printed operations manual at the front desk.</p>
                </div>
                <a href="Dashboard.jsp" class="btn-dashboard">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    Back to Dashboard
                </a>
            </div>

        </div><!-- /help-wrapper -->
    </div><!-- /page-body -->
</div><!-- /main-content -->

</body>
</html>
