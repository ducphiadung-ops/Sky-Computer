package demo.entity.hoa_don;

import demo.entity.san_pham.CauHinhSanPham;
import demo.entity.san_pham.MaSeri;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Table(name = "chi_tiet_hoa_don")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChiTietHoaDon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // Map với bảng cau_hinh_san_pham
    @ManyToOne
    @JoinColumn(name = "ma_cau_hinh", referencedColumnName = "id")
    private CauHinhSanPham cauHinhSanPham;

    @ManyToOne
    @JoinColumn(name = "id_hoa_don", referencedColumnName = "id")
    private HoaDon hoaDon;

    @ManyToOne
    @JoinColumn(name = "id_seri", referencedColumnName = "id")
    private MaSeri idSeri;

    @Column(name = "don_gia")
    private BigDecimal donGia;

    @Column(name = "thanh_tien")
    private BigDecimal thanhTien;

    @Column(name = "trang_thai")
    private Integer trangThai;
}