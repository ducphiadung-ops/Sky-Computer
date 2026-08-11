package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.LichSuHoaDon;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.ArrayList;
import java.util.List;

public class LichSuHoaDonRepo {

    public List<LichSuHoaDon> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM LichSuHoaDon", LichSuHoaDon.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void add(LichSuHoaDon ls) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            Integer hoaDonId = ls.getHoaDon() != null ? ls.getHoaDon().getId() : null;
            session.createNativeQuery(
                "INSERT INTO lich_su_hoa_don (id_hoa_don, ngay_tao, ghi_chu, trang_thai) " +
                "VALUES (:hoaDon, :ngay, :ghiChu, :tt)")
                .setParameter("hoaDon", hoaDonId)
                .setParameter("ngay",   ls.getNgayTao())
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
