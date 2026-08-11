package demo.entity.khach_hang;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "dia_chi_khach_hang")
public class DiaChiKhachHang {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @ManyToOne
    @JoinColumn(name = "id_khach_hang", referencedColumnName = "id")
    private KhachHang khachHang;

    @OneToOne(mappedBy = "diaChiKhachHang", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private DiaChiApiMapping diaChiApiMapping;

    @Column(name = "tinh_thanh")
    private String tinhThanh;
    @Column(name = "quan_huyen")
    private String quanHuyen;
    @Column(name = "phuong_xa")
    private String phuongXa;
    @Column(name = "dia_chi_cu_the")
    private String diaChiCuThe;
    @Column(name = "loai_dia_chi")
    private String loaiDiaChi;
    @Column(name = "trang_thai")
    private Integer trangThai;
    public DiaChiApiMapping getDiaChiApiMapping() {
        return diaChiApiMapping;
    }

    public void setDiaChiApiMapping(DiaChiApiMapping diaChiApiMapping) {
        this.diaChiApiMapping = diaChiApiMapping;
    }
}