# 🚀 Quick Start - Tích hợp QR Code Hóa Đơn

## ✅ Đã hoàn thành

Hệ thống mã QR cho hóa đơn đã được tích hợp hoàn chỉnh vào project.

## 📋 Checklist triển khai

### Bước 1: Build project
```bash
# Chạy file batch có sẵn
.\build.bat

# Hoặc dùng Maven trực tiếp (nếu đã cài)
mvn clean package
```

### Bước 2: Deploy
```bash
# Copy file WAR vào Tomcat
copy target\nhom5_DA1-1.0-SNAPSHOT.war %CATALINA_HOME%\webapps\

# Hoặc dùng script có sẵn
.\build_run.bat
```

### Bước 3: Khởi động Tomcat
```bash
# Windows
%CATALINA_HOME%\bin\startup.bat

# Hoặc từ IDE
# Right click project > Run on Server
```

### Bước 4: Kiểm tra

Truy cập các URL sau để test:

#### Test QR Servlet
```
http://localhost:8080/nhom5_DA1/qr-hoa-don?id=1
```
✅ Nếu thấy ảnh QR → Servlet hoạt động tốt

#### Test trang demo
```
http://localhost:8080/nhom5_DA1/demo/hoa_don/qr_code_example.jsp
```
✅ Nếu thấy 4 ví dụ QR → Frontend hoạt động tốt

#### Test danh sách hóa đơn
```
http://localhost:8080/nhom5_DA1/hoa-don/hien-thi
```
✅ Kiểm tra:
- Cột "QR CODE" xuất hiện trong bảng
- Click icon QR → Modal hiển thị mã QR
- Nút "Tải xuống" và "In mã QR" hoạt động

#### Test chi tiết hóa đơn
```
http://localhost:8080/nhom5_DA1/hoa-don/detail?id=1
```
✅ Kiểm tra:
- Card "Mã QR" xuất hiện ở cột thứ 4
- QR hiển thị đúng
- Nút download và print hoạt động

#### Test trang in
```
http://localhost:8080/nhom5_DA1/hoa-don/in?id=1
```
✅ Kiểm tra:
- Section QR xuất hiện ở cuối trang
- Nút "In hoá đơn" → QR được in cùng

---

## 📁 Files đã tạo/sửa

### Tạo mới (3 files Java + 1 JSP + 2 docs)
- ✅ `src/main/java/demo/util/QRCodeHoaDonUtil.java`
- ✅ `src/main/java/demo/servlet/QRCodeHoaDonServlet.java`
- ✅ `src/main/webapp/demo/hoa_don/qr_code_example.jsp`
- ✅ `HUONG_DAN_QR_HOA_DON.md`
- ✅ `CHANGELOG_QR_HOA_DON.md`
- ✅ `QR_SETUP_QUICK_START.md` (file này)

### Chỉnh sửa (3 files JSP)
- ✅ `src/main/webapp/demo/hoa_don/hoa_don.jsp` - Thêm cột QR + modal
- ✅ `src/main/webapp/demo/hoa_don/chi_tiet_hoa_don.jsp` - Thêm card QR
- ✅ `src/main/webapp/demo/hoa_don/in_hoa_don.jsp` - Thêm section QR

---

## 🎯 Chức năng chính

### 1. Tạo QR động
```java
// Trong Java code
String qrBase64 = QRCodeHoaDonUtil.generateQRCodeBase64(hoaDon);
byte[] qrBytes = QRCodeHoaDonUtil.generateQRCodeBytes(hoaDon, 300);
```

### 2. Hiển thị QR trong JSP
```jsp
<!-- Cách đơn giản nhất -->
<img src="${pageContext.request.contextPath}/qr-hoa-don?id=${hoaDon.id}" 
     width="300">
```

### 3. Download QR
```javascript
function downloadQR(hoaDonId, maHoaDon) {
    const link = document.createElement('a');
    link.href = '/nhom5_DA1/qr-hoa-don?id=' + hoaDonId;
    link.download = 'QR_' + maHoaDon + '.png';
    link.click();
}
```

### 4. In QR
```javascript
function printQR(hoaDonId) {
    window.open('/nhom5_DA1/qr-hoa-don?id=' + hoaDonId, '_blank');
    // Sau đó Ctrl+P để in
}
```

---

## 🐛 Troubleshooting

### ❌ Lỗi 404: /qr-hoa-don not found

**Nguyên nhân:** Servlet chưa được deploy

**Giải pháp:**
1. Clean & rebuild project
2. Restart Tomcat
3. Kiểm tra file `QRCodeHoaDonServlet.java` có annotation `@WebServlet("/qr-hoa-don")`

### ❌ QR không hiển thị (ảnh broken)

**Nguyên nhân:** Hóa đơn không tồn tại hoặc thiếu thông tin

**Giải pháp:**
```sql
-- Kiểm tra hóa đơn trong database
SELECT id, ma_hoa_don, ngay_lap, tong_tien 
FROM hoa_don 
WHERE id = 1;
```

### ❌ Modal không mở

**Nguyên nhân:** JavaScript error hoặc jQuery conflict

**Giải pháp:**
1. Mở Developer Console (F12)
2. Xem tab Console có lỗi gì
3. Kiểm tra function `showQRCode()` đã được define

### ❌ QR bị mờ khi in

**Giải pháp:** Tăng size lên 300-400px
```jsp
<img src="...?id=${hoaDon.id}&size=400">
```

---

## 📖 Tài liệu đầy đủ

Xem file `HUONG_DAN_QR_HOA_DON.md` để có hướng dẫn chi tiết về:
- Cách sử dụng từng phương thức
- Code examples đầy đủ
- Tùy chỉnh nội dung QR
- Tích hợp vào PDF, Email
- FAQ và tips

---

## 🎨 Tùy chỉnh nhanh

### Thay đổi kích thước QR mặc định

File: `QRCodeHoaDonUtil.java` (line ~21)
```java
private static final int DEFAULT_QR_SIZE = 300; // Đổi thành 250, 400, etc
```

### Thay đổi nội dung QR

File: `QRCodeHoaDonUtil.java` method `generateQRContent()`
```java
public static String generateQRContent(HoaDon hoaDon) {
    StringBuilder content = new StringBuilder();
    
    // THAY ĐỔI NỘI DUNG TẠI ĐÂY
    content.append("=== CỬA HÀNG CỦA BẠN ===\n");
    content.append("Mã HĐ: ").append(hoaDon.getMaHoaDon()).append("\n");
    // ... thêm thông tin khác
    
    return content.toString();
}
```

### Thêm logo vào QR

Hiện tại chưa hỗ trợ logo trong QR. Để thêm:
1. Dùng thư viện `zxing` với `EncodeHintType.ERROR_CORRECTION = HIGH`
2. Overlay logo lên QR bằng image processing
3. Hoặc dùng service bên thứ 3

---

## ✨ Tính năng có thể mở rộng

### 1. QR với link tra cứu online
```java
content.append("Xem chi tiết:\n");
content.append("https://yourdomain.com/invoice/").append(hoaDon.getId());
```

### 2. QR trong email
```java
String qrBase64 = QRCodeHoaDonUtil.generateQRCodeBase64(hoaDon);
String emailHtml = "<img src='data:image/png;base64," + qrBase64 + "'>";
EmailUtil.sendEmail(email, subject, emailHtml);
```

### 3. Tracking số lần quét
- Thêm counter trong database
- Increment mỗi khi servlet được gọi
- Báo cáo thống kê

---

## 💡 Tips

1. **Cache QR trong trình duyệt** - QR được cache 1 giờ, giảm load server
2. **Kích thước phù hợp:**
   - Web: 250-300px
   - In giấy: 200px
   - Email: 300px
3. **Test với smartphone** - Dùng app QR scanner để test
4. **Nội dung ngắn gọn** - QR quá dài sẽ khó quét
5. **Error correction level M** - Cân bằng giữa kích thước và khả năng chịu lỗi

---

## 🎉 Hoàn tất!

Bạn đã sẵn sàng sử dụng tính năng QR code cho hóa đơn!

**Các bước tiếp theo:**
1. ✅ Build & deploy (xem bước 1-3 phía trên)
2. ✅ Test với dữ liệu thực tế
3. ✅ Thu thập feedback
4. ✅ Tùy chỉnh nếu cần
5. ✅ Training cho team

---

**Created by:** Kiro AI Assistant  
**Date:** 17/08/2026  
**Version:** 1.0

**Questions?** Xem `HUONG_DAN_QR_HOA_DON.md` hoặc `CHANGELOG_QR_HOA_DON.md`
