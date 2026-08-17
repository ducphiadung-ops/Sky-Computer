package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.HinhThucThanhToan;
import org.hibernate.Session;

import java.util.ArrayList;
import java.util.List;

public class HinhThucThanhToanRepo {

    public List<HinhThucThanhToan> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM HinhThucThanhToan", HinhThucThanhToan.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<HinhThucThanhToan> getAllActive() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HinhThucThanhToan h WHERE h.TrangThai = '1'",
                    HinhThucThanhToan.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public HinhThucThanhToan getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(HinhThucThanhToan.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Tìm hình thức thanh toán đầu tiên có tên chứa từ khóa (không phân biệt hoa thường).
     * Dùng để tự động gán hình thức "Chuyển khoản" trong webhook SePay.
     */
    public HinhThucThanhToan findByTenContaining(String keyword) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            List<HinhThucThanhToan> list = session.createQuery(
                    "FROM HinhThucThanhToan h WHERE LOWER(h.tenHinhThuc) LIKE LOWER(:kw)",
                    HinhThucThanhToan.class)
                    .setParameter("kw", "%" + keyword + "%")
                    .setMaxResults(1)
                    .list();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
