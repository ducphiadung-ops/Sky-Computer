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
@Table(name = "pin")
public class Pin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "ten_pin")
    private String tenPin;
    @Column(name = "dung_luong_pin")
    private String dungLuongPin;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
