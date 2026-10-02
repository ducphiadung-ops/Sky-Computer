package demo.servlet;

import demo.Service.khachhang.KhachHangService;
import demo.entity.khach_hang.DiaChiApiMapping;
import demo.entity.khach_hang.DiaChiKhachHang;
import demo.entity.khach_hang.KhachHang;
import demo.repository.khachhang.DiaChiApiMappingRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet(name = "KhachHangServlet", value = {
        "/khach-hang/hien-thi",
        "/khach-hang/doi-trang-thai",
        "/khach-hang/view-add",
        "/khach-hang/add",
        "/khach-hang/sua",
        "/khach-hang/cap-nhat",
        "/khach-hang/xoa"
})
public class KhachHangServlet extends HttpServlet {

    KhachHangService service = new KhachHangService();

    // Regex SĐT: bắt đầu 0, tổng 10-11 số
    private static final Pattern SDT_PATTERN = Pattern.compile("^0\\d{9,10}$");
    // Regex tên: chỉ chữ cái (kể cả Unicode tiếng Việt) và khoảng trắng
    private static final Pattern TEN_PATTERN = Pattern.compile(
            "^[\\p{L} ]+$", Pattern.UNICODE_CHARACTER_CLASS);

    // ----------------------------------------------------------------
    //  Utility: chuẩn hóa họ tên (trim, thu gọn khoảng trắng, viết hoa đầu từ)
    // ----------------------------------------------------------------
    private static String chuanHoaTen(String raw) {
        if (raw == null) return "";
        String trimmed = raw.trim().replaceAll("\\s+", " ");
        if (trimmed.isEmpty()) return "";
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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.contains("hien-thi")) {
            String tuKhoa   = req.getParameter("tuKhoa");
            String gioiTinh = req.getParameter("gioiTinh");
            String trangThai = req.getParameter("trangThai");

            boolean coLoc = (tuKhoa   != null && !tuKhoa.trim().isEmpty())
                         || (gioiTinh  != null && !gioiTinh.trim().isEmpty())
                         || (trangThai != null && !trangThai.trim().isEmpty());

            List<KhachHang> danhSachFull;
            if (coLoc) {
                danhSachFull = service.filter(tuKhoa, gioiTinh, trangThai);
            } else {
                danhSachFull = service.getAll();
            }

            // Phân trang
            int pageSize = 10; // Số khách hàng mỗi trang
            int currentPage = 1;
            String pageParam = req.getParameter("page");
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

            List<KhachHang> danhSachTrang = danhSachFull.subList(startIndex, endIndex);

            req.setAttribute("listKH", danhSachTrang);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalRecords", totalRecords);

            // Giữ lại giá trị bộ lọc để JSP hiển thị lại
            req.setAttribute("filterTuKhoa",   tuKhoa   != null ? tuKhoa   : "");
            req.setAttribute("filterGioiTinh", gioiTinh != null ? gioiTinh : "");
            req.setAttribute("filterTrangThai", trangThai != null ? trangThai : "");

            req.getRequestDispatcher("/demo/khach_hang/khach_hang.jsp").forward(req, resp);
        }

        if (uri.contains("view-add")) {
            req.getRequestDispatcher("/demo/khach_hang/khach_hang_add.jsp").forward(req, resp);
        }

        if (uri.contains("/sua")) {
            Integer id = Integer.valueOf(req.getParameter("id"));
            KhachHang kh = service.timTheoId(id);
            req.setAttribute("kh", kh);
            req.getRequestDispatcher("/demo/khach_hang/khach_hang_update.jsp").forward(req, resp);
            return;
        }

        if (uri.contains("xoa")) {
            Integer id = Integer.valueOf(req.getParameter("id"));
            service.xoa(id);
            resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");
            return;
        } else if (uri.contains("doi-trang-thai")) {
            Integer id = Integer.valueOf(req.getParameter("id"));
            String trangThaiParam = req.getParameter("trangThai");
            Integer trangThai;
            if ("true".equalsIgnoreCase(trangThaiParam) || "1".equals(trangThaiParam)) {
                trangThai = 1;
            } else if ("false".equalsIgnoreCase(trangThaiParam) || "0".equals(trangThaiParam)) {
                trangThai = 0;
            } else {
                trangThai = 0;
            }
            service.doiTrangThai(id, trangThai);

            String xhrHeader  = req.getHeader("X-Requested-With");
            String acceptHdr  = req.getHeader("Accept");
            if ("XMLHttpRequest".equals(xhrHeader)
                    || (acceptHdr != null && acceptHdr.contains("application/json"))) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":true}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");
            }
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        // =====================================================================
        //  1. THÊM MỚI KHÁCH HÀNG
        // =====================================================================
        if (uri.contains("add")) {

            // --- Lấy và chuẩn hóa các trường ---
            String ten   = chuanHoaTen(req.getParameter("tenKhachHang"));
            String sdt   = req.getParameter("sdt")   != null ? req.getParameter("sdt").trim()   : "";
            String email = req.getParameter("email") != null ? req.getParameter("email").trim() : "";
            Boolean gioiTinh = Boolean.valueOf(req.getParameter("gioiTinh"));

            // --- Validate tên ---
            if (ten.isEmpty()) {
                forwardAddError(req, resp, "Họ và tên không được để trống.");
                return;
            }
            if (!TEN_PATTERN.matcher(ten).matches()) {
                forwardAddError(req, resp,
                        "Họ và tên không được chứa số hoặc ký tự đặc biệt.");
                return;
            }

            // --- Validate SĐT ---
            if (sdt.isEmpty()) {
                forwardAddError(req, resp, "Số điện thoại không được để trống.");
                return;
            }
            if (!SDT_PATTERN.matcher(sdt).matches()) {
                forwardAddError(req, resp,
                        "Số điện thoại phải bắt đầu bằng số 0 và có 10–11 chữ số.");
                return;
            }
            if (service.existsBySdt(sdt, null)) {
                forwardAddError(req, resp,
                        "Số điện thoại \"" + sdt + "\" đã được sử dụng bởi khách hàng khác.");
                return;
            }

            // --- Validate email (tùy chọn nhưng nếu nhập thì phải hợp lệ và không trùng) ---
            if (!email.isEmpty() && service.existsByEmail(email, null)) {
                forwardAddError(req, resp,
                        "Email \"" + email + "\" đã được sử dụng bởi khách hàng khác.");
                return;
            }

            // --- Validate ngày sinh: không được lớn hơn ngày hiện tại ---
            String ngaySinhStr = req.getParameter("ngaySinh");
            LocalDate ngaySinh = null;
            if (ngaySinhStr != null && !ngaySinhStr.trim().isEmpty()) {
                try {
                    ngaySinh = LocalDate.parse(ngaySinhStr.trim());
                } catch (Exception e) {
                    forwardAddError(req, resp, "Ngày sinh không hợp lệ.");
                    return;
                }
                if (ngaySinh.isAfter(LocalDate.now())) {
                    forwardAddError(req, resp,
                            "Ngày sinh không được lớn hơn ngày hiện tại.");
                    return;
                }
            }

            // --- Lấy mảng địa chỉ (khách hàng: địa chỉ không bắt buộc) ---
            String[] tinhThanh   = req.getParameterValues("tinhThanh");
            String[] quanHuyen   = req.getParameterValues("quanHuyen");
            String[] phuongXa    = req.getParameterValues("phuongXa");
            String[] diaChiCuThe = req.getParameterValues("diaChiCuThe");
            String[] loaiDiaChi  = req.getParameterValues("loaiDiaChi");
            String[] provinceCode = req.getParameterValues("provinceCode");
            String[] districtCode = req.getParameterValues("districtCode");
            String[] wardCode     = req.getParameterValues("wardCode");

            // --- Tạo đối tượng khách hàng ---
            KhachHang kh = new KhachHang();
            kh.setMaKhachHang(service.layMaKhachHangMoi());
            kh.setTenKhachHang(ten);
            kh.setGioiTinh(gioiTinh);
            kh.setNgaySinh(ngaySinh);
            kh.setSdt(sdt);
            kh.setEmail(email.isEmpty() ? null : email);
            kh.setTrangThai(1); // luôn active khi thêm mới

            // --- Tạo danh sách địa chỉ ---
            List<DiaChiKhachHang> listDiaChi = new ArrayList<>();
            if (tinhThanh != null) {
                for (int i = 0; i < tinhThanh.length; i++) {
                    // Bỏ qua card địa chỉ rỗng hoàn toàn
                    if (diaChiCuThe == null || i >= diaChiCuThe.length
                            || diaChiCuThe[i] == null || diaChiCuThe[i].trim().isEmpty()) {
                        continue;
                    }

                    DiaChiKhachHang dc = new DiaChiKhachHang();
                    dc.setTinhThanh(tinhThanh[i]);
                    dc.setQuanHuyen(quanHuyen != null && i < quanHuyen.length ? quanHuyen[i] : "");
                    dc.setPhuongXa(phuongXa   != null && i < phuongXa.length  ? phuongXa[i]  : "");
                    dc.setDiaChiCuThe(diaChiCuThe[i]);
                    dc.setLoaiDiaChi((loaiDiaChi != null && i < loaiDiaChi.length
                            && loaiDiaChi[i] != null && !loaiDiaChi[i].trim().isEmpty())
                            ? loaiDiaChi[i] : "Nhà riêng");
                    dc.setTrangThai(i == 0 ? 1 : 0);
                    dc.setKhachHang(kh);

                    // Mapping API code
                    int pCode = 0, dCode = 0, wCode = 0;
                    try { if (provinceCode != null && i < provinceCode.length) pCode = Integer.parseInt(provinceCode[i]); } catch (Exception ignored) {}
                    try { if (districtCode != null && i < districtCode.length) dCode = Integer.parseInt(districtCode[i]); } catch (Exception ignored) {}
                    try { if (wardCode     != null && i < wardCode.length)     wCode = Integer.parseInt(wardCode[i]);     } catch (Exception ignored) {}

                    DiaChiApiMapping mapping = new DiaChiApiMapping();
                    mapping.setProvinceCode(pCode);
                    mapping.setDistrictCode(dCode);
                    mapping.setWardCode(wCode);
                    mapping.setDiaChiKhachHang(dc);
                    dc.setDiaChiApiMapping(mapping);

                    listDiaChi.add(dc);
                }
            }
            kh.setDiaChiKhachHang(listDiaChi);

            service.add(kh);
            resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");
            return;
        }

        // =====================================================================
        //  2. CẬP NHẬT KHÁCH HÀNG
        // =====================================================================
        if (uri.contains("cap-nhat")) {

            try {
                String idParam = req.getParameter("id");
                System.out.println("[KhachHangServlet] Bắt đầu cập nhật khách hàng ID: " + idParam);
                
                Integer id = Integer.valueOf(idParam);
                KhachHang kh = service.timTheoId(id);

                if (kh == null) {
                    System.out.println("[KhachHangServlet] Không tìm thấy khách hàng với ID: " + id);
                    resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");
                    return;
                }

                String ten   = chuanHoaTen(req.getParameter("tenKhachHang"));
                String sdt   = req.getParameter("sdt")   != null ? req.getParameter("sdt").trim()   : "";
                String email = req.getParameter("email") != null ? req.getParameter("email").trim() : "";

                System.out.println("[KhachHangServlet] Thông tin nhận được - Tên: " + ten + ", SĐT: " + sdt);

                // Validate tên
                if (ten.isEmpty()) {
                    req.setAttribute("errorMsg", "Họ và tên không được để trống.");
                    req.setAttribute("kh", kh);
                    req.getRequestDispatcher("/demo/khach_hang/khach_hang_update.jsp").forward(req, resp);
                    return;
                }
                if (!TEN_PATTERN.matcher(ten).matches()) {
                    req.setAttribute("errorMsg", "Họ và tên không được chứa số hoặc ký tự đặc biệt.");
                    req.setAttribute("kh", kh);
                    req.getRequestDispatcher("/demo/khach_hang/khach_hang_update.jsp").forward(req, resp);
                    return;
                }

                // Validate SĐT
                if (sdt.isEmpty() || !SDT_PATTERN.matcher(sdt).matches()) {
                    req.setAttribute("errorMsg", "Số điện thoại phải bắt đầu bằng số 0 và có 10–11 chữ số.");
                    req.setAttribute("kh", kh);
                    req.getRequestDispatcher("/demo/khach_hang/khach_hang_update.jsp").forward(req, resp);
                    return;
                }
                if (service.existsBySdt(sdt, id)) {
                    req.setAttribute("errorMsg", "Số điện thoại \"" + sdt + "\" đã được sử dụng bởi khách hàng khác.");
                    req.setAttribute("kh", kh);
                    req.getRequestDispatcher("/demo/khach_hang/khach_hang_update.jsp").forward(req, resp);
                    return;
                }
                if (!email.isEmpty() && service.existsByEmail(email, id)) {
                    req.setAttribute("errorMsg", "Email \"" + email + "\" đã được sử dụng bởi khách hàng khác.");
                    req.setAttribute("kh", kh);
                    req.getRequestDispatcher("/demo/khach_hang/khach_hang_update.jsp").forward(req, resp);
                    return;
                }

                kh.setMaKhachHang(req.getParameter("maKhachHang"));
                kh.setTenKhachHang(ten);
                kh.setGioiTinh(Boolean.valueOf(req.getParameter("gioiTinh")));
                kh.setSdt(sdt);
                kh.setEmail(email.isEmpty() ? null : email);
                String trangThaiParam = req.getParameter("trangThai");
                kh.setTrangThai(("1".equals(trangThaiParam) || "true".equalsIgnoreCase(trangThaiParam)) ? 1 : 0);

                // Ngày sinh
                String ngaySinhStr = req.getParameter("ngaySinh");
                if (ngaySinhStr != null && !ngaySinhStr.trim().isEmpty()) {
                    try {
                        LocalDate ns = LocalDate.parse(ngaySinhStr.trim());
                        if (ns.isAfter(LocalDate.now())) {
                            req.setAttribute("errorMsg", "Ngày sinh không được lớn hơn ngày hiện tại.");
                            req.setAttribute("kh", kh);
                            req.getRequestDispatcher("/demo/khach_hang/khach_hang_update.jsp").forward(req, resp);
                            return;
                        }
                        kh.setNgaySinh(ns);
                    } catch (Exception e) {
                        kh.setNgaySinh(null);
                    }
                } else {
                    kh.setNgaySinh(null);
                }

                // Địa chỉ
                String[] dsTinhThanh  = req.getParameterValues("tinhThanh");
                String[] dsQuanHuyen  = req.getParameterValues("quanHuyen");
                String[] dsPhuongXa   = req.getParameterValues("phuongXa");
                String[] dsDiaChiCuThe = req.getParameterValues("diaChiCuThe");
                String[] dsLoaiDiaChi = req.getParameterValues("loaiDiaChi");
                String[] provinceCode = req.getParameterValues("provinceCode");
                String[] districtCode = req.getParameterValues("districtCode");
                String[] wardCode     = req.getParameterValues("wardCode");

                List<DiaChiKhachHang> danhSachMoi = new ArrayList<>();
                if (dsDiaChiCuThe != null) {
                    System.out.println("[KhachHangServlet] Số địa chỉ nhận được: " + dsDiaChiCuThe.length);
                    for (int i = 0; i < dsDiaChiCuThe.length; i++) {
                        if (dsDiaChiCuThe[i] == null || dsDiaChiCuThe[i].trim().isEmpty()) continue;

                        DiaChiKhachHang dc = new DiaChiKhachHang();
                        dc.setTinhThanh(dsTinhThanh != null && i < dsTinhThanh.length ? dsTinhThanh[i] : "");
                        dc.setQuanHuyen(dsQuanHuyen != null && i < dsQuanHuyen.length ? dsQuanHuyen[i] : "");
                        dc.setPhuongXa(dsPhuongXa   != null && i < dsPhuongXa.length  ? dsPhuongXa[i]  : "");
                        dc.setDiaChiCuThe(dsDiaChiCuThe[i]);
                        dc.setLoaiDiaChi(dsLoaiDiaChi != null && i < dsLoaiDiaChi.length ? dsLoaiDiaChi[i] : "Nhà riêng");
                        dc.setKhachHang(kh);

                        int pCode = 0, dCode = 0, wCode = 0;
                        try { if (provinceCode != null && i < provinceCode.length) pCode = Integer.parseInt(provinceCode[i]); } catch (Exception ignored) {}
                        try { if (districtCode != null && i < districtCode.length) dCode = Integer.parseInt(districtCode[i]); } catch (Exception ignored) {}
                        try { if (wardCode     != null && i < wardCode.length)     wCode = Integer.parseInt(wardCode[i]);     } catch (Exception ignored) {}

                        DiaChiApiMapping mapping = new DiaChiApiMapping();
                        mapping.setProvinceCode(pCode);
                        mapping.setDistrictCode(dCode);
                        mapping.setWardCode(wCode);
                        mapping.setDiaChiKhachHang(dc);
                        dc.setDiaChiApiMapping(mapping);
                        danhSachMoi.add(dc);
                        
                        System.out.println("[KhachHangServlet] Địa chỉ " + (i+1) + ": " + dc.getDiaChiCuThe());
                    }
                } else {
                    System.out.println("[KhachHangServlet] Không có địa chỉ nào được gửi lên");
                }

                if (kh.getDiaChiKhachHangList() != null) {
                    kh.getDiaChiKhachHangList().clear();
                    kh.getDiaChiKhachHangList().addAll(danhSachMoi);
                } else {
                    kh.setDiaChiKhachHang(danhSachMoi);
                }

                System.out.println("[KhachHangServlet] Gọi service.capNhat()...");
                service.capNhat(kh);
                System.out.println("[KhachHangServlet] ✅ Hoàn tất cập nhật, redirect về danh sách");
                resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");
            } catch (Exception e) {
                System.out.println("[KhachHangServlet] ❌ LỖI trong quá trình cập nhật: " + e.getMessage());
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");
            }
        }
    }

    // ----------------------------------------------------------------
    //  Helper: forward lại trang add kèm lỗi
    // ----------------------------------------------------------------
    private void forwardAddError(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("errorMsg", msg);
        req.getRequestDispatcher("/demo/khach_hang/khach_hang_add.jsp").forward(req, resp);
    }
}
