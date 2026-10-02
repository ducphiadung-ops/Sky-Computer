package demo.servlet;

import demo.entity.san_pham.*;

import demo.repository.san_pham.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "SanPhamServlet", value = {
        "/san-pham/hien-thi",
        "/san-pham/them",
        "/san-pham/sua",
        "/san-pham/xoa",
        "/san-pham/giao-dien-them",
        "/san-pham/check-imei",
        "/san-pham/check-ten"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class SanPhamServlet extends HttpServlet {
    private final SanPhamRepository sanPhamRepo = new SanPhamRepository();
    private final ThuongHieuRepository thuongHieuRepo = new ThuongHieuRepository();
    private final DanhMucRepository danhMucRepo = new DanhMucRepository();
    private final CpuRepository cpuRepo = new CpuRepository();
    private final RamRepository ramRepo = new RamRepository();
    private final OCungRepository oCungRepo = new OCungRepository();
    private final GpuRepository gpuRepo = new GpuRepository();
    private final ManHinhRepository manHinhRepo = new ManHinhRepository();
    private final MauSacRepository mauSacRepo = new MauSacRepository();
    private final PinRepository pinRepo = new PinRepository();
    private final MaSeriRepository maSeriRepo = new MaSeriRepository();
    private final CauHinhSanPhamRepository cauHinhRepo = new CauHinhSanPhamRepository();
    private final ChiTietSanPhamRepository ctspRepo = new ChiTietSanPhamRepository();

    private final PhieuNhapRepository phieuNhapRepo = new PhieuNhapRepository();
    private final ChiTietPhieuNhapRepository chiTietPhieuNhapRepo = new ChiTietPhieuNhapRepository();
    private final NhaCungCapRepository nhaCungCapRepo = new NhaCungCapRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Nhân viên không được vào trang thêm / sửa sản phẩm
        if (!path.equals("/san-pham/hien-thi")) {
            Object nvObj = req.getSession(false) != null ? req.getSession().getAttribute("nhanVien") : null;
            demo.entity.nhan_vien.NhanVien nv = (nvObj instanceof demo.entity.nhan_vien.NhanVien)
                    ? (demo.entity.nhan_vien.NhanVien) nvObj : null;
            boolean isNhanVien = LoginServlet.isNhanVienRole(nv != null ? nv.getChucVu() : null);
            if (isNhanVien) {
                resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
                return;
            }
        }

        if (path.equals("/san-pham/hien-thi")) {
            hienThiDanhSach(req, resp);
        } else if (path.equals("/san-pham/sua")) {
            hienThiFormSua(req, resp);
        } else if (path.equals("/san-pham/giao-dien-them")) {
            hienThiFormThemGop(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Nhân viên không được thêm/sửa/xóa sản phẩm
        Object nvObjPost = req.getSession(false) != null ? req.getSession().getAttribute("nhanVien") : null;
        demo.entity.nhan_vien.NhanVien nv = (nvObjPost instanceof demo.entity.nhan_vien.NhanVien)
                ? (demo.entity.nhan_vien.NhanVien) nvObjPost : null;
        boolean isNhanVien = LoginServlet.isNhanVienRole(nv != null ? nv.getChucVu() : null);
        if (isNhanVien) {
            req.getSession().setAttribute("errorMessage", "Bạn không có quyền thực hiện thao tác này.");
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
            return;
        }

        if (path.equals("/san-pham/them")) {
            xuLyThemMoi(req, resp);
        } else if (path.equals("/san-pham/sua")) {
            xuLyCapNhat(req, resp);
        } else if (path.equals("/san-pham/xoa")) {
            xuLyXoa(req, resp);
        } else if (path.equals("/san-pham/check-imei")) {
            xuLyCheckImei(req, resp);
        } else if (path.equals("/san-pham/check-ten")) {
            xuLyCheckTenSanPham(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
        }
    }

    private void hienThiFormThemGop(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try { req.setAttribute("listThuongHieu", thuongHieuRepo.getAll()); } catch (Exception e) { req.setAttribute("listThuongHieu", new ArrayList<>()); }
        try { req.setAttribute("listDanhMuc", danhMucRepo.getAll()); } catch (Exception e) { req.setAttribute("listDanhMuc", new ArrayList<>()); }
        try { req.setAttribute("listCpu", cpuRepo.getAll()); } catch (Exception e) { req.setAttribute("listCpu", new ArrayList<>()); }
        try { req.setAttribute("listRam", ramRepo.getAllDistinctByDungLuong()); } catch (Exception e) { req.setAttribute("listRam", new ArrayList<>()); }
        try { req.setAttribute("listOCung", oCungRepo.getAllDistinctByDungLuong()); } catch (Exception e) { req.setAttribute("listOCung", new ArrayList<>()); }
        try { req.setAttribute("listGpu", gpuRepo.getAll()); } catch (Exception e) { req.setAttribute("listGpu", new ArrayList<>()); }
        try { req.setAttribute("listManHinh", manHinhRepo.getAll()); } catch (Exception e) { req.setAttribute("listManHinh", new ArrayList<>()); }
        try { req.setAttribute("listMauSac", mauSacRepo.getAll()); } catch (Exception e) { req.setAttribute("listMauSac", new ArrayList<>()); }
        try { req.setAttribute("listPin", pinRepo.getAll()); } catch (Exception e) { req.setAttribute("listPin", new ArrayList<>()); }
        try { req.setAttribute("listNhaCungCap", nhaCungCapRepo.getAll()); } catch (Exception e) { req.setAttribute("listNhaCungCap", new ArrayList<>()); }

        req.getRequestDispatcher("/demo/san_pham/them.jsp").forward(req, resp);
    }

    private void xuLyThemMoi(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();

        try {
            String ten = req.getParameter("tenSanPham");
            String moTa = req.getParameter("moTa");

            if (ten == null || ten.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Thất bại: Tên sản phẩm không được để trống!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                return;
            }

            ten = ten.trim().replaceAll("\\s+", " ");

            if (ten.length() < 5 || ten.length() > 150) {
                session.setAttribute("errorMessage", "Thất bại: Tên sản phẩm phải từ 5 đến 150 ký tự!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                return;
            }

            String regexTen = "^[a-zA-Z0-9 ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰYÝỲỶỸỵỷỹýỳỹ\\-_ .()]+$";
            if (!ten.matches(regexTen)) {
                session.setAttribute("errorMessage", "Thất bại: Tên sản phẩm chứa ký tự đặc biệt không hợp lệ!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                return;
            }

            if (sanPhamRepo.checkTrungTen(ten)) {
                session.setAttribute("errorMessage", "Thất bại: Tên sản phẩm [" + ten + "] đã tồn tại trong hệ thống!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                return;
            }

            if (req.getParameter("idThuongHieu") == null || req.getParameter("idDanhMuc") == null || req.getParameter("idNhaCungCapForm") == null) {
                session.setAttribute("errorMessage", "Thất bại: Vui lòng chọn đầy đủ Thương hiệu, Danh mục và Nhà cung cấp!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                return;
            }

            Integer idThuongHieu = Integer.parseInt(req.getParameter("idThuongHieu"));
            Integer idDanhMuc = Integer.parseInt(req.getParameter("idDanhMuc"));

            String[] arrGiaBan = req.getParameterValues("giaBanDong");
            String[] arrMauSac = req.getParameterValues("idMauSacDong");
            String[] arrRam = req.getParameterValues("idRamDong");
            String[] arrOCung = req.getParameterValues("idOCungDong");
            String[] arrGiaNhap = req.getParameterValues("giaNhapDong");
            String[] arrSoSeri = req.getParameterValues("soSeriDong");

            if (arrMauSac == null || arrMauSac.length == 0) {
                session.setAttribute("errorMessage", "Thất bại: Vui lòng sinh cấu hình biến thể trước khi lưu!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                return;
            }

            // ==========================================
            // 🟢 VALIDATE TOÀN BỘ LOGIC GIÁ & IMEI
            // ==========================================
            Set<String> formUniqueCheck = new HashSet<>();
            List<String> danhSachImeiLoiDinhDang = new ArrayList<>();
            List<String> danhSachImeiTrungTrenForm = new ArrayList<>();
            List<String> danhSachImeiTrungHeThong = new ArrayList<>();
            String regexImeiHopLe = "^[A-Z0-9\\-_]{8,30}$";

            for (int i = 0; i < arrMauSac.length; i++) {
                BigDecimal giaBan = (arrGiaBan != null && arrGiaBan.length > i && !arrGiaBan[i].trim().isEmpty())
                        ? new BigDecimal(arrGiaBan[i].trim()) : BigDecimal.ZERO;
                BigDecimal giaNhap = (arrGiaNhap != null && arrGiaNhap.length > i && !arrGiaNhap[i].trim().isEmpty())
                        ? new BigDecimal(arrGiaNhap[i].trim()) : BigDecimal.ZERO;
                String chuoiImei = (arrSoSeri != null && arrSoSeri.length > i) ? arrSoSeri[i] : "";

                // Validate logic giá tiền
                if (giaNhap.compareTo(BigDecimal.ZERO) <= 0 || giaBan.compareTo(BigDecimal.ZERO) <= 0) {
                    session.setAttribute("errorMessage", "Thất bại: Đơn giá bán và nhập kho phải lớn hơn 0đ!");
                    resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                    return;
                }
                if (giaBan.compareTo(giaNhap) < 0) {
                    session.setAttribute("errorMessage", "Thất bại: Giá bán không được nhỏ hơn giá nhập kho!");
                    resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                    return;
                }

                // Tách các mã IMEI từ TextArea
                String[] mangImei = new String[0];
                if (chuoiImei != null && !chuoiImei.trim().isEmpty()) {
                    String cleanChuoi = chuoiImei.replaceAll("\\r\\n", "\n").replaceAll("\\r", "\n");
                    mangImei = cleanChuoi.split("[,\n]+");
                }

                if (mangImei.length == 0) {
                    session.setAttribute("errorMessage", "Thất bại: Mọi dòng cấu hình biến thể bắt buộc phải có ít nhất 1 mã IMEI!");
                    resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                    return;
                }

                for (String imei : mangImei) {
                    // Làm sạch IMEI: Xóa khoảng trắng, in hoa
                    String cleanImei = imei.trim().replaceAll("\\s+", "").toUpperCase();
                    if (cleanImei.isEmpty()) continue;

                    // Validate Định dạng (8-30 ký tự, A-Z, 0-9, -, _)
                    if (!cleanImei.matches(regexImeiHopLe)) {
                        if (!danhSachImeiLoiDinhDang.contains(cleanImei)) {
                            danhSachImeiLoiDinhDang.add(cleanImei);
                        }
                    }

                    // Check trùng trên Form
                    if (!formUniqueCheck.add(cleanImei)) {
                        if (!danhSachImeiTrungTrenForm.contains(cleanImei)) {
                            danhSachImeiTrungTrenForm.add(cleanImei);
                        }
                    }

                    // Check trùng Database
                    if (maSeriRepo.checkTrungImei(cleanImei)) {
                        if (!danhSachImeiTrungHeThong.contains(cleanImei)) {
                            danhSachImeiTrungHeThong.add(cleanImei);
                        }
                    }
                }
            }

            // ==========================================
            // ❌ TRẢ VỀ CÁC THÔNG BÁO LỖI NẾU IMEI VI PHẠM
            // ==========================================
            if (!danhSachImeiLoiDinhDang.isEmpty()) {
                session.setAttribute("errorMessage", "Thất bại: Các mã IMEI sau sai định dạng (chỉ gồm A-Z, 0-9, -, _ và từ 8-30 ký tự): " + String.join(", ", danhSachImeiLoiDinhDang));
                resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                return;
            }

            if (!danhSachImeiTrungTrenForm.isEmpty()) {
                session.setAttribute("errorMessage", "Không thể thêm! Phát hiện mã IMEI trùng nhau ngay trên form nhập: " + String.join(", ", danhSachImeiTrungTrenForm));
                resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                return;
            }

            if (!danhSachImeiTrungHeThong.isEmpty()) {
                session.setAttribute("errorMessage", "Không thể thêm! Các mã IMEI sau đã tồn tại trong kho Database: " + String.join(", ", danhSachImeiTrungHeThong));
                resp.sendRedirect(req.getContextPath() + "/san-pham/giao-dien-them");
                return;
            }

            // ==========================================
            // 🟢 TIẾP TỤC LUỒNG LƯU VÀO DATABASE NẾU THÀNH CÔNG
            // ==========================================
            BigDecimal giaDaiDien = (arrGiaBan != null && arrGiaBan.length > 0 && !arrGiaBan[0].trim().isEmpty())
                    ? new BigDecimal(arrGiaBan[0].trim()) : BigDecimal.ZERO;
            ThuongHieu thuongHieuDuocChon = thuongHieuRepo.getOne(idThuongHieu);
            // Tạo mã tạm để tránh lỗi NOT NULL, sẽ được cập nhật sau khi có id
            String maTam = "SP_TMP_" + System.currentTimeMillis();

            SanPham sp = new SanPham();
            sp.setMaSanPham(maTam);
            sp.setTenSanPham(ten);
            sp.setMoTa(moTa);
            sp.setGiaBan(giaDaiDien);
            sp.setThuongHieu(thuongHieuDuocChon);
            sp.setDanhMuc(danhMucRepo.getOne(idDanhMuc));
            sp.setNgayTao(LocalDate.now());
            sp.setTrangThai(1);
            sp.setSoLuongTon(0);

            sanPhamRepo.add(sp);

            sp = sanPhamRepo.getOne(sp.getId() != null ? sp.getId() : sanPhamRepo.getAll().get(sanPhamRepo.getAll().size() - 1).getId());

            // Sinh mã sản phẩm theo format: SP_<Hãng>_<id 3 chữ số>
            // Ví dụ: SP_Dell_011
            String tenHang = (thuongHieuDuocChon != null && thuongHieuDuocChon.getTenThuongHieu() != null)
                    ? thuongHieuDuocChon.getTenThuongHieu().trim().replaceAll("\\s+", "")
                    : "Unknown";
            String maTuSinh = String.format("SP_%s_%03d", tenHang, sp.getId());
            sp.setMaSanPham(maTuSinh);
            sanPhamRepo.update(sp);

            Integer idCpu = Integer.parseInt(req.getParameter("idCpu"));
            Integer idGpu = Integer.parseInt(req.getParameter("idGpu"));
            Integer idManHinh = Integer.parseInt(req.getParameter("idManHinh"));
            Integer idPin = Integer.parseInt(req.getParameter("idPin"));
            String heDieuHanh = req.getParameter("heDieuHanh");

            int tongSoLuongMayTrongKho = 0;
            Integer idNhaCungCapDuocChon = Integer.parseInt(req.getParameter("idNhaCungCapForm"));

            PhieuNhap phieuNhapAo = new PhieuNhap();
            phieuNhapAo.setIdNhaCungCap(idNhaCungCapDuocChon);
            phieuNhapAo.setNgayNhap(LocalDateTime.now());
            phieuNhapAo.setTongTien(BigDecimal.ZERO);
            phieuNhapRepo.add(phieuNhapAo);

            for (int i = 0; i < arrMauSac.length; i++) {
                Integer idMau = Integer.parseInt(arrMauSac[i]);
                Integer idRam = Integer.parseInt(arrRam[i]);
                Integer idOCung = Integer.parseInt(arrOCung[i]);

                BigDecimal giaBan = new BigDecimal(arrGiaBan[i].trim());
                BigDecimal giaNhap = new BigDecimal(arrGiaNhap[i].trim());
                String chuoiImei = arrSoSeri[i];

                CauHinhSanPham ch = new CauHinhSanPham();
                ch.setSanPham(sp);
                ch.setCpu(cpuRepo.getOne(idCpu));
                ch.setGpu(gpuRepo.getOne(idGpu));
                ch.setManHinh(manHinhRepo.getOne(idManHinh));
                ch.setPin(pinRepo.getOne(idPin));
                ch.setHeDieuHanh(heDieuHanh);
                ch.setMauSac(mauSacRepo.getOne(idMau));
                ch.setRam(ramRepo.getOne(idRam));
                ch.setOCung(oCungRepo.getOne(idOCung));
                cauHinhRepo.add(ch);

                String[] mangImei = chuoiImei.replaceAll("\\r\\n", "\n").replaceAll("\\r", "\n").split("[,\n]+");
                List<String> validImeisList = new ArrayList<>();
                for (String imei : mangImei) {
                    // Xóa khoảng trắng lần nữa trước khi add vào List lưu DB
                    String cleanImei = imei.trim().replaceAll("\\s+", "").toUpperCase();
                    if (!cleanImei.isEmpty()) {
                        validImeisList.add(cleanImei);
                    }
                }

                int soLuongImeiHopLe = validImeisList.size();

                ChiTietPhieuNhap ctpn = new ChiTietPhieuNhap();
                ctpn.setPhieuNhap(phieuNhapAo);
                ctpn.setCauHinhSanPham(ch);
                ctpn.setSoLuong(soLuongImeiHopLe);
                ctpn.setGiaNhap(giaNhap);
                chiTietPhieuNhapRepo.add(ctpn);

                ChiTietSanPham ctsp = new ChiTietSanPham();
                ctsp.setSanPham(sp);
                ctsp.setCauHinhSanPham(ch);
                ctsp.setDonGia(giaBan);
                ctsp.setGiaNhap(giaNhap);
                ctsp.setTonKho(soLuongImeiHopLe);
                ctsp.setTrangThai(1);
                ctspRepo.add(ctsp);

                for (String cleanImei : validImeisList) {
                    MaSeri maSeriObj = new MaSeri();
                    maSeriObj.setCauHinhSanPham(ch);
                    maSeriObj.setChiTietPhieuNhap(ctpn);
                    maSeriObj.setSoSeri(cleanImei);
                    maSeriObj.setNgayNhap(LocalDate.now());
                    maSeriObj.setTrangThai(1);
                    maSeriRepo.add(maSeriObj);
                }
                tongSoLuongMayTrongKho += soLuongImeiHopLe;
            }

            sp.setSoLuongTon(tongSoLuongMayTrongKho);
            sanPhamRepo.update(sp);

            session.setAttribute("successMessage", "Thêm mới sản phẩm cha và toàn bộ biến thể thành công!");
        } catch (Exception e) {
            String errorMsg = e.getMessage() != null ? e.getMessage() : e.toString();
            session.setAttribute("errorMessage", "Lỗi lưu DB thực tế: " + errorMsg);
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
    }

    // ==========================================
    // 🟢 API CHECK TRÙNG IMEI - Trả về JSON
    // POST /san-pham/check-imei
    // Body param: imeiList = chuỗi IMEI phân cách bởi dấu phẩy
    // Response: {"trungDB":["IMEI1","IMEI2"],"trungForm":[]}
    // ==========================================
    private void xuLyCheckImei(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        String imeiListParam = req.getParameter("imeiList");
        // imeiDaDiemParam: danh sách IMEI đã được lưu ở các biến thể khác trên form (để check trùng form)
        String imeiDaDiemParam = req.getParameter("imeiDaDiem");

        List<String> trungDB = new ArrayList<>();
        List<String> trungForm = new ArrayList<>();

        if (imeiListParam != null && !imeiListParam.trim().isEmpty()) {
            String[] mangImei = imeiListParam.trim().split(",");

            // Tập IMEI đã điền ở biến thể khác
            Set<String> setDaDiem = new HashSet<>();
            if (imeiDaDiemParam != null && !imeiDaDiemParam.trim().isEmpty()) {
                for (String s : imeiDaDiemParam.trim().split(",")) {
                    String clean = s.trim().toUpperCase();
                    if (!clean.isEmpty()) setDaDiem.add(clean);
                }
            }

            for (String raw : mangImei) {
                String imei = raw.trim().toUpperCase();
                if (imei.isEmpty()) continue;

                // Check trùng database
                if (maSeriRepo.checkTrungImei(imei)) {
                    trungDB.add(imei);
                }
                // Check trùng IMEI đã điền ở biến thể khác
                else if (setDaDiem.contains(imei)) {
                    trungForm.add(imei);
                }
            }
        }

        // Xây dựng JSON response thủ công (không cần thư viện ngoài)
        StringBuilder json = new StringBuilder("{");
        json.append("\"trungDB\":[");
        for (int i = 0; i < trungDB.size(); i++) {
            if (i > 0) json.append(",");
            json.append("\"").append(escapeJson(trungDB.get(i))).append("\"");
        }
        json.append("],\"trungForm\":[");
        for (int i = 0; i < trungForm.size(); i++) {
            if (i > 0) json.append(",");
            json.append("\"").append(escapeJson(trungForm.get(i))).append("\"");
        }
        json.append("]}");

        PrintWriter out = resp.getWriter();
        out.print(json.toString());
        out.flush();
    }

    // ==========================================
    // 🟢 API CHECK TRÙNG TÊN SẢN PHẨM - Trả về JSON
    // POST /san-pham/check-ten
    // Body param: tenSanPham = tên cần kiểm tra
    // Response: {"trung": true/false}
    // ==========================================
    private void xuLyCheckTenSanPham(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        String ten = req.getParameter("tenSanPham");
        boolean trung = false;

        if (ten != null && !ten.trim().isEmpty()) {
            ten = ten.trim().replaceAll("\\s+", " ");
            trung = sanPhamRepo.checkTrungTen(ten);
        }

        PrintWriter out = resp.getWriter();
        out.print("{\"trung\":" + trung + "}");
        out.flush();
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private static final int PAGE_SIZE = 10;

    private void hienThiDanhSach(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // --- đọc tham số lọc từ request ---
        String keyword         = req.getParameter("keyword");
        String idThuongHieuStr = req.getParameter("idThuongHieu");
        String trangThaiStr    = req.getParameter("trangThai");
        String giaMinStr       = req.getParameter("giaMin");
        String giaMaxStr       = req.getParameter("giaMax");
        String pageStr         = req.getParameter("page");

        Integer idThuongHieu = null;
        Integer trangThai    = null;
        java.math.BigDecimal giaMin = null;
        java.math.BigDecimal giaMax = null;
        int currentPage = 1;

        try { if (idThuongHieuStr != null && !idThuongHieuStr.isEmpty()) idThuongHieu = Integer.parseInt(idThuongHieuStr); } catch (Exception ignored) {}
        try { if (trangThaiStr    != null && !trangThaiStr.isEmpty())    trangThai    = Integer.parseInt(trangThaiStr);    } catch (Exception ignored) {}
        try { if (giaMinStr       != null && !giaMinStr.isEmpty())       giaMin       = new java.math.BigDecimal(giaMinStr); } catch (Exception ignored) {}
        try { if (giaMaxStr       != null && !giaMaxStr.isEmpty())       giaMax       = new java.math.BigDecimal(giaMaxStr); } catch (Exception ignored) {}
        try { if (pageStr         != null && !pageStr.isEmpty())         currentPage  = Math.max(1, Integer.parseInt(pageStr)); } catch (Exception ignored) {}

        // Mặc định hiển thị sản phẩm đang hoạt động khi vào trang lần đầu
        boolean coLoc = (keyword != null && !keyword.isEmpty())
                || idThuongHieu != null
                || (trangThaiStr != null && !trangThaiStr.isEmpty())
                || giaMin != null || giaMax != null;

        // Nếu không có bộ lọc nào và trangThai chưa được set → mặc định = 1 (đang hoạt động)
        if (!coLoc && trangThai == null) {
            trangThai = 1;
            trangThaiStr = "1";
        }

        // --- đếm tổng để tính số trang ---
        long totalRecords = sanPhamRepo.countLocDaKieu(
                keyword,
                null,
                idThuongHieu,
                trangThai,
                giaMin,
                giaMax
        );

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * PAGE_SIZE;

        // --- lấy trang hiện tại ---
        List listSanPham = sanPhamRepo.locDaKieuPhanTrang(
                keyword,
                null,
                idThuongHieu,
                trangThai,
                giaMin,
                giaMax,
                offset, PAGE_SIZE
        );

        // --- lấy min/max giá để render thanh kéo ---
        java.math.BigDecimal[] minMax = sanPhamRepo.getMinMaxGiaBan();

        try { req.setAttribute("listSanPham",    listSanPham); }                                      catch (Exception e) { req.setAttribute("listSanPham", new ArrayList<>()); }
        try { req.setAttribute("listThuongHieu", thuongHieuRepo.getAll()); }                          catch (Exception e) { req.setAttribute("listThuongHieu", new ArrayList<>()); }
        try { req.setAttribute("listDanhMuc",    danhMucRepo.getAll()); }                             catch (Exception e) { req.setAttribute("listDanhMuc", new ArrayList<>()); }
        try { req.setAttribute("mapSoBienThe",   maSeriRepo.demImeiConHangTheoSanPham()); }            catch (Exception e) { req.setAttribute("mapSoBienThe", new java.util.HashMap<>()); }
        try { req.setAttribute("mapKhoangGia",   ctspRepo.getMinMaxDonGiaTheoSanPham()); }            catch (Exception e) { req.setAttribute("mapKhoangGia", new java.util.HashMap<>()); }

        req.setAttribute("priceAbsMin",     minMax[0].longValue());
        req.setAttribute("priceAbsMax",     minMax[1].longValue());
        req.setAttribute("priceCurrentMax", giaMax != null ? giaMax.longValue() : minMax[1].longValue());

        // giữ lại giá trị cũ để hiển thị lại form
        req.setAttribute("oldKeyword",    keyword      != null ? keyword      : "");
        req.setAttribute("oldThuongHieu", idThuongHieu);
        req.setAttribute("oldTrangThai",  trangThaiStr != null ? trangThaiStr : "");
        req.setAttribute("oldGiaMin",     giaMin  != null ? giaMin.longValue()  : minMax[0].longValue());
        req.setAttribute("oldGiaMax",     giaMax  != null ? giaMax.longValue()  : minMax[1].longValue());

        // phân trang
        req.setAttribute("currentPage",  currentPage);
        req.setAttribute("totalPages",   totalPages);
        req.setAttribute("totalRecords", totalRecords);
        req.setAttribute("pageSize",     PAGE_SIZE);
        req.setAttribute("offset",       offset);

        req.getRequestDispatcher("/demo/san_pham/hien_thi.jsp").forward(req, resp);
    }

    private void hienThiFormSua(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("sanPham", sanPhamRepo.getOne(id));
            req.setAttribute("listThuongHieu", thuongHieuRepo.getAll());
            req.setAttribute("listDanhMuc", danhMucRepo.getAll());
            req.getRequestDispatcher("/demo/san_pham/form_sua.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
        }
    }

    private void xuLyCapNhat(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        try {
            String idRaw = req.getParameter("id");
            String ten = req.getParameter("tenSanPham");
            String idThuongHieuRaw = req.getParameter("idThuongHieu");
            String idDanhMucRaw = req.getParameter("idDanhMuc");
            String trangThaiRaw = req.getParameter("trangThai");

            // 🟢 1. VALIDATE BẮT BUỘC NHẬP DỮ LIỆU
            if (idRaw == null || idRaw.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Không tìm thấy mã ID sản phẩm cần cập nhật!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
                return;
            }

            Integer id = Integer.parseInt(idRaw.trim());

            if (ten == null || ten.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Thất bại: Tên sản phẩm không được để trống!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/sua?id=" + id);
                return;
            }

            // 🟢 2. CHUẨN HÓA KHOẢNG TRẮNG DƯ THỪA (Ví dụ: "Dell   XPS" -> "Dell XPS")
            ten = ten.trim().replaceAll("\\s+", " ");

            // 🟢 3. VALIDATE ĐỘ DÀI TÊN SẢN PHẨM (Từ 5 đến 150 ký tự)
            if (ten.length() < 5 || ten.length() > 150) {
                session.setAttribute("errorMessage", "Thất bại: Tên sản phẩm phải từ 5 đến 150 ký tự!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/sua?id=" + id);
                return;
            }

            String regexTen = "^[a-zA-Z0-9 ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰYÝỲỶỸỵỷỹýỳỹ\\-_ .()]+$";
            if (!ten.matches(regexTen)) {
                session.setAttribute("errorMessage", "Thất bại: Tên sản phẩm chứa ký tự đặc biệt không hợp lệ!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/sua?id=" + id);
                return;
            }

            if (sanPhamRepo.checkTrungTenKhiSua(ten, id)) {
                session.setAttribute("errorMessage", "Thất bại: Tên sản phẩm [" + ten + "] đã được sử dụng bởi sản phẩm khác!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/sua?id=" + id);
                return;
            }

            if (idThuongHieuRaw == null || idDanhMucRaw == null) {
                session.setAttribute("errorMessage", "Thất bại: Vui lòng chọn đầy đủ Thương hiệu và Danh mục!");
                resp.sendRedirect(req.getContextPath() + "/san-pham/sua?id=" + id);
                return;
            }

            Integer idThuongHieu = Integer.parseInt(idThuongHieuRaw.trim());
            Integer idDanhMuc = Integer.parseInt(idDanhMucRaw.trim());
            Integer trangThai = trangThaiRaw != null && (trangThaiRaw.equalsIgnoreCase("true") || trangThaiRaw.equals("1")) ? 1 : 0;

            SanPham sp = sanPhamRepo.getOne(id);
            if (sp != null) {
                sp.setTenSanPham(ten);
                sp.setThuongHieu(thuongHieuRepo.getOne(idThuongHieu));
                sp.setDanhMuc(danhMucRepo.getOne(idDanhMuc));
                sp.setTrangThai(trangThai);
                sanPhamRepo.update(sp);
                session.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
            } else {
                session.setAttribute("errorMessage", "Không tìm thấy sản phẩm cần cập nhật trong cơ sở dữ liệu!");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Thất bại: Dữ liệu ID hoặc thuộc tính không phải là số hợp lệ!");
            e.printStackTrace();
        } catch (Exception e) {
            String errorMsg = e.getMessage() != null ? e.getMessage() : e.toString();
            session.setAttribute("errorMessage", "Cập nhật thất bại do lỗi hệ thống: " + errorMsg);
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
    }

    private void xuLyXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        try {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                Integer id = Integer.parseInt(idStr);
                SanPham sp = sanPhamRepo.getOne(id);

                if (sp != null) {
                    sp.setTrangThai(sp.getTrangThai() != null && sp.getTrangThai() == 1 ? 0 : 1);
                    sanPhamRepo.update(sp);
                    session.setAttribute("successMessage", "Cập nhật trạng thái kinh doanh thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không tìm thấy sản phẩm!");
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại do hệ thống!");
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
    }
}