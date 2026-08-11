package demo.servlet;

import demo.Service.nhanvien.NhanVienService;
import demo.entity.nhan_vien.NhanVien;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.Normalizer;

@WebServlet(name = "LoginServlet", value = {
        "/login/dang_nhap",
        "/login/dang_ky"
})
public class LoginServlet extends HttpServlet {

    private final NhanVienService nhanVienService = new NhanVienService();

    /**
     * Xóa dấu tiếng Việt và chuyển về chữ thường để so sánh không phân biệt dấu.
     * "Nhân Viên" -> "nhan vien"
     * "NHÂN VIÊN" -> "nhan vien"
     */
    public static String removeDiacritics(String str) {
        if (str == null) return "";
        String normalized = Normalizer.normalize(str, Normalizer.Form.NFD);
        return normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "")
                .replace("đ", "d").replace("Đ", "d")
                .toLowerCase().trim();
    }

    /**
     * Kiểm tra chức vụ có phải nhân viên không (bất kể cách viết dấu/hoa/thường).
     * Nhân Viên / nhan vien / NHÂN VIÊN / Nhân viên / Bán Hàng → true
     * Admin / Quản Lý / Giám Đốc → false
     */
    public static boolean isNhanVienRole(String chucVu) {
        if (chucVu == null || chucVu.trim().isEmpty()) return false;
        String normalized = removeDiacritics(chucVu);
        // Các từ khóa đặc trưng của nhân viên (không dấu)
        return normalized.contains("nhan vien")
                || normalized.contains("nhanvien")
                || normalized.contains("ban hang")
                || normalized.contains("banhang")
                || normalized.contains("thu ngan")
                || normalized.contains("thu kho")
                || normalized.contains("ky thuat");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/login/dang_nhap")) {
            // Nếu đã đăng nhập thì chuyển về trang chính
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("nhanVien") != null) {
                NhanVien nv = (NhanVien) session.getAttribute("nhanVien");
                if (isNhanVienRole(nv.getChucVu())) {
                    resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/tong_quan");
                }
                return;
            }
            req.getRequestDispatcher("/demo/login/dang_nhap.jsp").forward(req, resp);
        } else if (uri.contains("/login/dang_ky")) {
            req.getRequestDispatcher("/demo/login/dang_ky.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.contains("/login/dang_nhap")) {
            String taiKhoan = req.getParameter("username");
            String matKhau  = req.getParameter("password");

            if (taiKhoan == null || taiKhoan.trim().isEmpty()
                    || matKhau == null || matKhau.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tài khoản và mật khẩu.");
                req.getRequestDispatcher("/demo/login/dang_nhap.jsp").forward(req, resp);
                return;
            }

            NhanVien nv = nhanVienService.findByTaiKhoanAndMatKhau(taiKhoan.trim(), matKhau.trim());

            if (nv == null) {
                req.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không đúng. Vui lòng thử lại.");
                req.setAttribute("oldUsername", taiKhoan);
                req.getRequestDispatcher("/demo/login/dang_nhap.jsp").forward(req, resp);
                return;
            }

            // Lưu thông tin vào session
            HttpSession session = req.getSession(true);
            session.setAttribute("nhanVien", nv);

            // Kiểm tra chức vụ (không phân biệt dấu/hoa/thường)
            if (isNhanVienRole(nv.getChucVu())) {
                resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
            } else {
                resp.sendRedirect(req.getContextPath() + "/tong_quan");
            }

        } else if (uri.contains("/login/dang_ky")) {
            req.getRequestDispatcher("/demo/login/dang_ky.jsp").forward(req, resp);
        }
    }
}
