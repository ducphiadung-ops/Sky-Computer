package demo.entity.san_pham;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "phieu_nhap")
public class PhieuNhap {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "id_nha_cung_cap", nullable = false)
    private Integer idNhaCungCap;

    @Column(name = "ngay_nhap", nullable = false)
    private LocalDateTime ngayNhap = LocalDateTime.now();

    @Column(name = "tong_tien", nullable = false)
    private BigDecimal tongTien;
}