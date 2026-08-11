package demo.repository.khachhang;

import demo.util.HibernateConfig;
import demo.entity.khach_hang.DiaChiKhachHang;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class DiaChiKhachHangRepository {

    // Hiển thị tất cả địa chỉ
    public List<DiaChiKhachHang> getAll() {

        Session session = HibernateConfig.getFACTORY().openSession();

        List<DiaChiKhachHang> list =
                session.createQuery("FROM DiaChiKhachHang", DiaChiKhachHang.class)
                        .getResultList();

        session.close();

        return list;
    }

    // Lấy địa chỉ theo id
    public DiaChiKhachHang getOne(Integer id) {

        Session session = HibernateConfig.getFACTORY().openSession();

        DiaChiKhachHang diaChi = session.find(DiaChiKhachHang.class, id);

        session.close();

        return diaChi;
    }

    // Thêm địa chỉ
    public void add(DiaChiKhachHang diaChi) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = session.beginTransaction();

        session.persist(diaChi);

        transaction.commit();

        session.close();
    }

    // Sửa địa chỉ
    public void update(DiaChiKhachHang diaChi) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = session.beginTransaction();

        session.merge(diaChi);

        transaction.commit();

        session.close();
    }

    // Xóa địa chỉ
    public void delete(Integer id) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = session.beginTransaction();

        DiaChiKhachHang diaChi = session.find(DiaChiKhachHang.class, id);

        if (diaChi != null) {
            session.remove(diaChi);
        }

        transaction.commit();

        session.close();
    }

    // Lấy địa chỉ theo id khách hàng
    public DiaChiKhachHang getByKhachHang(Integer idKhachHang) {

        Session session = HibernateConfig.getFACTORY().openSession();

        DiaChiKhachHang diaChi = session.createQuery(
                        "FROM DiaChiKhachHang WHERE khachHang.id = :id",
                        DiaChiKhachHang.class)
                .setParameter("id", idKhachHang)
                .uniqueResult();

        session.close();

        return diaChi;
    }

    // Xóa tất cả địa chỉ của khách hàng
    public void deleteByKhachHang(Integer idKhachHang) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = session.beginTransaction();

        session.createQuery(
                        "DELETE FROM DiaChiKhachHang WHERE khachHang.id = :id")
                .setParameter("id", idKhachHang)
                .executeUpdate();

        transaction.commit();

        session.close();
    }

}
