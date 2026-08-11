package demo.repository.san_pham;


import demo.entity.san_pham.ManHinh;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class ManHinhRepository {
    public ManHinhRepository() {
    }

    public List<ManHinh> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM ManHinh WHERE trangThai = 1 ORDER BY id DESC", ManHinh.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<ManHinh> filter(String tuKhoa, String trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM ManHinh m WHERE 1=1");
            boolean coTK = tuKhoa != null && !tuKhoa.trim().isEmpty();
            boolean coTT = trangThai != null && !trangThai.trim().isEmpty();
            if (coTK) hql.append(" AND (LOWER(m.tenManHinh) LIKE :tk OR LOWER(m.kichThuoc) LIKE :tk OR LOWER(m.doPhanGiai) LIKE :tk OR LOWER(m.tanSoQuet) LIKE :tk)");
            if (coTT) hql.append(" AND m.trangThai = :tt");
            else      hql.append(" AND m.trangThai IN (0,1)");
            hql.append(" ORDER BY m.id DESC");
            var q = session.createQuery(hql.toString(), ManHinh.class);
            if (coTK) q.setParameter("tk", "%" + tuKhoa.trim().toLowerCase() + "%");
            if (coTT) q.setParameter("tt", Integer.parseInt(trangThai));
            return q.list();
        } catch (Exception e) { e.printStackTrace(); return new java.util.ArrayList<>(); }
    }

    public boolean existsDuplicate(String tenManHinh, String kichThuoc, String doPhanGiai, String tanSoQuet, Integer excludeId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(m) FROM ManHinh m WHERE LOWER(m.tenManHinh) = LOWER(:ten) AND m.trangThai = 1" +
                    " AND (:kich IS NULL AND m.kichThuoc IS NULL OR LOWER(m.kichThuoc) = LOWER(:kich))" +
                    " AND (:dpg IS NULL AND m.doPhanGiai IS NULL OR LOWER(m.doPhanGiai) = LOWER(:dpg))" +
                    " AND (:tsq IS NULL AND m.tanSoQuet IS NULL OR LOWER(m.tanSoQuet) = LOWER(:tsq))" +
                    " AND m.id <> :excludeId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenManHinh.trim())
                    .setParameter("kich", (kichThuoc == null || kichThuoc.trim().isEmpty()) ? null : kichThuoc.trim())
                    .setParameter("dpg",  (doPhanGiai == null || doPhanGiai.trim().isEmpty()) ? null : doPhanGiai.trim())
                    .setParameter("tsq",  (tanSoQuet == null || tanSoQuet.trim().isEmpty()) ? null : tanSoQuet.trim())
                    .setParameter("excludeId", excludeId == null ? -1 : excludeId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ManHinh> getDangHoatDong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM ManHinh WHERE trangThai = 1", ManHinh.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public ManHinh getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(ManHinh.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void add(ManHinh mh) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(mh);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(ManHinh mh) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(mh);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}