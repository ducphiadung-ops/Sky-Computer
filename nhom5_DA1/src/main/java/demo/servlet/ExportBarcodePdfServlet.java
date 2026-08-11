package demo.servlet;

import demo.entity.san_pham.MaSeri;
import demo.repository.san_pham.MaSeriRepository;
import demo.util.PdfUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/san-pham/xuat-tem-pdf")
public class ExportBarcodePdfServlet extends HttpServlet {

    private final MaSeriRepository maSeriRepository = new MaSeriRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("idCauHinh");

        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID cấu hình sản phẩm!");
            return;
        }

        try {
            Integer idCauHinh = Integer.parseInt(idParam.trim());
            List<MaSeri> listSerial = maSeriRepository.getByIdCauHinh(idCauHinh);

            if (listSerial == null || listSerial.isEmpty()) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy Serial nào khả dụng!");
                return;
            }

            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition", "inline; filename=Tem_QRCode_CH_" + idCauHinh + ".pdf");

            PdfUtil.exportSerialBarcodesToPdf(listSerial, resp.getOutputStream());

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống khi xuất tem PDF!");
        }
    }
}