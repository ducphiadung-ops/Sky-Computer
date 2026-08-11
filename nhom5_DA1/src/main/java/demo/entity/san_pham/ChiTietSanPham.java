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
@Table(name = "chi_tiet_san_pham")
public class ChiTietSanPham {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_cau_hinh",referencedColumnName = "id")
    private CauHinhSanPham cauHinhSanPham;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_san_pham",referencedColumnName = "id")
    private SanPham sanPham;

    @Column(name = "don_gia")
    private BigDecimal donGia;

    @Column(name = "gia_nhap")
    private BigDecimal giaNhap;

    @Column(name = "ton_kho")
    private Integer tonKho;

    @Column(name = "trang_thai")
    private Integer trangThai;
}