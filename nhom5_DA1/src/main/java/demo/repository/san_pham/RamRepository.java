package demo.repository.san_pham;


import demo.entity.san_pham.Ram;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class RamRepository {
    public RamRepository() {
    }
    public List<Ram> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM Ram WHERE trangThai = 1 ORDER BY id DESC", Ram.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<Ram> filter(String tuKhoa, String trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM Ram r WHERE 1=1");
            boolean coTK = tuKhoa != null && !tuKhoa.trim().isEmpty();
            boolean coTT = trangThai != null && !trangThai.trim().isEmpty();
            if (coTK) hql.append(" AND (LOWER(r.tenRam) LIKE :tk OR LOWER(r.dungLuongRam) LIKE :tk)");
            if (coTT) hql.append(" AND r.trangThai = :tt");
            else      hql.append(" AND r.trangThai IN (0,1)");
            hql.append(" ORDER BY r.id DESC");
            var q = session.createQuery(hql.toString(), Ram.class);
            if (coTK) q.setParameter("tk", "%" + tuKhoa.trim().toLowerCase() + "%");
            if (coTT) q.setParameter("tt", Integer.parseInt(trangThai));
            return q.list();
        } catch (Exception e) { e.printStackTrace(); return new java.util.ArrayList<>(); }
    }

    public boolean existsDuplicate(String tenRam, String dungLuong, Integer excludeId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(r) FROM Ram r WHERE LOWER(r.tenRam) = LOWER(:ten) AND r.trangThai = 1" +
                    " AND (:dung IS NULL AND r.dungLuongRam IS NULL OR LOWER(r.dungLuongRam) = LOWER(:dung))" +
                    " AND r.id <> :excludeId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenRam.trim())
                    .setParameter("dung", (dungLuong == null || dungLuong.trim().isEmpty()) ? null : dungLuong.trim())
                    .setParameter("excludeId", excludeId == null ? -1 : excludeId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Ram> getAllDistinctByDungLuong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Lấy id nhỏ nhất đại diện cho mỗi giá trị dung lượng, tránh hiển thị trùng
            List<Integer> ids = session.createQuery(
                    "SELECT MIN(r.id) FROM Ram r WHERE r.trangThai = 1 GROUP BY r.dungLuongRam",
                    Integer.class).list();
            if (ids == null || ids.isEmpty()) return new java.util.ArrayList<>();
            return session.createQuery(
                    "FROM Ram WHERE id IN :ids ORDER BY id", Ram.class)
                    .setParameter("ids", ids)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
    public Ram getOne(Integer id){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.find(Ram.class, id);
        }
    }
    public void add(Ram ram) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(ram);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(Ram ram) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(ram);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
