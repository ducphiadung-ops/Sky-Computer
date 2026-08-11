package demo.repository.san_pham;


import demo.entity.san_pham.Gpu;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class GpuRepository {
    public GpuRepository() {
    }

    public List<Gpu> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM Gpu WHERE trangThai = 1 ORDER BY id DESC", Gpu.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<Gpu> filter(String tuKhoa, String trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM Gpu g WHERE 1=1");
            boolean coTK = tuKhoa != null && !tuKhoa.trim().isEmpty();
            boolean coTT = trangThai != null && !trangThai.trim().isEmpty();
            if (coTK) hql.append(" AND (LOWER(g.tenGpu) LIKE :tk OR LOWER(g.dungLuongGpu) LIKE :tk)");
            if (coTT) hql.append(" AND g.trangThai = :tt");
            else      hql.append(" AND g.trangThai IN (0,1)");
            hql.append(" ORDER BY g.id DESC");
            var q = session.createQuery(hql.toString(), Gpu.class);
            if (coTK) q.setParameter("tk", "%" + tuKhoa.trim().toLowerCase() + "%");
            if (coTT) q.setParameter("tt", Integer.parseInt(trangThai));
            return q.list();
        } catch (Exception e) { e.printStackTrace(); return new java.util.ArrayList<>(); }
    }

    public boolean existsDuplicate(String tenGpu, String dungLuong, Integer excludeId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(g) FROM Gpu g WHERE LOWER(g.tenGpu) = LOWER(:ten) AND g.trangThai = 1" +
                    " AND (:dung IS NULL AND g.dungLuongGpu IS NULL OR LOWER(g.dungLuongGpu) = LOWER(:dung))" +
                    " AND g.id <> :excludeId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenGpu.trim())
                    .setParameter("dung", (dungLuong == null || dungLuong.trim().isEmpty()) ? null : dungLuong.trim())
                    .setParameter("excludeId", excludeId == null ? -1 : excludeId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Gpu> getDangHoatDong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // ĐÃ SỬA: Đổi Cpu thành Gpu
            return session.createQuery("FROM Gpu WHERE trangThai = 1", Gpu.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Gpu getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(Gpu.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void add(Gpu gpu) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(gpu);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(Gpu gpu) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(gpu);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void deleteSoft(Integer id) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            Gpu gpu = session.find(Gpu.class, id);
            if (gpu != null) {gpu.setTrangThai(0);
                session.merge(gpu);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}