package demo.repository.san_pham;


import demo.entity.san_pham.CauHinhSanPham;
import demo.entity.san_pham.ChiTietSanPham;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class ChiTietSanPhamRepository {

    public ChiTietSanPhamRepository() {
    }

    public ChiTietSanPham getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Step 1: Dùng HQL đơn giản nhất, chỉ FETCH sang Sản phẩm và Cấu hình
            String hql = "SELECT ct FROM ChiTietSanPham ct " +
                    "LEFT JOIN FETCH ct.sanPham sp " +
                    "LEFT JOIN FETCH ct.cauHinhSanPham ch " +
                    "WHERE ct.id = :id";

            ChiTietSanPham ct = session.createQuery(hql, ChiTietSanPham.class)
                    .setParameter("id", id)
                    .uniqueResult();

            // Step 2: Nếu tìm thấy, chủ động kích hoạt (Lazy Load) an toàn các thuộc tính con
            if (ct != null && ct.getCauHinhSanPham() != null) {
                CauHinhSanPham ch = ct.getCauHinhSanPham();

                // Dùng các khối try-catch bọc từng linh kiện, lỗi linh kiện nào cũng không sợ sập dây chuyền
                try { if (ch.getCpu() != null) ch.getCpu().getTenCpu(); } catch (Exception e) {}
                try { if (ch.getRam() != null) ch.getRam().getDungLuongRam(); } catch (Exception e) {}
                try { if (ch.getOCung() != null) ch.getOCung().getDungLuongOCung(); } catch (Exception e) {}
                try { if (ch.getGpu() != null) ch.getGpu().getTenGpu(); } catch (Exception e) {}
                try { if (ch.getManHinh() != null) ch.getManHinh().getTenManHinh(); } catch (Exception e) {}
                try { if (ch.getMauSac() != null) ch.getMauSac().getTenMauSac(); } catch (Exception e) {}
                try { if (ch.getPin() != null) ch.getPin().getTenPin(); } catch (Exception e) {}
            }

            return ct;
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi lấy chi tiết biến thể getOne: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    public List<ChiTietSanPham> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT ct FROM ChiTietSanPham ct " +
                    "LEFT JOIN FETCH ct.sanPham sp " +
                    "LEFT JOIN FETCH ct.cauHinhSanPham ch " +
                    "WHERE sp.trangThai = 1 " +
                    "ORDER BY ct.id DESC";

            List<ChiTietSanPham> list = session.createQuery(hql, ChiTietSanPham.class).getResultList();
            for (ChiTietSanPham ct : list) {
                if (ct.getCauHinhSanPham() != null) {
                    if (ct.getCauHinhSanPham().getCpu() != null) {
                        ct.getCauHinhSanPham().getCpu().getTenCpu(); // Kích hoạt Lazy load CPU
                    }
                    if (ct.getCauHinhSanPham().getRam() != null) {
                        ct.getCauHinhSanPham().getRam().getTenRam(); // Kích hoạt Lazy load RAM
                    }
                    if (ct.getCauHinhSanPham().getOCung() != null) {
                        ct.getCauHinhSanPham().getOCung().getTenOCung(); // Kích hoạt Lazy load Ổ cứng
                    }
                    if (ct.getCauHinhSanPham().getMauSac() != null) {
                        ct.getCauHinhSanPham().getMauSac().getTenMauSac(); // Kích hoạt Lazy load Màu sắc
                    }
                }
            }

            return list;
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi lấy danh sách sản phẩm chi tiết: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * Chỉ lấy các biến thể (ChiTietSanPham) có ít nhất 1 IMEI đang hoạt động (trangThai=1).
     * Dùng cho trang bán hàng tại quầy — ẩn biến thể hết hàng khỏi danh sách chọn.
     */
    public List<ChiTietSanPham> getAllCoImeiHoatDong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Chỉ lấy biến thể khi:
            // 1. Biến thể đang hoạt động (ct.trangThai = 1)
            // 2. Sản phẩm cha đang kinh doanh (sp.trangThai = 1)
            // 3. Có ít nhất 1 IMEI còn trong kho (MaSeri.trangThai = 1)
            String hql = "SELECT ct FROM ChiTietSanPham ct " +
                    "LEFT JOIN FETCH ct.sanPham sp " +
                    "LEFT JOIN FETCH ct.cauHinhSanPham ch " +
                    "WHERE ct.trangThai = 1 " +
                    "AND sp.trangThai = 1 " +
                    "AND EXISTS (" +
                    "  SELECT 1 FROM MaSeri ms " +
                    "  WHERE ms.cauHinhSanPham.id = ch.id AND ms.trangThai = 1" +
                    ") " +
                    "ORDER BY ct.id DESC";

            List<ChiTietSanPham> list = session.createQuery(hql, ChiTietSanPham.class).getResultList();

            // Kích hoạt lazy load các thuộc tính con (giữ đúng pattern của getAll)
            for (ChiTietSanPham ct : list) {
                if (ct.getCauHinhSanPham() != null) {
                    CauHinhSanPham ch = ct.getCauHinhSanPham();
                    try { if (ch.getCpu()    != null) ch.getCpu().getTenCpu(); }    catch (Exception e) {}
                    try { if (ch.getRam()    != null) ch.getRam().getTenRam(); }    catch (Exception e) {}
                    try { if (ch.getOCung()  != null) ch.getOCung().getTenOCung(); } catch (Exception e) {}
                    try { if (ch.getMauSac() != null) ch.getMauSac().getTenMauSac(); } catch (Exception e) {}
                    try { if (ch.getGpu()    != null) ch.getGpu().getTenGpu(); }    catch (Exception e) {}
                }
            }

            return list;
        } catch (Exception e) {
            System.out.println("❌ Lỗi getAllCoImeiHoatDong: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public List<ChiTietSanPham> findByCauHinhId(Integer idCauHinh) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "SELECT ct FROM ChiTietSanPham ct WHERE ct.cauHinhSanPham.id = :id",
                    ChiTietSanPham.class)
                    .setParameter("id", idCauHinh)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public List<ChiTietSanPham> findBySanPhamId(Integer idSanPham) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT ct FROM ChiTietSanPham ct " +
                    "LEFT JOIN FETCH ct.sanPham sp " +
                    "LEFT JOIN FETCH ct.cauHinhSanPham ch " +
                    "WHERE ct.sanPham.id = :id " +
                    "AND sp.trangThai = 1 " +
                    "ORDER BY ct.id DESC";
            return session.createQuery(hql, ChiTietSanPham.class)
                    .setParameter("id", idSanPham)
                    .getResultList();
        }
    }

    public void add(ChiTietSanPham ctsp) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.save(ctsp);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void delete(Integer id) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            ChiTietSanPham ctsp = session.find(ChiTietSanPham.class, id);
            if (ctsp != null) {
                session.delete(ctsp);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void update(ChiTietSanPham ctsp) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.merge(ctsp);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    // 🟢 Đếm tất cả biến thể theo idSanPham rồi UPDATE thẳng vào san_pham.so_luong_ton
    public void capNhatSoLuongTonSanPhamCha(Integer idSanPham) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            Long soLuongBienThe = session.createQuery(
                            "SELECT COUNT(ct) FROM ChiTietSanPham ct WHERE ct.sanPham.id = :idSP",
                            Long.class)
                    .setParameter("idSP", idSanPham)
                    .uniqueResult();

            int soLuong = (soLuongBienThe != null) ? soLuongBienThe.intValue() : 0;

            session.createNativeQuery(
                            "UPDATE san_pham SET so_luong_ton = :soLuong WHERE id = :idSP")
                    .setParameter("soLuong", soLuong)
                    .setParameter("idSP", idSanPham)
                    .executeUpdate();

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            System.out.println("❌ Lỗi capNhatSoLuongTonSanPhamCha: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 🟢 Đếm tổng số biến thể (kể cả trạng_thái 0 và 1) theo id sản phẩm cha
    public long countAllBySanPhamId(Integer idSanPham) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Long count = session.createQuery(
                            "SELECT COUNT(ct) FROM ChiTietSanPham ct WHERE ct.sanPham.id = :idSP",
                            Long.class)
                    .setParameter("idSP", idSanPham)
                    .uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            System.out.println("❌ Lỗi countAllBySanPhamId: " + e.getMessage());
            return 0L;
        }
    }

    // 🟢 Đếm số biến thể CÒN HOẠT ĐỘNG (trạng_thái = 1) theo id sản phẩm cha
    public long countActiveBySanPhamId(Integer idSanPham) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Long count = session.createQuery(
                            "SELECT COUNT(ct) FROM ChiTietSanPham ct WHERE ct.sanPham.id = :idSP AND ct.trangThai = 1",
                            Long.class)
                    .setParameter("idSP", idSanPham)
                    .uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            System.out.println("❌ Lỗi countActiveBySanPhamId: " + e.getMessage());
            return 0L;
        }
    }

    // 🟢 TÁC VỤ 2: Tự động đồng bộ số lượng tồn kho (ton_kho) dựa theo số IMEI còn trong kho (trang_thai = 1)
    // Đếm tổng số mã seri (bảng ma_seri) có trang_thai = true thuộc cấu hình idCauHinh,
    // rồi UPDATE kết quả đếm được vào cột ton_kho của bảng chi_tiet_san_pham tương ứng.
    public void capNhatTonKhoTheoImei(Integer idCauHinh) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            Long soLuongConLai = session.createQuery(
                            "SELECT COUNT(m) FROM MaSeri m " +
                                    "WHERE m.cauHinhSanPham.id = :idCH AND m.trangThai = 1",
                            Long.class)
                    .setParameter("idCH", idCauHinh)
                    .uniqueResult();

            int tonKhoMoi = (soLuongConLai != null) ? soLuongConLai.intValue() : 0;

            session.createQuery(
                            "UPDATE ChiTietSanPham ct SET ct.tonKho = :tonKho " +
                                    "WHERE ct.cauHinhSanPham.id = :idCH")
                    .setParameter("tonKho", tonKhoMoi)
                    .setParameter("idCH", idCauHinh)
                    .executeUpdate();

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            System.out.println("❌ Lỗi khi đồng bộ tồn kho theo IMEI: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Lọc biến thể đa tiêu chí cho trang Quản lý Biến thể Sản phẩm.
     * Tất cả tham số đều nullable — null nghĩa là bỏ qua điều kiện đó.
     * @param idSanPham  nếu không null thì ghim theo 1 SP cụ thể (chế độ xem biến thể của SP cha)
     */
    public List<ChiTietSanPham> locDaKieu(String tenSanPham,
                                          Integer idCpu, Integer idGpu,
                                          Integer idMauSac, Integer idRam, Integer idOCung,
                                          Integer trangThai,
                                          java.math.BigDecimal giaMin, java.math.BigDecimal giaMax,
                                          Integer idSanPham) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT ct FROM ChiTietSanPham ct " +
                    "LEFT JOIN FETCH ct.sanPham sp " +
                    "LEFT JOIN FETCH ct.cauHinhSanPham ch " +
                    "WHERE sp.trangThai = 1");

            if (tenSanPham != null && !tenSanPham.trim().isEmpty())
                hql.append(" AND LOWER(sp.tenSanPham) LIKE LOWER(:tenSanPham)");
            if (idSanPham != null)
                hql.append(" AND sp.id = :idSanPham");
            if (idCpu != null)
                hql.append(" AND ch.cpu.id = :idCpu");
            if (idGpu != null)
                hql.append(" AND ch.gpu.id = :idGpu");
            if (idMauSac != null)
                hql.append(" AND ch.mauSac.id = :idMauSac");
            if (idRam != null)
                hql.append(" AND ch.ram.id = :idRam");
            if (idOCung != null)
                hql.append(" AND ch.OCung.id = :idOCung");
            if (trangThai != null)
                hql.append(" AND ct.trangThai = :trangThai");
            if (giaMin != null)
                hql.append(" AND ct.donGia >= :giaMin");
            if (giaMax != null)
                hql.append(" AND ct.donGia <= :giaMax");

            hql.append(" ORDER BY ct.id DESC");

            org.hibernate.query.Query<ChiTietSanPham> query =
                    session.createQuery(hql.toString(), ChiTietSanPham.class);

            if (tenSanPham != null && !tenSanPham.trim().isEmpty())
                query.setParameter("tenSanPham", "%" + tenSanPham.trim() + "%");
            if (idSanPham != null) query.setParameter("idSanPham", idSanPham);
            if (idCpu != null)    query.setParameter("idCpu", idCpu);
            if (idGpu != null)    query.setParameter("idGpu", idGpu);
            if (idMauSac != null) query.setParameter("idMauSac", idMauSac);
            if (idRam != null)    query.setParameter("idRam", idRam);
            if (idOCung != null)  query.setParameter("idOCung", idOCung);
            if (trangThai != null) query.setParameter("trangThai", trangThai);
            if (giaMin != null)   query.setParameter("giaMin", giaMin);
            if (giaMax != null)   query.setParameter("giaMax", giaMax);

            List<ChiTietSanPham> list = query.getResultList();

            // Kích hoạt lazy-load các thuộc tính con
            for (ChiTietSanPham ct : list) {
                if (ct.getCauHinhSanPham() != null) {
                    CauHinhSanPham ch = ct.getCauHinhSanPham();
                    try { if (ch.getCpu()    != null) ch.getCpu().getTenCpu();          } catch (Exception ignored) {}
                    try { if (ch.getRam()    != null) ch.getRam().getTenRam();          } catch (Exception ignored) {}
                    try { if (ch.getOCung()  != null) ch.getOCung().getTenOCung();      } catch (Exception ignored) {}
                    try { if (ch.getMauSac() != null) ch.getMauSac().getTenMauSac();    } catch (Exception ignored) {}
                    try { if (ch.getGpu()    != null) ch.getGpu().getTenGpu();          } catch (Exception ignored) {}
                }
            }
            return list;
        } catch (Exception e) {
            System.out.println("❌ Lỗi locDaKieu ChiTietSanPham: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * Đếm tổng số biến thể khớp bộ lọc (dùng cho phân trang).
     * Tham số giống hệt locDaKieu().
     */
    public long countLocDaKieu(String tenSanPham,
                                Integer idCpu, Integer idGpu,
                                Integer idMauSac, Integer idRam, Integer idOCung,
                                Integer trangThai,
                                java.math.BigDecimal giaMin, java.math.BigDecimal giaMax,
                                Integer idSanPham) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT COUNT(ct) FROM ChiTietSanPham ct " +
                    "LEFT JOIN ct.sanPham sp " +
                    "LEFT JOIN ct.cauHinhSanPham ch " +
                    "WHERE sp.trangThai = 1");

            if (tenSanPham != null && !tenSanPham.trim().isEmpty())
                hql.append(" AND LOWER(sp.tenSanPham) LIKE LOWER(:tenSanPham)");
            if (idSanPham != null) hql.append(" AND sp.id = :idSanPham");
            if (idCpu     != null) hql.append(" AND ch.cpu.id = :idCpu");
            if (idGpu     != null) hql.append(" AND ch.gpu.id = :idGpu");
            if (idMauSac  != null) hql.append(" AND ch.mauSac.id = :idMauSac");
            if (idRam     != null) hql.append(" AND ch.ram.id = :idRam");
            if (idOCung   != null) hql.append(" AND ch.oCung.id = :idOCung");
            if (trangThai != null) hql.append(" AND ct.trangThai = :trangThai");
            if (giaMin    != null) hql.append(" AND ct.donGia >= :giaMin");
            if (giaMax    != null) hql.append(" AND ct.donGia <= :giaMax");

            org.hibernate.query.Query<Long> query =
                    session.createQuery(hql.toString(), Long.class);

            if (tenSanPham != null && !tenSanPham.trim().isEmpty())
                query.setParameter("tenSanPham", "%" + tenSanPham.trim() + "%");
            if (idSanPham != null) query.setParameter("idSanPham", idSanPham);
            if (idCpu     != null) query.setParameter("idCpu",     idCpu);
            if (idGpu     != null) query.setParameter("idGpu",     idGpu);
            if (idMauSac  != null) query.setParameter("idMauSac",  idMauSac);
            if (idRam     != null) query.setParameter("idRam",     idRam);
            if (idOCung   != null) query.setParameter("idOCung",   idOCung);
            if (trangThai != null) query.setParameter("trangThai", trangThai);
            if (giaMin    != null) query.setParameter("giaMin",    giaMin);
            if (giaMax    != null) query.setParameter("giaMax",    giaMax);

            Long result = query.getSingleResult();
            return result != null ? result : 0L;
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }

    /**
     * Lọc đa tiêu chí có phân trang (offset + limit).
     */
    public List<ChiTietSanPham> locDaKieuPhanTrang(String tenSanPham,
                                                    Integer idCpu, Integer idGpu,
                                                    Integer idMauSac, Integer idRam, Integer idOCung,
                                                    Integer trangThai,
                                                    java.math.BigDecimal giaMin, java.math.BigDecimal giaMax,
                                                    Integer idSanPham,
                                                    int offset, int limit) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT ct FROM ChiTietSanPham ct " +
                    "LEFT JOIN FETCH ct.sanPham sp " +
                    "LEFT JOIN FETCH ct.cauHinhSanPham ch " +
                    "WHERE sp.trangThai = 1");

            if (tenSanPham != null && !tenSanPham.trim().isEmpty())
                hql.append(" AND LOWER(sp.tenSanPham) LIKE LOWER(:tenSanPham)");
            if (idSanPham != null) hql.append(" AND sp.id = :idSanPham");
            if (idCpu     != null) hql.append(" AND ch.cpu.id = :idCpu");
            if (idGpu     != null) hql.append(" AND ch.gpu.id = :idGpu");
            if (idMauSac  != null) hql.append(" AND ch.mauSac.id = :idMauSac");
            if (idRam     != null) hql.append(" AND ch.ram.id = :idRam");
            if (idOCung   != null) hql.append(" AND ch.oCung.id = :idOCung");
            if (trangThai != null) hql.append(" AND ct.trangThai = :trangThai");
            if (giaMin    != null) hql.append(" AND ct.donGia >= :giaMin");
            if (giaMax    != null) hql.append(" AND ct.donGia <= :giaMax");
            hql.append(" ORDER BY ct.id DESC");

            org.hibernate.query.Query<ChiTietSanPham> query =
                    session.createQuery(hql.toString(), ChiTietSanPham.class);

            if (tenSanPham != null && !tenSanPham.trim().isEmpty())
                query.setParameter("tenSanPham", "%" + tenSanPham.trim() + "%");
            if (idSanPham != null) query.setParameter("idSanPham", idSanPham);
            if (idCpu     != null) query.setParameter("idCpu",     idCpu);
            if (idGpu     != null) query.setParameter("idGpu",     idGpu);
            if (idMauSac  != null) query.setParameter("idMauSac",  idMauSac);
            if (idRam     != null) query.setParameter("idRam",     idRam);
            if (idOCung   != null) query.setParameter("idOCung",   idOCung);
            if (trangThai != null) query.setParameter("trangThai", trangThai);
            if (giaMin    != null) query.setParameter("giaMin",    giaMin);
            if (giaMax    != null) query.setParameter("giaMax",    giaMax);

            List<ChiTietSanPham> list = query
                    .setFirstResult(offset)
                    .setMaxResults(limit)
                    .getResultList();

            // Kích hoạt lazy-load các thuộc tính con
            for (ChiTietSanPham ct : list) {
                if (ct.getCauHinhSanPham() != null) {
                    CauHinhSanPham ch = ct.getCauHinhSanPham();
                    try { if (ch.getCpu()    != null) ch.getCpu().getTenCpu();       } catch (Exception ignored) {}
                    try { if (ch.getRam()    != null) ch.getRam().getTenRam();       } catch (Exception ignored) {}
                    try { if (ch.getOCung()  != null) ch.getOCung().getTenOCung();  } catch (Exception ignored) {}
                    try { if (ch.getMauSac() != null) ch.getMauSac().getTenMauSac();} catch (Exception ignored) {}
                    try { if (ch.getGpu()    != null) ch.getGpu().getTenGpu();      } catch (Exception ignored) {}
                }
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /** Lấy giá bán nhỏ nhất và lớn nhất trong toàn bộ biến thể */
    /** Overload tương thích ngược — không lọc theo SP cụ thể */
    public List<ChiTietSanPham> locDaKieu(String tenSanPham,
                                          Integer idCpu, Integer idGpu,
                                          Integer idMauSac, Integer idRam, Integer idOCung,
                                          Integer trangThai,
                                          java.math.BigDecimal giaMin, java.math.BigDecimal giaMax) {
        return locDaKieu(tenSanPham, idCpu, idGpu, idMauSac, idRam, idOCung, trangThai, giaMin, giaMax, null);
    }

    public java.math.BigDecimal[] getMinMaxDonGia() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Object[] row = (Object[]) session.createQuery(
                    "SELECT MIN(ct.donGia), MAX(ct.donGia) FROM ChiTietSanPham ct")
                    .uniqueResult();
            java.math.BigDecimal min = row[0] != null ? (java.math.BigDecimal) row[0] : java.math.BigDecimal.ZERO;
            java.math.BigDecimal max = row[1] != null ? (java.math.BigDecimal) row[1] : java.math.BigDecimal.ZERO;
            return new java.math.BigDecimal[]{min, max};
        } catch (Exception e) {
            e.printStackTrace();
            return new java.math.BigDecimal[]{java.math.BigDecimal.ZERO, java.math.BigDecimal.ZERO};
        }
    }

    // Đếm số biến thể (chi_tiet_san_pham) theo từng id sản phẩm cha
    // Trả về Map<idSanPham, soLuongBienThe>
    public java.util.Map<Integer, Long> demBienTheTheoSanPham() {
        java.util.Map<Integer, Long> map = new java.util.HashMap<>();
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            List<Object[]> rows = session.createQuery(
                    "SELECT ct.sanPham.id, COUNT(ct) FROM ChiTietSanPham ct GROUP BY ct.sanPham.id",
                    Object[].class).getResultList();
            for (Object[] row : rows) {
                map.put((Integer) row[0], (Long) row[1]);
            }
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi đếm biến thể theo sản phẩm: " + e.getMessage());
            e.printStackTrace();
        }
        return map;
    }

    /**
     * Trả về Map<idSanPham, BigDecimal[2]> trong đó [0]=minDonGia, [1]=maxDonGia
     * Chỉ tính các biến thể đang hoạt động (trangThai = 1) và có donGia > 0
     */
    public java.util.Map<Integer, java.math.BigDecimal[]> getMinMaxDonGiaTheoSanPham() {
        java.util.Map<Integer, java.math.BigDecimal[]> map = new java.util.HashMap<>();
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            List<Object[]> rows = session.createQuery(
                    "SELECT ct.sanPham.id, MIN(ct.donGia), MAX(ct.donGia) " +
                    "FROM ChiTietSanPham ct " +
                    "WHERE ct.trangThai = 1 AND ct.donGia > 0 " +
                    "GROUP BY ct.sanPham.id",
                    Object[].class).getResultList();
            for (Object[] row : rows) {
                java.math.BigDecimal min = (java.math.BigDecimal) row[1];
                java.math.BigDecimal max = (java.math.BigDecimal) row[2];
                map.put((Integer) row[0], new java.math.BigDecimal[]{min, max});
            }
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi lấy khoảng giá biến thể: " + e.getMessage());
            e.printStackTrace();
        }
        return map;
    }
}