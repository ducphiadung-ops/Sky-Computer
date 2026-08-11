package demo.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter kiểm tra đăng nhập cho toàn bộ ứng dụng.
 * Bất kỳ URL nào không nằm trong danh sách cho phép đều bị chuyển về trang đăng nhập.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String ctx = req.getContextPath();

        // Loại trừ các tài nguyên công khai (login, static files)
        if (isPublicResource(uri, ctx)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("nhanVien") != null);

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(ctx + "/login/dang_nhap");
        }
    }

    @Override
    public void destroy() {}

    private boolean isPublicResource(String uri, String ctx) {
        // Trang đăng nhập / đăng ký
        if (uri.startsWith(ctx + "/login/")) return true;
        // Trực tiếp JSP login (đường dẫn cũ từ index.jsp)
        if (uri.contains("/demo/login/")) return true;
        // Tài nguyên tĩnh
        if (uri.endsWith(".css") || uri.endsWith(".js")
                || uri.endsWith(".png") || uri.endsWith(".jpg")
                || uri.endsWith(".jpeg") || uri.endsWith(".gif")
                || uri.endsWith(".ico") || uri.endsWith(".svg")
                || uri.endsWith(".woff") || uri.endsWith(".woff2")
                || uri.endsWith(".ttf") || uri.endsWith(".map")) return true;
        // Favicon
        if (uri.equals(ctx + "/favicon.ico")) return true;
        return false;
    }
}
