package demo.entity.san_pham;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "san_pham")
public class SanPham {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @ManyToOne
    @JoinColumn(name = "id_danh_muc", referencedColumnName = "id")
    private DanhMuc danhMuc;
    @ManyToOne
    @JoinColumn(name = "id_thuong_hieu", referencedColumnName = "id")
    private ThuongHieu thuongHieu;
    @Column(name = "ma_san_pham")
    private String maSanPham;
    @Column(name = "ten_san_pham")
    private String tenSanPham;
    @Column(name = "gia_ban")
    private BigDecimal giaBan;
    @Column(name = "mo_ta")
    private String moTa;
    @Column(name = "so_luong_ton")
    private Integer soLuongTon;
    @Column(name = "ngay_tao")
    private LocalDate ngayTao;
    @Column(name = "ngay_sua")
    private LocalDate ngaySua;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
