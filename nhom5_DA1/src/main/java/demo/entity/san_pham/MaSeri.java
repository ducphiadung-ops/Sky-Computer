package demo.entity.san_pham;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "ma_seri")
public class MaSeri {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @ManyToOne
    @JoinColumn(name = "id_cau_hinh",referencedColumnName = "id")
    private CauHinhSanPham cauHinhSanPham;
    @ManyToOne
    @JoinColumn(name = "ma_chi_tiet_phieu_nhap",referencedColumnName = "id")
    private ChiTietPhieuNhap chiTietPhieuNhap;
    @Column(name = "so_seri")
    private String soSeri;
    @Column(name = "ngay_nhap")
    private LocalDate ngayNhap;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
