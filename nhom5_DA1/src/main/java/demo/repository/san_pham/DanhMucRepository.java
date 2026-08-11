package demo.repository.san_pham;


import demo.entity.san_pham.DanhMuc;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class DanhMucRepository {

    public DanhMucRepository() {
    }

    public List<DanhMuc> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM DanhMuc where trangThai = 1 ORDER BY id DESC", DanhMuc.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<DanhMuc> filter(String tuKhoa, String trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM DanhMuc d WHERE 1=1");
            boolean coTK = tuKhoa != null && !tuKhoa.trim().isEmpty();
            boolean coTT = trangThai != null && !trangThai.trim().isEmpty();
            if (coTK) hql.append(" AND LOWER(d.tenDanhMuc) LIKE :tk");
            if (coTT) hql.append(" AND d.trangThai = :tt");
            else      hql.append(" AND d.trangThai IN (0,1)");
            hql.append(" ORDER BY d.id DESC");
            var q = session.createQuery(hql.toString(), DanhMuc.class);
            if (coTK) q.setParameter("tk", "%" + tuKhoa.trim().toLowerCase() + "%");
            if (coTT) q.setParameter("tt", Integer.parseInt(trangThai));
            return q.list();
        } catch (Exception e) { e.printStackTrace(); return new java.util.ArrayList<>(); }
    }

    public boolean existsDuplicate(String tenDanhMuc, Integer excludeId) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(d) FROM DanhMuc d WHERE LOWER(d.tenDanhMuc) = LOWER(:ten) AND d.trangThai = 1 AND d.id <> :excludeId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenDanhMuc.trim())
                    .setParameter("excludeId", excludeId == null ? -1 : excludeId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public DanhMuc getOne(Integer id){
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(DanhMuc.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void add (DanhMuc danhMuc){
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(danhMuc);
            tx.commit();
        } catch (Exception e){
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public List<DanhMuc> getDangHoatDong(){
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM DanhMuc where trangThai = 1", DanhMuc.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public void update (DanhMuc danhMuc){
        Transaction tx = null;
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            tx = session.beginTransaction();
            session.merge(danhMuc);
            tx.commit();
        }catch (Exception e){
            if(tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}