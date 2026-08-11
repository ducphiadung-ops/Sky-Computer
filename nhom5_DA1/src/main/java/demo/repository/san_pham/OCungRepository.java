package demo.repository.san_pham;


import demo.entity.san_pham.OCung;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class OCungRepository {
    public OCungRepository() {
    }
    public List<OCung> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM OCung WHERE trangThai = 1 ORDER BY id DESC", OCung.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<OCung> filter(String tuKhoa, String trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM OCung o WHERE 1=1");
            boolean coTK = tuKhoa != null && !tuKhoa.trim().isEmpty();
            boolean coTT = trangThai != null && !trangThai.trim().isEmpty();
            if (coTK) hql.append(" AND (LOWER(o.tenOCung) LIKE :tk OR LOWER(o.dungLuongOCung) LIKE :tk)");
            if (coTT) hql.append(" AND o.trangThai = :tt");
            else      hql.append(" AND o.trangThai IN (0,1)");
            hql.append(" ORDER BY o.id DESC");
            var q = session.createQuery(hql.toString(), OCung.class);
            if (coTK) q.setParameter("tk", "%" + tuKhoa.trim().toLowerCase() + "%");
            if (coTT) q.setParameter("tt", Integer.parseInt(trangThai));
            return q.list();
        } catch (Exception e) { e.printStackTrace(); return new java.util.ArrayList<>(); }
    }

    public boolean existsDuplicate(String tenOCung, String dungLuong, Integer excludeId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(o) FROM OCung o WHERE LOWER(o.tenOCung) = LOWER(:ten) AND o.trangThai = 1" +
                    " AND (:dung IS NULL AND o.dungLuongOCung IS NULL OR LOWER(o.dungLuongOCung) = LOWER(:dung))" +
                    " AND o.id <> :excludeId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenOCung.trim())
                    .setParameter("dung", (dungLuong == null || dungLuong.trim().isEmpty()) ? null : dungLuong.trim())
                    .setParameter("excludeId", excludeId == null ? -1 : excludeId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<OCung> getAllDistinctByDungLuong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Lấy id nhỏ nhất đại diện cho mỗi giá trị dung lượng, tránh hiển thị trùng
            List<Integer> ids = session.createQuery(
                    "SELECT MIN(o.id) FROM OCung o WHERE o.trangThai = 1 GROUP BY o.dungLuongOCung",
                    Integer.class).list();
            if (ids == null || ids.isEmpty()) return new java.util.ArrayList<>();
            return session.createQuery(
                    "FROM OCung WHERE id IN :ids ORDER BY id", OCung.class)
                    .setParameter("ids", ids)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
    public OCung getOne(Integer id){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.find(OCung.class, id);
        }
    }
    public void add(OCung oCung) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(oCung);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(OCung oCung) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(oCung);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
