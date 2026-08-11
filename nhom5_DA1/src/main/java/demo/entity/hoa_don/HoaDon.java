package demo.entity.hoa_don;

import demo.entity.khach_hang.KhachHang;
import demo.entity.nhan_vien.NhanVien;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

import java.sql.Date;
import java.util.List;
import java.math.BigDecimal;


@Entity
@Table(name = "hoa_don")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SQLDelete(sql="UPDATE hoa_don SET is_deleted = 1 WHERE id = ?")
@Where(clause = "is_deleted = 0")
public class HoaDon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;


    @ManyToOne
    @JoinColumn(name = "id_khach_hang", referencedColumnName = "id")
    private KhachHang khachHang;

    @ManyToOne
    @JoinColumn(name = "id_nhan_vien", referencedColumnName = "id")
    private NhanVien nhanVien;

    @ManyToOne
    @JoinColumn(name = "id_hinh_thuc_thanh_toan", referencedColumnName = "id")
    private HinhThucThanhToan hinhThucThanhToan;

    // --- Các cột dữ liệu (Columns) ---
    @Column(name = "ma_hoa_don")
    private String maHoaDon;

    @Column(name = "ngay_lap")
    private Date ngayLap;

    @Column(name = "ngay_thanh_toan")
    private Date ngayThanhToan;

    @Column(name = "tong_tien")
    private BigDecimal tongTien;

    @Column(name = "ten_khach_hang")
    private String tenKhachHang;

    @Column(name = "sdt_khach_hang")
    private String sdtKhachHang;

    @Column(name = "tien_khach_tra")
    private BigDecimal tienKhachTra;

    @Column(name = "tien_thua")
    private BigDecimal tienThua;

    @Column(name = "ghi_chu")
    private String ghiChu;

    @Column(name = "trang_thai")
    private Integer trangThai;

    @Column(name = "is_deleted")
    private Integer isDeleted = 0;

    @OneToMany(mappedBy = "hoaDon")
    private List<LichSuThanhToan> lichSuThanhToan;
    public List<LichSuThanhToan> getLichSuThanhToan() {
        return lichSuThanhToan;
    }

    @OneToMany(mappedBy = "hoaDon")
    private List<ChiTietHoaDon> listChiTiet;

}
