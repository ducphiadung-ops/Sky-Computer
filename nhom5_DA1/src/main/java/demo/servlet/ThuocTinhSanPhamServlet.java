package demo.servlet;

import demo.entity.san_pham.*;
import demo.repository.san_pham.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ThuocTinhSanPhamServlet", value = {
        // Hiển thị danh sách
        "/thuoc-tinh/cpu/hien-thi",
        "/thuoc-tinh/ram/hien-thi",
        "/thuoc-tinh/o-cung/hien-thi",
        "/thuoc-tinh/gpu/hien-thi",
        "/thuoc-tinh/man-hinh/hien-thi",
        "/thuoc-tinh/mau-sac/hien-thi",
        "/thuoc-tinh/pin/hien-thi",
        "/thuoc-tinh/danh-muc/hien-thi",
        "/thuoc-tinh/thuong-hieu/hien-thi",

        // Chức năng Xóa
        "/thuoc-tinh/cpu/xoa",
        "/thuoc-tinh/ram/xoa",
        "/thuoc-tinh/o-cung/xoa",
        "/thuoc-tinh/gpu/xoa",
        "/thuoc-tinh/man-hinh/xoa",
        "/thuoc-tinh/mau-sac/xoa",
        "/thuoc-tinh/pin/xoa",
        "/thuoc-tinh/danh-muc/xoa",
        "/thuoc-tinh/thuong-hieu/xoa",

        // Chức năng Thêm mới
        "/thuoc-tinh/cpu/them",
        "/thuoc-tinh/ram/them",
        "/thuoc-tinh/o-cung/them",
        "/thuoc-tinh/gpu/them",
        "/thuoc-tinh/man-hinh/them",
        "/thuoc-tinh/mau-sac/them",
        "/thuoc-tinh/pin/them",
        "/thuoc-tinh/danh-muc/them",
        "/thuoc-tinh/thuong-hieu/them",

        // Chức năng Sửa (POST)
        "/thuoc-tinh/cpu/sua",
        "/thuoc-tinh/ram/sua",
        "/thuoc-tinh/o-cung/sua",
        "/thuoc-tinh/gpu/sua",
        "/thuoc-tinh/man-hinh/sua",
        "/thuoc-tinh/mau-sac/sua",
        "/thuoc-tinh/pin/sua",
        "/thuoc-tinh/danh-muc/sua",
        "/thuoc-tinh/thuong-hieu/sua"
})
public class ThuocTinhSanPhamServlet extends HttpServlet {
    private final CpuRepository cpuRepo = new CpuRepository();
    private final RamRepository ramRepo = new RamRepository();
    private final OCungRepository oCungRepo = new OCungRepository();
    private final GpuRepository gpuRepo = new GpuRepository();
    private final ManHinhRepository manHinhRepo = new ManHinhRepository();
    private final MauSacRepository mauSacRepo = new MauSacRepository();
    private final PinRepository pinRepo = new PinRepository();
    private final ThuongHieuRepository thuongHieuRepo = new ThuongHieuRepository();
    private final DanhMucRepository danhMucRepo = new DanhMucRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        // Kiểm tra quyền: nhân viên không được xóa thuộc tính
        demo.entity.nhan_vien.NhanVien nv = null;
        if (req.getSession(false) != null) {
            Object obj = req.getSession().getAttribute("nhanVien");
            if (obj instanceof demo.entity.nhan_vien.NhanVien) {
                nv = (demo.entity.nhan_vien.NhanVien) obj;
            }
        }
        boolean isNhanVien = LoginServlet.isNhanVienRole(nv != null ? nv.getChucVu() : null);

        // Nếu nhân viên cố truy cập chức năng xóa → redirect về trang hiện thị
        if (isNhanVien && uri.contains("/xoa")) {
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
            return;
        }

        if (uri.contains("/thuoc-tinh/cpu/hien-thi")) this.cpuHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/ram/hien-thi")) this.ramHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/o-cung/hien-thi")) this.oCungHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/gpu/hien-thi")) this.gpuHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/man-hinh/hien-thi")) this.manHinhHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/mau-sac/hien-thi")) this.mauSacHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/pin/hien-thi")) this.pinHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/thuong-hieu/hien-thi")) this.thuongHieuHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/danh-muc/hien-thi")) this.danhMucHienThi(req, resp);

        else if (uri.contains("/thuoc-tinh/cpu/xoa")) this.cpuXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/ram/xoa")) this.ramXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/o-cung/xoa")) this.oCungXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/gpu/xoa")) this.gpuXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/man-hinh/xoa")) this.manHinhXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/mau-sac/xoa")) this.mauSacXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/pin/xoa")) this.pinXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/danh-muc/xoa")) this.danhMucXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/thuong-hieu/xoa")) this.thuongHieuXoa(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        HttpSession session = req.getSession();

        // Kiểm tra quyền server-side: nhân viên không được thêm thuộc tính
        Object nvObj = session.getAttribute("nhanVien");
        demo.entity.nhan_vien.NhanVien nv = (nvObj instanceof demo.entity.nhan_vien.NhanVien)
                ? (demo.entity.nhan_vien.NhanVien) nvObj : null;
        boolean isNhanVien = LoginServlet.isNhanVienRole(nv != null ? nv.getChucVu() : null);
        if (isNhanVien) {
            session.setAttribute("errorMessage", "Bạn không có quyền thực hiện thao tác này.");
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
            return;
        }

        try {
            if (uri.contains("/thuoc-tinh/cpu/sua")) {
                Cpu obj = cpuRepo.getOne(Integer.valueOf(req.getParameter("id")));
                if (obj != null) {
                    String tenCpu = req.getParameter("tenCpu");
                    String theHe  = req.getParameter("theHeCpu");
                    if (cpuRepo.existsDuplicate(tenCpu, theHe, obj.getId())) {
                        session.setAttribute("errorMessage", "\"" + tenCpu + "\" đã tồn tại!");
                    } else {
                        obj.setTenCpu(tenCpu);
                        obj.setTheHeCpu(theHe);
                        cpuRepo.update(obj);
                        session.setAttribute("successMessage", "Cập nhật CPU thành công!");
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/cpu/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/ram/sua")) {
                Ram obj = ramRepo.getOne(Integer.valueOf(req.getParameter("id")));
                if (obj != null) {
                    String tenRam = req.getParameter("tenRam");
                    String dung   = req.getParameter("dungLuongRam");
                    if (ramRepo.existsDuplicate(tenRam, dung, obj.getId())) {
                        session.setAttribute("errorMessage", "\"" + tenRam + "\" đã tồn tại!");
                    } else {
                        obj.setTenRam(tenRam);
                        obj.setDungLuongRam(dung);
                        ramRepo.update(obj);
                        session.setAttribute("successMessage", "Cập nhật RAM thành công!");
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/ram/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/o-cung/sua")) {
                OCung obj = oCungRepo.getOne(Integer.valueOf(req.getParameter("id")));
                if (obj != null) {
                    String tenOCung = req.getParameter("tenOCung");
                    String dung     = req.getParameter("dungLuongOCung");
                    if (oCungRepo.existsDuplicate(tenOCung, dung, obj.getId())) {
                        session.setAttribute("errorMessage", "\"" + tenOCung + "\" đã tồn tại!");
                    } else {
                        obj.setTenOCung(tenOCung);
                        obj.setDungLuongOCung(dung);
                        oCungRepo.update(obj);
                        session.setAttribute("successMessage", "Cập nhật Ổ cứng thành công!");
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/o-cung/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/gpu/sua")) {
                Gpu obj = gpuRepo.getOne(Integer.valueOf(req.getParameter("id")));
                if (obj != null) {
                    String tenGpu = req.getParameter("tenGpu");
                    String dung   = req.getParameter("dungLuongGpu");
                    if (gpuRepo.existsDuplicate(tenGpu, dung, obj.getId())) {
                        session.setAttribute("errorMessage", "\"" + tenGpu + "\" đã tồn tại!");
                    } else {
                        obj.setTenGpu(tenGpu);
                        obj.setDungLuongGpu(dung);
                        gpuRepo.update(obj);
                        session.setAttribute("successMessage", "Cập nhật GPU thành công!");
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/gpu/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/man-hinh/sua")) {
                ManHinh obj = manHinhRepo.getOne(Integer.valueOf(req.getParameter("id")));
                if (obj != null) {
                    String tenMh = req.getParameter("tenManHinh");
                    String kich  = req.getParameter("kichThuoc");
                    String dpg   = req.getParameter("doPhanGiai");
                    String tsq   = req.getParameter("tanSoQuet");
                    if (manHinhRepo.existsDuplicate(tenMh, kich, dpg, tsq, obj.getId())) {
                        session.setAttribute("errorMessage", "\"" + tenMh + "\" đã tồn tại!");
                    } else {
                        obj.setTenManHinh(tenMh);
                        obj.setKichThuoc(kich);
                        obj.setDoPhanGiai(dpg);
                        obj.setTanSoQuet(tsq);
                        manHinhRepo.update(obj);
                        session.setAttribute("successMessage", "Cập nhật Màn hình thành công!");
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/man-hinh/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/mau-sac/sua")) {
                MauSac obj = mauSacRepo.getOne(Integer.valueOf(req.getParameter("id")));
                if (obj != null) {
                    String tenMs = req.getParameter("tenMauSac");
                    if (mauSacRepo.existsDuplicate(tenMs, obj.getId())) {
                        session.setAttribute("errorMessage", "\"" + tenMs + "\" đã tồn tại!");
                    } else {
                        obj.setTenMauSac(tenMs);
                        mauSacRepo.update(obj);
                        session.setAttribute("successMessage", "Cập nhật Màu sắc thành công!");
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/mau-sac/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/pin/sua")) {
                Pin obj = pinRepo.getOne(Integer.valueOf(req.getParameter("id")));
                if (obj != null) {
                    String tenPin = req.getParameter("tenPin");
                    String dung   = req.getParameter("dungLuongPin");
                    if (pinRepo.existsDuplicate(tenPin, dung, obj.getId())) {
                        session.setAttribute("errorMessage", "\"" + tenPin + "\" đã tồn tại!");
                    } else {
                        obj.setTenPin(tenPin);
                        obj.setDungLuongPin(dung);
                        pinRepo.update(obj);
                        session.setAttribute("successMessage", "Cập nhật Pin thành công!");
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/pin/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/danh-muc/sua")) {
                DanhMuc obj = danhMucRepo.getOne(Integer.valueOf(req.getParameter("id")));
                if (obj != null) {
                    String tenDm = req.getParameter("tenDanhMuc");
                    if (danhMucRepo.existsDuplicate(tenDm, obj.getId())) {
                        session.setAttribute("errorMessage", "\"" + tenDm + "\" đã tồn tại!");
                    } else {
                        obj.setTenDanhMuc(tenDm);
                        danhMucRepo.update(obj);
                        session.setAttribute("successMessage", "Cập nhật Danh mục thành công!");
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/danh-muc/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/thuong-hieu/sua")) {
                ThuongHieu obj = thuongHieuRepo.getOne(Integer.valueOf(req.getParameter("id")));
                if (obj != null) {
                    String tenTh = req.getParameter("tenThuongHieu");
                    if (thuongHieuRepo.existsDuplicate(tenTh, obj.getId())) {
                        session.setAttribute("errorMessage", "\"" + tenTh + "\" đã tồn tại!");
                    } else {
                        obj.setTenThuongHieu(tenTh);
                        thuongHieuRepo.update(obj);
                        session.setAttribute("successMessage", "Cập nhật Thương hiệu thành công!");
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/thuong-hieu/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/cpu/them")) {
                String tenCpu = req.getParameter("tenCpu");
                String theHe  = req.getParameter("theHeCpu");
                if (cpuRepo.existsDuplicate(tenCpu, theHe, null)) {
                    session.setAttribute("errorMessage", "\"" + tenCpu + "\" đã tồn tại!");
                } else {
                    Cpu obj = new Cpu();
                    obj.setTenCpu(tenCpu);
                    obj.setTheHeCpu(theHe);
                    obj.setTrangThai(1);
                    cpuRepo.add(obj);
                    session.setAttribute("successMessage", "Thêm mới cấu hình CPU thành công!");
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/cpu/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/ram/them")) {
                String tenRam = req.getParameter("tenRam");
                String dung   = req.getParameter("dungLuongRam");
                if (ramRepo.existsDuplicate(tenRam, dung, null)) {
                    session.setAttribute("errorMessage", "\"" + tenRam + "\" đã tồn tại!");
                } else {
                    Ram obj = new Ram();
                    obj.setTenRam(tenRam);
                    obj.setDungLuongRam(dung);
                    obj.setTrangThai(1);
                    ramRepo.add(obj);
                    session.setAttribute("successMessage", "Thêm mới cấu hình RAM thành công!");
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/ram/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/o-cung/them")) {
                String tenOCung = req.getParameter("tenOCung");
                String dung     = req.getParameter("dungLuongOCung");
                if (oCungRepo.existsDuplicate(tenOCung, dung, null)) {
                    session.setAttribute("errorMessage", "\"" + tenOCung + "\" đã tồn tại!");
                } else {
                    OCung obj = new OCung();
                    obj.setTenOCung(tenOCung);
                    obj.setDungLuongOCung(dung);
                    obj.setTrangThai(1);
                    oCungRepo.add(obj);
                    session.setAttribute("successMessage", "Thêm mới Ổ cứng thành công!");
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/o-cung/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/gpu/them")) {
                String tenGpu = req.getParameter("tenGpu");
                String dung   = req.getParameter("dungLuongGpu");
                if (gpuRepo.existsDuplicate(tenGpu, dung, null)) {
                    session.setAttribute("errorMessage", "\"" + tenGpu + "\" đã tồn tại!");
                } else {
                    Gpu obj = new Gpu();
                    obj.setTenGpu(tenGpu);
                    obj.setDungLuongGpu(dung);
                    obj.setTrangThai(1);
                    gpuRepo.add(obj);
                    session.setAttribute("successMessage", "Thêm mới Card đồ họa (GPU) thành công!");
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/gpu/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/man-hinh/them")) {
                String tenMh = req.getParameter("tenManHinh");
                String kich  = req.getParameter("kichThuoc");
                String dpg   = req.getParameter("doPhanGiai");
                String tsq   = req.getParameter("tanSoQuet");
                if (manHinhRepo.existsDuplicate(tenMh, kich, dpg, tsq, null)) {
                    session.setAttribute("errorMessage", "\"" + tenMh + "\" đã tồn tại!");
                } else {
                    ManHinh obj = new ManHinh();
                    obj.setTenManHinh(tenMh);
                    obj.setKichThuoc(kich);
                    obj.setDoPhanGiai(dpg);
                    obj.setTanSoQuet(tsq);
                    obj.setTrangThai(1);
                    manHinhRepo.add(obj);
                    session.setAttribute("successMessage", "Thêm mới Màn hình thành công!");
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/man-hinh/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/mau-sac/them")) {
                String tenMs = req.getParameter("tenMauSac");
                if (mauSacRepo.existsDuplicate(tenMs, null)) {
                    session.setAttribute("errorMessage", "\"" + tenMs + "\" đã tồn tại!");
                } else {
                    MauSac obj = new MauSac();
                    obj.setTenMauSac(tenMs);
                    obj.setTrangThai(1);
                    mauSacRepo.add(obj);
                    session.setAttribute("successMessage", "Thêm mới Màu sắc thành công!");
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/mau-sac/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/pin/them")) {
                String tenPin = req.getParameter("tenPin");
                String dung   = req.getParameter("dungLuongPin");
                if (pinRepo.existsDuplicate(tenPin, dung, null)) {
                    session.setAttribute("errorMessage", "\"" + tenPin + "\" đã tồn tại!");
                } else {
                    Pin obj = new Pin();
                    obj.setTenPin(tenPin);
                    obj.setDungLuongPin(dung);
                    obj.setTrangThai(1);
                    pinRepo.add(obj);
                    session.setAttribute("successMessage", "Thêm mới Pin thành công!");
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/pin/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/danh-muc/them")) {
                String tenDm = req.getParameter("tenDanhMuc");
                if (danhMucRepo.existsDuplicate(tenDm, null)) {
                    session.setAttribute("errorMessage", "\"" + tenDm + "\" đã tồn tại!");
                } else {
                    DanhMuc obj = new DanhMuc();
                    obj.setTenDanhMuc(tenDm);
                    obj.setTrangThai(1);
                    danhMucRepo.add(obj);
                    session.setAttribute("successMessage", "Thêm mới Danh mục sản phẩm thành công!");
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/danh-muc/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/thuong-hieu/them")) {
                String tenTh = req.getParameter("tenThuongHieu");
                if (thuongHieuRepo.existsDuplicate(tenTh, null)) {
                    session.setAttribute("errorMessage", "\"" + tenTh + "\" đã tồn tại!");
                } else {
                    ThuongHieu obj = new ThuongHieu();
                    obj.setTenThuongHieu(tenTh);
                    obj.setTrangThai(1);
                    thuongHieuRepo.add(obj);
                    session.setAttribute("successMessage", "Thêm mới Thương hiệu/Hãng thành công!");
                }
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/thuong-hieu/hien-thi");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi nghiêm trọng khi thêm mới dữ liệu thuộc tính!");
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
        }
    }


    // ---- helper: đọc params lọc chung ----
    private String p(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return (v != null && !v.trim().isEmpty()) ? v.trim() : null;
    }

    public void cpuHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tk = p(req, "tuKhoa"); String tt = p(req, "trangThai");
        req.setAttribute("listCpu", (tk != null || tt != null) ? cpuRepo.filter(tk, tt) : cpuRepo.getAll());
        req.setAttribute("filterTuKhoa", tk != null ? tk : "");
        req.setAttribute("filterTrangThai", tt != null ? tt : "");
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/cpu/cpu-index.jsp").forward(req, resp);
    }

    public void ramHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tk = p(req, "tuKhoa"); String tt = p(req, "trangThai");
        req.setAttribute("listRam", (tk != null || tt != null) ? ramRepo.filter(tk, tt) : ramRepo.getAll());
        req.setAttribute("filterTuKhoa", tk != null ? tk : "");
        req.setAttribute("filterTrangThai", tt != null ? tt : "");
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/ram/ram-index.jsp").forward(req, resp);
    }

    public void oCungHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tk = p(req, "tuKhoa"); String tt = p(req, "trangThai");
        req.setAttribute("listOCung", (tk != null || tt != null) ? oCungRepo.filter(tk, tt) : oCungRepo.getAll());
        req.setAttribute("filterTuKhoa", tk != null ? tk : "");
        req.setAttribute("filterTrangThai", tt != null ? tt : "");
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/o-cung/o-cung-index.jsp").forward(req, resp);
    }

    public void gpuHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tk = p(req, "tuKhoa"); String tt = p(req, "trangThai");
        req.setAttribute("listGpu", (tk != null || tt != null) ? gpuRepo.filter(tk, tt) : gpuRepo.getAll());
        req.setAttribute("filterTuKhoa", tk != null ? tk : "");
        req.setAttribute("filterTrangThai", tt != null ? tt : "");
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/gpu/gpu-index.jsp").forward(req, resp);
    }

    public void manHinhHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tk = p(req, "tuKhoa"); String tt = p(req, "trangThai");
        req.setAttribute("listManHinh", (tk != null || tt != null) ? manHinhRepo.filter(tk, tt) : manHinhRepo.getAll());
        req.setAttribute("filterTuKhoa", tk != null ? tk : "");
        req.setAttribute("filterTrangThai", tt != null ? tt : "");
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/man-hinh/man-hinh-index.jsp").forward(req, resp);
    }

    public void mauSacHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tk = p(req, "tuKhoa"); String tt = p(req, "trangThai");
        req.setAttribute("listMauSac", (tk != null || tt != null) ? mauSacRepo.filter(tk, tt) : mauSacRepo.getAll());
        req.setAttribute("filterTuKhoa", tk != null ? tk : "");
        req.setAttribute("filterTrangThai", tt != null ? tt : "");
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/mau-sac/mau-sac-index.jsp").forward(req, resp);
    }

    public void pinHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tk = p(req, "tuKhoa"); String tt = p(req, "trangThai");
        req.setAttribute("listPin", (tk != null || tt != null) ? pinRepo.filter(tk, tt) : pinRepo.getAll());
        req.setAttribute("filterTuKhoa", tk != null ? tk : "");
        req.setAttribute("filterTrangThai", tt != null ? tt : "");
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/pin/pin-index.jsp").forward(req, resp);
    }

    public void thuongHieuHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tk = p(req, "tuKhoa"); String tt = p(req, "trangThai");
        req.setAttribute("listThuongHieu", (tk != null || tt != null) ? thuongHieuRepo.filter(tk, tt) : thuongHieuRepo.getAll());
        req.setAttribute("filterTuKhoa", tk != null ? tk : "");
        req.setAttribute("filterTrangThai", tt != null ? tt : "");
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/thuong-hieu/thuong-hieu-index.jsp").forward(req, resp);
    }

    public void danhMucHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tk = p(req, "tuKhoa"); String tt = p(req, "trangThai");
        req.setAttribute("listDanhMuc", (tk != null || tt != null) ? danhMucRepo.filter(tk, tt) : danhMucRepo.getAll());
        req.setAttribute("filterTuKhoa", tk != null ? tk : "");
        req.setAttribute("filterTrangThai", tt != null ? tt : "");
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/danh-muc/danh-muc-index.jsp").forward(req, resp);
    }

    public void cpuXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Cpu obj = cpuRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(0); cpuRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/cpu/hien-thi");
    }

    public void ramXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Ram obj = ramRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(0); ramRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/ram/hien-thi");
    }

    public void oCungXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            OCung obj = oCungRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(0); oCungRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/o-cung/hien-thi");
    }

    public void gpuXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Gpu obj = gpuRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(0); gpuRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/gpu/hien-thi");
    }

    public void manHinhXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            ManHinh obj = manHinhRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(0); manHinhRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/man-hinh/hien-thi");
    }

    public void mauSacXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            MauSac obj = mauSacRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(0); mauSacRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/mau-sac/hien-thi");
    }

    public void pinXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Pin obj = pinRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(0); pinRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/pin/hien-thi");
    }

    public void danhMucXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            DanhMuc obj = danhMucRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(0); danhMucRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/danh-muc/hien-thi");
    }

    public void thuongHieuXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            ThuongHieu obj = thuongHieuRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(0); thuongHieuRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/thuong-hieu/hien-thi");
    }
}