package demo.entity.san_pham;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "ram")
public class Ram {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "ten_ram")
    private String tenRam;
    @Column(name = "dung_luong_ram")
    private String dungLuongRam;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
