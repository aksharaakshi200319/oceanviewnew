import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("*.jsp")
public class SessionFilter implements Filter {

    // Pages that don't require login
    private static final String[] PUBLIC_PAGES = {
        "/Login.jsp",
        "/index.jsp"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  httpRequest  = (HttpServletRequest)  request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // ── 1. Kill browser cache on ALL pages ──
        // This prevents the back/forward button from showing stale cached pages
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma",        "no-cache");
        httpResponse.setDateHeader("Expires",   0);

        // ── 2. Check if this is a public page ──
        String requestedPage = httpRequest.getServletPath();
        boolean isPublicPage = false;
        for (String page : PUBLIC_PAGES) {
            if (requestedPage.equalsIgnoreCase(page)) {
                isPublicPage = true;
                break;
            }
        }

        // ── 3. If public page → let through ──
        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // ── 4. If protected page → check session ──
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn  = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            // Valid session → let through
            chain.doFilter(request, response);
        } else {
            // No session → redirect to login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/Login.jsp");
        }
    }

    @Override public void init(FilterConfig filterConfig) throws ServletException {}
    @Override public void destroy() {}
}