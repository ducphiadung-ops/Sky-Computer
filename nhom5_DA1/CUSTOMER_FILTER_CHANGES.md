# Cập nhật: Lọc Khách Hàng Theo Trạng Thái Trong Bán Hàng Tại Quầy

## Mô tả thay đổi
Cập nhật chức năng "Chọn khách hàng" trong module bán hàng tại quầy để **chỉ hiển thị khách hàng có trạng thái hoạt động (trangThai = 1)**.

## Vấn đề trước khi sửa
- `HoaDonServlet` đang sử dụng `KhachHangRepo.getAll()` để load danh sách khách hàng
- Method `KhachHangRepo.getAll()` **KHÔNG có filter** theo trạng thái → trả về TẤT CẢ khách hàng (cả đang hoạt động và ngừng hoạt động)
- Mặc dù JSP có filter `<c:if test="${kh.trangThai == 1}">`, nhưng dữ liệu không cần thiết vẫn được load từ database và truyền qua network

## Giải pháp
Thay đổi từ `KhachHangRepo` sang `KhachHangRepository` - repository có sẵn method filter theo trạng thái.

## Files đã thay đổi

### 1. `src/main/java/demo/servlet/HoaDonServlet.java`

#### Thay đổi import:
```java
// TRƯỚC:
import demo.repository.khachhang.KhachHangRepo;

// SAU:
import demo.repository.khachhang.KhachHangRepository;
```

#### Thay đổi field declaration (dòng ~75):
```java
// TRƯỚC:
private final KhachHangRepo khachHangRepo = new KhachHangRepo();

// SAU:
private final KhachHangRepository khachHangRepo = new KhachHangRepository();
```

#### Thay đổi method call trong apiCapNhatKhach() (dòng ~404):
```java
// TRƯỚC:
KhachHang kh = khachHangRepo.getOne(Integer.parseInt(idKhParam));

// SAU:
KhachHang kh = khachHangRepo.timTheoId(Integer.parseInt(idKhParam));
```

## So sánh Repository Classes

### KhachHangRepo (CŨ - Không dùng nữa)
```java
public List<KhachHang> getAll() { 
    return session.createQuery("from KhachHang").list(); 
}
```
❌ Không có filter → Lấy TẤT CẢ khách hàng

### KhachHangRepository (MỚI - Đang dùng)
```java
public List<KhachHang> getAll() {
    Session session = HibernateConfig.getFACTORY().openSession();
    List<KhachHang> list = session.createQuery(
        "SELECT DISTINCT kh FROM KhachHang kh " +
        "LEFT JOIN FETCH kh.diaChiKhachHang " +
        "WHERE kh.trangThai = 1 " +  // ← CHỈ LẤY KHÁCH HÀNG HOẠT ĐỘNG
        "ORDER BY kh.id DESC", 
        KhachHang.class
    ).getResultList();
    session.close();
    return list;
}
```
✅ Có filter `WHERE kh.trangThai = 1` → Chỉ lấy khách hàng đang hoạt động

## Lợi ích

1. **Hiệu suất tốt hơn**: 
   - Giảm lượng dữ liệu truy vấn từ database
   - Giảm memory usage trên server
   - Giảm bandwidth khi truyền dữ liệu đến JSP

2. **Bảo mật tốt hơn**:
   - Không truyền thông tin khách hàng đã ngừng hoạt động qua network
   - Filter ngay từ tầng database

3. **Tối ưu query**:
   - `KhachHangRepository.getAll()` đã có `LEFT JOIN FETCH` để eager load địa chỉ → tránh N+1 query problem
   - Sắp xếp theo ID giảm dần → khách hàng mới nhất hiển thị đầu tiên

## Trường trạng thái KhachHang

| Giá trị | Ý nghĩa |
|---------|---------|
| `1` | Khách hàng đang hoạt động (hiển thị trong modal chọn khách hàng) |
| `0` | Khách hàng ngừng hoạt động (bị ẩn, không hiển thị) |

## Test case cần kiểm tra

1. ✅ Mở trang bán hàng tại quầy `/hoa-don/ban-hang`
2. ✅ Click nút "Chọn khách hàng"
3. ✅ Kiểm tra danh sách chỉ hiển thị khách hàng có `trangThai = 1`
4. ✅ Khách hàng có `trangThai = 0` KHÔNG xuất hiện trong danh sách
5. ✅ Chức năng tìm kiếm khách hàng vẫn hoạt động bình thường
6. ✅ Chức năng chọn và cập nhật khách hàng vào hóa đơn vẫn hoạt động

## Ghi chú

- JSP vẫn giữ filter `<c:if test="${kh.trangThai == 1}">` như một lớp bảo vệ bổ sung (defensive programming)
- Không ảnh hưởng đến các chức năng khác của module hóa đơn
- Method name đã được cập nhật từ `getOne()` thành `timTheoId()` để phù hợp với API của `KhachHangRepository`

## Ngày cập nhật
2026-08-17
