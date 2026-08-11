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
@Table(name = "o_cung")
public class OCung {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "ten_o_cung")
    private String tenOCung;
    @Column(name = "dung_luong_o_cung")
    private String dungLuongOCung;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
