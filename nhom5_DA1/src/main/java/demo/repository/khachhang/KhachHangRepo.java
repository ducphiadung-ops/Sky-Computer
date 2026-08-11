package demo.repository.khachhang;

import demo.util.HibernateConfig;
import demo.entity.khach_hang.KhachHang;
import org.hibernate.Session;
import java.util.List;

public class KhachHangRepo {
    Session session;
    public KhachHangRepo() {session = HibernateConfig.getFACTORY().openSession();
    }
    public List<KhachHang> getAll() { return session.createQuery("from KhachHang").list(); }
    public KhachHang getOne(Integer id) {
        Session session  = HibernateConfig.getFACTORY().openSession();
        return session.find(KhachHang.class, id);}
}
