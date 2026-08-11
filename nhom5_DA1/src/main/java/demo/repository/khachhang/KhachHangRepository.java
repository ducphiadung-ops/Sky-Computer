package demo.repository.khachhang;

import demo.util.HibernateConfig;
import demo.entity.khach_hang.KhachHang;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class KhachHangRepository {

    // Hiển thị
    public List<KhachHang> getAll() {
        Session session = HibernateConfig.getFACTORY().openSession();
        List<KhachHang> list = session.createQuery(
                "SELECT DISTINCT kh FROM KhachHang kh " +
                "LEFT JOIN FETCH kh.diaChiKhachHang " +
                "WHERE kh.trangThai = 1 " +
                "ORDER BY kh.id DESC", 
                KhachHang.class
        ).getResultList();
        session.close();
        return list;
    }

    // Lọc danh sách khách hàng
    public List<KhachHang> filter(String tuKhoa, String gioiTinh, String trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("SELECT DISTINCT kh FROM KhachHang kh LEFT JOIN FETCH kh.diaChiKhachHang WHERE 1=1");

            // Từ khóa: tìm theo tên, SĐT, mã KH
            boolean coTuKhoa = tuKhoa != null && !tuKhoa.trim().isEmpty();
            if (coTuKhoa) {
                hql.append(" AND (LOWER(kh.tenKhachHang) LIKE :tuKhoa OR kh.sdt LIKE :tuKhoa OR LOWER(kh.maKhachHang) LIKE :tuKhoa)");
            }

            // Giới tính: "1" = Nam (true), "0" = Nữ (false)
            boolean coGioiTinh = gioiTinh != null && !gioiTinh.trim().isEmpty();
            if (coGioiTinh) {
                hql.append(" AND kh.gioiTinh = :gioiTinh");
            }

            // Trạng thái: "1" = hoạt động, "0" = ngừng, null = tất cả
            boolean coTrangThai = trangThai != null && !trangThai.trim().isEmpty();
            if (coTrangThai) {
                hql.append(" AND kh.trangThai = :trangThai");
            }

            hql.append(" ORDER BY kh.id DESC");

            var query = session.createQuery(hql.toString(), KhachHang.class);
            if (coTuKhoa) {
                query.setParameter("tuKhoa", "%" + tuKhoa.trim().toLowerCase() + "%");
            }
            if (coGioiTinh) {
                query.setParameter("gioiTinh", "1".equals(gioiTinh));
            }
            if (coTrangThai) {
                query.setParameter("trangThai", Integer.parseInt(trangThai));
            }
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
    //


    // Thêm khách hàng
    public void add(KhachHang kh) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = null;

        try {

            transaction = session.beginTransaction();

            session.persist(kh);

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();

        } finally {
            session.close();
        }
    }
    // lấy mã khách hàng lớn nhất
    public String layMaKhachHangMoi() {

        Session session = HibernateConfig.getFACTORY().openSession();

        String hql = "SELECT MAX(maKhachHang) FROM KhachHang";

        String maCuoi = session.createQuery(hql, String.class).uniqueResult();

        session.close();

        if (maCuoi == null) {
            return "KH001";
        }

        int so = Integer.parseInt(maCuoi.substring(2));

        so++;

        return String.format("KH%03d", so);
    }
//xoa
    public void xoa(Integer id){
        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = null;

        try{

            transaction = session.beginTransaction();

            KhachHang kh = session.find(KhachHang.class,id);

            if(kh != null){

                kh.setTrangThai(0);

                session.merge(kh);

            }

            transaction.commit();
        }catch (Exception e){

            if(transaction != null)
            {
                transaction.rollback();
            }

            e.printStackTrace();

        }finally {
            session.close();
        }
    }
    //tim theo id
    public KhachHang timTheoId(Integer id){

        Session session = HibernateConfig.getFACTORY().openSession();

        KhachHang kh = session.find(KhachHang.class,id);

        session.close();

        return kh;
    }
    //cap nhat khách hàng
    public void capNhat(KhachHang kh){

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = null;

        try{
            transaction = session.beginTransaction();

            // Xóa toàn bộ địa chỉ cũ của khách hàng trước khi ghi địa chỉ mới
            // (orphanRemoval trên entity sẽ xử lý, nhưng cần load đúng managed entity)
            KhachHang managed = session.find(KhachHang.class, kh.getId());
            if (managed != null) {
                // Cập nhật các field thông tin chung
                managed.setMaKhachHang(kh.getMaKhachHang());
                managed.setTenKhachHang(kh.getTenKhachHang());
                managed.setGioiTinh(kh.getGioiTinh());
                managed.setNgaySinh(kh.getNgaySinh());
                managed.setSdt(kh.getSdt());
                managed.setEmail(kh.getEmail());
                managed.setTrangThai(kh.getTrangThai());

                // Xóa địa chỉ cũ, thêm địa chỉ mới (orphanRemoval tự xóa DB)
                managed.getDiaChiKhachHangList().clear();

                if (kh.getDiaChiKhachHangList() != null) {
                    for (demo.entity.khach_hang.DiaChiKhachHang dc : kh.getDiaChiKhachHangList()) {
                        dc.setKhachHang(managed);
                        managed.getDiaChiKhachHangList().add(dc);
                    }
                }
            }

            transaction.commit();

        }catch (Exception e){
            if(transaction != null){
                transaction.rollback();
            }
            e.printStackTrace();

        }finally {
            session.close();
        }
    }
    // Kiểm tra SĐT đã tồn tại chưa (bỏ qua theo id khi update)
    public boolean existsBySdt(String sdt, Integer excludeId) {
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            String hql = excludeId != null
                    ? "SELECT COUNT(kh) FROM KhachHang kh WHERE kh.sdt = :sdt AND kh.trangThai = 1 AND kh.id <> :excludeId"
                    : "SELECT COUNT(kh) FROM KhachHang kh WHERE kh.sdt = :sdt AND kh.trangThai = 1";
            org.hibernate.query.Query<Long> query = session.createQuery(hql, Long.class).setParameter("sdt", sdt);
            if (excludeId != null) query.setParameter("excludeId", excludeId);
            return query.uniqueResult() > 0;
        } finally {
            session.close();
        }
    }

    // Kiểm tra email đã tồn tại chưa (bỏ qua theo id khi update)
    public boolean existsByEmail(String email, Integer excludeId) {
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            String hql = excludeId != null
                    ? "SELECT COUNT(kh) FROM KhachHang kh WHERE kh.email = :email AND kh.trangThai = 1 AND kh.id <> :excludeId"
                    : "SELECT COUNT(kh) FROM KhachHang kh WHERE kh.email = :email AND kh.trangThai = 1";
            org.hibernate.query.Query<Long> query = session.createQuery(hql, Long.class).setParameter("email", email);
            if (excludeId != null) query.setParameter("excludeId", excludeId);
            return query.uniqueResult() > 0;
        } finally {
            session.close();
        }
    }

    // doi trang thai
    public void doiTrangThai(Integer id, Integer trangThai) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = session.beginTransaction();

        KhachHang kh = session.find(KhachHang.class, id);

        kh.setTrangThai(trangThai);

        session.merge(kh);

        transaction.commit();

        session.close();
    }
}