package demo.repository.san_pham;

import demo.entity.san_pham.MauSac;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;
public class MauSacRepository {
    public MauSacRepository() {
    }

    public List<MauSac> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM MauSac WHERE trangThai = 1 ORDER BY id DESC", MauSac.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<MauSac> filter(String tuKhoa, String trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM MauSac m WHERE 1=1");
            boolean coTK = tuKhoa != null && !tuKhoa.trim().isEmpty();
            boolean coTT = trangThai != null && !trangThai.trim().isEmpty();
            if (coTK) hql.append(" AND LOWER(m.tenMauSac) LIKE :tk");
            if (coTT) hql.append(" AND m.trangThai = :tt");
            else      hql.append(" AND m.trangThai IN (0,1)");
            hql.append(" ORDER BY m.id DESC");
            var q = session.createQuery(hql.toString(), MauSac.class);
            if (coTK) q.setParameter("tk", "%" + tuKhoa.trim().toLowerCase() + "%");
            if (coTT) q.setParameter("tt", Integer.parseInt(trangThai));
            return q.list();
        } catch (Exception e) { e.printStackTrace(); return new java.util.ArrayList<>(); }
    }

    public boolean existsDuplicate(String tenMauSac, Integer excludeId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(m) FROM MauSac m WHERE LOWER(m.tenMauSac) = LOWER(:ten) AND m.trangThai = 1 AND m.id <> :excludeId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenMauSac.trim())
                    .setParameter("excludeId", excludeId == null ? -1 : excludeId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<MauSac> getDangHoatDong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // ĐÃ SỬA: Đổi Cpu thành MauSac
            return session.createQuery("FROM MauSac WHERE trangThai = 1", MauSac.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public MauSac getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(MauSac.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void add(MauSac mauSac) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(mauSac);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(MauSac mauSac) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(mauSac);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}