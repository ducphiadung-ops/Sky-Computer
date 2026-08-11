package demo.util;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.RejectedExecutionException;
import java.util.concurrent.TimeUnit;

/**
 * Dịch vụ gửi email bất đồng bộ.
 *
 * <p>Mục tiêu: tách việc gửi email ra khỏi request thread của servlet,
 * giúp response trả về ngay sau khi lưu DB mà không phải chờ SMTP Gmail.
 *
 * <p>Thiết kế:
 * <ul>
 *   <li>Thread pool cố định 3 thread — đủ cho tải thực tế, không tạo thread vô hạn.</li>
 *   <li>Mọi lỗi (SMTP, mạng, timeout) được bắt và log; không ném exception lên caller.</li>
 *   <li>Gọi {@link #shutdown()} khi ứng dụng dừng (trong ServletContextListener) để
 *       thoát sạch, tránh thread leak trên Tomcat.</li>
 * </ul>
 */
public class AsyncEmailService {

    // Pool 3 thread — đủ cho các thao tác thêm NV đồng thời
    private static final ExecutorService EXECUTOR =
            Executors.newFixedThreadPool(3);

    /**
     * Gửi email thông tin tài khoản nhân viên mới — bất đồng bộ.
     *
     * <p>Các trường hợp được xử lý:
     * <ul>
     *   <li>{@code toEmail} null/rỗng → bỏ qua, không gửi, log cảnh báo.</li>
     *   <li>Gửi thành công → log.</li>
     *   <li>Gửi thất bại → log lỗi, không ảnh hưởng response servlet.</li>
     *   <li>Executor đã shutdown → log cảnh báo, không gửi.</li>
     * </ul>
     *
     * @param toEmail   địa chỉ email nhận
     * @param taiKhoan  tên tài khoản đăng nhập
     * @param matKhau   mật khẩu tạm thời
     */
    public static void guiEmailTaiKhoan(String toEmail, String taiKhoan, String matKhau) {

        // TH1: Email null hoặc rỗng — không có gì để gửi
        if (toEmail == null || toEmail.trim().isEmpty()) {
            System.out.println("[AsyncEmailService] Bỏ qua: địa chỉ email null hoặc rỗng.");
            return;
        }

        // TH2: taiKhoan hoặc matKhau null — dùng chuỗi rỗng để tránh NPE trong nội dung email
        final String finalTaiKhoan = taiKhoan != null ? taiKhoan : "";
        final String finalMatKhau  = matKhau  != null ? matKhau  : "";
        final String finalEmail    = toEmail.trim();

        try {
            EXECUTOR.submit(() -> {
                try {
                    System.out.println("[AsyncEmailService] Đang gửi email đến: " + finalEmail);
                    EmailUtil.sendMail(finalEmail, finalTaiKhoan, finalMatKhau);
                    System.out.println("[AsyncEmailService] Gửi email thành công: " + finalEmail);
                } catch (Exception e) {
                    // TH3: Gửi thất bại — log nhưng không crash ứng dụng
                    System.err.println("[AsyncEmailService] Lỗi gửi email đến " + finalEmail
                            + ": " + e.getMessage());
                    e.printStackTrace();
                }
            });
        } catch (RejectedExecutionException e) {
            // TH4: Executor đã shutdown (xảy ra khi undeploy WAR)
            System.err.println("[AsyncEmailService] Không thể submit task: executor đã shutdown. "
                    + "Email chưa gửi đến: " + finalEmail);
        }
    }

    /**
     * Dừng thread pool sạch sẽ khi ứng dụng undeploy.
     * Gọi từ {@code contextDestroyed} trong ServletContextListener.
     *
     * <p>Đợi tối đa 10 giây để các task đang chạy hoàn thành,
     * sau đó force-shutdown nếu vẫn còn task chờ.
     */
    public static void shutdown() {
        System.out.println("[AsyncEmailService] Đang shutdown thread pool...");
        EXECUTOR.shutdown();
        try {
            if (!EXECUTOR.awaitTermination(10, TimeUnit.SECONDS)) {
                EXECUTOR.shutdownNow();
                System.out.println("[AsyncEmailService] Force shutdown sau 10 giây chờ.");
            } else {
                System.out.println("[AsyncEmailService] Thread pool đã shutdown sạch.");
            }
        } catch (InterruptedException ie) {
            EXECUTOR.shutdownNow();
            Thread.currentThread().interrupt();
        }
    }
}
