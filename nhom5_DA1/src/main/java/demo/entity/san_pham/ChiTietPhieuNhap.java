package demo.entity.san_pham;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "chi_tiet_phieu_nhap")
public class ChiTietPhieuNhap {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    // Liên kết nhiều chi tiết về một Phiếu Nhập
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_phieu_nhap", nullable = false)
    private PhieuNhap phieuNhap;

    // Liên kết nhiều chi tiết về một Cấu Hình Sản Phẩm
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ma_cau_hinh", nullable = false)
    private CauHinhSanPham cauHinhSanPham;

    @Column(name = "so_luong", nullable = false)
    private Integer soLuong;

    // Kiểu DECIMAL(18,2) trong SQL Server ánh xạ chuẩn nhất là BigDecimal trong Java
    @Column(name = "gia_nhap", nullable = false)
    private BigDecimal giaNhap;
}