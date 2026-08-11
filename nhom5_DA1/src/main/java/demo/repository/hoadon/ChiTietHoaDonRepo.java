package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.ChiTietHoaDon;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.ArrayList;
import java.util.List;

public class ChiTietHoaDonRepo {

    public List<ChiTietHoaDon> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM ChiTietHoaDon", ChiTietHoaDon.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public ChiTietHoaDon getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(ChiTietHoaDon.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<ChiTietHoaDon> getByHoaDonId(Integer hoaDonId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            List<ChiTietHoaDon> list = session.createQuery(
                    "FROM ChiTietHoaDon ct WHERE ct.hoaDon.id = :hdId",
                    ChiTietHoaDon.class)
                    .setParameter("hdId", hoaDonId)
                    .list();
            // Initialize tất cả lazy-loaded relations trước khi đóng session
            for (ChiTietHoaDon ct : list) {
                if (ct.getIdSeri() != null) {
                    org.hibernate.Hibernate.initialize(ct.getIdSeri());
                }
                if (ct.getCauHinhSanPham() != null) {
                    org.hibernate.Hibernate.initialize(ct.getCauHinhSanPham());
                    demo.entity.san_pham.CauHinhSanPham ch = ct.getCauHinhSanPham();
                    try { if (ch.getSanPham()  != null) {
                            org.hibernate.Hibernate.initialize(ch.getSanPham());
                            if (ch.getSanPham().getThuongHieu() != null)
                                org.hibernate.Hibernate.initialize(ch.getSanPham().getThuongHieu());
                        } } catch(Exception e) {}
                    try { if (ch.getCpu()      != null) org.hibernate.Hibernate.initialize(ch.getCpu()); } catch(Exception e) {}
                    try { if (ch.getRam()      != null) org.hibernate.Hibernate.initialize(ch.getRam()); } catch(Exception e) {}
                    try { if (ch.getGpu()      != null) org.hibernate.Hibernate.initialize(ch.getGpu()); } catch(Exception e) {}
                    try { if (ch.getOCung()    != null) org.hibernate.Hibernate.initialize(ch.getOCung()); } catch(Exception e) {}
                    try { if (ch.getMauSac()   != null) org.hibernate.Hibernate.initialize(ch.getMauSac()); } catch(Exception e) {}
                }
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public ChiTietHoaDon getBySeriId(Integer seriId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM ChiTietHoaDon ct WHERE ct.idSeri.id = :seriId",
                    ChiTietHoaDon.class)
                    .setParameter("seriId", seriId)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Kiểm tra xem IMEI (seriId) đã có trong hoá đơn (hoaDonId) chưa.
     * Dùng để chặn duplicate khi quét nhanh gây ra race condition.
     */
    public boolean existsByHoaDonAndSeri(Integer hoaDonId, Integer seriId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Long count = session.createQuery(
                    "SELECT COUNT(ct) FROM ChiTietHoaDon ct " +
                    "WHERE ct.hoaDon.id = :hdId AND ct.idSeri.id = :seriId",
                    Long.class)
                    .setParameter("hdId", hoaDonId)
                    .setParameter("seriId", seriId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Integer add(ChiTietHoaDon ct) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            // Dùng native SQL để tránh vấn đề detached entity và lazy load
            Integer hoaDonId  = ct.getHoaDon()        != null ? ct.getHoaDon().getId()        : null;
            Integer cauHinhId = ct.getCauHinhSanPham() != null ? ct.getCauHinhSanPham().getId() : null;
            Integer seriId    = ct.getIdSeri()         != null ? ct.getIdSeri().getId()         : null;
            java.math.BigDecimal donGia    = ct.getDonGia();
            java.math.BigDecimal thanhTien = ct.getThanhTien();
            Integer trangThai = ct.getTrangThai();

            org.hibernate.query.NativeQuery<?> q = session.createNativeQuery(
                "INSERT INTO chi_tiet_hoa_don (ma_cau_hinh, id_hoa_don, id_seri, don_gia, thanh_tien, trang_thai) " +
                "VALUES (:cauHinh, :hoaDon, :seri, :donGia, :thanhTien, :trangThai)");
            q.setParameter("cauHinh",    cauHinhId);
            q.setParameter("hoaDon",     hoaDonId);
            q.setParameter("seri",       seriId);
            q.setParameter("donGia",     donGia);
            q.setParameter("thanhTien",  thanhTien);
            q.setParameter("trangThai",  trangThai);
            q.executeUpdate();

            // Lấy ID vừa insert
            Object newId = session.createNativeQuery("SELECT SCOPE_IDENTITY()").uniqueResult();
            tx.commit();
            if (newId != null) {
                ct.setId(((Number) newId).intValue());
                return ct.getId();
            }
            return null;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return null;
        }
    }

    public void delete(Integer id) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            ChiTietHoaDon ct = session.find(ChiTietHoaDon.class, id);
            if (ct != null) session.delete(ct);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(ChiTietHoaDon ct) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(ct);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
