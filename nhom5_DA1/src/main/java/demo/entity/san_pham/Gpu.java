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
@Table(name = "gpu")
public class Gpu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "ten_gpu")
    private String tenGpu;
    @Column(name = "dung_luong_gpu")
    private String dungLuongGpu;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
