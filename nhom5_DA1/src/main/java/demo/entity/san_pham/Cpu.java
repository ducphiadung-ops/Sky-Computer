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
@Table(name = "cpu")
public class Cpu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id") // 🟢 BẮT BUỘC phải là "id"
    private Integer id;

    @Column(name = "ten_cpu")
    private String tenCpu;

    @Column(name = "the_he_cpu")
    private String theHeCpu; // Khớp với NVARCHAR(50)

    @Column(name = "trang_thai")
    private Integer trangThai;
}


