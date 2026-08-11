package demo.listener;

import demo.entity.hoa_don.ChiTietHoaDon;
import demo.entity.hoa_don.HoaDon;
import demo.entity.san_pham.MaSeri;
import demo.repository.hoadon.ChiTietHoaDonRepo;
import demo.repository.hoadon.HoaDonRepository;
import demo.repository.san_pham.ChiTietSanPhamRepository;
import demo.repository.san_pham.MaSeriRepository;
import demo.util.AsyncEmailService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Listener chạy cron job mỗi phút, phát hiện khi sang ngày mới:
 *   - Lấy tất cả hóa đơn chờ (trangThai=2) có ngayLap < hôm nay
 *   - Giải phóng seri đã bị giữ → trả về trangThai=1 (còn hàng)
 *   - Đồng bộ tồn kho cho từng cấu hình sản phẩm
 *   - Đổi trangThai hóa đơn → 3 (đã hủy)
 *
 * Dùng polling mỗi phút thay vì tính delay cố định đến 00:00
 * để tránh mất trigger khi đổi giờ hệ thống hoặc server sleep/wake.
 */
// Thứ tự khởi tạo được quản lý qua web.xml — không dùng @WebListener
// để tránh bị đăng ký 2 lần
public class HoaDonHuyCronListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    // Ghi nhớ ngày đã xử lý lần cuối để không chạy lại nhiều lần trong cùng 1 ngày
    private volatile LocalDate ngayDaXuLy = null;

    // Khởi tạo lazy trong contextInitialized để tránh trigger HibernateConfig
    // trên thread sai (trước AppInitListener chạy)
    private HoaDonRepository        hoaDonRepository;
    private ChiTietHoaDonRepo        chiTietHoaDonRepo;
    private MaSeriRepository         maSeriRepository;
    private ChiTietSanPhamRepository chiTietSanPhamRepository;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Khởi tạo repository sau khi HibernateConfig đã sẵn sàng (AppInitListener chạy trước)
        hoaDonRepository         = new HoaDonRepository();
        chiTietHoaDonRepo        = new ChiTietHoaDonRepo();
        maSeriRepository         = new MaSeriRepository();
        chiTietSanPhamRepository = new ChiTietSanPhamRepository();

        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "hoadon-huy-cron");
            t.setDaemon(true);
            return t;
        });

        // Poll mỗi phút — khi phát hiện ngày thay đổi thì chạy job
        // initialDelay=10s: chờ AppInitListener khởi tạo HibernateConfig xong
        scheduler.scheduleAtFixedRate(
                this::kiemTraVaHuyDon,
                10,         // delay 10 giây để Hibernate kịp khởi tạo
                1,
                TimeUnit.MINUTES
        );

        System.out.println("[HoaDonHuyCron] Scheduler khởi động. Kiểm tra mỗi phút.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
            System.out.println("[HoaDonHuyCron] Scheduler đã dừng.");
        }
        // Dừng thread pool gửi email bất đồng bộ
        AsyncEmailService.shutdown();
    }

    // =========================================================
    //  Kiểm tra ngày — chỉ chạy job khi sang ngày mới
    // =========================================================
    private void kiemTraVaHuyDon() {
        try {
            LocalDate homNay = LocalDate.now(ZoneId.systemDefault());

            // Lần đầu khởi động: chạy ngay để xử lý đơn còn sót từ hôm trước
            // Các lần sau: chỉ chạy khi phát hiện sang ngày mới
            if (ngayDaXuLy == null || homNay.isAfter(ngayDaXuLy)) {
                System.out.println("[HoaDonHuyCron] Phát hiện ngày mới: " + homNay
                        + " (lần trước: " + ngayDaXuLy + "). Bắt đầu kiểm tra đơn chờ quá hạn...");
                // Chạy job trước, chỉ đánh dấu ngày sau khi hoàn thành thành công
                // Tránh race condition: nếu job lỗi giữa chừng, lần poll tiếp theo sẽ thử lại
                huyDonChoQuaHan();
                ngayDaXuLy = homNay;
            }
        } catch (Exception e) {
            System.err.println("[HoaDonHuyCron] Lỗi khi kiểm tra ngày: " + e.getMessage());
        }
    }

    // =========================================================
    //  Job logic: giải phóng seri rồi hủy đơn chờ quá hạn
    // =========================================================
    private void huyDonChoQuaHan() {
        try {
            List<HoaDon> danhSachQuaHan = hoaDonRepository.getDonChoQuaHan();

            if (danhSachQuaHan.isEmpty()) {
                System.out.println("[HoaDonHuyCron] Không có đơn chờ quá hạn cần hủy.");
                return;
            }

            System.out.println("[HoaDonHuyCron] Đang hủy " + danhSachQuaHan.size() + " đơn chờ quá hạn...");

            Set<Integer> cauHinhDaCapNhat = new HashSet<>();

            for (HoaDon hd : danhSachQuaHan) {
                try {
                    // Giải phóng tất cả seri đang bị giữ trong đơn này
                    List<ChiTietHoaDon> dsCT = chiTietHoaDonRepo.getByHoaDonId(hd.getId());
                    for (ChiTietHoaDon ct : dsCT) {
                        MaSeri seri = ct.getIdSeri();
                        if (seri != null && seri.getTrangThai() != null && seri.getTrangThai() == 2) {
                            // trangThai seri: 2 = đang giữ trong đơn chờ → hoàn lại 1 = còn hàng
                            seri.setTrangThai(1);
                            maSeriRepository.update(seri);

                            // Đồng bộ tồn kho — chỉ gọi 1 lần mỗi cấu hình
                            if (seri.getCauHinhSanPham() != null) {
                                Integer idCH = seri.getCauHinhSanPham().getId();
                                if (cauHinhDaCapNhat.add(idCH)) {
                                    chiTietSanPhamRepository.capNhatTonKhoTheoImei(idCH);
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    System.err.println("[HoaDonHuyCron] Lỗi khi giải phóng seri cho HĐ id="
                            + hd.getId() + ": " + e.getMessage());
                }
            }

            // Cập nhật hàng loạt trangThai → 3 bằng native query (1 câu duy nhất)
            int soLuongHuy = hoaDonRepository.huyDonChoQuaHan();
            System.out.println("[HoaDonHuyCron] Đã hủy " + soLuongHuy + " đơn chờ quá hạn thành công.");

        } catch (Exception e) {
            System.err.println("[HoaDonHuyCron] Lỗi khi chạy job hủy đơn chờ: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
