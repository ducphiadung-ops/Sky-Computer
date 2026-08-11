package demo.entity.hoa_don;

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
@Table(name = "hinh_thuc_thanh_toan")

public class HinhThucThanhToan {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "ten_hinh_thuc_thanh_toan")
    private String tenHinhThuc;

    @Column(name = "trang_thai")
    private String TrangThai;
}
