package demo.entity.san_pham;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "man_hinh")
public class ManHinh {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "ten_man_hinh")
    private String tenManHinh;
    @Column(name = "do_phan_giai")
    private String doPhanGiai;
    @Column(name = "tan_so_quet")
    private String tanSoQuet;
    @Column(name = "kich_thuoc")
    private String kichThuoc;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
