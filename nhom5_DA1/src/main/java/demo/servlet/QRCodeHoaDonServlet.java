package demo.servlet;

import demo.entity.hoa_don.HoaDon;
import demo.util.HibernateConfig;
import demo.util.QRCodeHoaDonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;
import java.io.OutputStream;

/**
 * Servlet để tạo và trả về mã QR code cho hóa đơn.
 * URL: /qr-hoa-don?id=123
 */
@WebServlet("/qr-hoa-don")
public class QRCodeHoaDonServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        String sizeParam = req.getParameter("size");
        String formatParam = req.getParameter("format"); // "image" hoặc "base64"

        if (idParam == null || idParam.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số id hóa đơn");
            return;
        }

        try {
            Integer hoaDonId = Integer.parseInt(idParam);
            int qrSize = (sizeParam != null && !sizeParam.isEmpty()) ? Integer.parseInt(sizeParam) : 300;

            // Lấy thông tin hóa đơn từ database
            HoaDon hoaDon = getHoaDonById(hoaDonId);

            if (hoaDon == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy hóa đơn với ID: " + hoaDonId);
                return;
            }

            // Kiểm tra xem có thể tạo QR code không
            if (!QRCodeHoaDonUtil.canGenerateQRCode(hoaDon)) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hóa đơn không có đủ thông tin để tạo mã QR");
                return;
            }

            // Trả về Base64 hoặc ảnh PNG
            if ("base64".equalsIgnoreCase(formatParam)) {
                // Trả về Base64 JSON
                String base64 = QRCodeHoaDonUtil.generateQRCodeBase64(hoaDon, qrSize);
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"qrCodeBase64\": \"" + base64 + "\"}");
            } else {
                // Trả về ảnh PNG (mặc định)
                byte[] qrBytes = QRCodeHoaDonUtil.generateQRCodeBytes(hoaDon, qrSize);
                resp.setContentType("image/png");
                resp.setContentLength(qrBytes.length);
                
                // Thêm cache control để tăng hiệu suất
                resp.setHeader("Cache-Control", "public, max-age=3600");
                
                try (OutputStream os = resp.getOutputStream()) {
                    os.write(qrBytes);
                    os.flush();
                }
            }

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID hóa đơn hoặc size không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tạo mã QR: " + e.getMessage());
        }
    }

    /**
     * Lấy thông tin hóa đơn từ database theo ID.
     *
     * @param id ID của hóa đơn
     * @return Đối tượng HoaDon hoặc null nếu không tìm thấy
     */
    private HoaDon getHoaDonById(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.get(HoaDon.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
