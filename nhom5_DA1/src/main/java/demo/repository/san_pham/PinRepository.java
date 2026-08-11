package demo.repository.san_pham;


import demo.entity.san_pham.Pin;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class PinRepository {
    public PinRepository() {
    }
    public List<Pin> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM Pin WHERE trangThai = 1 ORDER BY id DESC", Pin.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<Pin> filter(String tuKhoa, String trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM Pin p WHERE 1=1");
            boolean coTK = tuKhoa != null && !tuKhoa.trim().isEmpty();
            boolean coTT = trangThai != null && !trangThai.trim().isEmpty();
            if (coTK) hql.append(" AND (LOWER(p.tenPin) LIKE :tk OR LOWER(p.dungLuongPin) LIKE :tk)");
            if (coTT) hql.append(" AND p.trangThai = :tt");
            else      hql.append(" AND p.trangThai IN (0,1)");
            hql.append(" ORDER BY p.id DESC");
            var q = session.createQuery(hql.toString(), Pin.class);
            if (coTK) q.setParameter("tk", "%" + tuKhoa.trim().toLowerCase() + "%");
            if (coTT) q.setParameter("tt", Integer.parseInt(trangThai));
            return q.list();
        } catch (Exception e) { e.printStackTrace(); return new java.util.ArrayList<>(); }
    }

    public boolean existsDuplicate(String tenPin, String dungLuong, Integer excludeId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(p) FROM Pin p WHERE LOWER(p.tenPin) = LOWER(:ten) AND p.trangThai = 1" +
                    " AND (:dung IS NULL AND p.dungLuongPin IS NULL OR LOWER(p.dungLuongPin) = LOWER(:dung))" +
                    " AND p.id <> :excludeId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenPin.trim())
                    .setParameter("dung", (dungLuong == null || dungLuong.trim().isEmpty()) ? null : dungLuong.trim())
                    .setParameter("excludeId", excludeId == null ? -1 : excludeId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public Pin getOne(Integer id){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.find(Pin.class, id);
        }
    }
    public void add(Pin pin) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(pin);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(Pin pin) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(pin);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
