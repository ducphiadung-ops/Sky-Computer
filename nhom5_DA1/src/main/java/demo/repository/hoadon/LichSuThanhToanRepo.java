package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.LichSuThanhToan;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.ArrayList;
import java.util.List;

public class LichSuThanhToanRepo {

    public List<LichSuThanhToan> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM LichSuThanhToan", LichSuThanhToan.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void add(LichSuThanhToan ls) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            // Dùng native SQL để tránh detached entity
            Integer hoaDonId = ls.getHoaDon() != null ? ls.getHoaDon().getId() : null;
            session.createNativeQuery(
                "INSERT INTO lich_su_thanh_toan (id_hoa_don, phuong_thuc_thanh_toan, so_tien, trang_thai_thanh_toan, ngay_thanh_toan, ghi_chu, trang_thai) " +
                "VALUES (:hoaDon, :pttt, :soTien, :tttt, :ngay, :ghiChu, :tt)")
                .setParameter("hoaDon", hoaDonId)
                .setParameter("pttt",   ls.getPhuongThucThanhToan())
                .setParameter("soTien", ls.getSoTien())
                .setParameter("tttt",   ls.getTrangThaiThanhToan())
                .setParameter("ngay",   ls.getNgayThanhToan())
                .setParameter("ghiChu", ls.getGhiChu())
                .setParameter("tt",     ls.getTrangThai())
                .executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null) try { tx.rollback(); } catch(Exception ignored) {}
            e.printStackTrace();
        }
    }
}
