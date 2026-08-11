package demo.repository.san_pham;


import demo.entity.san_pham.ThuongHieu;
import demo.util.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class ThuongHieuRepository {
    private Session session;

    public ThuongHieuRepository() {
        session = HibernateConfig.getFACTORY().openSession();
    }
    public List<ThuongHieu> getAll(){
        return session.createQuery("FROM ThuongHieu WHERE trangThai = 1 ORDER BY id DESC", ThuongHieu.class).list();
    }
    public List<ThuongHieu> filter(String tuKhoa, String trangThai) {
        try {
            StringBuilder hql = new StringBuilder("FROM ThuongHieu t WHERE 1=1");
            boolean coTK = tuKhoa != null && !tuKhoa.trim().isEmpty();
            boolean coTT = trangThai != null && !trangThai.trim().isEmpty();
            if (coTK) hql.append(" AND LOWER(t.tenThuongHieu) LIKE :tk");
            if (coTT) hql.append(" AND t.trangThai = :tt");
            else      hql.append(" AND t.trangThai IN (0,1)");
            hql.append(" ORDER BY t.id DESC");
            var q = session.createQuery(hql.toString(), ThuongHieu.class);
            if (coTK) q.setParameter("tk", "%" + tuKhoa.trim().toLowerCase() + "%");
            if (coTT) q.setParameter("tt", Integer.parseInt(trangThai));
            return q.list();
        } catch (Exception e) { e.printStackTrace(); return new java.util.ArrayList<>(); }
    }

    public boolean existsDuplicate(String tenThuongHieu, Integer excludeId) {
        try {
            String hql = "SELECT COUNT(t) FROM ThuongHieu t WHERE LOWER(t.tenThuongHieu) = LOWER(:ten) AND t.trangThai = 1 AND t.id <> :excludeId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenThuongHieu.trim())
                    .setParameter("excludeId", excludeId == null ? -1 : excludeId)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public ThuongHieu getOne(Integer id){
        return session.find(ThuongHieu.class, id);
    }
    public void add (ThuongHieu thuongHieu){
        try {
            session.getTransaction().begin();
            session.save(thuongHieu);
            session.getTransaction().commit();
        }catch (Exception e){
            session.getTransaction().rollback();
            e.printStackTrace();
        }
    }
    public void update (ThuongHieu thuongHieu){
        try {
            session.getTransaction().begin();
            session.merge(thuongHieu);
            session.getTransaction().commit();
        }catch (Exception e){
            session.getTransaction().rollback();
            e.printStackTrace();
        }
    }
    public void delete (Integer id){
        try {
            session.getTransaction().begin();
            session.delete(this.getOne(id));
            session.getTransaction().commit();
        }catch (Exception e){
            session.getTransaction().rollback();
            e.printStackTrace();
        }
    }
    public List<ThuongHieu> getDangHoatDong(){
        return session.createQuery("FROM ThuongHieu where trangThai = 1", ThuongHieu.class).getResultList();
    }
}
