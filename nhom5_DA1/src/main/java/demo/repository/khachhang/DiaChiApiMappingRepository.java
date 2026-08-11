package demo.repository.khachhang;


import demo.util.HibernateConfig;
import demo.entity.khach_hang.DiaChiApiMapping;
import org.hibernate.Session;

public class DiaChiApiMappingRepository {

    private Session s;

    public DiaChiApiMappingRepository() {
        s = HibernateConfig.getFACTORY().openSession();
    }

    public void add(DiaChiApiMapping mapping) {

        try {

            s.getTransaction().begin();

            s.persist(mapping);

            s.getTransaction().commit();

        } catch (Exception e) {

            e.printStackTrace();

            if (s.getTransaction().isActive()) {
                s.getTransaction().rollback();
            }

        }

    }

    public void update(DiaChiApiMapping mapping) {

        try {

            s.getTransaction().begin();

            s.merge(mapping);

            s.getTransaction().commit();

        } catch (Exception e) {

            e.printStackTrace();

            if (s.getTransaction().isActive()) {
                s.getTransaction().rollback();
            }

        }

    }

    public void delete(DiaChiApiMapping mapping) {

        try {

            s.getTransaction().begin();

            s.delete(mapping);

            s.getTransaction().commit();

        } catch (Exception e) {

            e.printStackTrace();

            if (s.getTransaction().isActive()) {
                s.getTransaction().rollback();
            }

        }

    }

    public DiaChiApiMapping findByDiaChiId(Integer idDiaChiKhachHang) {
        return s.createQuery("FROM DiaChiApiMapping WHERE DiaChiKhachHang.id = :id", DiaChiApiMapping.class)
                .setParameter("id", idDiaChiKhachHang)
                .uniqueResult();
    }
}