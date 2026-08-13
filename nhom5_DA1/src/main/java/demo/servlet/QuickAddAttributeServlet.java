package demo.servlet;

import demo.entity.san_pham.*;
import demo.repository.san_pham.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * API thêm nhanh thuộc tính từ form tạo sản phẩm.
 * POST /san-pham/them-nhanh-thuoc-tinh
 *
 * Param bắt buộc:
 *   loai = mauSac | ram | oCung | manHinh | pin | cpu | gpu
 *
 * Params theo loại:
 *   mauSac  : tenMauSac
 *   ram     : tenRam, dungLuongRam
 *   oCung   : tenOCung, dungLuongOCung
 *   manHinh : tenManHinh, kichThuoc, doPhanGiai, tanSoQuet
 *   pin     : tenPin, dungLuongPin
 *   cpu     : tenCpu, theHeCpu
 *   gpu     : tenGpu, dungLuongGpu
 *
 * Response JSON:
 *   { "success": true,  "id": 5, "label": "Intel Core i5-13500H" }
 *   { "success": false, "message": "Tên không được để trống" }
 */
@WebServlet("/san-pham/them-nhanh-thuoc-tinh")
public class QuickAddAttributeServlet extends HttpServlet {

    private final MauSacRepository mauSacRepo  = new MauSacRepository();
    private final RamRepository    ramRepo      = new RamRepository();
    private final OCungRepository  oCungRepo    = new OCungRepository();
    private final ManHinhRepository manHinhRepo = new ManHinhRepository();
    private final PinRepository    pinRepo      = new PinRepository();
    private final CpuRepository    cpuRepo      = new CpuRepository();
    private final GpuRepository    gpuRepo      = new GpuRepository();
    private final DanhMucRepository   danhMucRepo    = new DanhMucRepository();
    private final ThuongHieuRepository thuongHieuRepo = new ThuongHieuRepository();
    private final NhaCungCapRepository nhaCungCapRepo = new NhaCungCapRepository();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        // Chỉ admin mới được thêm thuộc tính
        Object nvObj = req.getSession(false) != null
                ? req.getSession().getAttribute("nhanVien") : null;
        demo.entity.nhan_vien.NhanVien nv =
                (nvObj instanceof demo.entity.nhan_vien.NhanVien)
                        ? (demo.entity.nhan_vien.NhanVien) nvObj : null;
        if (LoginServlet.isNhanVienRole(nv != null ? nv.getChucVu() : null)) {
            jsonError(resp, "Bạn không có quyền thực hiện thao tác này.");
            return;
        }

        String loai = trim(req.getParameter("loai"));
        if (loai == null) { jsonError(resp, "Thiếu tham số loại thuộc tính."); return; }

        try {
            switch (loai) {
                case "mauSac"    -> themMauSac(req, resp);
                case "ram"       -> themRam(req, resp);
                case "oCung"     -> themOCung(req, resp);
                case "manHinh"   -> themManHinh(req, resp);
                case "pin"       -> themPin(req, resp);
                case "cpu"       -> themCpu(req, resp);
                case "gpu"       -> themGpu(req, resp);
                case "danhMuc"   -> themDanhMuc(req, resp);
                case "thuongHieu"-> themThuongHieu(req, resp);
                case "nhaCungCap"-> themNhaCungCap(req, resp);
                default          -> jsonError(resp, "Loại thuộc tính không hợp lệ: " + loai);
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonError(resp, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    // ===================== MÀU SẮC =====================
    private void themMauSac(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten = trim(req.getParameter("tenMauSac"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên màu sắc không được để trống."); return; }
        if (mauSacRepo.existsDuplicate(ten, null)) { jsonError(resp, "Màu sắc \"" + ten + "\" đã tồn tại."); return; }
        MauSac obj = new MauSac();
        obj.setTenMauSac(ten);
        obj.setTrangThai(1);
        mauSacRepo.add(obj);
        MauSac saved = findLastMauSac(ten);
        jsonOk(resp, saved != null ? saved.getId() : 0, ten);
    }

    // ===================== RAM =====================
    private void themRam(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten  = trim(req.getParameter("tenRam"));
        String dung = trim(req.getParameter("dungLuongRam"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên RAM không được để trống."); return; }
        if (dung == null || dung.isEmpty()) { jsonError(resp, "Dung lượng RAM không được để trống."); return; }
        if (ramRepo.existsDuplicate(ten, dung, null)) { jsonError(resp, "RAM \"" + ten + " - " + dung + "\" đã tồn tại."); return; }
        Ram obj = new Ram();
        obj.setTenRam(ten);
        obj.setDungLuongRam(dung);
        obj.setTrangThai(1);
        ramRepo.add(obj);
        Ram saved = findLastRam(ten, dung);
        String label = dung;
        jsonOk(resp, saved != null ? saved.getId() : 0, label);
    }

    // ===================== Ổ CỨNG =====================
    private void themOCung(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten  = trim(req.getParameter("tenOCung"));
        String dung = trim(req.getParameter("dungLuongOCung"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên ổ cứng không được để trống."); return; }
        if (dung == null || dung.isEmpty()) { jsonError(resp, "Dung lượng ổ cứng không được để trống."); return; }
        if (oCungRepo.existsDuplicate(ten, dung, null)) { jsonError(resp, "Ổ cứng \"" + ten + " - " + dung + "\" đã tồn tại."); return; }
        OCung obj = new OCung();
        obj.setTenOCung(ten);
        obj.setDungLuongOCung(dung);
        obj.setTrangThai(1);
        oCungRepo.add(obj);
        OCung saved = findLastOCung(ten, dung);
        jsonOk(resp, saved != null ? saved.getId() : 0, dung);
    }

    // ===================== MÀN HÌNH =====================
    private void themManHinh(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten   = trim(req.getParameter("tenManHinh"));
        String kich  = trim(req.getParameter("kichThuoc"));
        String dpg   = trim(req.getParameter("doPhanGiai"));
        String tsq   = trim(req.getParameter("tanSoQuet"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên màn hình không được để trống."); return; }
        if (manHinhRepo.existsDuplicate(ten, kich, dpg, tsq, null)) { jsonError(resp, "Màn hình \"" + ten + "\" đã tồn tại."); return; }
        ManHinh obj = new ManHinh();
        obj.setTenManHinh(ten);
        obj.setKichThuoc(kich);
        obj.setDoPhanGiai(dpg);
        obj.setTanSoQuet(tsq);
        obj.setTrangThai(1);
        manHinhRepo.add(obj);
        ManHinh saved = findLastManHinh(ten);
        String label = ten + (kich != null && !kich.isEmpty() ? " (" + kich + ")" : "");
        jsonOk(resp, saved != null ? saved.getId() : 0, label);
    }

    // ===================== PIN =====================
    private void themPin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten  = trim(req.getParameter("tenPin"));
        String dung = trim(req.getParameter("dungLuongPin"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên pin không được để trống."); return; }
        if (pinRepo.existsDuplicate(ten, dung, null)) { jsonError(resp, "Pin \"" + ten + "\" đã tồn tại."); return; }
        Pin obj = new Pin();
        obj.setTenPin(ten);
        obj.setDungLuongPin(dung != null ? dung : "");
        obj.setTrangThai(1);
        pinRepo.add(obj);
        Pin saved = findLastPin(ten);
        jsonOk(resp, saved != null ? saved.getId() : 0, ten);
    }

    // ===================== CPU =====================
    private void themCpu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten   = trim(req.getParameter("tenCpu"));
        String theHe = trim(req.getParameter("theHeCpu"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên CPU không được để trống."); return; }
        if (cpuRepo.existsDuplicate(ten, theHe, null)) { jsonError(resp, "CPU \"" + ten + "\" đã tồn tại."); return; }
        Cpu obj = new Cpu();
        obj.setTenCpu(ten);
        obj.setTheHeCpu(theHe != null ? theHe : "");
        obj.setTrangThai(1);
        cpuRepo.add(obj);
        Cpu saved = findLastCpu(ten);
        jsonOk(resp, saved != null ? saved.getId() : 0, ten);
    }

    // ===================== GPU =====================
    private void themGpu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten  = trim(req.getParameter("tenGpu"));
        String dung = trim(req.getParameter("dungLuongGpu"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên GPU không được để trống."); return; }
        if (gpuRepo.existsDuplicate(ten, dung, null)) { jsonError(resp, "GPU \"" + ten + "\" đã tồn tại."); return; }
        Gpu obj = new Gpu();
        obj.setTenGpu(ten);
        obj.setDungLuongGpu(dung != null ? dung : "");
        obj.setTrangThai(1);
        gpuRepo.add(obj);
        Gpu saved = findLastGpu(ten);
        jsonOk(resp, saved != null ? saved.getId() : 0, ten);
    }

    // ===================== DANH MỤC =====================
    private void themDanhMuc(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten = trim(req.getParameter("tenDanhMuc"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên danh mục không được để trống."); return; }
        if (danhMucRepo.existsDuplicate(ten, null)) { jsonError(resp, "Danh mục \"" + ten + "\" đã tồn tại."); return; }
        DanhMuc obj = new DanhMuc();
        obj.setTenDanhMuc(ten);
        obj.setTrangThai(1);
        danhMucRepo.add(obj);
        DanhMuc saved = danhMucRepo.getAll().stream()
                .filter(d -> d.getTenDanhMuc().equalsIgnoreCase(ten)).findFirst().orElse(null);
        jsonOk(resp, saved != null ? saved.getId() : 0, ten);
    }

    // ===================== THƯƠNG HIỆU =====================
    private void themThuongHieu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten = trim(req.getParameter("tenThuongHieu"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên thương hiệu không được để trống."); return; }
        if (thuongHieuRepo.existsDuplicate(ten, null)) { jsonError(resp, "Thương hiệu \"" + ten + "\" đã tồn tại."); return; }
        ThuongHieu obj = new ThuongHieu();
        obj.setTenThuongHieu(ten);
        obj.setTrangThai(1);
        thuongHieuRepo.add(obj);
        // ThuongHieuRepository dùng shared session — tạo repo mới để query fresh
        ThuongHieuRepository freshRepo = new ThuongHieuRepository();
        ThuongHieu saved = freshRepo.getAll().stream()
                .filter(t -> t.getTenThuongHieu().equalsIgnoreCase(ten)).findFirst().orElse(null);
        jsonOk(resp, saved != null ? saved.getId() : 0, ten);
    }

    // ===================== NHÀ CUNG CẤP =====================
    private void themNhaCungCap(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ten   = trim(req.getParameter("tenNhaCungCap"));
        String sdt   = trim(req.getParameter("sdt"));
        String diaChi= trim(req.getParameter("diaChi"));
        if (ten == null || ten.isEmpty()) { jsonError(resp, "Tên nhà cung cấp không được để trống."); return; }
        // Kiểm tra trùng tên (không có sẵn existsDuplicate nên tự check)
        boolean trung = nhaCungCapRepo.getAll().stream()
                .anyMatch(n -> n.getTenNhaCungCap().equalsIgnoreCase(ten));
        if (trung) { jsonError(resp, "Nhà cung cấp \"" + ten + "\" đã tồn tại."); return; }
        NhaCungCap obj = new NhaCungCap();
        obj.setTenNhaCungCap(ten);
        obj.setSDT(sdt != null ? sdt : "");
        obj.setDiaChi(diaChi != null ? diaChi : "");
        obj.setEmail("");
        nhaCungCapRepo.add(obj);
        NhaCungCap saved = nhaCungCapRepo.getAll().stream()
                .filter(n -> n.getTenNhaCungCap().equalsIgnoreCase(ten)).findFirst().orElse(null);
        jsonOk(resp, saved != null ? saved.getId() : 0, ten);
    }

    // ===================== HELPERS: tìm bản ghi vừa thêm =====================
    private MauSac findLastMauSac(String ten) {
        try { return mauSacRepo.getAll().stream()
                .filter(m -> m.getTenMauSac().equalsIgnoreCase(ten)).findFirst().orElse(null);
        } catch (Exception e) { return null; }
    }
    private Ram findLastRam(String ten, String dung) {
        try { return ramRepo.getAll().stream()
                .filter(r -> r.getTenRam().equalsIgnoreCase(ten) && r.getDungLuongRam().equalsIgnoreCase(dung))
                .findFirst().orElse(null);
        } catch (Exception e) { return null; }
    }
    private OCung findLastOCung(String ten, String dung) {
        try { return oCungRepo.getAll().stream()
                .filter(o -> o.getTenOCung().equalsIgnoreCase(ten) && o.getDungLuongOCung().equalsIgnoreCase(dung))
                .findFirst().orElse(null);
        } catch (Exception e) { return null; }
    }
    private ManHinh findLastManHinh(String ten) {
        try { return manHinhRepo.getAll().stream()
                .filter(m -> m.getTenManHinh().equalsIgnoreCase(ten)).findFirst().orElse(null);
        } catch (Exception e) { return null; }
    }
    private Pin findLastPin(String ten) {
        try { return pinRepo.getAll().stream()
                .filter(p -> p.getTenPin().equalsIgnoreCase(ten)).findFirst().orElse(null);
        } catch (Exception e) { return null; }
    }
    private Cpu findLastCpu(String ten) {
        try { return cpuRepo.getAll().stream()
                .filter(c -> c.getTenCpu().equalsIgnoreCase(ten)).findFirst().orElse(null);
        } catch (Exception e) { return null; }
    }
    private Gpu findLastGpu(String ten) {
        try { return gpuRepo.getAll().stream()
                .filter(g -> g.getTenGpu().equalsIgnoreCase(ten)).findFirst().orElse(null);
        } catch (Exception e) { return null; }
    }

    // ===================== JSON helpers =====================
    private void jsonOk(HttpServletResponse resp, int id, String label) throws IOException {
        PrintWriter out = resp.getWriter();
        out.print("{\"success\":true,\"id\":" + id + ",\"label\":\"" + escJson(label) + "\"}");
        out.flush();
    }
    private void jsonError(HttpServletResponse resp, String msg) throws IOException {
        PrintWriter out = resp.getWriter();
        out.print("{\"success\":false,\"message\":\"" + escJson(msg) + "\"}");
        out.flush();
    }
    private String trim(String s) { return s != null ? s.trim() : null; }
    private String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r");
    }
}
