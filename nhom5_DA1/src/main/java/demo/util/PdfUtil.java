package demo.util;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import demo.entity.san_pham.MaSeri;

import java.io.OutputStream;
import java.util.List;

public class PdfUtil {

    /**
     * Xuất PDF tem QR Code cho danh sách IMEI/Seri.
     * Bố cục: 3 tem mỗi hàng, mỗi tem gồm:
     *   - Tên sản phẩm (tiêu đề nhỏ)
     *   - Hình QR Code (120×120 px)
     *   - Dòng "IMEI/SN: <số seri>"
     */
    public static void exportSerialBarcodesToPdf(List<MaSeri> listSerial, OutputStream outputStream) throws Exception {
        Document document = new Document(PageSize.A4, 20, 20, 20, 20);
        PdfWriter.getInstance(document, outputStream);
        document.open();

        BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, BaseFont.NOT_EMBEDDED);
        Font fontTitle = new Font(bf, 8,  Font.BOLD,   BaseColor.BLACK);
        Font fontSub   = new Font(bf, 7,  Font.NORMAL, BaseColor.DARK_GRAY);
        Font fontLabel = new Font(bf, 6,  Font.ITALIC, new BaseColor(100, 100, 100));

        // 3 cột — mỗi tem một ô
        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        table.setSpacingBefore(8f);

        for (MaSeri ms : listSerial) {
            PdfPCell cell = new PdfPCell();
            cell.setPadding(10f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setBorderColor(new BaseColor(200, 200, 200));
            cell.setBorderWidth(0.5f);

            // --- Tên sản phẩm ---
            String tenSp = (ms.getCauHinhSanPham() != null && ms.getCauHinhSanPham().getSanPham() != null)
                    ? ms.getCauHinhSanPham().getSanPham().getTenSanPham()
                    : "Skycomputer";
            Paragraph pTitle = new Paragraph(tenSp, fontTitle);
            pTitle.setAlignment(Element.ALIGN_CENTER);
            pTitle.setSpacingAfter(4f);
            cell.addElement(pTitle);

            // --- QR Code (120×120 px) ---
            byte[] qrBytes = BarcodeUtil.generateQRCodeImage(ms.getSoSeri(), 120);
            Image qrImg = Image.getInstance(qrBytes);
            qrImg.setAlignment(Element.ALIGN_CENTER);
            // Scale vừa ô — 80pt × 80pt (giữ tỷ lệ vuông)
            qrImg.scaleAbsolute(80f, 80f);
            cell.addElement(qrImg);

            // --- Số IMEI/Seri bên dưới QR ---
            Paragraph pSeri = new Paragraph("IMEI/SN: " + ms.getSoSeri(), fontSub);
            pSeri.setAlignment(Element.ALIGN_CENTER);
            pSeri.setSpacingBefore(4f);
            cell.addElement(pSeri);

            // --- Nhãn nhỏ "QR Code" ---
            Paragraph pLabel = new Paragraph("QR Code", fontLabel);
            pLabel.setAlignment(Element.ALIGN_CENTER);
            cell.addElement(pLabel);

            table.addCell(cell);
        }

        // Điền ô trống để hoàn chỉnh hàng cuối (3 cột)
        int rem = listSerial.size() % 3;
        if (rem > 0) {
            for (int i = 0; i < 3 - rem; i++) {
                PdfPCell emptyCell = new PdfPCell();
                emptyCell.setBorder(Rectangle.NO_BORDER);
                table.addCell(emptyCell);
            }
        }

        document.add(table);
        document.close();
    }
}
