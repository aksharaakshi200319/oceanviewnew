<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- ✅ Fixed - return stops execution immediately -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Layout.css">
    <style>
        /* ── STAT CARDS ── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 22px 24px;
            transition: border-color 0.2s, transform 0.2s;
            animation: fadeUp 0.4s ease both;
        }
        .stat-card:hover { border-color: var(--border-hover); transform: translateY(-2px); }
        .stat-card:nth-child(1) { animation-delay: .05s; }
        .stat-card:nth-child(2) { animation-delay: .10s; }
        .stat-card:nth-child(3) { animation-delay: .15s; }
        .stat-card:nth-child(4) { animation-delay: .20s; }

        .stat-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .stat-label  { font-size: 0.78rem; color: var(--text-secondary); }

        .stat-badge {
            display: flex; align-items: center; gap: 3px;
            font-size: 0.72rem; font-weight: 600;
            padding: 3px 8px; border-radius: 20px;
        }
        .stat-badge.up   { background: rgba(34,197,94,.12);  color: var(--accent-green); }
        .stat-badge.down { background: rgba(239,68,68,.12);  color: var(--accent-red); }
        .stat-badge svg  { width: 11px; height: 11px; }

        .stat-value { font-size: 1.9rem; font-weight: 700; letter-spacing: -0.03em; margin-bottom: 14px; line-height: 1; }
        .stat-footer { border-top: 1px solid var(--border); padding-top: 14px; }

        .stat-trend { display: flex; align-items: center; gap: 5px; font-size: 0.78rem; font-weight: 500; margin-bottom: 3px; }
        .stat-trend svg { width: 13px; height: 13px; }
        .stat-trend.up   svg { color: var(--accent-green); }
        .stat-trend.down svg { color: var(--accent-red); }
        .stat-sub { font-size: 0.73rem; color: var(--text-muted); }

        .section-title {
            font-size: 1rem; font-weight: 600;
            margin-bottom: 16px;
            display: flex; align-items: center; gap: 8px;
        }
        .section-title::after { content: ''; flex: 1; height: 1px; background: var(--border); }

        /* ── ACTION CARDS ── */
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }

        .action-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 28px 22px;
            text-decoration: none;
            color: var(--text-primary);
            display: flex; flex-direction: column; align-items: flex-start; gap: 10px;
            position: relative; overflow: hidden;
            transition: border-color 0.2s, transform 0.2s, background 0.2s;
            animation: fadeUp 0.4s ease both;
        }
        .action-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 2px; background: var(--card-accent, transparent);
            opacity: 0; transition: opacity 0.2s;
        }
        .action-card:hover { border-color: var(--border-hover); background: var(--bg-card-hover); transform: translateY(-3px); }
        .action-card:hover::before { opacity: 1; }
        .action-card.reservation { --card-accent: var(--accent-cyan); }
        .action-card.records     { --card-accent: var(--accent-purple); }
        .action-card.billing     { --card-accent: var(--accent-green); }
        .action-card.help        { --card-accent: var(--accent-amber); }
        .action-card:nth-child(1) { animation-delay: .25s; }
        .action-card:nth-child(2) { animation-delay: .30s; }
        .action-card:nth-child(3) { animation-delay: .35s; }
        .action-card:nth-child(4) { animation-delay: .40s; }

        .card-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; }
        .card-icon svg { width: 20px; height: 20px; }
        .card-icon.cyan   { background: rgba(0,212,255,.1);  color: var(--accent-cyan); }
        .card-icon.purple { background: rgba(168,85,247,.1); color: var(--accent-purple); }
        .card-icon.green  { background: rgba(34,197,94,.1);  color: var(--accent-green); }
        .card-icon.amber  { background: rgba(245,158,11,.1); color: var(--accent-amber); }

        .action-card h3 { font-size: 0.95rem; font-weight: 600; }
        .action-card p  { font-size: 0.78rem; color: var(--text-secondary); line-height: 1.5; }

        .card-arrow {
            position: absolute; bottom: 20px; right: 20px;
            width: 20px; height: 20px; color: var(--text-muted);
            transition: color .2s, transform .2s;
        }
        .action-card:hover .card-arrow { color: var(--text-secondary); transform: translate(2px, -2px); }
    </style>
</head>
<body>

<%@ include file="SideBar.jsp" %>

<div class="main-content">
    <header class="topbar">
        <span class="topbar-title">Dashboard</span>
        <a href="LogoutServlet" class="btn-exit">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1"/></svg>
            Exit System
        </a>
    </header>

    <div class="page-body">

        <!-- STAT CARDS -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-label">Total Reservations</span>
                    <span class="stat-badge up"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>+12.5%</span>
                </div>
                <div class="stat-value">1,284</div>
                <div class="stat-footer">
                    <div class="stat-trend up"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>Trending up this month</div>
                    <div class="stat-sub">Bookings over the last 6 months</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-label">New Guests</span>
                    <span class="stat-badge down"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M17 7L7 17M7 17h10M7 17V7"/></svg>-20%</span>
                </div>
                <div class="stat-value">1,234</div>
                <div class="stat-footer">
                    <div class="stat-trend down"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M17 7L7 17M7 17h10M7 17V7"/></svg>Down 20% this period</div>
                    <div class="stat-sub">Acquisition needs attention</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-label">Active Rooms</span>
                    <span class="stat-badge up"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>+12.5%</span>
                </div>
                <div class="stat-value">45,678</div>
                <div class="stat-footer">
                    <div class="stat-trend up"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>Strong occupancy rate</div>
                    <div class="stat-sub">Engagement exceeds targets</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-label">Revenue Growth</span>
                    <span class="stat-badge up"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>+4.5%</span>
                </div>
                <div class="stat-value">4.5%</div>
                <div class="stat-footer">
                    <div class="stat-trend up"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>Steady performance increase</div>
                    <div class="stat-sub">Meets growth projections</div>
                </div>
            </div>
        </div>

        <!-- QUICK ACTIONS -->
        <div class="section-title">Quick Actions</div>

        <div class="actions-grid">
            <a href="AddReservation.jsp" class="action-card reservation">
                <div class="card-icon cyan"><svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg></div>
                <h3>Add Reservation</h3>
                <p>Register new guests and book rooms.</p>
                <svg class="card-arrow" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>
            </a>

            <a href="Records.jsp" class="action-card records">
                <div class="card-icon purple"><svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg></div>
                <h3>View Records</h3>
                <p>Search and display guest information.</p>
                <svg class="card-arrow" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>
            </a>

            <a href="calculateBill.jsp" class="action-card billing">
                <div class="card-icon green"><svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg></div>
                <h3>Billing</h3>
                <p>Compute stay costs and print invoices.</p>
                <svg class="card-arrow" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>
            </a>

            <a href="Help.jsp" class="action-card help">
                <div class="card-icon amber"><svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3M12 17h.01"/></svg></div>
                <h3>Help Center</h3>
                <p>Guidelines for new staff members.</p>
                <svg class="card-arrow" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M7 17L17 7M17 7H7M17 7v10"/></svg>
            </a>
        </div>

    </div><!-- /page-body -->
</div><!-- /main-content -->

</body>
</html>
