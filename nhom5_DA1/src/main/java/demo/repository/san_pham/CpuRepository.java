package demo.repository.san_pham;


import demo.entity.san_pham.Cpu;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class CpuRepository {
    public CpuRepository() {
    }
    public List<Cpu> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM Cpu WHERE trangThai = 1 ORDER BY id DESC", Cpu.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<Cpu> filter(String tuKhoa, String trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM Cpu c WHERE 1=1");
            boolean coTK = tuKhoa != null && !tuKhoa.trim().isEmpty();
            boolean coTT = trangThai != null && !trangThai.trim().isEmpty();
            if (coTK) hql.append(" AND (LOWER(c.tenCpu) LIKE :tk OR LOWER(c.theHeCpu) LIKE :tk)");
            if (coTT) hql.append(" AND c.trangThai = :tt");
            else      hql.append(" AND c.trangThai IN (0,1)");
            hql.append(" ORDER BY c.id DESC");
            var q = session.createQuery(hql.toString(), Cpu.class);
            if (coTK) q.setParameter("tk", "%" + tuKhoa.trim().toLowerCase() + "%");
            if (coTT) q.setParameter("tt", Integer.parseInt(trangThai));
            return q.list();
        } catch (Exception e) { e.printStackTrace(); return new java.util.ArrayList<>(); }
    }

    public boolean existsDuplicate(String tenCpu, String theHeCpu, Integer excludeId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(c) FROM Cpu c WHERE LOWER(c.tenCpu) = LOWER(:ten) AND c.trangThai = 1" +
                    " AND (:theHe IS NULL AND c.theHeCpu IS NULL OR LOWER(c.theHeCpu) = LOWER(:theHe))" +
                    " AND c.id <> :excludeId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenCpu.trim())
                    .setParameter("theHe", (theHeCpu == null || theHeCpu.trim().isEmpty()) ? null : theHeCpu.trim())
                    .setParameter("excludeId", excludeId == null ? -1 : excludeId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public Cpu getOne(Integer id){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.find(Cpu.class, id);
        }
    }

    public void add(Cpu cpu) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(cpu);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
    public void update (Cpu cpu){
        Transaction tx = null;
        try(Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(cpu);
            tx.commit();
        }catch (Exception e){
            if(tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
    public void delete (Integer id){
        Transaction tx = null;
        try(Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.delete(this.getOne(id));
            tx.commit();
        }catch (Exception e){
            if(tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}