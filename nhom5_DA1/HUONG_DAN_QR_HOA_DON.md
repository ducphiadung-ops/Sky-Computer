# Hướng dẫn tạo mã QR cho Hóa Đơn

## 📋 Tổng quan

Hệ thống tạo mã QR cho hóa đơn **không cần thêm cột mới vào database**. Mã QR được tạo động từ thông tin hóa đơn hiện có (mã hóa đơn, ngày lập, khách hàng, tổng tiền, trạng thái).

## 🎯 Ưu điểm của phương pháp này

✅ **Không cần sửa database** - Không cần ALTER TABLE hay migration  
✅ **Mã QR luôn chính xác** - Được tạo từ dữ liệu hiện tại  
✅ **Tiết kiệm dung lượng** - Không lưu ảnh QR vào DB  
✅ **Dễ bảo trì** - Thay đổi format QR không ảnh hưởng dữ liệu cũ  
✅ **Linh hoạt** - Có thể tùy chỉnh kích thước, format khi cần  

## 📦 Các file đã tạo

### 1. **QRCodeHoaDonUtil.java** 
   📍 `src/main/java/demo/util/QRCodeHoaDonUtil.java`
   
   Class tiện ích chứa các phương thức tạo mã QR:
   - `generateQRContent(HoaDon)` - Tạo nội dung QR đầy đủ
   - `generateQRContentCompact(HoaDon)` - Tạo nội dung QR ngắn gọn
   - `generateQRCodeBase64(HoaDon)` - Tạo QR dạng Base64
   - `generateQRCodeBytes(HoaDon)` - Tạo QR dạng byte array
   - `generateQRCodeDataURI(HoaDon)` - Tạo data URI cho HTML
   - `canGenerateQRCode(HoaDon)` - Kiểm tra hóa đơn có thể tạo QR

### 2. **QRCodeHoaDonServlet.java**
   📍 `src/main/java/demo/servlet/QRCodeHoaDonServlet.java`
   
   Servlet xử lý request tạo mã QR:
   - URL: `/qr-hoa-don`
   - Tham số:
     - `id` (bắt buộc): ID của hóa đơn
     - `size` (tùy chọn): Kích thước QR (mặc định: 300px)
     - `format` (tùy chọn): "image" (mặc định) hoặc "base64"

### 3. **qr_code_example.jsp**
   📍 `src/main/webapp/demo/hoa_don/qr_code_example.jsp`
   
   Trang demo với 4 cách sử dụng QR code khác nhau.

### 4. **hoa_don.jsp** (Đã cập nhật)
   📍 `src/main/webapp/demo/hoa_don/hoa_don.jsp`
   
   ✅ Thêm cột "QR CODE" vào bảng danh sách hóa đơn
   ✅ Modal hiển thị mã QR với chức năng tải xuống và in
   ✅ Icon QR trên mỗi hàng hóa đơn

### 5. **chi_tiet_hoa_don.jsp** (Đã cập nhật)
   📍 `src/main/webapp/demo/hoa_don/chi_tiet_hoa_don.jsp`
   
   ✅ Thêm card "Mã QR" vào info-grid (4 cột)
   ✅ Hiển thị QR code với nút tải xuống và in
   ✅ QR code được load tự động khi mở trang

### 6. **in_hoa_don.jsp** (Đã cập nhật)
   📍 `src/main/webapp/demo/hoa_don/in_hoa_don.jsp`
   
   ✅ Thêm section mã QR ở cuối trang in
   ✅ QR code được in cùng với hóa đơn
   ✅ Tối ưu cho in ấn (200x200px)

## 🚀 Cách sử dụng

### Cách 1: Hiển thị QR trong JSP (Đơn giản nhất)

```jsp
<!-- Trong trang chi tiết hóa đơn -->
<img src="${pageContext.request.contextPath}/qr-hoa-don?id=${hoaDon.id}" 
     alt="QR Code Hóa Đơn"
     width="300">
```

### Cách 2: Với JSTL

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty hoaDon}">
    <c:url var="qrCodeUrl" value="/qr-hoa-don">
        <c:param name="id" value="${hoaDon.id}"/>
        <c:param name="size" value="250"/>
    </c:url>
    
    <img src="${qrCodeUrl}" alt="QR Code">
</c:if>
```

### Cách 3: Tải QR bằng JavaScript

```javascript
function loadQRCode(hoaDonId) {
    const qrUrl = '/nhom5_DA1/qr-hoa-don?id=' + hoaDonId;
    document.getElementById('qrImage').src = qrUrl;
}
```

### Cách 4: Lấy QR dạng Base64 (AJAX)

```javascript
fetch('/nhom5_DA1/qr-hoa-don?id=' + hoaDonId + '&format=base64')
    .then(response => response.json())
    .then(data => {
        const img = document.getElementById('qrImage');
        img.src = 'data:image/png;base64,' + data.qrCodeBase64;
    });
```

### Cách 5: Sử dụng trong Java (Backend)

```java
// Trong Servlet hoặc Service
import demo.util.QRCodeHoaDonUtil;

// Tạo QR dạng Base64 để nhúng vào HTML/Email
String qrBase64 = QRCodeHoaDonUtil.generateQRCodeBase64(hoaDon);
request.setAttribute("qrCode", qrBase64);

// Hoặc tạo QR dạng byte để nhúng vào PDF
byte[] qrBytes = QRCodeHoaDonUtil.generateQRCodeBytes(hoaDon, 200);
// Sau đó dùng iText để nhúng vào PDF
```

## 🖨️ Tích hợp vào tính năng in hóa đơn

### A. Hiển thị QR trong trang in hóa đơn (HTML)

```jsp
<!-- Trong file in_hoa_don.jsp -->
<div class="invoice-qr">
    <h4>Quét mã QR để xem chi tiết</h4>
    <img src="${pageContext.request.contextPath}/qr-hoa-don?id=${hoaDon.id}" 
         alt="QR Code"
         width="200">
</div>

<style>
    .invoice-qr {
        text-align: center;
        margin: 20px 0;
        page-break-inside: avoid;
    }
    
    @media print {
        .invoice-qr img {
            width: 150px !important;
        }
    }
</style>
```

### B. Nhúng QR vào PDF

Tìm file `PdfUtil.java` và thêm phương thức:

```java
import com.itextpdf.text.Image;
import demo.util.QRCodeHoaDonUtil;

public static void addQRCodeToPdf(Document document, HoaDon hoaDon) throws Exception {
    // Tạo QR code
    byte[] qrBytes = QRCodeHoaDonUtil.generateQRCodeBytes(hoaDon, 200);
    
    // Chuyển byte array sang Image của iText
    Image qrImage = Image.getInstance(qrBytes);
    qrImage.scaleToFit(150, 150);
    qrImage.setAlignment(Image.ALIGN_CENTER);
    
    // Thêm vào document
    document.add(new Paragraph("Quét mã QR để xem chi tiết hóa đơn:"));
    document.add(qrImage);
}
```

### C. Gửi QR qua Email

```java
import demo.util.QRCodeHoaDonUtil;
import demo.util.EmailUtil;

// Trong method gửi email
String qrBase64 = QRCodeHoaDonUtil.generateQRCodeBase64(hoaDon);

String emailContent = "<html><body>" +
    "<h2>Hóa đơn #" + hoaDon.getMaHoaDon() + "</h2>" +
    "<p>Quét mã QR để xem chi tiết:</p>" +
    "<img src='data:image/png;base64," + qrBase64 + "' width='300'>" +
    "</body></html>";

EmailUtil.sendEmail(khachHang.getEmail(), "Hóa đơn của bạn", emailContent);
```

## 🎨 Tùy chỉnh nội dung QR Code

Mở file `QRCodeHoaDonUtil.java` và chỉnh sửa method `generateQRContent()`:

```java
public static String generateQRContent(HoaDon hoaDon) {
    StringBuilder content = new StringBuilder();
    
    // Thêm logo/header
    content.append("🏪 TÊN CỬA HÀNG CỦA BẠN\n");
    content.append("=== HÓA ĐƠN BÁN HÀNG ===\n\n");
    
    // Thông tin hóa đơn
    content.append("Mã HĐ: ").append(hoaDon.getMaHoaDon()).append("\n");
    content.append("Ngày: ").append(DATE_FORMAT.format(hoaDon.getNgayLap())).append("\n");
    content.append("Khách: ").append(hoaDon.getTenKhachHang()).append("\n");
    content.append("Tổng: ").append(CURRENCY_FORMAT.format(hoaDon.getTongTien())).append("\n");
    
    // Thêm link xác thực (nếu có website)
    content.append("\nXem online:\n");
    content.append("https://yourdomain.com/hoa-don/").append(hoaDon.getId()).append("\n");
    
    // Footer
    content.append("\nCảm ơn quý khách!");
    
    return content.toString();
}
```

## 📱 Ví dụ nội dung QR Code

Khi quét mã QR, khách hàng sẽ thấy:

```
=== HÓA ĐƠN BÁN HÀNG ===
Mã HĐ: HD001234
Ngày lập: 17/08/2026
Khách hàng: Nguyễn Văn A
SĐT: 0123456789
Tổng tiền: 15.000.000₫
Trạng thái: Đã hoàn thành
```

## 🔧 Test và Debug

### 1. Test trực tiếp bằng URL

Mở trình duyệt và truy cập:
```
http://localhost:8080/nhom5_DA1/qr-hoa-don?id=1
```

### 2. Xem trang demo

```
http://localhost:8080/nhom5_DA1/demo/hoa_don/qr_code_example.jsp
```

### 3. Test bằng công cụ quét QR

- Dùng điện thoại quét mã QR
- Dùng website: https://zxing.org/w/decode.jspx (upload ảnh QR)

## ❓ Câu hỏi thường gặp

### Q1: Có cần thêm cột vào database không?
**A:** Không cần! Mã QR được tạo động từ dữ liệu có sẵn.

### Q2: Mã QR có thay đổi khi cập nhật hóa đơn không?
**A:** Có, mã QR sẽ tự động cập nhật theo dữ liệu mới nhất. Đây là ưu điểm của phương pháp tạo động.

### Q3: Làm sao để in QR code ra giấy?
**A:** Sử dụng `@media print` CSS hoặc nhúng QR vào PDF bằng iText (xem phần "Nhúng QR vào PDF" ở trên).

### Q4: QR code có hỗ trợ tiếng Việt không?
**A:** Có, đã cấu hình UTF-8 encoding trong `BarcodeUtil`.

### Q5: Làm thế nào để thay đổi kích thước QR?
**A:** Thêm parameter `size` vào URL:
```jsp
<img src="/qr-hoa-don?id=${hoaDon.id}&size=200">
```

### Q6: Có thể tạo QR chứa link website không?
**A:** Có, sửa method `generateQRContent()` và thêm URL của bạn.

### Q7: QR code có bị lỗi nếu dữ liệu dài không?
**A:** Không, ZXing tự động điều chỉnh độ phức tạp của QR. Tuy nhiên, nội dung quá dài sẽ làm QR khó quét.

## 🎯 Khuyến nghị

1. **Kích thước QR phù hợp:**
   - Web: 250-300px
   - In giấy: 150-200px
   - Email: 300px
   - PDF: 150-200px

2. **Nội dung QR:**
   - Giữ nội dung ngắn gọn, dễ đọc
   - Ưu tiên thông tin quan trọng (mã HĐ, tổng tiền)
   - Có thể thêm link website để khách tra cứu online

3. **Performance:**
   - QR được cache 1 giờ (đã config trong servlet)
   - Với lượng truy cập lớn, cân nhắc cache vào Redis/Memcached

4. **Bảo mật:**
   - Đừng đưa thông tin nhạy cảm vào QR (mật khẩu, token)
   - Nếu cần bảo mật, dùng ID ngắn gọn và link đến trang xác thực

## 📞 Hỗ trợ

Nếu gặp vấn đề:
1. Kiểm tra dependency ZXing đã có trong `pom.xml`
2. Kiểm tra servlet mapping trong `web.xml` hoặc annotation
3. Xem log lỗi trong console Tomcat
4. Test trực tiếp URL servlet trước khi tích hợp vào JSP

---

**Tạo bởi:** Kiro AI Assistant  
**Ngày:** 17/08/2026  
**Version:** 1.0
