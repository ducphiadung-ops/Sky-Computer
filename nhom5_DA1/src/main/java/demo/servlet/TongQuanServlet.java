package demo.servlet;

import demo.entity.hoa_don.HoaDon;
import demo.repository.hoadon.HoaDonRepository;
import demo.repository.san_pham.SanPhamRepository;
import demo.util.HibernateConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "TongQuanServlet", value = {"/tong_quan"})
public class TongQuanServlet extends HttpServlet {

    private final HoaDonRepository hoaDonRepo = new HoaDonRepository();
    private final SanPhamRepository sanPhamRepo = new SanPhamRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Object nvObj = req.getSession(false) != null ? req.getSession().getAttribute("nhanVien") : null;
        demo.entity.nhan_vien.NhanVien nv = (nvObj instanceof demo.entity.nhan_vien.NhanVien)
                ? (demo.entity.nhan_vien.NhanVien) nvObj : null;
        if (nv != null && LoginServlet.isNhanVienRole(nv.getChucVu())) {
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
            return;
        }
        this.tongquan(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.tongquan(req, resp);
    }

    private void tongquan(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String todayStr = LocalDate.now().toString(); // yyyy-MM-dd

        // Xác định chế độ lọc:
        //   - ngayLoc = "all"        → toàn bộ thời gian
        //   - ngayLoc = "yyyy-MM-dd" → lọc theo ngày cụ thể
        //   - ngayLoc = null/empty   → mặc định ngày hôm nay
        String ngayLocParam = req.getParameter("ngayLoc");
        boolean isAll = "all".equals(ngayLocParam);

        LocalDate ngayLoc = null;
        java.sql.Date ngayLocSql = null;
        String ngayLocHienThi;
        String ngayLocValue;

        if (isAll) {
            ngayLocHienThi = "Toàn bộ";
            ngayLocValue   = "";
        } else {
            if (ngayLocParam != null && !ngayLocParam.trim().isEmpty()) {
                try {
                    ngayLoc = LocalDate.parse(ngayLocParam.trim());
                } catch (Exception e) {
                    ngayLoc = LocalDate.now();
                }
            } else {
                ngayLoc = LocalDate.now();
            }
            ngayLocSql     = java.sql.Date.valueOf(ngayLoc);
            ngayLocHienThi = ngayLoc.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            ngayLocValue   = ngayLoc.toString();
        }

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            // ─────────────────────────────────────────────────────────────────────
            // FIX #4: Gộp 3 aggregate (doanhThu + soHoaDon + soSanPhamBanDuoc)
            // thành 1 native query trả về 1 row — giảm từ 3 round-trip xuống 1
            // ─────────────────────────────────────────────────────────────────────
            BigDecimal tongDoanhThu;
            Long tongHoaDon;
            Long tongSanPhamDaBan;

            if (isAll) {
                Object[] aggRow = (Object[]) session.createNativeQuery(
                        "SELECT " +
                        "  COALESCE(SUM(h.tong_tien), 0)          AS doanh_thu, " +
                        "  COUNT(h.id)                             AS so_hoa_don, " +
                        "  COALESCE((SELECT COUNT(ct.id) FROM chi_tiet_hoa_don ct " +
                        "            INNER JOIN hoa_don hd2 ON ct.id_hoa_don = hd2.id " +
                        "            WHERE hd2.trang_thai = 1 AND hd2.is_deleted = 0), 0) AS so_sp_ban " +
                        "FROM hoa_don h WHERE h.trang_thai = 1 AND h.is_deleted = 0")
                        .uniqueResult();
                tongDoanhThu     = aggRow[0] != null ? new BigDecimal(aggRow[0].toString()) : BigDecimal.ZERO;
                tongHoaDon       = aggRow[1] != null ? ((Number) aggRow[1]).longValue() : 0L;
                tongSanPhamDaBan = aggRow[2] != null ? ((Number) aggRow[2]).longValue() : 0L;
            } else {
                Object[] aggRow = (Object[]) session.createNativeQuery(
                        "SELECT " +
                        "  COALESCE(SUM(h.tong_tien), 0)          AS doanh_thu, " +
                        "  COUNT(h.id)                             AS so_hoa_don, " +
                        "  COALESCE((SELECT COUNT(ct.id) FROM chi_tiet_hoa_don ct " +
                        "            INNER JOIN hoa_don hd2 ON ct.id_hoa_don = hd2.id " +
                        "            WHERE hd2.trang_thai = 1 AND hd2.is_deleted = 0 " +
                        "            AND CAST(hd2.ngay_lap AS DATE) = :ngayLoc), 0) AS so_sp_ban " +
                        "FROM hoa_don h " +
                        "WHERE h.trang_thai = 1 AND h.is_deleted = 0 AND CAST(h.ngay_lap AS DATE) = :ngayLoc")
                        .setParameter("ngayLoc", ngayLocSql)
                        .uniqueResult();
                tongDoanhThu     = aggRow[0] != null ? new BigDecimal(aggRow[0].toString()) : BigDecimal.ZERO;
                tongHoaDon       = aggRow[1] != null ? ((Number) aggRow[1]).longValue() : 0L;
                tongSanPhamDaBan = aggRow[2] != null ? ((Number) aggRow[2]).longValue() : 0L;
            }

            double doanhThuValue = tongDoanhThu.doubleValue();

            // ─────────────────────────────────────────────────────────────────────
            // Khách hàng mua trong kỳ + tổng KH: vẫn 2 query nhưng đơn giản
            // ─────────────────────────────────────────────────────────────────────
            Long khachHangMua;
            if (isAll) {
                khachHangMua = session.createQuery(
                        "SELECT COUNT(DISTINCT h.khachHang.id) FROM HoaDon h " +
                        "WHERE h.trangThai = 1 AND h.khachHang IS NOT NULL",
                        Long.class).uniqueResult();
            } else {
                khachHangMua = session.createQuery(
                        "SELECT COUNT(DISTINCT h.khachHang.id) FROM HoaDon h " +
                        "WHERE h.trangThai = 1 AND h.khachHang IS NOT NULL " +
                        "AND CAST(h.ngayLap AS date) = :ngayLoc",
                        Long.class)
                        .setParameter("ngayLoc", ngayLocSql)
                        .uniqueResult();
            }
            if (khachHangMua == null) khachHangMua = 0L;

            Long tongKhachHang = session.createQuery(
                    "SELECT COUNT(k) FROM KhachHang k", Long.class).uniqueResult();
            if (tongKhachHang == null) tongKhachHang = 0L;

            // Top 5 đơn hàng gần đây + top 5 sản phẩm bán chạy
            // (mỗi cái mở session riêng trong repository — đây là thiết kế hiện tại)
            List<HoaDon> listDonHangGanDay   = hoaDonRepo.getTop5();
            List<Object[]> listSanPhamBanChay = sanPhamRepo.getTop5BanChay();

            // ─────────────────────────────────────────────────────────────────────
            // FIX #3: Biểu đồ doanh thu theo tuần
            // TRƯỚC: 7 query riêng lẻ trong vòng lặp  → 7 round-trips DB
            // SAU  : 1 query GROUP BY duy nhất         → 1 round-trip DB
            // ─────────────────────────────────────────────────────────────────────
            int tuanOffset = 0;
            String tuanOffsetParam = req.getParameter("tuanOffset");
            if (tuanOffsetParam != null && !tuanOffsetParam.trim().isEmpty()) {
                try {
                    tuanOffset = Integer.parseInt(tuanOffsetParam.trim());
                    if (tuanOffset > 0)   tuanOffset = 0;
                    if (tuanOffset < -52) tuanOffset = -52;
                } catch (NumberFormatException ex) {
                    tuanOffset = 0;
                }
            }

            LocalDate today    = LocalDate.now();
            LocalDate dauTuan  = today.with(DayOfWeek.MONDAY).plusWeeks(tuanOffset);
            LocalDate cuoiTuan = dauTuan.plusDays(6);

            // Ngày cuối thực tế để query: không vượt quá hôm nay
            LocalDate cuoiQuery = cuoiTuan.isAfter(today) ? today : cuoiTuan;

            // 1 query GROUP BY thay cho 7 query lẻ
            // Kết quả: Map<ngày → doanhThu(triệu đồng)>
            Map<LocalDate, Double> doanhThuTheoNgay = new HashMap<>();

            @SuppressWarnings("unchecked")
            List<Object[]> chartRows = session.createNativeQuery(
                    "SELECT CAST(h.ngay_lap AS DATE) AS ngay, SUM(h.tong_tien) AS tong " +
                    "FROM hoa_don h " +
                    "WHERE h.trang_thai = 1 AND h.is_deleted = 0 " +
                    "  AND CAST(h.ngay_lap AS DATE) >= :dauTuan " +
                    "  AND CAST(h.ngay_lap AS DATE) <= :cuoiQuery " +
                    "GROUP BY CAST(h.ngay_lap AS DATE)")
                    .setParameter("dauTuan",   java.sql.Date.valueOf(dauTuan))
                    .setParameter("cuoiQuery", java.sql.Date.valueOf(cuoiQuery))
                    .list();

            for (Object[] row : chartRows) {
                // row[0]: java.sql.Date hoặc LocalDate tuỳ driver
                LocalDate ngay;
                if (row[0] instanceof java.sql.Date) {
                    ngay = ((java.sql.Date) row[0]).toLocalDate();
                } else if (row[0] instanceof LocalDate) {
                    ngay = (LocalDate) row[0];
                } else {
                    ngay = LocalDate.parse(row[0].toString());
                }
                double val = row[1] != null ? new BigDecimal(row[1].toString()).doubleValue() / 1_000_000.0 : 0.0;
                doanhThuTheoNgay.put(ngay, val);
            }

            // Build JSON từ map — O(7), không thêm round-trip nào
            String[] tenNgay = {"T2", "T3", "T4", "T5", "T6", "T7", "CN"};
            DateTimeFormatter fmtLabel = DateTimeFormatter.ofPattern("dd/MM");

            StringBuilder jsonLabels = new StringBuilder("[");
            StringBuilder jsonData   = new StringBuilder("[");

            for (int i = 0; i < 7; i++) {
                LocalDate ngay  = dauTuan.plusDays(i);
                String    label = tenNgay[i] + " " + ngay.format(fmtLabel);

                if (i > 0) { jsonLabels.append(","); jsonData.append(","); }
                jsonLabels.append("\"").append(label).append("\"");

                if (ngay.isAfter(today)) {
                    // Ngày tương lai → null (ngắt đường trên biểu đồ)
                    jsonData.append("null");
                } else {
                    double val = doanhThuTheoNgay.getOrDefault(ngay, 0.0);
                    jsonData.append(String.format("%.3f", val).replace(",", "."));
                }
            }
            jsonLabels.append("]");
            jsonData.append("]");

            // Định dạng tiền tệ chuẩn VN
            String doanhThuFormatted = String.format("%,.0f", doanhThuValue).replace(",", ".");

            req.setAttribute("chartLabels",       jsonLabels.toString());
            req.setAttribute("chartData",         jsonData.toString());
            req.setAttribute("dauTuan",           dauTuan.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            req.setAttribute("cuoiTuan",          cuoiTuan.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            req.setAttribute("tuanOffset",        tuanOffset);
            req.setAttribute("tongDoanhThu",      doanhThuFormatted);
            req.setAttribute("tongHoaDon",        tongHoaDon);
            req.setAttribute("tongSanPham",       tongSanPhamDaBan);
            req.setAttribute("khachHangMua",      khachHangMua);
            req.setAttribute("tongKhachHang",     tongKhachHang);
            req.setAttribute("ListDonHangGanDay", listDonHangGanDay);
            req.setAttribute("ListSanPhamBanChay",listSanPhamBanChay);
            req.setAttribute("ngayLocHienThi",    ngayLocHienThi);
            req.setAttribute("ngayLocValue",      ngayLocValue);
            req.setAttribute("ngayTodayValue",    todayStr);
            req.setAttribute("isAll",             isAll);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("tongDoanhThu",  "0");
            req.setAttribute("tongHoaDon",    0L);
            req.setAttribute("tongSanPham",   0L);
            req.setAttribute("khachHangMua",  0L);
            req.setAttribute("tongKhachHang", 0L);
            req.setAttribute("ngayLocHienThi","Toàn bộ");
            req.setAttribute("ngayLocValue",  "");
            req.setAttribute("ngayTodayValue",todayStr);
            req.setAttribute("isAll",         false);
            req.setAttribute("chartLabels",   "[\"T2\",\"T3\",\"T4\",\"T5\",\"T6\",\"T7\",\"CN\"]");
            req.setAttribute("chartData",     "[null,null,null,null,null,null,null]");
            req.setAttribute("dauTuan",       "");
            req.setAttribute("cuoiTuan",      "");
            req.setAttribute("tuanOffset",    0);
        }

        req.getRequestDispatcher("/demo/tong_quan.jsp").forward(req, resp);
    }
}
