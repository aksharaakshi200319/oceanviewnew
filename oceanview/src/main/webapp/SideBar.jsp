<%-- sidebar.jsp  — include this at the top of every page body --%>
<%-- The including page must set String activePage before including this file --%>
<%-- e.g.  <% String activePage = "reservation"; %> --%>
<aside class="sidebar">

    <div class="sidebar-brand">
        <div class="brand-icon">O</div>
        <span class="brand-name">Ocean View</span>
    </div>

    <span class="nav-section-label">Home</span>

    <a href="Dashboard.jsp" class="nav-item <%= "dashboard".equals(activePage) ? "active" : "" %>">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <rect x="3"  y="3"  width="7" height="7" rx="1"/>
            <rect x="14" y="3"  width="7" height="7" rx="1"/>
            <rect x="3"  y="14" width="7" height="7" rx="1"/>
            <rect x="14" y="14" width="7" height="7" rx="1"/>
        </svg>
        Dashboard
    </a>

    <span class="nav-section-label">Management</span>

    <a href="AddReservation.jsp" class="nav-item <%= "reservation".equals(activePage) ? "active" : "" %>">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path d="M12 5v14M5 12h14"/>
        </svg>
        Reservations
    </a>

    <a href="Records.jsp" class="nav-item <%= "records".equals(activePage) ? "active" : "" %>">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
        </svg>
        Records
    </a>

    <a href="calculateBill.jsp" class="nav-item <%= "billing".equals(activePage) ? "active" : "" %>">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <rect x="2" y="5" width="20" height="14" rx="2"/>
            <path d="M2 10h20"/>
        </svg>
        Billing
    </a>

    <a href="Help.jsp" class="nav-item <%= "help".equals(activePage) ? "active" : "" %>">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"/>
            <path d="M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3M12 17h.01"/>
        </svg>
        Help Center
    </a>

</aside>
