package demo.Service.nhanvien;

import demo.entity.nhan_vien.NhanVien;
import demo.repository.nhanvien.NhanVienRepository;

import java.util.List;

public class NhanVienService {

    NhanVienRepository repo = new NhanVienRepository();

    public List<NhanVien> getAll() {
        return repo.getAll();
    }

    // Lọc danh sách
    public List<NhanVien> filter(String tuKhoa, String chucVu, String trangThai) {
        return repo.filter(tuKhoa, chucVu, trangThai);
    }

    public void add(NhanVien nv) {
        repo.add(nv);
    }

    public NhanVien getOne(Integer id) {
        return repo.getOne(id);
    }

    public String layMaNhanVienMoi() {
        return repo.layMaNhanVienMoi();
    }

    public void update(NhanVien nv) {
        repo.update(nv);
    }


    public void delete(Integer id) {
        repo.delete(id);
    }


    // switch doi trang thai
    public void doiTrangThai(Integer id, Integer trangThai) {
        repo.doiTrangThai(id, trangThai);
    }

    // Đăng nhập
    public NhanVien findByTaiKhoanAndMatKhau(String taiKhoan, String matKhau) {
        return repo.findByTaiKhoanAndMatKhau(taiKhoan, matKhau);
    }

    // Kiểm tra SĐT trùng
    public boolean existsBySdt(String sdt, Integer excludeId) {
        return repo.existsBySdt(sdt, excludeId);
    }

    // Kiểm tra email trùng
    public boolean existsByEmail(String email, Integer excludeId) {
        return repo.existsByEmail(email, excludeId);
    }
}
