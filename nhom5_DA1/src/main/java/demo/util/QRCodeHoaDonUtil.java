package demo.util;

import demo.entity.hoa_don.HoaDon;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Locale;

/**
 * Utility class để tạo mã QR cho hóa đơn.
 * Mã QR được tạo động từ thông tin hóa đơn, không cần lưu vào database.
 */
public class QRCodeHoaDonUtil {

    private static final int DEFAULT_QR_SIZE = 300; // Kích thước QR mặc định (pixels)
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");
    private static final NumberFormat CURRENCY_FORMAT = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

    /**
     * Tạo nội dung văn bản cho mã QR từ thông tin hóa đơn.
     * Format: Thông tin ngắn gọn, dễ đọc khi scan QR
     *
     * @param hoaDon Đối tượng hóa đơn
     * @return Chuỗi văn bản chứa thông tin hóa đơn
     */
    public static String generateQRContent(HoaDon hoaDon) {
        StringBuilder content = new StringBuilder();
        
        // Tiêu đề
        content.append("=== HÓA ĐƠN BÁN HÀNG ===\n");
        
        // Mã hóa đơn
        content.append("Mã HĐ: ").append(hoaDon.getMaHoaDon()).append("\n");
        
        // Ngày lập
        if (hoaDon.getNgayLap() != null) {
            content.append("Ngày lập: ").append(DATE_FORMAT.format(hoaDon.getNgayLap())).append("\n");
        }
        
        // Khách hàng
        if (hoaDon.getTenKhachHang() != null && !hoaDon.getTenKhachHang().isEmpty()) {
            content.append("Khách hàng: ").append(hoaDon.getTenKhachHang()).append("\n");
        }
        
        // Số điện thoại
        if (hoaDon.getSdtKhachHang() != null && !hoaDon.getSdtKhachHang().isEmpty()) {
            content.append("SĐT: ").append(hoaDon.getSdtKhachHang()).append("\n");
        }
        
        // Tổng tiền
        if (hoaDon.getTongTien() != null) {
            content.append("Tổng tiền: ").append(CURRENCY_FORMAT.format(hoaDon.getTongTien())).append("\n");
        }
        
        // Trạng thái
        String trangThai = getTrangThaiText(hoaDon.getTrangThai());
        content.append("Trạng thái: ").append(trangThai).append("\n");
        
        // Link xác thực (nếu có hệ thống web)
        // content.append("Xác thực: https://yourdomain.com/hoadon/").append(hoaDon.getId()).append("\n");
        
        return content.toString();
    }

    /**
     * Tạo nội dung văn bản ngắn gọn cho mã QR (chỉ chứa thông tin quan trọng nhất).
     * Dùng khi muốn mã QR nhỏ gọn hơn.
     *
     * @param hoaDon Đối tượng hóa đơn
     * @return Chuỗi văn bản ngắn gọn
     */
    public static String generateQRContentCompact(HoaDon hoaDon) {
        StringBuilder content = new StringBuilder();
        
        content.append("HĐ:").append(hoaDon.getMaHoaDon()).append("|");
        
        if (hoaDon.getNgayLap() != null) {
            content.append(DATE_FORMAT.format(hoaDon.getNgayLap())).append("|");
        }
        
        if (hoaDon.getTongTien() != null) {
            content.append(hoaDon.getTongTien()).append("đ|");
        }
        
        content.append(getTrangThaiText(hoaDon.getTrangThai()));
        
        return content.toString();
    }

    /**
     * Tạo mã QR dạng Base64 từ thông tin hóa đơn.
     * Base64 có thể nhúng trực tiếp vào HTML: <img src="data:image/png;base64,...">
     *
     * @param hoaDon Đối tượng hóa đơn
     * @return Chuỗi Base64 của ảnh QR code
     */
    public static String generateQRCodeBase64(HoaDon hoaDon) {
        return generateQRCodeBase64(hoaDon, DEFAULT_QR_SIZE);
    }

    /**
     * Tạo mã QR dạng Base64 với kích thước tùy chỉnh.
     *
     * @param hoaDon Đối tượng hóa đơn
     * @param size   Kích thước QR code (pixels)
     * @return Chuỗi Base64 của ảnh QR code
     */
    public static String generateQRCodeBase64(HoaDon hoaDon, int size) {
        try {
            String content = generateQRContent(hoaDon);
            byte[] qrBytes = BarcodeUtil.generateQRCodeImage(content, size);
            return Base64.getEncoder().encodeToString(qrBytes);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tạo mã QR cho hóa đơn: " + e.getMessage(), e);
        }
    }

    /**
     * Tạo mã QR dạng byte array từ thông tin hóa đơn.
     * Dùng để xuất file ảnh hoặc nhúng vào PDF.
     *
     * @param hoaDon Đối tượng hóa đơn
     * @return Mảng byte của ảnh QR code (PNG)
     */
    public static byte[] generateQRCodeBytes(HoaDon hoaDon) {
        return generateQRCodeBytes(hoaDon, DEFAULT_QR_SIZE);
    }

    /**
     * Tạo mã QR dạng byte array với kích thước tùy chỉnh.
     *
     * @param hoaDon Đối tượng hóa đơn
     * @param size   Kích thước QR code (pixels)
     * @return Mảng byte của ảnh QR code (PNG)
     */
    public static byte[] generateQRCodeBytes(HoaDon hoaDon, int size) {
        try {
            String content = generateQRContent(hoaDon);
            return BarcodeUtil.generateQRCodeImage(content, size);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tạo mã QR cho hóa đơn: " + e.getMessage(), e);
        }
    }

    /**
     * Tạo data URI cho ảnh QR code để sử dụng trong HTML.
     * Format: data:image/png;base64,iVBORw0KG...
     *
     * @param hoaDon Đối tượng hóa đơn
     * @return Data URI string
     */
    public static String generateQRCodeDataURI(HoaDon hoaDon) {
        return "data:image/png;base64," + generateQRCodeBase64(hoaDon);
    }

    /**
     * Chuyển đổi mã trạng thái thành văn bản.
     *
     * @param trangThai Mã trạng thái
     * @return Văn bản mô tả trạng thái
     */
    private static String getTrangThaiText(Integer trangThai) {
        if (trangThai == null) {
            return "Không xác định";
        }
        
        switch (trangThai) {
            case 0:
                return "Chờ xử lý";
            case 1:
                return "Đã xác nhận";
            case 2:
                return "Đang giao hàng";
            case 3:
                return "Đã hoàn thành";
            case 4:
                return "Đã hủy";
            default:
                return "Không xác định";
        }
    }

    /**
     * Kiểm tra xem hóa đơn có đủ thông tin để tạo mã QR không.
     *
     * @param hoaDon Đối tượng hóa đơn
     * @return true nếu có thể tạo QR, false nếu thiếu thông tin quan trọng
     */
    public static boolean canGenerateQRCode(HoaDon hoaDon) {
        return hoaDon != null 
            && hoaDon.getMaHoaDon() != null 
            && !hoaDon.getMaHoaDon().isEmpty();
    }
}
