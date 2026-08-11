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
@Table(name = "nha_cung_cap")
public class NhaCungCap {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "ten_nha_cung_cap")
    private String tenNhaCungCap;
    @Column(name = "sdt")
    private String SDT;
    @Column(name = "dia_chi")
    private String diaChi;
    @Column(name = "email")
    private String email;
}
