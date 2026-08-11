package demo.entity.san_pham;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Entity
@Table(name = "cau_hinh_san_pham")
public class CauHinhSanPham {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_san_pham", referencedColumnName = "id")
    private SanPham sanPham;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "cpu",referencedColumnName = "id")
    private Cpu cpu;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ram",referencedColumnName = "id")
    private Ram ram;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "o_cung",referencedColumnName = "id")
    private OCung OCung;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "gpu",referencedColumnName = "id")
    private Gpu gpu;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "man_hinh",referencedColumnName = "id")
    private ManHinh manHinh;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "mau_sac",referencedColumnName = "id")
    private MauSac mauSac;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "pin",referencedColumnName = "id")
    private Pin pin;
    @Column(name = "he_dieu_hanh")
    private String heDieuHanh;
    @Column(name = "trong_luong")
    private String trongLuong;
}
