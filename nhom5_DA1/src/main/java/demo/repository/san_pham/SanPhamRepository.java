package demo.repository.san_pham;

import demo.entity.san_pham.SanPham;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class  SanPhamRepository {

    public SanPhamRepository() {
    }

    public SanPham getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(SanPham.class, id);
        }
    }

    public List<SanPham> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // 🟢 Đã thêm SanPham.class
            return session.createQuery("FROM SanPham WHERE trangThai = 1 ORDER BY id DESC", SanPham.class).getResultList();
        }
    }

    public void add(SanPham sp) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();

            session.save(sp);
            session.flush();

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void delete(Integer idSanPhamCha) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            session.createNativeQuery("UPDATE san_pham SET trang_thai = 0 WHERE id = :id")
                    .setParameter("id", idSanPhamCha)
                    .executeUpdate();

            session.createNativeQuery("UPDATE chi_tiet_san_pham SET trang_thai = 0 WHERE id_san_pham = :id")
                    .setParameter("id", idSanPhamCha)
                    .executeUpdate();

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            System.out.println("❌ Lỗi khi xóa mềm sản phẩm cha: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public void update(SanPham sanPham) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            session.merge(sanPham);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<SanPham> timTheoTen(String tenCT) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE LOWER(tenSanPham) LIKE LOWER(:ten)", SanPham.class)
                    .setParameter("ten", "%" + tenCT + "%")
                    .getResultList();
        }
    }

    public List<SanPham> timTheoMa(String maCT) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE LOWER(maSanPham) LIKE LOWER(:ma)", SanPham.class)
                    .setParameter("ma", "%" + maCT + "%")
                    .getResultList();
        }
    }

    public List<SanPham> timTheoTH(String tenHangCT) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE LOWER(thuongHieu.tenThuongHieu) LIKE LOWER(:tenHang)", SanPham.class)
                    .setParameter("tenHang", "%" + tenHangCT + "%")
                    .getResultList();
        }
    }

    public List<SanPham> timTheoTrangThai(Integer trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE trangThai = :tt", SanPham.class)
                    .setParameter("tt", trangThai)
                    .getResultList();
        }
    }

    public List<SanPham> timTheoNgay(LocalDate ngay) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE ngayTao = :ngay", SanPham.class)
                    .setParameter("ngay", ngay)
                    .getResultList();
        }
    }

    public List<SanPham> timTheoKhoang(LocalDate ngay1, LocalDate ngay2) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE ngayTao BETWEEN :ngay1 AND :ngay2", SanPham.class)
                    .setParameter("ngay1", ngay1)
                    .setParameter("ngay2", ngay2)
                    .getResultList();
        }
    }

    public List<SanPham> getAllWithPagination(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham", SanPham.class)
                    .setFirstResult(offset)
                    .setMaxResults(pageSize)
                    .getResultList();
        }
    }

    public Long countAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("SELECT COUNT(s) FROM SanPham s WHERE s.trangThai = 1", Long.class)
                    .getSingleResult();
        }
    }

    /**
     * Đếm tổng số sản phẩm khớp với bộ lọc (dùng cho phân trang).
     * Tham số giống hệt locDaKieu().
     */
    public long countLocDaKieu(String keyword, String maSanPham, Integer idThuongHieu,
                                Integer trangThai, java.math.BigDecimal giaMin, java.math.BigDecimal giaMax) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("SELECT COUNT(sp) FROM SanPham sp WHERE 1=1");
            boolean coKeyword = keyword != null && !keyword.trim().isEmpty();
            boolean coMa      = maSanPham != null && !maSanPham.trim().isEmpty();
            if (coKeyword && coMa) {
                hql.append(" AND (LOWER(sp.tenSanPham) LIKE LOWER(:keyword) OR LOWER(sp.maSanPham) LIKE LOWER(:maSanPham))");
            } else if (coKeyword) {
                hql.append(" AND (LOWER(sp.tenSanPham) LIKE LOWER(:keyword) OR LOWER(sp.maSanPham) LIKE LOWER(:keyword))");
            } else if (coMa) {
                hql.append(" AND LOWER(sp.maSanPham) LIKE LOWER(:maSanPham)");
            }
            if (idThuongHieu != null) hql.append(" AND sp.thuongHieu.id = :idThuongHieu");
            if (trangThai != null)    hql.append(" AND sp.trangThai = :trangThai");
            if (giaMin != null)       hql.append(" AND sp.giaBan >= :giaMin");
            if (giaMax != null)       hql.append(" AND sp.giaBan <= :giaMax");

            Query<Long> query = session.createQuery(hql.toString(), Long.class);
            if (coKeyword && coMa) {
                query.setParameter("keyword",   "%" + keyword.trim() + "%");
                query.setParameter("maSanPham", "%" + maSanPham.trim() + "%");
            } else if (coKeyword) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            } else if (coMa) {
                query.setParameter("maSanPham", "%" + maSanPham.trim() + "%");
            }
            if (idThuongHieu != null) query.setParameter("idThuongHieu", idThuongHieu);
            if (trangThai != null)    query.setParameter("trangThai", trangThai);
            if (giaMin != null)       query.setParameter("giaMin", giaMin);
            if (giaMax != null)       query.setParameter("giaMax", giaMax);

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
    public List<SanPham> locDaKieuPhanTrang(String keyword, String maSanPham, Integer idThuongHieu,
                                             Integer trangThai, java.math.BigDecimal giaMin, java.math.BigDecimal giaMax,
                                             int offset, int limit) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM SanPham sp WHERE 1=1");
            boolean coKeyword = keyword != null && !keyword.trim().isEmpty();
            boolean coMa      = maSanPham != null && !maSanPham.trim().isEmpty();
            if (coKeyword && coMa) {
                hql.append(" AND (LOWER(sp.tenSanPham) LIKE LOWER(:keyword) OR LOWER(sp.maSanPham) LIKE LOWER(:maSanPham))");
            } else if (coKeyword) {
                hql.append(" AND (LOWER(sp.tenSanPham) LIKE LOWER(:keyword) OR LOWER(sp.maSanPham) LIKE LOWER(:keyword))");
            } else if (coMa) {
                hql.append(" AND LOWER(sp.maSanPham) LIKE LOWER(:maSanPham)");
            }
            if (idThuongHieu != null) hql.append(" AND sp.thuongHieu.id = :idThuongHieu");
            if (trangThai != null)    hql.append(" AND sp.trangThai = :trangThai");
            if (giaMin != null)       hql.append(" AND sp.giaBan >= :giaMin");
            if (giaMax != null)       hql.append(" AND sp.giaBan <= :giaMax");
            hql.append(" ORDER BY sp.id DESC");

            Query<SanPham> query = session.createQuery(hql.toString(), SanPham.class);
            if (coKeyword && coMa) {
                query.setParameter("keyword",   "%" + keyword.trim() + "%");
                query.setParameter("maSanPham", "%" + maSanPham.trim() + "%");
            } else if (coKeyword) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            } else if (coMa) {
                query.setParameter("maSanPham", "%" + maSanPham.trim() + "%");
            }
            if (idThuongHieu != null) query.setParameter("idThuongHieu", idThuongHieu);
            if (trangThai != null)    query.setParameter("trangThai", trangThai);
            if (giaMin != null)       query.setParameter("giaMin", giaMin);
            if (giaMax != null)       query.setParameter("giaMax", giaMax);

            return query.setFirstResult(offset).setMaxResults(limit).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // 1. Check trùng tên khi thêm
    public boolean checkTrungTen(String tenSanPham) {
        if (tenSanPham == null || tenSanPham.trim().isEmpty()) {
            return false;
        }
        String hql = "FROM SanPham sp WHERE LOWER(TRIM(sp.tenSanPham)) = :ten";
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Query<SanPham> query = session.createQuery(hql, SanPham.class);
            query.setParameter("ten", tenSanPham.trim().toLowerCase());
            return query.uniqueResult() != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Check trùng tên khi sửa
    public boolean checkTrungTenKhiSua(String tenSanPham, Integer idCurrent) {
        if (tenSanPham == null || tenSanPham.trim().isEmpty()) {
            return false;
        }
        String hql = "FROM SanPham sp WHERE LOWER(TRIM(sp.tenSanPham)) = :ten AND sp.id != :id";
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Query<SanPham> query = session.createQuery(hql, SanPham.class);
            query.setParameter("ten", tenSanPham.trim().toLowerCase());
            query.setParameter("id", idCurrent);
            return query.uniqueResult() != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lọc sản phẩm đa tiêu chí:
     * - keyword: tìm tương đối theo tên sản phẩm
     * - maSanPham: tìm tuyệt đối theo mã sản phẩm (exact, case-insensitive)
     * - idThuongHieu: lọc theo hãng
     * - trangThai: lọc theo trạng thái (null = tất cả, mặc định chỉ hiện trangThai=1 nếu cả 3 điều kiện kia đều null)
     * - giaMin / giaMax: khoảng giá bán
     */
    public List<SanPham> locDaKieu(String keyword, String maSanPham, Integer idThuongHieu,
                                   Integer trangThai, java.math.BigDecimal giaMin, java.math.BigDecimal giaMax) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("FROM SanPham sp WHERE 1=1");
            // keyword tìm đồng thời theo tên (LIKE) HOẶC mã sản phẩm (LIKE)
            boolean coKeyword = keyword != null && !keyword.trim().isEmpty();
            boolean coMa      = maSanPham != null && !maSanPham.trim().isEmpty();
            if (coKeyword && coMa) {
                // Cả 2 được truyền riêng (legacy) — OR giữa tên và mã
                hql.append(" AND (LOWER(sp.tenSanPham) LIKE LOWER(:keyword) OR LOWER(sp.maSanPham) LIKE LOWER(:maSanPham))");
            } else if (coKeyword) {
                // Chỉ có keyword — tìm trong cả tên lẫn mã
                hql.append(" AND (LOWER(sp.tenSanPham) LIKE LOWER(:keyword) OR LOWER(sp.maSanPham) LIKE LOWER(:keyword))");
            } else if (coMa) {
                hql.append(" AND LOWER(sp.maSanPham) LIKE LOWER(:maSanPham)");
            }
            if (idThuongHieu != null) {
                hql.append(" AND sp.thuongHieu.id = :idThuongHieu");
            }
            if (trangThai != null) {
                hql.append(" AND sp.trangThai = :trangThai");
            } else {
                // Mặc định chỉ hiện sản phẩm đang hoạt động khi không lọc gì
                hql.append(" AND sp.trangThai = 1");
            }
            if (giaMin != null) {
                hql.append(" AND sp.giaBan >= :giaMin");
            }
            if (giaMax != null) {
                hql.append(" AND sp.giaBan <= :giaMax");
            }
            hql.append(" ORDER BY sp.id DESC");

            Query<SanPham> query = session.createQuery(hql.toString(), SanPham.class);
            if (coKeyword && coMa) {
                query.setParameter("keyword",    "%" + keyword.trim() + "%");
                query.setParameter("maSanPham",  "%" + maSanPham.trim() + "%");
            } else if (coKeyword) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            } else if (coMa) {
                query.setParameter("maSanPham", "%" + maSanPham.trim() + "%");
            }
            if (idThuongHieu != null)
                query.setParameter("idThuongHieu", idThuongHieu);
            if (trangThai != null)
                query.setParameter("trangThai", trangThai);
            if (giaMin != null)
                query.setParameter("giaMin", giaMin);
            if (giaMax != null)
                query.setParameter("giaMax", giaMax);

            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /** Lấy giá bán nhỏ nhất và lớn nhất trong toàn bộ sản phẩm đang hoạt động */
    public java.math.BigDecimal[] getMinMaxGiaBan() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Object[] row = (Object[]) session.createQuery(
                    "SELECT MIN(sp.giaBan), MAX(sp.giaBan) FROM SanPham sp WHERE sp.trangThai = 1")
                    .uniqueResult();
            java.math.BigDecimal min = row[0] != null ? (java.math.BigDecimal) row[0] : java.math.BigDecimal.ZERO;
            java.math.BigDecimal max = row[1] != null ? (java.math.BigDecimal) row[1] : java.math.BigDecimal.ZERO;
            return new java.math.BigDecimal[]{min, max};
        } catch (Exception e) {
            e.printStackTrace();
            return new java.math.BigDecimal[]{java.math.BigDecimal.ZERO, java.math.BigDecimal.ZERO};
        }
    }

    /**
     * Trả về top 5 sản phẩm bán chạy nhất dựa trên số lượt mua thực tế
     * (đếm số dòng ChiTietHoaDon thuộc hoá đơn đã thanh toán, nhóm theo SanPham).
     * Mỗi phần tử trong list là Object[] { SanPham sp, Long soLuongBan }.
     */
    public List<Object[]> getTop5BanChay() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Dùng native SQL để tránh vấn đề Hibernate GROUP BY object
            // và đảm bảo LEFT JOIN đúng, bao gồm cả các dòng có ma_cau_hinh không null
            @SuppressWarnings("unchecked")
            List<Object[]> rawRows = session.createNativeQuery(
                    "SELECT TOP 5 sp.id, sp.ten_san_pham, sp.gia_ban, COUNT(ct.id) AS so_luong " +
                    "FROM chi_tiet_hoa_don ct " +
                    "INNER JOIN hoa_don hd ON ct.id_hoa_don = hd.id " +
                    "INNER JOIN cau_hinh_san_pham chs ON ct.ma_cau_hinh = chs.id " +
                    "INNER JOIN san_pham sp ON chs.id_san_pham = sp.id " +
                    "WHERE hd.trang_thai = 1 " +
                    "  AND ct.ma_cau_hinh IS NOT NULL " +
                    "GROUP BY sp.id, sp.ten_san_pham, sp.gia_ban " +
                    "ORDER BY so_luong DESC")
                    .list();

            // Chuyển sang Object[] chứa [SanPham, Long]
            List<Object[]> result = new ArrayList<>();
            for (Object[] row : rawRows) {
                Integer spId    = row[0] instanceof Number ? ((Number) row[0]).intValue() : null;
                String  tenSp   = (String) row[1];
                java.math.BigDecimal giaBan = row[2] != null
                        ? new java.math.BigDecimal(row[2].toString()) : java.math.BigDecimal.ZERO;
                Long soLuong    = row[3] instanceof Number ? ((Number) row[3]).longValue() : 0L;

                // Tải đầy đủ entity SanPham
                SanPham sp = session.find(SanPham.class, spId);
                if (sp == null) {
                    // Fallback: tạo object tạm nếu không load được
                    sp = new SanPham();
                    sp.setId(spId);
                    sp.setTenSanPham(tenSp);
                    sp.setGiaBan(giaBan);
                }
                result.add(new Object[]{sp, soLuong});
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}