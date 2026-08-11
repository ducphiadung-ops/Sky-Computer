    package demo.repository.nhanvien;

    import demo.entity.nhan_vien.NhanVien;
    import demo.util.HibernateConfig;
    import org.hibernate.Session;
    import org.hibernate.Transaction;

    import java.util.List;

    public class NhanVienRepository {

        // Hiển thị
        public List<NhanVien> getAll() {
            Session session = HibernateConfig.getFACTORY().openSession();
            List<NhanVien> list = session.createQuery("FROM NhanVien WHERE trangThai = 1 ORDER BY id DESC", NhanVien.class).getResultList();
            session.close();
            return list;
        }

        // Lọc danh sách nhân viên
        public List<NhanVien> filter(String tuKhoa, String chucVu, String trangThai) {
            try (Session session = HibernateConfig.getFACTORY().openSession()) {
                StringBuilder hql = new StringBuilder("FROM NhanVien nv WHERE 1=1");

                // Từ khóa: tìm theo tên, SĐT, mã NV
                boolean coTuKhoa = tuKhoa != null && !tuKhoa.trim().isEmpty();
                if (coTuKhoa) {
                    hql.append(" AND (LOWER(nv.hoTen) LIKE :tuKhoa OR nv.sdt LIKE :tuKhoa OR LOWER(nv.maNhanVien) LIKE :tuKhoa)");
                }

                // Chức vụ: "Quản Lý" hoặc "Nhân viên"
                boolean coChucVu = chucVu != null && !chucVu.trim().isEmpty();
                if (coChucVu) {
                    hql.append(" AND LOWER(nv.chucVu) = :chucVu");
                }

                // Trạng thái: "1" = đang làm, "0" = đã nghỉ, null = tất cả
                boolean coTrangThai = trangThai != null && !trangThai.trim().isEmpty();
                if (coTrangThai) {
                    hql.append(" AND nv.trangThai = :trangThai");
                }

                hql.append(" ORDER BY nv.id DESC");

                var query = session.createQuery(hql.toString(), NhanVien.class);
                if (coTuKhoa) {
                    query.setParameter("tuKhoa", "%" + tuKhoa.trim().toLowerCase() + "%");
                }
                if (coChucVu) {
                    query.setParameter("chucVu", chucVu.trim().toLowerCase());
                }
                if (coTrangThai) {
                    query.setParameter("trangThai", Integer.parseInt(trangThai));
                }
                return query.getResultList();
            } catch (Exception e) {
                e.printStackTrace();
                return new java.util.ArrayList<>();
            }
        }

        // Thêm
        public void add(NhanVien nv) {

            Session session = HibernateConfig.getFACTORY().openSession();

            Transaction transaction = session.beginTransaction();

            session.persist(nv);

            transaction.commit();

            session.close();

        }

        // Lấy theo id
        public NhanVien getOne(Integer id) {

            Session session = HibernateConfig.getFACTORY().openSession();

            NhanVien nv = session.find(NhanVien.class, id);

            session.close();

            return nv;

        }

        // Lấy mã nhân viên mới
        public String layMaNhanVienMoi() {

            Session session = HibernateConfig.getFACTORY().openSession();

            String hql = "SELECT MAX(maNhanVien) FROM NhanVien";

            String maCuoi = session.createQuery(hql, String.class).uniqueResult();

            session.close();

            if (maCuoi == null) {
                return "NV001";
            }

            int so = Integer.parseInt(maCuoi.substring(2));

            so++;

            return String.format("NV%03d", so);
        }

        // Đăng nhập
        public NhanVien findByTaiKhoanAndMatKhau(String taiKhoan, String matKhau) {
            Session session = HibernateConfig.getFACTORY().openSession();
            try {
                String hql = "FROM NhanVien WHERE taiKhoan = :taiKhoan AND matKhau = :matKhau AND trangThai = 1";
                return session.createQuery(hql, NhanVien.class)
                        .setParameter("taiKhoan", taiKhoan)
                        .setParameter("matKhau", matKhau)
                        .uniqueResult();
            } finally {
                session.close();
            }
        }

        // Sửa
        public void update(NhanVien nv) {

            Session session = HibernateConfig.getFACTORY().openSession();

            Transaction transaction = session.beginTransaction();

            session.merge(nv);

            transaction.commit();

            session.close();

        }

        // Xóa thật khỏi database
        public void delete(Integer id) {

            Session session = HibernateConfig.getFACTORY().openSession();

            Transaction transaction = null;

            try {
                transaction = session.beginTransaction();

                // 1. Set NULL cột id_nhan_vien trên tất cả hóa đơn liên quan
                //    để tránh lỗi FK constraint khi xóa nhân viên
                session.createQuery(
                        "UPDATE HoaDon hd SET hd.nhanVien = NULL WHERE hd.nhanVien.id = :id"
                ).setParameter("id", id).executeUpdate();

                // 2. Xóa nhân viên khỏi database
                NhanVien nv = session.find(NhanVien.class, id);

                if (nv != null) {
                    session.remove(nv);
                }

                transaction.commit();

            } catch (Exception e) {
                if (transaction != null) {
                    transaction.rollback();
                }
                e.printStackTrace();
            } finally {
                session.close();
            }

        }

        // Kiểm tra SĐT đã tồn tại chưa (bỏ qua theo id khi update)
        public boolean existsBySdt(String sdt, Integer excludeId) {
            Session session = HibernateConfig.getFACTORY().openSession();
            try {
                String hql = excludeId != null
                        ? "SELECT COUNT(nv) FROM NhanVien nv WHERE nv.sdt = :sdt AND nv.trangThai = 1 AND nv.id <> :excludeId"
                        : "SELECT COUNT(nv) FROM NhanVien nv WHERE nv.sdt = :sdt AND nv.trangThai = 1";
                org.hibernate.query.Query<Long> query = session.createQuery(hql, Long.class).setParameter("sdt", sdt);
                if (excludeId != null) query.setParameter("excludeId", excludeId);
                return query.uniqueResult() > 0;
            } finally {
                session.close();
            }
        }

        // Kiểm tra email đã tồn tại chưa (bỏ qua theo id khi update)
        public boolean existsByEmail(String email, Integer excludeId) {
            Session session = HibernateConfig.getFACTORY().openSession();
            try {
                String hql = excludeId != null
                        ? "SELECT COUNT(nv) FROM NhanVien nv WHERE nv.email = :email AND nv.trangThai = 1 AND nv.id <> :excludeId"
                        : "SELECT COUNT(nv) FROM NhanVien nv WHERE nv.email = :email AND nv.trangThai = 1";
                org.hibernate.query.Query<Long> query = session.createQuery(hql, Long.class).setParameter("email", email);
                if (excludeId != null) query.setParameter("excludeId", excludeId);
                return query.uniqueResult() > 0;
            } finally {
                session.close();
            }
        }

        // switch doi trang thai
        public void doiTrangThai(Integer id, Integer trangThai) {

            Session session = HibernateConfig.getFACTORY().openSession();

            Transaction transaction = session.beginTransaction();

            NhanVien nv = session.find(NhanVien.class, id);

            nv.setTrangThai(trangThai);

            session.merge(nv);

            transaction.commit();

            session.close();
        }

    }
