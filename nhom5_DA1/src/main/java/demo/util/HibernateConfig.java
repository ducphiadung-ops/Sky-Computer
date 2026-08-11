package demo.util;

import demo.entity.hoa_don.ChiTietHoaDon;
import demo.entity.hoa_don.HinhThucThanhToan;
import demo.entity.hoa_don.HoaDon;
import demo.entity.hoa_don.LichSuHoaDon;
import demo.entity.hoa_don.LichSuThanhToan;
import demo.entity.khach_hang.DiaChiApiMapping;
import demo.entity.khach_hang.DiaChiKhachHang;
import demo.entity.khach_hang.KhachHang;
import demo.entity.nhan_vien.NhanVien;
import demo.entity.san_pham.CauHinhSanPham;
import demo.entity.san_pham.ChiTietPhieuNhap;
import demo.entity.san_pham.ChiTietSanPham;
import demo.entity.san_pham.Cpu;
import demo.entity.san_pham.DanhMuc;
import demo.entity.san_pham.Gpu;
import demo.entity.san_pham.HinhAnhSanPham;
import demo.entity.san_pham.ManHinh;
import demo.entity.san_pham.MaSeri;
import demo.entity.san_pham.MauSac;
import demo.entity.san_pham.NhaCungCap;
import demo.entity.san_pham.OCung;
import demo.entity.san_pham.PhieuNhap;
import demo.entity.san_pham.Pin;
import demo.entity.san_pham.Ram;
import demo.entity.san_pham.SanPham;
import demo.entity.san_pham.ThuongHieu;

import org.hibernate.SessionFactory;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

public class HibernateConfig {

    private static volatile SessionFactory FACTORY;

    /**
     * Hibernate 6.x + Jakarta EE 9+ + Tomcat 10+
     * Dùng connection pool mặc định (Hibernate C3P0 / built-in).
     */
    public static synchronized SessionFactory getFACTORY() {
        if (FACTORY == null) {
            try {
                System.out.println("[HibernateConfig] Building SessionFactory (Hibernate 6)...");

                StandardServiceRegistry ssr = new StandardServiceRegistryBuilder()
                        .applySetting("hibernate.dialect",
                                "org.hibernate.dialect.SQLServerDialect")
                        .applySetting("hibernate.connection.driver_class",
                                "com.microsoft.sqlserver.jdbc.SQLServerDriver")
                        .applySetting("hibernate.connection.url",
                                "jdbc:sqlserver://localhost:1433;"
                                + "databaseName=DB_Quan_ly_may_tinh;"
                                + "encrypt=true;trustServerCertificate=true;")
                        .applySetting("hibernate.connection.username", "sa")
                        .applySetting("hibernate.connection.password", "123456")
                        .applySetting("hibernate.show_sql",   "false")
                        .applySetting("hibernate.format_sql", "false")
                        .build();

                MetadataSources sources = new MetadataSources(ssr);

                // Hóa đơn
                sources.addAnnotatedClass(HoaDon.class);
                sources.addAnnotatedClass(ChiTietHoaDon.class);
                sources.addAnnotatedClass(HinhThucThanhToan.class);
                sources.addAnnotatedClass(LichSuHoaDon.class);
                sources.addAnnotatedClass(LichSuThanhToan.class);
                // Khách hàng
                sources.addAnnotatedClass(KhachHang.class);
                sources.addAnnotatedClass(DiaChiKhachHang.class);
                sources.addAnnotatedClass(DiaChiApiMapping.class);
                // Nhân viên
                sources.addAnnotatedClass(NhanVien.class);
                // Sản phẩm
                sources.addAnnotatedClass(SanPham.class);
                sources.addAnnotatedClass(CauHinhSanPham.class);
                sources.addAnnotatedClass(ChiTietSanPham.class);
                sources.addAnnotatedClass(ChiTietPhieuNhap.class);
                sources.addAnnotatedClass(Cpu.class);
                sources.addAnnotatedClass(DanhMuc.class);
                sources.addAnnotatedClass(Gpu.class);
                sources.addAnnotatedClass(HinhAnhSanPham.class);
                sources.addAnnotatedClass(ManHinh.class);
                sources.addAnnotatedClass(MaSeri.class);
                sources.addAnnotatedClass(MauSac.class);
                sources.addAnnotatedClass(NhaCungCap.class);
                sources.addAnnotatedClass(OCung.class);
                sources.addAnnotatedClass(PhieuNhap.class);
                sources.addAnnotatedClass(Pin.class);
                sources.addAnnotatedClass(Ram.class);
                sources.addAnnotatedClass(ThuongHieu.class);

                FACTORY = sources.buildMetadata().buildSessionFactory();
                System.out.println("[HibernateConfig] SessionFactory OK.");

            } catch (Throwable ex) {
                System.err.println("[HibernateConfig] FAILED: " + ex.getMessage());
                ex.printStackTrace();
                throw new ExceptionInInitializerError(ex);
            }
        }
        return FACTORY;
    }

    public static void close() {
        if (FACTORY != null && FACTORY.isOpen()) {
            FACTORY.close();
        }
    }
}
