package demo.servlet;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import demo.entity.hoa_don.*;
import demo.entity.san_pham.MaSeri;
import demo.repository.hoadon.*;
import demo.repository.san_pham.ChiTietSanPhamRepository;
import demo.repository.san_pham.MaSeriRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(name = "SepayWebhookServlet", value = "/hoa-don/api/sepay-webhook")
public class SepayWebhookServlet extends HttpServlet {

    private final HoaDonRepository hoaDonRepository = new HoaDonRepository();
    private final ChiTietHoaDonRepo chiTietHoaDonRepo = new ChiTietHoaDonRepo();
    private final MaSeriRepository maSeriRepository = new MaSeriRepository();
    private final ChiTietSanPhamRepository chiTietSanPhamRepository = new ChiTietSanPhamRepository();
    private final LichSuThanhToanRepo lichSuThanhToanRepo = new LichSuThanhToanRepo();
    private final LichSuHoaDonRepo lichSuHoaDonRepo = new LichSuHoaDonRepo();
    private final HinhThucThanhToanRepo hinhThucThanhToanRepo = new HinhThucThanhToanRepo();

    // 1. API GET: Phục vụ màn hình ban_hang.jsp hỏi trạng thái đơn hàng ngầm mỗi 2 giây
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        resp.setContentType("application/json;charset=UTF-8");

        try {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                Integer id = Integer.parseInt(idStr.trim());
                HoaDon hd = hoaDonRepository.getOne(id);

                if (hd != null && hd.getTrangThai() != null && hd.getTrangThai() == 1) {
                    resp.getWriter().write("{\"paid\": true, \"trangThai\": 1}");
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.getWriter().write("{\"paid\": false, \"trangThai\": 2}");
    }

    // 2. API POST: Nhận Webhook biến động số dư từ SePay
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("==================================================");
        System.out.println("🚀 [SEPAY WEBHOOK] Tín hiệu chuyển khoản từ Ngrok/SePay đã tới!");

        try {
            BufferedReader reader = req.getReader();
            ObjectMapper mapper = new ObjectMapper();
            JsonNode json = mapper.readTree(reader);

            if (json == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            // Đọc nội dung chuyển khoản và số tiền thực nhận
            String content = json.has("content") ? json.get("content").asText() :
                    (json.has("transactionContent") ? json.get("transactionContent").asText() : "");

            BigDecimal amountIn = BigDecimal.ZERO;
            if (json.has("transferAmount")) {
                amountIn = new BigDecimal(json.get("transferAmount").asText());
            } else if (json.has("amountIn")) {
                amountIn = new BigDecimal(json.get("amountIn").asText());
            } else if (json.has("amount_in")) {
                amountIn = new BigDecimal(json.get("amount_in").asText());
            }

            System.out.println(" Nội dung CK thực tế: [" + content + "]");
            System.out.println(" Số tiền thực nhận: [" + amountIn + " VNĐ]");

            // REGEX MỚI: Bắt linh hoạt HD2026058, HD2026_058, HD001, HD_001, HD 001...
            Pattern pattern = Pattern.compile("(HD[A-Za-z0-9_]+)");
            Matcher matcher = pattern.matcher(content.toUpperCase());

            if (matcher.find()) {
                String maHoaDon = matcher.group(1).trim();
                System.out.println("🎯 Lọc ra mã hóa đơn: [" + maHoaDon + "]");

                // 1. Tìm trực tiếp trong CSDL theo mã lọc được
                HoaDon hd = hoaDonRepository.findByMa(maHoaDon);

                // 2. Nếu không thấy (do ngân hàng bỏ bớt dấu _), thử tìm mã bỏ dấu gạch dưới
                if (hd == null && maHoaDon.contains("_")) {
                    String maLien = maHoaDon.replace("_", "");
                    hd = hoaDonRepository.findByMa(maLien);
                }

                if (hd != null) {
                    System.out.println("✅ Khớp Hóa Đơn trong CSDL! ID: " + hd.getId() + " - Mã: " + hd.getMaHoaDon());

                    if (hd.getTrangThai() != null && hd.getTrangThai() != 1) {
                        BigDecimal tongTien = hd.getTongTien() != null ? hd.getTongTien() : BigDecimal.ZERO;

                        if (amountIn.compareTo(tongTien) >= 0) {
                            // 🟢 1. Tìm và set hình thức thanh toán "Chuyển khoản"
                            HinhThucThanhToan hinhThuc = hinhThucThanhToanRepo.findByTenContaining("chuyển khoản");
                            if (hinhThuc == null) hinhThuc = hinhThucThanhToanRepo.findByTenContaining("bank");
                            if (hinhThuc == null) hinhThuc = hinhThucThanhToanRepo.findByTenContaining("sepay");
                            
                            // 🟢 2. Cập nhật hóa đơn sang trạng thái Đã thanh toán (1)
                            hd.setTrangThai(1);
                            hd.setHinhThucThanhToan(hinhThuc);
                            hd.setTienKhachTra(amountIn);
                            hd.setTienThua(amountIn.subtract(tongTien));
                            hd.setNgayLap(new java.sql.Date(System.currentTimeMillis()));
                            hoaDonRepository.update(hd);

                            // 🟢 2. Cập nhật seri/IMEI thành Đã bán (0) và trừ tồn kho
                            List<ChiTietHoaDon> dsCT = chiTietHoaDonRepo.getByHoaDonId(hd.getId());
                            Set<Integer> daCapNhat = new HashSet<>();

                            for (ChiTietHoaDon ct : dsCT) {
                                if (ct.getIdSeri() != null) {
                                    MaSeri seri = ct.getIdSeri();
                                    seri.setTrangThai(0); // 0 = Đã bán
                                    maSeriRepository.update(seri);

                                    if (seri.getCauHinhSanPham() != null) {
                                        Integer idCH = seri.getCauHinhSanPham().getId();
                                        if (daCapNhat.add(idCH)) {
                                            chiTietSanPhamRepository.capNhatTonKhoTheoImei(idCH);
                                        }
                                    }
                                }
                            }

                            // 🟢 3. Ghi lịch sử thanh toán & lịch sử hóa đơn
                            try {
                                LichSuThanhToan lstt = new LichSuThanhToan();
                                lstt.setHoaDon(hd);
                                lstt.setPhuongThucThanhToan("Chuyển khoản SePay");
                                lstt.setSoTien(amountIn);
                                lstt.setNgayThanhToan(new Date());
                                lstt.setTrangThaiThanhToan(1);
                                lstt.setTrangThai(1);
                                lichSuThanhToanRepo.add(lstt);
                            } catch (Exception e) {
                                System.out.println("⚠️ Bỏ qua ghi Lịch sử thanh toán: " + e.getMessage());
                            }

                            try {
                                LichSuHoaDon lshd = new LichSuHoaDon();
                                lshd.setHoaDon(hd);
                                lshd.setNgayTao(new Date());
                                lshd.setGhiChu("SePay Webhook: Gạch nợ tự động thành công");
                                lshd.setTrangThai(1);
                                lichSuHoaDonRepo.add(lshd);
                            } catch (Exception e) {
                                System.out.println("⚠️ Bỏ qua ghi Lịch sử hóa đơn: " + e.getMessage());
                            }
                        } else {
                            System.out.println("Tiền nhận (" + amountIn + ") nhỏ hơn tổng tiền đơn (" + tongTien + ")");
                        }
                    } else {
                        System.out.println("ℹHóa đơn " + hd.getMaHoaDon() + " đã ở trạng thái đã thanh toán trước đó.");
                    }
                } else {
                    System.out.println("KHÔNG TÌM THẤY HÓA ĐƠN NÀO KHỚP MÃ: [" + maHoaDon + "] TRONG CSDL!");
                }
            } else {
                System.out.println(" Nội dung chuyển khoản không tìm thấy chuỗi định dạng 'HD...'");
            }

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":true}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
        System.out.println("==================================================");
    }
}