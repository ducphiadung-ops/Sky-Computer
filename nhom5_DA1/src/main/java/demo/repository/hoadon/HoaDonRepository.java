package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.*;
import org.hibernate.Session;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.query.Query;

public class HoaDonRepository {
    public List<HoaDon> getAllHoaDon() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDon h ORDER BY h.ngayLap DESC, h.id DESC",
                    HoaDon.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public HoaDon getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(HoaDon.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Load hoá đơn kèm tất cả lazy relations — dùng cho trang chi tiết
    public HoaDon getOneWithDetails(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            HoaDon hd = session.find(HoaDon.class, id);
            if (hd == null) return null;
            // Initialize tất cả trong cùng 1 session
            try { org.hibernate.Hibernate.initialize(hd.getLichSuThanhToan()); } catch (Exception e) {}
            try { org.hibernate.Hibernate.initialize(hd.getListChiTiet()); } catch (Exception e) {}
            if (hd.getListChiTiet() != null) {
                for (ChiTietHoaDon ct : hd.getListChiTiet()) {
                    try { org.hibernate.Hibernate.initialize(ct.getCauHinhSanPham()); } catch (Exception e) {}
                    if (ct.getCauHinhSanPham() != null) {
                        try { org.hibernate.Hibernate.initialize(ct.getCauHinhSanPham().getSanPham()); } catch (Exception e) {}
                        try { org.hibernate.Hibernate.initialize(ct.getCauHinhSanPham().getCpu()); } catch (Exception e) {}
                        try { org.hibernate.Hibernate.initialize(ct.getCauHinhSanPham().getRam()); } catch (Exception e) {}
                        try { org.hibernate.Hibernate.initialize(ct.getCauHinhSanPham().getGpu()); } catch (Exception e) {}
                        try { org.hibernate.Hibernate.initialize(ct.getCauHinhSanPham().getOCung()); } catch (Exception e) {}
                    }
                    try { org.hibernate.Hibernate.initialize(ct.getIdSeri()); } catch (Exception e) {}
                }
            }
            if (hd.getKhachHang() != null) {
                try { org.hibernate.Hibernate.initialize(hd.getKhachHang().getDiaChiKhachHang()); } catch (Exception e) {}
            }
            return hd;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy ID tiếp theo để sinh mã trước khi insert
    public Integer getNextId() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Object result = session.createNativeQuery(
                    "SELECT ISNULL(MAX(id), 0) + 1 FROM hoa_don").uniqueResult();
            return result != null ? ((Number) result).intValue() : 1;
        } catch (Exception e) {
            e.printStackTrace();
            return (int)(System.currentTimeMillis() % 100000);
        }
    }

    public Integer add(HoaDon hoaDon) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            org.hibernate.Transaction tx = session.beginTransaction();
            try {
                // Dùng persist thay save — chuẩn JPA hơn
                session.persist(hoaDon);
                session.flush();
                tx.commit();
                return hoaDon.getId();
            } catch (Exception e) {
                tx.rollback();
                e.printStackTrace();
                return null;
            }
        }
    }


    public List<HoaDon> getTop5() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "SELECT h FROM HoaDon h LEFT JOIN h.khachHang " +
                    "WHERE h.trangThai = 1 " +
                    "ORDER BY h.id DESC",
                    HoaDon.class)
                    .setMaxResults(5)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    public List<HoaDon> timKiemVaLoc(String keyword, String trangThai, String ngayTao) {
        List<HoaDon> list = new ArrayList<>();

        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // LEFT JOIN để giữ lại hóa đơn không có khách hàng (hóa đơn chờ)
            StringBuilder hql = new StringBuilder(
                "SELECT h FROM HoaDon h " +
                "LEFT JOIN h.khachHang kh " +
                "LEFT JOIN h.nhanVien nv " +
                "WHERE 1=1 "
            );

            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append("AND (h.maHoaDon LIKE :keyword " +
                        "OR kh.tenKhachHang LIKE :keyword " +
                        "OR kh.sdt LIKE :keyword) ");
            }

            if (trangThai != null && !trangThai.trim().isEmpty()) {
                // Người dùng chọn cụ thể → lọc đúng giá trị đó
                hql.append("AND h.trangThai = :trangThai ");
            } else {
                // Không chọn → mặc định ẩn hóa đơn chờ (status 2) khỏi danh sách
                hql.append("AND h.trangThai <> 2 ");
            }

            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                hql.append("AND CAST(h.ngayLap as date) = :ngayTao ");
            }

            hql.append("ORDER BY h.ngayLap DESC, h.id DESC ");

            Query<HoaDon> query = session.createQuery(hql.toString(), HoaDon.class);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                query.setParameter("trangThai", Integer.parseInt(trangThai));
            }
            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                query.setParameter("ngayTao", java.sql.Date.valueOf(ngayTao));
            }

            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy một trang hóa đơn theo bộ lọc — dùng cho trang quản lý (phân trang)
    public List<HoaDon> timKiemVaLocPhanTrang(String keyword, String trangThai, String ngayTao,
                                               int page, int pageSize) {
        List<HoaDon> list = new ArrayList<>();
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                "SELECT h FROM HoaDon h " +
                "LEFT JOIN h.khachHang kh " +
                "LEFT JOIN h.nhanVien nv " +
                "WHERE 1=1 "
            );
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append("AND (h.maHoaDon LIKE :keyword " +
                        "OR kh.tenKhachHang LIKE :keyword " +
                        "OR kh.sdt LIKE :keyword) ");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                // Người dùng chọn cụ thể → lọc đúng giá trị đó
                hql.append("AND h.trangThai = :trangThai ");
            } else {
                // Không chọn → mặc định ẩn hóa đơn chờ (status 2) khỏi danh sách
                hql.append("AND h.trangThai <> 2 ");
            }
            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                hql.append("AND CAST(h.ngayLap as date) = :ngayTao ");
            }
            hql.append("ORDER BY h.ngayLap DESC, h.id DESC ");

            Query<HoaDon> query = session.createQuery(hql.toString(), HoaDon.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                query.setParameter("trangThai", Integer.parseInt(trangThai));
            }
            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                query.setParameter("ngayTao", java.sql.Date.valueOf(ngayTao));
            }
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số hóa đơn theo bộ lọc — dùng để tính tổng số trang
    public long demTongHoaDon(String keyword, String trangThai, String ngayTao) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                "SELECT COUNT(h) FROM HoaDon h " +
                "LEFT JOIN h.khachHang kh " +
                "LEFT JOIN h.nhanVien nv " +
                "WHERE 1=1 "
            );
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append("AND (h.maHoaDon LIKE :keyword " +
                        "OR kh.tenKhachHang LIKE :keyword " +
                        "OR kh.sdt LIKE :keyword) ");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                // Người dùng chọn cụ thể → lọc đúng giá trị đó
                hql.append("AND h.trangThai = :trangThai ");
            } else {
                // Không chọn → mặc định ẩn hóa đơn chờ (status 2) khỏi danh sách
                hql.append("AND h.trangThai <> 2 ");
            }
            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                hql.append("AND CAST(h.ngayLap as date) = :ngayTao ");
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                query.setParameter("trangThai", Integer.parseInt(trangThai));
            }
            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                query.setParameter("ngayTao", java.sql.Date.valueOf(ngayTao));
            }
            Long result = query.uniqueResult();
            return result != null ? result : 0L;
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }

    // Lấy danh sách hóa đơn chờ (trangThai = 2) — toàn bộ, dùng cho trang quản lý
    public List<HoaDon> getHoaDonCho() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDon h WHERE h.trangThai = 2 " +
                    "AND h.maHoaDon IS NOT NULL AND h.maHoaDon NOT LIKE '%null%' " +
                    "ORDER BY h.ngayLap DESC",
                    HoaDon.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Lấy danh sách hóa đơn chờ (trangThai = 2) CHỈ của một nhân viên cụ thể
    // Dùng cho trang bán hàng tại quầy — mỗi nhân viên chỉ thấy đơn chờ của mình
    public List<HoaDon> getHoaDonChoByNhanVien(Integer idNhanVien) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDon h WHERE h.trangThai = 2 " +
                    "AND h.nhanVien.id = :idNhanVien " +
                    "AND h.maHoaDon IS NOT NULL AND h.maHoaDon NOT LIKE '%null%' " +
                    "ORDER BY h.ngayLap DESC",
                    HoaDon.class)
                    .setParameter("idNhanVien", idNhanVien)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Tự động sinh mã hóa đơn: HD001, HD002, ...
    public String taoMaHoaDon() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Long count = session.createQuery(
                    "SELECT COUNT(h) FROM HoaDon h", Long.class).uniqueResult();
            if (count == null) count = 0L;
            return String.format("HD%03d", count + 1);
        } catch (Exception e) {
            e.printStackTrace();
            return "HD" + System.currentTimeMillis();
        }
    }

    // Sinh mã hoá đơn theo năm: HD2026_001 (dựa vào id sau khi lưu)
    public String taoMaHoaDonTheoNam(Integer id) {
        int nam = java.time.LocalDate.now().getYear();
        return String.format("HD%d_%03d", nam, id);
    }

    public void update(HoaDon hoaDon) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            org.hibernate.Transaction tx = session.beginTransaction();
            session.merge(hoaDon);
            tx.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa hóa đơn chờ (soft delete — chỉ dùng cho hóa đơn chờ trangThai=2)
    public void deleteHoaDonCho(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            org.hibernate.Transaction tx = session.beginTransaction();
            session.createNativeQuery(
                    "UPDATE hoa_don SET is_deleted = 1 WHERE id = :id AND trang_thai = 2"
            ).setParameter("id", id).executeUpdate();
            tx.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================================================================
    //  Lấy danh sách hóa đơn chờ (trangThai=2) được tạo TRƯỚC ngày hôm nay
    //  Dùng để cron job kiểm tra và hủy các đơn chờ quá hạn
    // =====================================================================
    public List<HoaDon> getDonChoQuaHan() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            java.sql.Date homNay = java.sql.Date.valueOf(java.time.LocalDate.now());
            return session.createQuery(
                    "FROM HoaDon h WHERE h.trangThai = 2 " +
                    "AND h.ngayLap < :homNay",
                    HoaDon.class)
                    .setParameter("homNay", homNay)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // =====================================================================
    //  Cập nhật hàng loạt: tất cả đơn chờ (trangThai=2) tạo trước hôm nay
    //  → chuyển sang trangThai=3 (đã hủy)
    //  Trả về số bản ghi đã cập nhật
    // =====================================================================
    public int huyDonChoQuaHan() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            org.hibernate.Transaction tx = session.beginTransaction();
            java.sql.Date homNay = java.sql.Date.valueOf(java.time.LocalDate.now());
            int soLuong = session.createNativeQuery(
                    "UPDATE hoa_don SET trang_thai = 3 " +
                    "WHERE trang_thai = 2 AND CAST(ngay_lap AS DATE) < :homNay AND is_deleted = 0"
            ).setParameter("homNay", homNay).executeUpdate();
            tx.commit();
            return soLuong;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}

