package demo.entity.khach_hang;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "dia_chi_api_mapping")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DiaChiApiMapping {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // Liên kết 1-1 với bảng dia_chi_khach_hang
    @OneToOne
    @JoinColumn(name = "id_dia_chi_khach_hang")
    private DiaChiKhachHang diaChiKhachHang;

    @Column(name = "province_code")
    private Integer provinceCode;

    @Column(name = "district_code")
    private Integer districtCode;

    @Column(name = "ward_code")
    private Integer wardCode;
}
