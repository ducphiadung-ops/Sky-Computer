package demo.repository.san_pham;

import demo.entity.san_pham.CauHinhSanPham;
import demo.entity.san_pham.MaSeri;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.time.LocalDate;
import java.util.List;

public class MaSeriRepository {
    public MaSeriRepository() {
    }

    public List<MaSeri> getAll(){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.createQuery("FROM MaSeri ", MaSeri.class).list();
        }
    }

    /**
     * Lấy danh sách IMEI dùng cho trang bán hàng tại quầy.
     * Chỉ lấy IMEI trangThai=1 (còn hàng), thuộc biến thể trangThai=1,
     * và sản phẩm cha trangThai=1 (đang kinh doanh).
     */
    public List<MaSeri> getAllForBanHang() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT ms FROM MaSeri ms " +
                    "LEFT JOIN FETCH ms.cauHinhSanPham ch " +
                    "LEFT JOIN FETCH ch.sanPham sp " +
                    "JOIN ChiTietSanPham ct ON ct.cauHinhSanPham.id = ch.id " +
                    "WHERE ms.trangThai = 1 " +
                    "AND ct.trangThai = 1 " +
                    "AND sp.trangThai = 1";
            return session.createQuery(hql, MaSeri.class).getResultList();
        } catch (Exception e) {
            System.out.println("❌ Lỗi getAllForBanHang: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public MaSeri getOne(Integer id){
        try(Session session= HibernateConfig.getFACTORY().openSession()){
            MaSeri ms = session.find(MaSeri.class, id);
            // Kích hoạt lazy load cauHinhSanPham trước khi đóng session
            if (ms != null && ms.getCauHinhSanPham() != null) {
                org.hibernate.Hibernate.initialize(ms.getCauHinhSanPham());
                if (ms.getCauHinhSanPham().getSanPham() != null) {
                    org.hibernate.Hibernate.initialize(ms.getCauHinhSanPham().getSanPham());
                }
            }
            return ms;
        }
    }

    // Tìm kiếm danh sách mã IMEI/Seri thuộc về một Cấu hình cụ thể
    // Chỉ lấy trangThai 0, 1, 2 — bỏ qua trangThai = 3 (đã xóa khỏi hiển thị)
    public List<MaSeri> getByIdCauHinh(Integer idCauHinh) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "FROM MaSeri m WHERE m.cauHinhSanPham.id = :idCH AND m.trangThai != 3";
            return session.createQuery(hql, MaSeri.class)
                    .setParameter("idCH", idCauHinh)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public void add(MaSeri maSeri) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();

            session.save(maSeri);
            session.flush(); // Đồng bộ ID tự tăng sang đối tượng

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Thêm một mã IMEI/Seri mới bằng idCauHinh.
     * Dùng JDBC thuần trong 1 transaction để tránh mọi vấn đề Hibernate lazy/eager load.
     * Tự tạo phiếu nhập tạm + chi tiết phiếu nhập để đáp ứng ràng buộc NOT NULL của bảng ma_seri.
     */
    public void addByIdCauHinh(Integer idCauHinh, String soSeri, LocalDate ngayNhap, Integer trangThai) {
        String url  = "jdbc:sqlserver://localhost:1433;databaseName=DB_Quan_ly_may_tinh;encrypt=true;trustServerCertificate=true;";
        String user = "sa";
        String pass = "123456";

        try (java.sql.Connection conn = java.sql.DriverManager.getConnection(url, user, pass)) {
            conn.setAutoCommit(false);
            try {
                // Bước 1: Lấy id nhà cung cấp đầu tiên (dùng cho phiếu nhập tạm)
                int idNhaCungCap = 1;
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "SELECT TOP 1 id FROM nha_cung_cap ORDER BY id")) {
                    java.sql.ResultSet rs = ps.executeQuery();
                    if (rs.next()) idNhaCungCap = rs.getInt(1);
                }

                // Bước 2: Tạo phiếu nhập tạm
                int idPhieuNhap;
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO phieu_nhap (id_nha_cung_cap, ngay_nhap, tong_tien) VALUES (?, GETDATE(), 0)",
                        java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, idNhaCungCap);
                    ps.executeUpdate();
                    java.sql.ResultSet rs = ps.getGeneratedKeys();
                    rs.next();
                    idPhieuNhap = rs.getInt(1);
                }

                // Bước 3: Tạo chi tiết phiếu nhập (1 máy)
                int idChiTietPhieuNhap;
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO chi_tiet_phieu_nhap (id_phieu_nhap, ma_cau_hinh, so_luong, gia_nhap) VALUES (?, ?, 1, 0)",
                        java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, idPhieuNhap);
                    ps.setInt(2, idCauHinh);
                    ps.executeUpdate();
                    java.sql.ResultSet rs = ps.getGeneratedKeys();
                    rs.next();
                    idChiTietPhieuNhap = rs.getInt(1);
                }

                // Bước 4: Insert IMEI với đủ tất cả cột NOT NULL
                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO ma_seri (id_cau_hinh, ma_chi_tiet_phieu_nhap, so_seri, ngay_nhap, trang_thai) " +
                        "VALUES (?, ?, ?, ?, ?)")) {
                    ps.setInt(1, idCauHinh);
                    ps.setInt(2, idChiTietPhieuNhap);
                    ps.setString(3, soSeri);
                    ps.setDate(4, java.sql.Date.valueOf(ngayNhap));
                    ps.setInt(5, trangThai);
                    ps.executeUpdate();
                }

                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi JDBC khi thêm IMEI: " + e.getMessage(), e);
        }
    }

    public void update(MaSeri maSeri) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(maSeri);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Tìm biến thể theo IMEI/Serial — dùng trong trang bán hàng tại quầy.
     * Chỉ trả về IMEI đang hoạt động (trangThai = 1).
     */
    public MaSeri findByImei(String soSeri) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT m FROM MaSeri m " +
                    "LEFT JOIN FETCH m.cauHinhSanPham ch " +
                    "LEFT JOIN FETCH ch.sanPham sp " +
                    "WHERE LOWER(m.soSeri) = LOWER(:soSeri) AND m.trangThai = 1";
            MaSeri ms = session.createQuery(hql, MaSeri.class)
                    .setParameter("soSeri", soSeri.trim())
                    .uniqueResult();
            if (ms != null && ms.getCauHinhSanPham() != null) {
                try { if (ms.getCauHinhSanPham().getMauSac() != null) ms.getCauHinhSanPham().getMauSac().getTenMauSac(); } catch (Exception ignored) {}
                try { if (ms.getCauHinhSanPham().getCpu()    != null) ms.getCauHinhSanPham().getCpu().getTenCpu(); }       catch (Exception ignored) {}
                try { if (ms.getCauHinhSanPham().getRam()    != null) ms.getCauHinhSanPham().getRam().getDungLuongRam(); } catch (Exception ignored) {}
            }
            return ms;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 🟢 TÁC VỤ 1: Kiểm tra trùng lặp IMEI dưới Database
    // Trả về true nếu số seri đã tồn tại (bất kể trạng thái còn/đã bán) để tránh trùng lặp mã định danh
    public boolean checkTrungImei(String soSeri) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Long soLuong = session.createQuery(
                    "SELECT COUNT(m) FROM MaSeri m WHERE m.soSeri = :soSeri", Long.class)
                    .setParameter("soSeri", soSeri)
                    .uniqueResult();
            return soLuong != null && soLuong > 0;
        } catch (Exception e) {
            e.printStackTrace();
            // An toàn: nếu lỗi truy vấn thì coi như trùng để không lưu nhầm dữ liệu bẩn
            return true;
        }
    }

    // 🟢 TÁC VỤ 4: Cập nhật (Sửa) chuỗi số seri cho 1 mã IMEI đơn lẻ
    public void updateSoSeri(Integer id, String soSeriMoi) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            MaSeri m = session.find(MaSeri.class, id);
            if (m != null) {
                m.setSoSeri(soSeriMoi);
                session.merge(m);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // 🟢 TÁC VỤ 4: Hủy kích hoạt (xóa mềm) 1 mã IMEI ra khỏi kho -> trang_thai = false
    public void huyKichHoat(Integer id) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            MaSeri m = session.find(MaSeri.class, id);
            if (m != null) {
                m.setTrangThai(0);
                session.merge(m);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Chuyển trạng thái IMEI thành 3 (ẩn khỏi tab IMEI / xóa giao diện).
     * Chỉ áp dụng cho IMEI đang có trang_thai = 1 (hoạt động).
     */
    public void chuyenTrangThaiXoa(Integer id) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.createQuery(
                    "UPDATE MaSeri m SET m.trangThai = 3 WHERE m.id = :id AND m.trangThai = 1")
                    .setParameter("id", id)
                    .executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}