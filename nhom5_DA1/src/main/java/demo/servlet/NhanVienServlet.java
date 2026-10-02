package demo.servlet;

import demo.Service.nhanvien.NhanVienService;
import demo.entity.nhan_vien.NhanVien;
import demo.util.AsyncEmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.regex.Pattern;

@WebServlet({
        "/nhan-vien/hien-thi",
        "/nhan-vien/view-add",
        "/nhan-vien/add",
        "/nhan-vien/view-update",
        "/nhan-vien/update",
        "/nhan-vien/delete",
        "/nhan-vien/doi-trang-thai"
})
public class NhanVienServlet extends HttpServlet {

    NhanVienService service = new NhanVienService();

    // Regex SĐT: bắt đầu 0, tổng 10-11 số
    private static final Pattern SDT_PATTERN = Pattern.compile("^0\\d{9,10}$");
    // Regex tên: chỉ chữ cái tiếng Việt, Latin và khoảng trắng đơn giữa từ
    private static final Pattern TEN_PATTERN = Pattern.compile(
            "^[\\p{L} ]+$", Pattern.UNICODE_CHARACTER_CLASS);

    // ----------------------------------------------------------------
    //  Utility: chuẩn hóa họ tên (trim, bỏ khoảng trắng thừa, viết hoa đầu mỗi từ)
    // ----------------------------------------------------------------
    private static String chuanHoaTen(String raw) {
        if (raw == null) return "";
        // Loại bỏ khoảng trắng đầu cuối và thu gọn khoảng trắng giữa về 1
        String trimmed = raw.trim().replaceAll("\\s+", " ");
        if (trimmed.isEmpty()) return "";
        // Viết hoa chữ cái đầu mỗi từ
        String[] words = trimmed.split(" ");
        StringBuilder sb = new StringBuilder();
        for (String w : words) {
            if (!w.isEmpty()) {
                sb.append(Character.toUpperCase(w.charAt(0)))
                  .append(w.substring(1).toLowerCase());
                sb.append(" ");
            }
        }
        return sb.toString().trim();
    }

    // ----------------------------------------------------------------
    //  Gửi lỗi về form (forward lại trang add/update kèm thông báo)
    // ----------------------------------------------------------------
    private void sendError(HttpServletRequest req, HttpServletResponse resp,
                           String errorMsg, String jspPath)
            throws ServletException, IOException {
        req.setAttribute("errorMsg", errorMsg);
        req.getRequestDispatcher(jspPath).forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền: nhân viên không được truy cập quản lý nhân viên
        Object nvObjCheck = request.getSession(false) != null
                ? request.getSession().getAttribute("nhanVien") : null;
        demo.entity.nhan_vien.NhanVien nvSession =
                (nvObjCheck instanceof demo.entity.nhan_vien.NhanVien)
                        ? (demo.entity.nhan_vien.NhanVien) nvObjCheck : null;
        if (nvSession != null && LoginServlet.isNhanVienRole(nvSession.getChucVu())) {
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi");
            return;
        }

        String uri = request.getRequestURI();

        if (uri.contains("hien-thi")) {
            String tuKhoa    = request.getParameter("tuKhoa");
            String chucVu    = request.getParameter("chucVu");
            String trangThai = request.getParameter("trangThai");

            boolean coLoc = (tuKhoa   != null && !tuKhoa.trim().isEmpty())
                         || (chucVu   != null && !chucVu.trim().isEmpty())
                         || (trangThai != null && !trangThai.trim().isEmpty());

            java.util.List<NhanVien> danhSachFull;
            if (coLoc) {
                danhSachFull = service.filter(tuKhoa, chucVu, trangThai);
            } else {
                danhSachFull = service.getAll();
            }

            // Phân trang
            int pageSize = 10; // Số nhân viên mỗi trang
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int totalRecords = danhSachFull.size();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            if (totalPages < 1) totalPages = 1;
            if (currentPage > totalPages) currentPage = totalPages;

            int startIndex = (currentPage - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalRecords);

            java.util.List<NhanVien> danhSachTrang = danhSachFull.subList(startIndex, endIndex);

            request.setAttribute("listNV", danhSachTrang);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);

            // Giữ lại giá trị bộ lọc để JSP hiển thị lại
            request.setAttribute("filterTuKhoa",   tuKhoa   != null ? tuKhoa   : "");
            request.setAttribute("filterChucVu",   chucVu   != null ? chucVu   : "");
            request.setAttribute("filterTrangThai", trangThai != null ? trangThai : "");

            request.getRequestDispatcher("/demo/nhan_vien/nhan_vien.jsp").forward(request, response);

        } else if (uri.contains("view-add")) {
            request.getRequestDispatcher("/demo/nhan_vien/nhan_vien_add.jsp")
                    .forward(request, response);

        } else if (uri.contains("view-update")) {
            Integer id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("nv", service.getOne(id));
            request.getRequestDispatcher("/demo/nhan_vien/nhan_vien_update.jsp")
                    .forward(request, response);

        } else if (uri.contains("delete")) {
            Integer id = Integer.parseInt(request.getParameter("id"));
            service.delete(id);
            response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");

        } else if (uri.contains("doi-trang-thai")) {
            Integer id = Integer.parseInt(request.getParameter("id"));
            String trangThaiParam = request.getParameter("trangThai");
            Integer trangThai;
            if ("true".equalsIgnoreCase(trangThaiParam) || "1".equals(trangThaiParam)) {
                trangThai = 1;
            } else if ("false".equalsIgnoreCase(trangThaiParam) || "0".equals(trangThaiParam)) {
                trangThai = 0;
            } else {
                trangThai = 0;
            }
            service.doiTrangThai(id, trangThai);

            String xhrHeader = request.getHeader("X-Requested-With");
            String acceptHeader = request.getHeader("Accept");
            if ("XMLHttpRequest".equals(xhrHeader)
                    || (acceptHeader != null && acceptHeader.contains("application/json"))) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":true}");
            } else {
                response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        // =====================================================================
        //  1. LẤY VÀ CHUẨN HÓA CÁC TRƯỜNG THÔNG TIN CƠ BẢN
        // =====================================================================
        String hoTenRaw  = request.getParameter("hoTen");
        String hoTen     = chuanHoaTen(hoTenRaw);
        String sdt       = request.getParameter("sdt")   != null ? request.getParameter("sdt").trim()   : "";
        String email     = request.getParameter("email") != null ? request.getParameter("email").trim() : "";
        String chucVu    = request.getParameter("chucVu");
        String ngaySinhStr = request.getParameter("ngaySinh");
        Boolean gioiTinh = Boolean.parseBoolean(request.getParameter("gioiTinh"));

        // =====================================================================
        //  2. VALIDATE CHUNG (dùng cho cả ADD và UPDATE)
        // =====================================================================

        // ---- Lấy id (chỉ có khi update, null khi add) ----
        Integer updateId = null;
        if (uri.contains("update")) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                updateId = Integer.parseInt(idParam);
            }
        }

        // ---- Họ tên ----
        if (hoTen.isEmpty()) {
            forwardWithError(request, response, uri, "Họ và tên không được để trống.");
            return;
        }
        if (!TEN_PATTERN.matcher(hoTen).matches()) {
            forwardWithError(request, response, uri,
                    "Họ và tên không được chứa số hoặc ký tự đặc biệt.");
            return;
        }

        // ---- SĐT ----
        if (sdt.isEmpty()) {
            forwardWithError(request, response, uri, "Số điện thoại không được để trống.");
            return;
        }
        if (!SDT_PATTERN.matcher(sdt).matches()) {
            forwardWithError(request, response, uri,
                    "Số điện thoại phải bắt đầu bằng số 0 và có 10–11 chữ số.");
            return;
        }
        if (service.existsBySdt(sdt, updateId)) {
            forwardWithError(request, response, uri,
                    "Số điện thoại \"" + sdt + "\" đã được sử dụng bởi nhân viên khác.");
            return;
        }

        // ---- Email ----
        if (email.isEmpty()) {
            forwardWithError(request, response, uri, "Email không được để trống.");
            return;
        }
        if (service.existsByEmail(email, updateId)) {
            forwardWithError(request, response, uri,
                    "Email \"" + email + "\" đã được sử dụng bởi nhân viên khác.");
            return;
        }

        // ---- Ngày sinh (bắt buộc + không ở tương lai + tuổi >= 18) ----
        if (ngaySinhStr == null || ngaySinhStr.trim().isEmpty()) {
            forwardWithError(request, response, uri, "Ngày sinh không được để trống.");
            return;
        }
        LocalDate ngaySinhLocal;
        try {
            ngaySinhLocal = LocalDate.parse(ngaySinhStr.trim());
        } catch (Exception e) {
            forwardWithError(request, response, uri, "Ngày sinh không hợp lệ.");
            return;
        }
        LocalDate today = LocalDate.now();
        if (ngaySinhLocal.isAfter(today)) {
            forwardWithError(request, response, uri, "Ngày sinh không được lớn hơn ngày hiện tại.");
            return;
        }
        if (ngaySinhLocal.plusYears(18).isAfter(today)) {
            forwardWithError(request, response, uri, "Nhân viên phải đủ 18 tuổi trở lên.");
            return;
        }
        Date ngaySinh = Date.valueOf(ngaySinhLocal);

        // =====================================================================
        //  3. GHÉP CHUỖI ĐỊA CHỈ
        // =====================================================================
        String tinhThanh     = request.getParameter("tinhThanh");
        String quanHuyen     = request.getParameter("quanHuyen");
        String phuongXa      = request.getParameter("phuongXa");
        String diaChiChiTiet = request.getParameter("diaChiChiTiet");

        // ---- Địa chỉ bắt buộc (nhân viên) ----
        if (uri.contains("add")) {
            boolean diaChiThieu = (tinhThanh == null || tinhThanh.trim().isEmpty())
                    || (quanHuyen == null || quanHuyen.trim().isEmpty())
                    || (phuongXa == null || phuongXa.trim().isEmpty())
                    || (diaChiChiTiet == null || diaChiChiTiet.trim().isEmpty());
            if (diaChiThieu) {
                forwardWithError(request, response, uri,
                        "Vui lòng điền đầy đủ địa chỉ (Tỉnh/Thành, Quận/Huyện, Phường/Xã và số nhà).");
                return;
            }
        }

        String diaChiFull = "";
        if (diaChiChiTiet != null && !diaChiChiTiet.trim().isEmpty()) {
            diaChiFull = diaChiChiTiet.trim();
            if (phuongXa  != null && !phuongXa.trim().isEmpty())  diaChiFull += ", " + phuongXa.trim();
            if (quanHuyen != null && !quanHuyen.trim().isEmpty())  diaChiFull += ", " + quanHuyen.trim();
            if (tinhThanh != null && !tinhThanh.trim().isEmpty())  diaChiFull += ", " + tinhThanh.trim();
        } else {
            diaChiFull = request.getParameter("diaChi");
        }

        // =====================================================================
        //  4. THÊM MỚI
        // =====================================================================
        if (uri.contains("add")) {
            NhanVien nv = new NhanVien();

            // Lấy mã NV trước — dùng làm căn cứ tạo password ngay tại đây
            // (tránh phải INSERT "tmp" rồi UPDATE lại lần 2)
            String maNhanVien = service.layMaNhanVienMoi();

            // Tạo password dựa trên mã NV và chức vụ — thực hiện trước INSERT
            String matKhau;
            if ("Quản Lý".equalsIgnoreCase(chucVu != null ? chucVu.trim() : "")) {
                // VD: maNhanVien = "NV005" → prefix "admin_" + phần số "005" → "admin_005"
                matKhau = "admin_" + maNhanVien.replaceAll("[^0-9]", "");
            } else {
                // VD: "NV005" → "nv_005"
                matKhau = "nv_" + maNhanVien.replaceAll("[^0-9]", "");
            }

            nv.setMaNhanVien(maNhanVien);
            nv.setHoTen(hoTen);
            nv.setGioiTinh(gioiTinh);
            nv.setNgaySinh(ngaySinh);
            nv.setSdt(sdt);
            nv.setEmail(email);
            nv.setDiaChi(diaChiFull);
            nv.setChucVu(chucVu);
            nv.setTrangThai(1);       // luôn active khi thêm mới
            nv.setTaiKhoan(email);    // tài khoản = email
            nv.setMatKhau(matKhau);   // password đã tính sẵn — 1 lần INSERT duy nhất

            service.add(nv);

            // Gửi email thông tin tài khoản — bất đồng bộ, không chặn response
            // Các trường hợp lỗi (email sai, SMTP timeout, v.v.) được xử lý bên trong AsyncEmailService
            AsyncEmailService.guiEmailTaiKhoan(nv.getEmail(), nv.getTaiKhoan(), nv.getMatKhau());

        // =====================================================================
        //  5. CẬP NHẬT
        // =====================================================================
        } else if (uri.contains("update")) {
            NhanVien nv = service.getOne(updateId);
            if (nv != null) {
                nv.setHoTen(hoTen);
                nv.setGioiTinh(gioiTinh);
                nv.setNgaySinh(ngaySinh);
                nv.setSdt(sdt);
                nv.setEmail(email);
                nv.setDiaChi(diaChiFull);
                nv.setChucVu(chucVu);
                service.update(nv);
            }
        }

        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
    }

    // ----------------------------------------------------------------
    //  Helper: forward lại đúng trang (add hoặc update) kèm lỗi
    // ----------------------------------------------------------------
    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp,
                                  String uri, String msg)
            throws ServletException, IOException {
        req.setAttribute("errorMsg", msg);
        // Giữ lại giá trị form để người dùng không phải nhập lại
        if (uri.contains("update")) {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                NhanVien nv = service.getOne(Integer.parseInt(idParam));
                req.setAttribute("nv", nv);
            }
            req.getRequestDispatcher("/demo/nhan_vien/nhan_vien_update.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/demo/nhan_vien/nhan_vien_add.jsp").forward(req, resp);
        }
    }
}
