package demo.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.zxing.*;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.HybridBinarizer;
import demo.entity.hoa_don.*;
import demo.entity.khach_hang.DiaChiKhachHang;
import demo.entity.khach_hang.KhachHang;
import demo.entity.nhan_vien.NhanVien;
import demo.entity.san_pham.CauHinhSanPham;
import demo.entity.san_pham.ChiTietSanPham;
import demo.entity.san_pham.MaSeri;
import demo.repository.hoadon.*;
import demo.repository.khachhang.KhachHangRepo;
import demo.repository.san_pham.ChiTietSanPhamRepository;
import demo.repository.san_pham.MaSeriRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HoaDonServlet", value = {
        "/hoa-don/hien-thi",
        "/hoa-don/add",
        "/hoa-don/xoa-cho",
        "/hoa-don/detail",
        "/hoa-don/delete",
        "/hoa-don/update",
        "/hoa-don/view-update",
        "/hoa-don/ban-hang",
        "/hoa-don/export",
        "/hoa-don/print-view",
        "/hoa-don/api/tao-don",
        "/hoa-don/api/xoa-don",
        "/hoa-don/api/them-seri",
        "/hoa-don/api/xoa-seri",
        "/hoa-don/api/cap-nhat-khach",
        "/hoa-don/api/thanh-toan",
        "/hoa-don/api/chi-tiet",
        "/hoa-don/api/kiem-tra-thanh-toan",
        "/hoa-don/api/xac-nhan-chuyen-khoan",
        "/hoa-don/api/them-khach-hang",
        "/hoa-don/api/tim-theo-imei",
        "/hoa-don/api/quet-anh-imei" // 🟢 Endpoint mới: Quét IMEI từ File Ảnh
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class HoaDonServlet extends HttpServlet {

    private final HoaDonRepository hoaDonRepository         = new HoaDonRepository();
    private final HinhThucThanhToanRepo hinhThucThanhToanRepo = new HinhThucThanhToanRepo();
    private final KhachHangRepo khachHangRepo               = new KhachHangRepo();
    private final ChiTietSanPhamRepository chiTietSanPhamRepository = new ChiTietSanPhamRepository();
    private final MaSeriRepository maSeriRepository         = new MaSeriRepository();
    private final ChiTietHoaDonRepo chiTietHoaDonRepo       = new ChiTietHoaDonRepo();
    private final LichSuHoaDonRepo lichSuHoaDonRepo         = new LichSuHoaDonRepo();
    private final LichSuThanhToanRepo lichSuThanhToanRepo   = new LichSuThanhToanRepo();

    // =====================================================================
    //  ROUTING
    // =====================================================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("hien-thi"))        { hienthi(req, resp); }
        else if (uri.contains("detail"))     { detail(req, resp); }
        else if (uri.contains("view-update")){ viewUpdate(req, resp); }
        else if (uri.contains("ban-hang"))   { banhang(req, resp); }
        else if (uri.contains("export"))     { export(req, resp); }
        else if (uri.contains("print-view")) { printview(req, resp); }
        else if (uri.contains("/api/chi-tiet"))            { apiChiTiet(req, resp); }
        else if (uri.contains("/api/kiem-tra-thanh-toan")) { apiKiemTraThanhToan(req, resp); }
        else if (uri.contains("/api/tim-theo-imei"))        { apiTimTheoImei(req, resp); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if      (uri.contains("/api/tao-don"))               { apiTaoDon(req, resp); }
        else if (uri.contains("/api/xoa-don"))               { apiXoaDon(req, resp); }
        else if (uri.contains("/api/them-seri"))             { apiThemSeri(req, resp); }
        else if (uri.contains("/api/xoa-seri"))              { apiXoaSeri(req, resp); }
        else if (uri.contains("/api/cap-nhat-khach"))        { apiCapNhatKhach(req, resp); }
        else if (uri.contains("/api/thanh-toan"))            { apiThanhToan(req, resp); }
        else if (uri.contains("/api/xac-nhan-chuyen-khoan")) { apiXacNhanChuyenKhoan(req, resp); }
        else if (uri.contains("/api/them-khach-hang"))       { apiThemKhachHang(req, resp); }
        else if (uri.contains("/api/quet-anh-imei"))        { apiQuetAnhImei(req, resp); } // 🟢 Bổ sung xử lý POST Quét Ảnh
        else if (uri.contains("add"))                        { add(req, resp); }
        else if (uri.contains("update"))                     { update(req, resp); }
    }

    // HELPER: gửi JSON response
    private void jsonOk(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setStatus(200);
        try (PrintWriter pw = resp.getWriter()) { pw.print(json); }
    }

    private void jsonErr(HttpServletResponse resp, int code, String msg) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setStatus(code);
        try (PrintWriter pw = resp.getWriter()) {
            pw.print("{\"error\":\"" + msg.replace("\"", "'") + "\"}");
        }
    }

    // =====================================================================
    // 🟢 API MỚI: POST /hoa-don/api/quet-anh-imei
    // Đọc mã Barcode/QR từ file ảnh tem IMEI được tải lên
    // =====================================================================
    private void apiQuetAnhImei(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Part filePart = req.getPart("imageFile");
            if (filePart == null || filePart.getSize() == 0) {
                jsonErr(resp, 400, "Vui lòng chọn một file ảnh tem IMEI!");
                return;
            }

            // Đọc InputStream của ảnh tải lên
            try (InputStream inputStream = filePart.getInputStream()) {
                BufferedImage bufferedImage = ImageIO.read(inputStream);
                if (bufferedImage == null) {
                    jsonErr(resp, 400, "File tải lên không phải là định dạng ảnh hợp lệ!");
                    return;
                }

                // Dùng ZXing để giải mã mã vạch/QR trong ảnh
                LuminanceSource source = new BufferedImageLuminanceSource(bufferedImage);
                BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));

                Map<DecodeHintType, Object> hints = new HashMap<>();
                hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);

                Result result = new MultiFormatReader().decode(bitmap, hints);
                String imeiScanned = result.getText().trim();

                // Tra cứu IMEI vừa quét được trong CSDL
                MaSeri ms = maSeriRepository.findByImei(imeiScanned);
                if (ms == null) {
                    jsonErr(resp, 404, "Tìm thấy mã [" + imeiScanned + "] từ ảnh nhưng không có trong kho hệ thống!");
                    return;
                }

                if (ms.getTrangThai() != 1) {
                    jsonErr(resp, 400, "Mã IMEI [" + imeiScanned + "] đã được bán hoặc nằm trong hoá đơn khác!");
                    return;
                }

                CauHinhSanPham ch = ms.getCauHinhSanPham();
                int cauhinhId = ch != null ? ch.getId() : 0;
                String tenSP = "";
                String maSP = "";
                String mauSac = "";
                String cpu = "";
                String ram = "";
                BigDecimal donGia = BigDecimal.ZERO;

                if (ch != null) {
                    if (ch.getSanPham() != null) {
                        tenSP = ch.getSanPham().getTenSanPham() != null ? ch.getSanPham().getTenSanPham() : "";
                        maSP = ch.getSanPham().getMaSanPham() != null ? ch.getSanPham().getMaSanPham() : "";
                    }
                    if (ch.getMauSac() != null) mauSac = ch.getMauSac().getTenMauSac() != null ? ch.getMauSac().getTenMauSac() : "";
                    if (ch.getCpu() != null) cpu = ch.getCpu().getTenCpu() != null ? ch.getCpu().getTenCpu() : "";
                    if (ch.getRam() != null) ram = ch.getRam().getDungLuongRam() != null ? ch.getRam().getDungLuongRam() : "";
                }

                List<ChiTietSanPham> dsCT = chiTietSanPhamRepository.findByCauHinhId(cauhinhId);
                if (!dsCT.isEmpty() && dsCT.get(0).getDonGia() != null) {
                    donGia = dsCT.get(0).getDonGia();
                }

                String json = "{" +
                        "\"success\":true," +
                        "\"cauhinhId\":"  + cauhinhId + "," +
                        "\"idSeri\":"     + ms.getId() + "," +
                        "\"maSP\":\""     + escJson(maSP) + "\"," +
                        "\"tenSP\":\""    + escJson(tenSP) + "\"," +
                        "\"mauSac\":\""   + escJson(mauSac) + "\"," +
                        "\"cpu\":\""      + escJson(cpu) + "\"," +
                        "\"ram\":\""      + escJson(ram) + "\"," +
                        "\"donGia\":"     + donGia + "," +
                        "\"soSeri\":\""   + escJson(ms.getSoSeri() != null ? ms.getSoSeri() : "") + "\"" +
                        "}";
                jsonOk(resp, json);
            }
        } catch (NotFoundException e) {
            jsonErr(resp, 400, "Không tìm thấy mã vạch / QR IMEI trong ảnh này. Vui lòng chụp rõ tem hơn!");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi đọc file ảnh: " + e.getMessage());
        }
    }

    //  API: POST /hoa-don/api/tao-don
    private void apiTaoDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            NhanVien nv = (NhanVien) req.getSession().getAttribute("nhanVien");

            int nextId = hoaDonRepository.getNextId();
            int nam = java.time.LocalDate.now().getYear();
            String ma = String.format("HD%d_%03d", nam, nextId);

            HoaDon hd = new HoaDon();
            hd.setMaHoaDon(ma);
            hd.setTrangThai(2); // Chờ xử lý
            hd.setNgayLap(Date.valueOf(LocalDate.now()));
            hd.setTongTien(BigDecimal.ZERO);
            hd.setIsDeleted(0);
            if (nv != null) hd.setNhanVien(nv);

            Integer newId = hoaDonRepository.add(hd);
            if (newId == null) {
                jsonErr(resp, 500, "Không thể lưu hoá đơn vào database");
                return;
            }

            if (!newId.equals(nextId)) {
                ma = String.format("HD%d_%03d", nam, newId);
                hd.setId(newId);
                hd.setMaHoaDon(ma);
                hoaDonRepository.update(hd);
            }

            LichSuHoaDon ls = new LichSuHoaDon();
            ls.setHoaDon(hd);
            ls.setNgayTao(new java.util.Date());
            ls.setGhiChu("Tạo hoá đơn chờ tại quầy");
            ls.setTrangThai(2);
            lichSuHoaDonRepo.add(ls);

            jsonOk(resp, "{\"id\":" + newId + ",\"maHoaDon\":\"" + ma + "\",\"trangThai\":2}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Không thể tạo hoá đơn: " + e.getMessage());
        }
    }

    //  API: POST /hoa-don/api/xoa-don
    private void apiXoaDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idHoaDon = Integer.parseInt(req.getParameter("idHoaDon"));

            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }
            if (!isOwner(hd, req)) { jsonErr(resp, 403, "Bạn không có quyền thao tác hoá đơn này"); return; }

            List<ChiTietHoaDon> danhSachCT = chiTietHoaDonRepo.getByHoaDonId(idHoaDon);
            java.util.Set<Integer> cauHinhDaHoan = new java.util.HashSet<>();
            for (ChiTietHoaDon ct : danhSachCT) {
                MaSeri seri = ct.getIdSeri();
                if (seri != null) {
                    seri.setTrangThai(1);
                    maSeriRepository.update(seri);
                    if (seri.getCauHinhSanPham() != null) {
                        Integer idCH = seri.getCauHinhSanPham().getId();
                        if (cauHinhDaHoan.add(idCH)) {
                            chiTietSanPhamRepository.capNhatTonKhoTheoImei(idCH);
                        }
                    }
                }
            }
            hd.setTrangThai(3);
            hoaDonRepository.update(hd);
            jsonOk(resp, "{\"success\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Không thể xoá hoá đơn: " + e.getMessage());
        }
    }

    //  API: POST /hoa-don/api/them-seri
    private void apiThemSeri(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String idHoaDonStr = req.getParameter("idHoaDon");
            String idSeriStr   = req.getParameter("idSeri");

            if (idHoaDonStr == null || idHoaDonStr.trim().isEmpty()) {
                jsonErr(resp, 400, "Thiếu tham số idHoaDon"); return;
            }
            if (idSeriStr == null || idSeriStr.trim().isEmpty()) {
                jsonErr(resp, 400, "Thiếu tham số idSeri"); return;
            }

            int idHoaDon = Integer.parseInt(idHoaDonStr.trim());
            int idSeri   = Integer.parseInt(idSeriStr.trim());

            HoaDon hd     = hoaDonRepository.getOne(idHoaDon);
            MaSeri seri   = maSeriRepository.getOne(idSeri);

            if (hd == null)   { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }
            if (!isOwner(hd, req)) { jsonErr(resp, 403, "Bạn không có quyền thao tác hoá đơn này"); return; }
            if (seri == null) { jsonErr(resp, 404, "Không tìm thấy mã seri");  return; }
            if (seri.getTrangThai() != 1) {
                jsonErr(resp, 400, "Seri này không còn khả dụng");
                return;
            }
            // Chặn duplicate: kiểm tra IMEI đã có trong đơn này chưa (phòng race condition quét nhanh)
            if (chiTietHoaDonRepo.existsByHoaDonAndSeri(idHoaDon, idSeri)) {
                jsonErr(resp, 400, "Seri này đã có trong hoá đơn");
                return;
            }

            CauHinhSanPham cauHinh = seri.getCauHinhSanPham();
            BigDecimal donGia = BigDecimal.ZERO;
            if (cauHinh != null) {
                List<ChiTietSanPham> dsCT = chiTietSanPhamRepository.findByCauHinhId(cauHinh.getId());
                if (!dsCT.isEmpty() && dsCT.get(0).getDonGia() != null) {
                    donGia = dsCT.get(0).getDonGia();
                }
            }

            ChiTietHoaDon ct = new ChiTietHoaDon();
            ct.setHoaDon(hd);
            ct.setIdSeri(seri);
            ct.setCauHinhSanPham(cauHinh);
            ct.setDonGia(donGia);
            ct.setThanhTien(donGia);
            ct.setTrangThai(1);
            Integer ctId = chiTietHoaDonRepo.add(ct);

            seri.setTrangThai(2);
            maSeriRepository.update(seri);
            if (seri.getCauHinhSanPham() != null) {
                chiTietSanPhamRepository.capNhatTonKhoTheoImei(seri.getCauHinhSanPham().getId());
            }

            capNhatTongTien(idHoaDon);
            jsonOk(resp, "{\"success\":true,\"chiTietId\":" + ctId + ",\"donGia\":" + donGia + "}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi thêm seri: " + e.getMessage());
        }
    }

    //  API: POST /hoa-don/api/xoa-seri
    private void apiXoaSeri(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idChiTiet = Integer.parseInt(req.getParameter("idChiTiet"));
            ChiTietHoaDon ct = chiTietHoaDonRepo.getOne(idChiTiet);
            if (ct == null) { jsonErr(resp, 404, "Không tìm thấy chi tiết"); return; }

            int idHoaDon = ct.getHoaDon().getId();
            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }
            if (!isOwner(hd, req)) { jsonErr(resp, 403, "Bạn không có quyền thao tác hoá đơn này"); return; }

            MaSeri seri = ct.getIdSeri();
            if (seri != null) {
                seri.setTrangThai(1);
                maSeriRepository.update(seri);
                if (seri.getCauHinhSanPham() != null) {
                    chiTietSanPhamRepository.capNhatTonKhoTheoImei(seri.getCauHinhSanPham().getId());
                }
            }
            chiTietHoaDonRepo.delete(idChiTiet);
            capNhatTongTien(idHoaDon);

            jsonOk(resp, "{\"success\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi xoá seri: " + e.getMessage());
        }
    }

    //  API: POST /hoa-don/api/cap-nhat-khach
    private void apiCapNhatKhach(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idHoaDon = Integer.parseInt(req.getParameter("idHoaDon"));
            String idKhParam = req.getParameter("idKhachHang");

            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }
            if (!isOwner(hd, req)) { jsonErr(resp, 403, "Bạn không có quyền thao tác hoá đơn này"); return; }

            if (idKhParam == null || idKhParam.trim().isEmpty()) {
                hd.setKhachHang(null);
                hd.setTenKhachHang(null);
                hd.setSdtKhachHang(null);
            } else {
                KhachHang kh = khachHangRepo.getOne(Integer.parseInt(idKhParam));
                if (kh == null) { jsonErr(resp, 404, "Không tìm thấy khách hàng"); return; }
                hd.setKhachHang(kh);
                hd.setTenKhachHang(kh.getTenKhachHang());
                hd.setSdtKhachHang(kh.getSdt());
            }
            hoaDonRepository.update(hd);
            jsonOk(resp, "{\"success\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi cập nhật khách hàng: " + e.getMessage());
        }
    }

    //  API: GET /hoa-don/api/chi-tiet?id=X
    private void apiChiTiet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idHoaDon = Integer.parseInt(req.getParameter("id"));
            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }

            List<ChiTietHoaDon> list = chiTietHoaDonRepo.getByHoaDonId(idHoaDon);
            StringBuilder sb = new StringBuilder();
            sb.append("{\"idHoaDon\":").append(idHoaDon)
                    .append(",\"maHoaDon\":\"").append(hd.getMaHoaDon()).append("\"")
                    .append(",\"tongTien\":").append(hd.getTongTien() != null ? hd.getTongTien() : 0)
                    .append(",\"idKhachHang\":").append(hd.getKhachHang() != null ? hd.getKhachHang().getId() : "null")
                    .append(",\"tenKhachHang\":\"").append(hd.getKhachHang() != null ? hd.getKhachHang().getTenKhachHang() : "").append("\"")
                    .append(",\"sdtKhachHang\":\"").append(hd.getSdtKhachHang() != null ? hd.getSdtKhachHang() : "").append("\"")
                    .append(",\"items\":[");

            for (int i = 0; i < list.size(); i++) {
                ChiTietHoaDon ct = list.get(i);
                MaSeri seri = ct.getIdSeri();
                CauHinhSanPham ch = ct.getCauHinhSanPham();

                String soSeri  = seri != null ? seri.getSoSeri() : "";
                String tenSP   = "";
                String cpu     = "";
                String ram     = "";
                String gpu     = "";
                String storage = "";
                String mauSac  = "";
                String thuongHieu = "";

                if (ch != null) {
                    try { if (ch.getSanPham()  != null) { tenSP = ch.getSanPham().getTenSanPham(); } } catch(Exception ignored) {}
                    try { if (ch.getCpu()      != null) { cpu = ch.getCpu().getTenCpu(); } } catch(Exception ignored) {}
                    try { if (ch.getRam()      != null) { ram = ch.getRam().getDungLuongRam(); } } catch(Exception ignored) {}
                    try { if (ch.getGpu()      != null) { gpu = ch.getGpu().getTenGpu(); } } catch(Exception ignored) {}
                    try { if (ch.getOCung()    != null) { storage = ch.getOCung().getDungLuongOCung(); } } catch(Exception ignored) {}
                    try { if (ch.getMauSac()   != null) { mauSac = ch.getMauSac().getTenMauSac(); } } catch(Exception ignored) {}
                    try { if (ch.getSanPham()  != null && ch.getSanPham().getThuongHieu() != null) {
                        thuongHieu = ch.getSanPham().getThuongHieu().getTenThuongHieu();
                    } } catch(Exception ignored) {}
                }

                sb.append("{\"id\":").append(ct.getId())
                        .append(",\"soSeri\":\"").append(soSeri.replace("\"","'")).append("\"")
                        .append(",\"tenSanPham\":\"").append(tenSP.replace("\"","'")).append("\"")
                        .append(",\"donGia\":").append(ct.getDonGia() != null ? ct.getDonGia() : 0)
                        .append(",\"cpu\":\"").append(cpu.replace("\"","'")).append("\"")
                        .append(",\"ram\":\"").append(ram.replace("\"","'")).append("\"")
                        .append(",\"gpu\":\"").append(gpu.replace("\"","'")).append("\"")
                        .append(",\"storage\":\"").append(storage.replace("\"","'")).append("\"")
                        .append(",\"mauSac\":\"").append(mauSac.replace("\"","'")).append("\"")
                        .append(",\"thuongHieu\":\"").append(thuongHieu.replace("\"","'")).append("\"")
                        .append("}");
                if (i < list.size() - 1) sb.append(",");
            }
            sb.append("]}");
            jsonOk(resp, sb.toString());
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi lấy chi tiết: " + e.getMessage());
        }
    }

    //  API: POST /hoa-don/api/thanh-toan
    private void apiThanhToan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idHoaDon         = Integer.parseInt(req.getParameter("idHoaDon"));
            int idHinhThuc       = Integer.parseInt(req.getParameter("idHinhThuc"));
            BigDecimal tienKhachTra = new BigDecimal(req.getParameter("tienKhachTra"));

            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }
            if (!isOwner(hd, req)) { jsonErr(resp, 403, "Bạn không có quyền thao tác hoá đơn này"); return; }

            capNhatTongTien(idHoaDon);
            hd = hoaDonRepository.getOne(idHoaDon);

            BigDecimal tongTien = hd.getTongTien() != null ? hd.getTongTien() : BigDecimal.ZERO;

            if (tienKhachTra.compareTo(tongTien) < 0) {
                jsonErr(resp, 400, "Tiền khách đưa không đủ");
                return;
            }

            BigDecimal tienThua = tienKhachTra.subtract(tongTien);
            HinhThucThanhToan hinhThuc = hinhThucThanhToanRepo.getOne(idHinhThuc);
            NhanVien nv = (NhanVien) req.getSession().getAttribute("nhanVien");

            hd.setHinhThucThanhToan(hinhThuc);
            hd.setTienKhachTra(tienKhachTra);
            hd.setTienThua(tienThua);
            hd.setNgayLap(Date.valueOf(LocalDate.now()));
            hd.setTrangThai(1);
            if (nv != null) hd.setNhanVien(nv);
            if (hd.getKhachHang() == null && (hd.getTenKhachHang() == null || hd.getTenKhachHang().trim().isEmpty())) {
                hd.setTenKhachHang("Khách lẻ");
            }
            hoaDonRepository.update(hd);

            List<ChiTietHoaDon> dsCT = chiTietHoaDonRepo.getByHoaDonId(idHoaDon);
            java.util.Set<Integer> daCauHinhDaCapNhat = new java.util.HashSet<>();
            for (ChiTietHoaDon ct : dsCT) {
                if (ct.getIdSeri() != null) {
                    MaSeri seri = ct.getIdSeri();
                    seri.setTrangThai(0);
                    maSeriRepository.update(seri);
                    if (seri.getCauHinhSanPham() != null) {
                        Integer idCH = seri.getCauHinhSanPham().getId();
                        if (daCauHinhDaCapNhat.add(idCH)) {
                            chiTietSanPhamRepository.capNhatTonKhoTheoImei(idCH);
                        }
                    }
                }
            }

            LichSuThanhToan lstt = new LichSuThanhToan();
            lstt.setHoaDon(hd);
            lstt.setPhuongThucThanhToan(hinhThuc != null ? hinhThuc.getTenHinhThuc() : "");
            lstt.setSoTien(tienKhachTra);
            lstt.setNgayThanhToan(new java.util.Date());
            lstt.setTrangThaiThanhToan(1);
            lstt.setTrangThai(1);
            lichSuThanhToanRepo.add(lstt);

            LichSuHoaDon lshd = new LichSuHoaDon();
            lshd.setHoaDon(hd);
            lshd.setNgayTao(new java.util.Date());
            lshd.setGhiChu("Xác nhận thanh toán tại quầy");
            lshd.setTrangThai(1);
            lichSuHoaDonRepo.add(lshd);

            jsonOk(resp, "{\"success\":true,\"maHoaDon\":\"" + hd.getMaHoaDon() + "\""
                    + ",\"tienThua\":" + tienThua + "}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi thanh toán: " + e.getMessage());
        }
    }

    //  API: GET /hoa-don/api/kiem-tra-thanh-toan?id=X
    private void apiKiemTraThanhToan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                jsonErr(resp, 400, "Thiếu tham số id");
                return;
            }
            int idHoaDon = Integer.parseInt(idParam.trim());
            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) {
                jsonErr(resp, 404, "Không tìm thấy hoá đơn");
                return;
            }
            int trangThai = hd.getTrangThai() != null ? hd.getTrangThai() : 2;
            boolean paid  = (trangThai == 1);
            jsonOk(resp, "{\"paid\":" + paid + ",\"trangThai\":" + trangThai + "}");
        } catch (NumberFormatException e) {
            jsonErr(resp, 400, "ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi kiểm tra thanh toán: " + e.getMessage());
        }
    }

    //  API: GET /hoa-don/api/tim-theo-imei?imei=XXXXX
    private void apiTimTheoImei(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String imei = req.getParameter("imei");
            if (imei == null || imei.trim().isEmpty()) {
                jsonErr(resp, 400, "Thiếu tham số imei"); return;
            }
            MaSeri ms = maSeriRepository.findByImei(imei.trim());
            if (ms == null) {
                jsonErr(resp, 404, "Không tìm thấy IMEI \"" + imei.trim().replace("\"", "'") + "\" hoặc IMEI này không còn hàng"); return;
            }
            CauHinhSanPham ch = ms.getCauHinhSanPham();
            int cauhinhId = ch != null ? ch.getId() : 0;
            String tenSP   = "";
            String maSP    = "";
            String mauSac  = "";
            String cpu     = "";
            String ram     = "";
            BigDecimal donGia = BigDecimal.ZERO;

            if (ch != null) {
                try { if (ch.getSanPham()  != null) { tenSP  = ch.getSanPham().getTenSanPham()  != null ? ch.getSanPham().getTenSanPham()  : ""; maSP = ch.getSanPham().getMaSanPham() != null ? ch.getSanPham().getMaSanPham() : ""; } } catch (Exception ignored) {}
                try { if (ch.getMauSac() != null) mauSac = ch.getMauSac().getTenMauSac() != null ? ch.getMauSac().getTenMauSac() : ""; } catch (Exception ignored) {}
                try { if (ch.getCpu()    != null) cpu    = ch.getCpu().getTenCpu()       != null ? ch.getCpu().getTenCpu()       : ""; } catch (Exception ignored) {}
                try { if (ch.getRam()    != null) ram    = ch.getRam().getDungLuongRam() != null ? ch.getRam().getDungLuongRam() : ""; } catch (Exception ignored) {}
            }
            List<ChiTietSanPham> dsCT = chiTietSanPhamRepository.findByCauHinhId(cauhinhId);
            if (!dsCT.isEmpty()) {
                donGia = dsCT.get(0).getDonGia() != null ? dsCT.get(0).getDonGia() : BigDecimal.ZERO;
            }

            Integer idSeri = ms.getId();

            String json = "{" +
                    "\"cauhinhId\":"  + cauhinhId + "," +
                    "\"idSeri\":"     + idSeri     + "," +
                    "\"maSP\":\""     + escJson(maSP)    + "\"," +
                    "\"tenSP\":\""    + escJson(tenSP)   + "\"," +
                    "\"mauSac\":\""   + escJson(mauSac)  + "\"," +
                    "\"cpu\":\""      + escJson(cpu)     + "\"," +
                    "\"ram\":\""      + escJson(ram)     + "\"," +
                    "\"donGia\":"     + donGia            + "," +
                    "\"soSeri\":\""   + escJson(ms.getSoSeri() != null ? ms.getSoSeri() : "") + "\"" +
                    "}";
            jsonOk(resp, json);
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi tìm kiếm IMEI: " + e.getMessage());
        }
    }

    /** Escape ký tự đặc biệt trong JSON string */
    private String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    //  API: POST /hoa-don/api/xac-nhan-chuyen-khoan
    private void apiXacNhanChuyenKhoan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idHoaDon   = Integer.parseInt(req.getParameter("idHoaDon"));
            int idHinhThuc = Integer.parseInt(req.getParameter("idHinhThuc"));

            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }
            if (!isOwner(hd, req)) { jsonErr(resp, 403, "Bạn không có quyền thao tác hoá đơn này"); return; }
            
            // Nếu đã thanh toán nhưng thiếu hình thức, vẫn set lại
            if (hd.getTrangThai() != null && hd.getTrangThai() == 1) {
                if (hd.getHinhThucThanhToan() == null) {
                    HinhThucThanhToan hinhThuc = hinhThucThanhToanRepo.getOne(idHinhThuc);
                    if (hinhThuc != null) {
                        hd.setHinhThucThanhToan(hinhThuc);
                        hoaDonRepository.update(hd);
                    }
                }
                jsonOk(resp, "{\"success\":true,\"maHoaDon\":\"" + hd.getMaHoaDon() + "\"}");
                return;
            }

            capNhatTongTien(idHoaDon);
            hd = hoaDonRepository.getOne(idHoaDon);

            BigDecimal tongTien = hd.getTongTien() != null ? hd.getTongTien() : BigDecimal.ZERO;
            HinhThucThanhToan hinhThuc = hinhThucThanhToanRepo.getOne(idHinhThuc);
            NhanVien nv = (NhanVien) req.getSession().getAttribute("nhanVien");

            hd.setHinhThucThanhToan(hinhThuc);
            hd.setTienKhachTra(tongTien);
            hd.setTienThua(BigDecimal.ZERO);
            hd.setNgayLap(Date.valueOf(LocalDate.now()));
            hd.setTrangThai(1);
            if (nv != null) hd.setNhanVien(nv);
            hoaDonRepository.update(hd);

            List<ChiTietHoaDon> dsCT = chiTietHoaDonRepo.getByHoaDonId(idHoaDon);
            java.util.Set<Integer> daCauHinhDaCapNhat = new java.util.HashSet<>();
            for (ChiTietHoaDon ct : dsCT) {
                if (ct.getIdSeri() != null) {
                    MaSeri seri = ct.getIdSeri();
                    seri.setTrangThai(0);
                    maSeriRepository.update(seri);
                    if (seri.getCauHinhSanPham() != null) {
                        Integer idCH = seri.getCauHinhSanPham().getId();
                        if (daCauHinhDaCapNhat.add(idCH)) {
                            chiTietSanPhamRepository.capNhatTonKhoTheoImei(idCH);
                        }
                    }
                }
            }

            LichSuThanhToan lstt = new LichSuThanhToan();
            lstt.setHoaDon(hd);
            lstt.setPhuongThucThanhToan(hinhThuc != null ? hinhThuc.getTenHinhThuc() : "Chuyển khoản");
            lstt.setSoTien(tongTien);
            lstt.setNgayThanhToan(new java.util.Date());
            lstt.setTrangThaiThanhToan(1);
            lstt.setTrangThai(1);
            lichSuThanhToanRepo.add(lstt);

            LichSuHoaDon lshd = new LichSuHoaDon();
            lshd.setHoaDon(hd);
            lshd.setNgayTao(new java.util.Date());
            lshd.setGhiChu("Thanh toán chuyển khoản VietQR tại quầy");
            lshd.setTrangThai(1);
            lichSuHoaDonRepo.add(lshd);

            jsonOk(resp, "{\"success\":true,\"maHoaDon\":\"" + hd.getMaHoaDon() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi xác nhận chuyển khoản: " + e.getMessage());
        }
    }

    //  API: POST /hoa-don/api/them-khach-hang
    private void apiThemKhachHang(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            String tenRaw = req.getParameter("tenKhachHang");
            String sdt    = req.getParameter("sdt");
            String email  = req.getParameter("email");
            String ngaySinhStr = req.getParameter("ngaySinh");
            String gioiTinhStr = req.getParameter("gioiTinh");

            if (tenRaw == null || tenRaw.trim().isEmpty()) {
                jsonErr(resp, 400, "Tên khách hàng không được để trống."); return;
            }
            String ten = tenRaw.trim().replaceAll("\\s+", " ");
            if (!ten.matches("[\\p{L} ]+")) {
                jsonErr(resp, 400, "Tên không được chứa số hoặc ký tự đặc biệt."); return;
            }
            String[] words = ten.split(" ");
            StringBuilder tenFormatted = new StringBuilder();
            for (String w : words) {
                if (!w.isEmpty()) {
                    tenFormatted.append(Character.toUpperCase(w.charAt(0)))
                            .append(w.substring(1).toLowerCase()).append(" ");
                }
            }
            ten = tenFormatted.toString().trim();

            if (sdt == null || sdt.trim().isEmpty()) {
                jsonErr(resp, 400, "Số điện thoại không được để trống."); return;
            }
            sdt = sdt.trim();
            if (!sdt.matches("^0\\d{9,10}$")) {
                jsonErr(resp, 400, "Số điện thoại phải bắt đầu bằng 0 và có 10–11 chữ số."); return;
            }

            demo.Service.khachhang.KhachHangService khService = new demo.Service.khachhang.KhachHangService();
            if (khService.existsBySdt(sdt, null)) {
                jsonErr(resp, 400, "Số điện thoại \"" + sdt + "\" đã được sử dụng bởi khách hàng khác."); return;
            }

            if (email != null && !email.trim().isEmpty()) {
                email = email.trim();
                if (khService.existsByEmail(email, null)) {
                    jsonErr(resp, 400, "Email \"" + email + "\" đã được sử dụng bởi khách hàng khác."); return;
                }
            }

            String ma = khService.layMaKhachHangMoi();

            demo.entity.khach_hang.KhachHang kh = new demo.entity.khach_hang.KhachHang();
            kh.setMaKhachHang(ma);
            kh.setTenKhachHang(ten);
            kh.setSdt(sdt);
            kh.setTrangThai(1);

            if (email != null && !email.isEmpty()) kh.setEmail(email);

            if (ngaySinhStr != null && !ngaySinhStr.trim().isEmpty()) {
                try { kh.setNgaySinh(java.time.LocalDate.parse(ngaySinhStr.trim())); } catch (Exception ignored) {}
            }
            if (gioiTinhStr != null && !gioiTinhStr.trim().isEmpty()) {
                kh.setGioiTinh(Boolean.parseBoolean(gioiTinhStr));
            }

            String tinhThanh   = req.getParameter("tinhThanh");
            String quanHuyen   = req.getParameter("quanHuyen");
            String phuongXa    = req.getParameter("phuongXa");
            String diaChiCuThe = req.getParameter("diaChiCuThe");
            String loaiDiaChi  = req.getParameter("loaiDiaChi");
            String provinceCode = req.getParameter("provinceCode");
            String districtCode = req.getParameter("districtCode");
            String wardCode     = req.getParameter("wardCode");

            if (tinhThanh != null && !tinhThanh.trim().isEmpty()) {
                demo.entity.khach_hang.DiaChiKhachHang dc = new demo.entity.khach_hang.DiaChiKhachHang();
                dc.setTinhThanh(tinhThanh.trim());
                dc.setQuanHuyen(quanHuyen != null ? quanHuyen.trim() : "");
                dc.setPhuongXa(phuongXa != null ? phuongXa.trim() : "");
                dc.setDiaChiCuThe(diaChiCuThe != null ? diaChiCuThe.trim() : "");
                dc.setLoaiDiaChi(loaiDiaChi != null && !loaiDiaChi.trim().isEmpty() ? loaiDiaChi.trim() : "Nhà riêng");
                dc.setTrangThai(1);
                dc.setKhachHang(kh);

                demo.entity.khach_hang.DiaChiApiMapping mapping = new demo.entity.khach_hang.DiaChiApiMapping();
                try { mapping.setProvinceCode(Integer.parseInt(provinceCode != null ? provinceCode : "0")); } catch (Exception e2) { mapping.setProvinceCode(0); }
                try { mapping.setDistrictCode(Integer.parseInt(districtCode != null ? districtCode : "0")); } catch (Exception e2) { mapping.setDistrictCode(0); }
                try { mapping.setWardCode(Integer.parseInt(wardCode != null ? wardCode : "0")); } catch (Exception e2) { mapping.setWardCode(0); }
                mapping.setDiaChiKhachHang(dc);
                dc.setDiaChiApiMapping(mapping);

                kh.setDiaChiKhachHang(java.util.Arrays.asList(dc));
            }

            khService.add(kh);

            int savedId = kh.getId() != null ? kh.getId() : -1;
            String diaChi = "";
            if (kh.getDiaChiKhachHang() != null && !kh.getDiaChiKhachHang().isEmpty()) {
                demo.entity.khach_hang.DiaChiKhachHang dc0 = kh.getDiaChiKhachHang().get(0);
                diaChi = (dc0.getDiaChiCuThe() != null ? dc0.getDiaChiCuThe() + ", " : "") +
                        (dc0.getPhuongXa()    != null ? dc0.getPhuongXa()    + ", " : "") +
                        (dc0.getQuanHuyen()   != null ? dc0.getQuanHuyen()   + ", " : "") +
                        (dc0.getTinhThanh()   != null ? dc0.getTinhThanh()         : "");
            }

            String tenEsc   = ten.replace("\"","'");
            String sdtEsc   = sdt.replace("\"","'");
            String maEsc    = ma.replace("\"","'");
            String dcEsc    = diaChi.replace("\"","'");
            String emailEsc = (email != null ? email : "").replace("\"","'");
            jsonOk(resp, "{\"success\":true,\"id\":" + savedId + ",\"maKhachHang\":\"" + maEsc + "\""
                    + ",\"tenKhachHang\":\"" + tenEsc + "\",\"sdt\":\"" + sdtEsc + "\""
                    + ",\"email\":\"" + emailEsc + "\",\"diaChi\":\"" + dcEsc + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi thêm khách hàng: " + e.getMessage());
        }
    }

    private void capNhatTongTien(int idHoaDon) {
        try {
            List<ChiTietHoaDon> dsCT = chiTietHoaDonRepo.getByHoaDonId(idHoaDon);
            BigDecimal tong = BigDecimal.ZERO;
            for (ChiTietHoaDon ct : dsCT) {
                if (ct.getDonGia() != null) tong = tong.add(ct.getDonGia());
            }
            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd != null) {
                hd.setTongTien(tong);
                hoaDonRepository.update(hd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private boolean isOwner(HoaDon hd, HttpServletRequest req) {
        NhanVien nv = (NhanVien) req.getSession().getAttribute("nhanVien");
        if (nv == null) return false;
        if (hd.getNhanVien() == null) return false;
        return hd.getNhanVien().getId().equals(nv.getId());
    }

    private void banhang(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        NhanVien nv = (NhanVien) req.getSession().getAttribute("nhanVien");

        hoaDonRepository.huyDonChoQuaHan();

        List<ChiTietSanPham> listSanPham      = chiTietSanPhamRepository.getAllCoImeiHoatDong();
        List<KhachHang> listKhachHang          = khachHangRepo.getAll();
        List<MaSeri> listMaSeri                = maSeriRepository.getAllForBanHang();
        List<HinhThucThanhToan> listHinhThuc   = hinhThucThanhToanRepo.getAllActive();

        List<HoaDon> listHoaDonCho;
        if (nv != null) {
            listHoaDonCho = hoaDonRepository.getHoaDonChoByNhanVien(nv.getId());
        } else {
            listHoaDonCho = new java.util.ArrayList<>();
        }

        req.setAttribute("listSanPham",          listSanPham);
        req.setAttribute("listKhachHang",         listKhachHang);
        req.setAttribute("listMaSeri",            listMaSeri);
        req.setAttribute("listHinhThucThanhToan", listHinhThuc);
        req.setAttribute("listHoaDonCho",         listHoaDonCho);
        req.getRequestDispatcher("/demo/hoa_don/ban_hang.jsp").forward(req, resp);
    }

    private void printview(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            Integer id = Integer.valueOf(idParam);
            HoaDon hoaDon = hoaDonRepository.getOneWithDetails(id);
            if (hoaDon == null) { resp.sendError(404); return; }
            KhachHang khachHang = hoaDon.getKhachHang();
            DiaChiKhachHang diaChiHienThi = null;
            if (khachHang != null && khachHang.getDiaChiKhachHang() != null
                    && !khachHang.getDiaChiKhachHang().isEmpty()) {
                diaChiHienThi = khachHang.getDiaChiKhachHang().get(0);
            }
            req.setAttribute("diaChi",    diaChiHienThi);
            req.setAttribute("hoaDon",    hoaDon);
            req.setAttribute("khachHang", khachHang);
            req.getRequestDispatcher("/demo/hoa_don/in_hoa_don.jsp").forward(req, resp);
        }
    }

    private void detail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer id = Integer.valueOf(req.getParameter("id"));
        HoaDon hoaDon = hoaDonRepository.getOneWithDetails(id);
        if (hoaDon == null) {
            resp.sendError(404, "Không tìm thấy hoá đơn");
            return;
        }
        KhachHang khachHang = hoaDon.getKhachHang();
        DiaChiKhachHang diaChiHienThi = null;
        if (khachHang != null && khachHang.getDiaChiKhachHang() != null
                && !khachHang.getDiaChiKhachHang().isEmpty()) {
            diaChiHienThi = khachHang.getDiaChiKhachHang().get(0);
        }
        req.setAttribute("diaChi",    diaChiHienThi);
        req.setAttribute("hoaDon",    hoaDon);
        req.setAttribute("khachHang", khachHang);
        req.getRequestDispatcher("/demo/hoa_don/chi_tiet_hoa_don.jsp").forward(req, resp);
    }

    private void viewUpdate(HttpServletRequest req, HttpServletResponse resp) {}
    private void update(HttpServletRequest req, HttpServletResponse resp) {}
    private void add(HttpServletRequest req, HttpServletResponse resp) {}
    private void hienthi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword   = req.getParameter("keyword");
        String trangThai = req.getParameter("trangThai");
        String ngayTao   = req.getParameter("ngayTao");
        boolean isFiltered = "true".equals(req.getParameter("filtered"));
        if (!isFiltered) ngayTao = java.time.LocalDate.now().toString();

        final int PAGE_SIZE = 10;
        int page = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Integer.parseInt(pageParam.trim());
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        long totalRecords = hoaDonRepository.demTongHoaDon(keyword, trangThai, ngayTao);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<HoaDon> ListHoaDon = hoaDonRepository.timKiemVaLocPhanTrang(keyword, trangThai, ngayTao, page, PAGE_SIZE);

        req.setAttribute("oldNgayTao",    ngayTao);
        req.setAttribute("oldKeyword",    keyword   != null ? keyword   : "");
        req.setAttribute("oldTrangThai",  trangThai != null ? trangThai : "");
        req.setAttribute("isFiltered",    isFiltered);
        req.setAttribute("ListHoaDon",    ListHoaDon);
        req.setAttribute("currentPage",   page);
        req.setAttribute("totalPages",    totalPages);
        req.setAttribute("totalRecords",  totalRecords);
        req.setAttribute("pageSize",      PAGE_SIZE);
        req.getRequestDispatcher("/demo/hoa_don/hoa_don.jsp").forward(req, resp);
    }

    private void export(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword   = req.getParameter("keyword");
        String trangThai = req.getParameter("trangThai");
        String ngayTao   = req.getParameter("ngayTao");
        boolean isFiltering = (keyword != null && !keyword.trim().isEmpty()) ||
                (trangThai != null && !trangThai.trim().isEmpty()) ||
                (ngayTao != null && !ngayTao.trim().isEmpty());
        List<HoaDon> listHoaDon = isFiltering
                ? hoaDonRepository.timKiemVaLoc(keyword, trangThai, ngayTao)
                : hoaDonRepository.getAllHoaDon();

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Danh_Sach_Hoa_Don");
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("STT");
        headerRow.createCell(1).setCellValue("Mã Hóa Đơn");
        headerRow.createCell(2).setCellValue("Khách Hàng");
        headerRow.createCell(3).setCellValue("Số Điện Thoại");
        headerRow.createCell(4).setCellValue("Ngày Tạo");
        headerRow.createCell(5).setCellValue("Tổng Tiền");
        headerRow.createCell(6).setCellValue("Trạng Thái");
        int rowNum = 1;
        for (HoaDon hd : listHoaDon) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(rowNum - 1);
            row.createCell(1).setCellValue(hd.getMaHoaDon() != null ? hd.getMaHoaDon() : "");
            row.createCell(2).setCellValue(hd.getKhachHang() != null ? hd.getKhachHang().getTenKhachHang() : "");
            row.createCell(3).setCellValue(hd.getKhachHang() != null ? hd.getKhachHang().getSdt() : "");
            row.createCell(4).setCellValue(hd.getNgayLap() != null ? hd.getNgayLap().toString() : "");
            row.createCell(5).setCellValue(hd.getTongTien() != null ? hd.getTongTien().doubleValue() : 0);
            String trangThaiStr = (hd.getTrangThai() != null && hd.getTrangThai() == 1) ? "Đã thanh toán" : "Chưa thanh toán";
            row.createCell(6).setCellValue(trangThaiStr);
        }
        for (int i = 0; i < 7; i++) sheet.autoSizeColumn(i);
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=\"DanhSachHoaDon.xlsx\"");
        workbook.write(resp.getOutputStream());
        workbook.close();
    }
}