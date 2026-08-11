<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm sản phẩm chi tiết - Skycomputer</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; }
        /* 🎨 --- SIDEBAR --- */
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #fff;
            border-right: 1px solid #e5e7eb;
            display: flex;
            flex-direction: column;
            padding-bottom: 16px;
            z-index: 1000;
        }

        .brand {
            display: flex;
            align-items: center;
            padding: 20px 20px;
            gap: 12px;
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 12px;
        }

        .brand-logo {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff;
        }

        .brand-logo img { width: 100%; height: 100%; object-fit: contain; }
        .brand-text h1 { font-size: 16px; font-weight: 700; color: #1e3a8a; margin-bottom: 0px;}
        .brand-text p { font-size: 11px; color: #6b7280; margin-bottom: 0; }

        .nav-menu { list-style: none; padding: 0 12px; flex: 1; overflow-y: auto; }
        .nav-item { margin-bottom: 4px; }

        .nav-link-custom {
            display: flex;
            align-items: center;
            padding: 11px 16px;
            color: #6b7280;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            gap: 12px;
        }
        .nav-link-custom i { font-size: 16px; width: 20px; text-align: center; }
        .nav-link-custom:hover { background-color: #f3f4f6; color: #1f2937; }
        .nav-link-custom.active { background-color: #eef2ff; color: #1a56db; font-weight: 600; }

        .sub-menu {
            list-style: none;
            padding-left: 0;
            margin-top: 4px;
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .sub-menu .nav-link-custom {
            padding: 9px 16px 9px 44px !important;
            font-size: 13px;
        }
        .sub-menu .nav-link-custom.active-sub {
            background-color: #eef2ff;
            color: #1a56db;
            font-weight: 600;
        }

        .logout-item { margin-top: auto; padding: 0 12px; }
        .nav-link-custom.logout-link { color: #dc2626; border-top: 1px solid #e5e7eb; border-radius: 0; padding-top: 16px; }
        .nav-link-custom.logout-link:hover { background-color: #ffe4e6; color: #be123c; border-radius: 8px; }


        .main-content { margin-left: 260px; padding: 40px; }

        .form-card { background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); margin-bottom: 24px; }

        .form-label { font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; margin-bottom: 6px; letter-spacing: 0.5px; }
        .form-control, .form-select { border-color: #e2e8f0; border-radius: 6px; font-size: 14px; padding: 10px 12px; height: 42px; background-color: #f8fafc; }
        .form-control:focus, .form-select:focus { border-color: #0f172a; box-shadow: 0 0 0 3px rgba(15, 23, 42, 0.1); background-color: #ffffff; }

        .btn-dark-custom { background-color: #0f172a; color: white; border: none; font-weight: 500; height: 42px; padding: 0 20px; transition: all 0.2s; border-radius: 8px; }
        .btn-dark-custom:hover { background-color: #1e293b; color: white; }

        /* Nút + thêm nhanh thuộc tính màu đen */
        .btn-plus-quick { background-color: #0f172a; color: white; border: none; border-radius: 6px; width: 42px; height: 42px; display: flex; align-items: center; justify-content: center; font-size: 16px; transition: all 0.2s; }
        .btn-plus-quick:hover { background-color: #1e293b; }

        /* Khung chứa các phiên bản cấu hình gộp màu xám thanh lịch */
        .version-box { border: 1px solid #e2e8f0; border-radius: 12px; margin-bottom: 24px; overflow: hidden; background: #ffffff; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .version-header { background-color: #f8fafc; padding: 16px 20px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .version-title { font-weight: 700; font-size: 13px; color: #0f172a; text-transform: uppercase; letter-spacing: 0.5px; }

        .badge-imei-green { background-color: #dcfce7; color: #16a34a; padding: 6px 14px; border-radius: 6px; font-weight: 500; font-size: 12px; border: none; transition: all 0.2s; }
        .badge-imei-green:hover { background-color: #bbf7d0; }

        /* Nút thêm imei màu xám tinh tế */
        .btn-grey-import { background-color: #f1f5f9; color: #0f172a; border: 1px solid #cbd5e1; font-weight: 500; font-size: 13px; padding: 6px 14px; border-radius: 6px; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
        .btn-grey-import:hover { background-color: #e2e8f0; }

        /* Custom lại Select2 chọn nhiều thẻ tag khớp tông màu của trang*/
        .select2-container--default .select2-selection--multiple { border: 1px solid #e2e8f0 !important; border-radius: 6px !important; min-height: 42px !important; background-color: #f8fafc !important; }
        .select2-container--default .select2-selection--multiple .select2-selection__choice { background-color: #f1f5f9 !important; border: 1px solid #cbd5e1 !important; color: #0f172a !important; font-weight: 500; }

        /* Khung tải ảnh */
        .img-box-container { border: 1px solid #e2e8f0; padding: 16px; border-radius: 8px; background: white; text-align: center; }
        .img-placeholder { border: 2px dashed #e2e8f0; background: #f8fafc; border-radius: 6px; padding: 16px; cursor: pointer; transition: all 0.2s; }
        .img-placeholder:hover { border-color: #0f172a; background-color: #f1f5f9; }
    </style>
</head>
<body>

<!-- SIDEBAR NAVIGATION -->
<aside class="sidebar">
    <div class="brand">
        <div class="brand-logo">
            <img src="/img/logo.jpg" alt="Skycomputer Logo">
        </div>
        <div class="brand-text">
            <h1>Skycomputer</h1>
            <p>Hệ thống quản lý</p>
        </div>
    </div>

    <ul class="nav-menu">
        <li class="nav-item">
            <a href="/tong_quan" class="nav-link-custom"><i class="fa-solid fa-border-all"></i> Trang thống kê</a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/hoa-don/ban-hang" class="nav-link-custom"><i class="fa-solid fa-store"></i> Bán hàng tại quầy</a>
        </li>

        <!-- DROPDOWN QUẢN LÝ SẢN PHẨM -->
        <li class="nav-item">
            <a class="nav-link-custom d-flex justify-content-between align-items-center active" data-bs-toggle="collapse" role="button" aria-expanded="true">
                <span><i class="fa-solid fa-box"></i> Quản lý sản phẩm</span>
                <i class="fa-solid fa-chevron-down" style="font-size: 10px; transition: transform 0.2s;"></i>
            </a>
            <div class="collapse show" id="sub-san-pham">
                <ul class="sub-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="nav-link-custom">
                            <i class="fa-solid fa-list me-1"></i> Danh sách sản phẩm
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi" class="nav-link-custom active-sub">
                            <i class="fa-solid fa-circle-info me-1"></i> Sản phẩm chi tiết
                        </a>
                    </li>
                </ul>
            </div>
        </li>

        <!-- QUẢN LÝ HÓA ĐƠN -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/hoa-don/hien-thi" class="nav-link-custom"><i class="fa-solid fa-file-invoice"></i> Quản lý hóa đơn</a>
        </li>

        <!-- QUẢN LÝ KHÁCH HÀNG -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/khach-hang/hien-thi" class="nav-link-custom"><i class="fa-solid fa-users"></i> Quản lý khách hàng</a>
        </li>

        <!-- QUẢN LÝ NHÂN VIÊN -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="nav-link-custom"><i class="fa-solid fa-id-badge"></i> Quản lý nhân viên</a>
        </li>

        <!-- DROPDOWN QUẢN LÝ THUỘC TÍNH -->
        <li class="nav-item">
            <a class="nav-link-custom d-flex justify-content-between align-items-center" data-bs-toggle="collapse" role="button" aria-expanded="false">
                <span><i class="fa-solid fa-sliders"></i> Quản lý thuộc tính</span>
                <i class="fa-solid fa-chevron-down" style="font-size: 10px; transition: transform 0.2s;"></i>
            </a>
            <div class="collapse" id="sub-thuoc-tinh">
                <ul class="sub-menu">
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/cpu/hien-thi" class="nav-link-custom"><i class="fa-solid fa-microchip me-1"></i> Cấu hình CPU</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/ram/hien-thi" class="nav-link-custom"><i class="fa-solid fa-memory me-1"></i> Cấu hình RAM</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/o-cung/hien-thi" class="nav-link-custom"><i class="fa-solid fa-hard-drive me-1"></i> Ổ cứng</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/gpu/hien-thi" class="nav-link-custom"><i class="fa-solid fa-clone me-1"></i> Card đồ họa (GPU)</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/man-hinh/hien-thi" class="nav-link-custom"><i class="fa-solid fa-display me-1"></i> Màn hình</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/hien-thi" class="nav-link-custom"><i class="fa-solid fa-palette me-1"></i> Màu sắc</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/pin/hien-thi" class="nav-link-custom"><i class="fa-solid fa-battery-three-quarters me-1"></i> Thông số Pin</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/danh-muc/hien-thi" class="nav-link-custom"><i class="fa-solid fa-layer-group me-1"></i> Danh mục sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/thuong-hieu/hien-thi" class="nav-link-custom"><i class="fa-solid fa-copyright me-1"></i> Thương hiệu</a></li>
                </ul>
            </div>
        </li>
    </ul>

    <div class="logout-item">
        <a href="${pageContext.request.contextPath}/dang-xuat" class="nav-link-custom logout-link">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</aside>

<!-- MAIN CONTENT -->
<div class="main-content">

    <!-- Top Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1" style="color: #0f172a;">Sản phẩm chi tiết</h4>
            <small class="text-muted">Quản lý và sinh tự động các thuộc tính thương mại</small>
        </div>
        <button type="button" class="btn btn-dark-custom" onclick="window.location.reload();">
            <i class="fa-solid fa-rotate me-2"></i> LÀM MỚI
        </button>
    </div>

    <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/them" method="POST" enctype="multipart/form-data">

        <!-- ========================================================================= -->
        <!-- PHẦN 1: KHỐI THÔNG TIN CƠ BẢN (Form Xám/Đen tinh gọn có nút +) -->
        <!-- ========================================================================= -->
        <div class="form-card">
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <label class="form-label">TÊN SẢN PHẨM *</label>
                    <select id="selectSanPhamCha" name="idSanPham" class="form-select" required onchange="dongBoTenBienThe()">
                        <option value="">-- Chọn sản phẩm --</option>
                        <c:forEach items="${listSanPham}" var="sp">
                            <option value="${sp.id}" data-name="${sp.tenSanPham}">${sp.tenSanPham}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">DANH MỤC *</label>
                    <div class="d-flex gap-2">
                        <select name="idDanhMuc" class="form-select" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach items="${listDanhMuc}" var="dm"><option value="${dm.id}">${dm.tenDanhMuc}</option></c:forEach>
                        </select>
                        <button type="button" class="btn-plus-quick"><i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label">HÃNG *</label>
                    <div class="d-flex gap-2">
                        <select name="idThuongHieu" class="form-select" required>
                            <option value="">-- Chọn hãng --</option>
                            <c:forEach items="${listThuongHieu}" var="th"><option value="${th.id}">${th.tenThuongHieu}</option></c:forEach>
                        </select>
                        <button type="button" class="btn-plus-quick"><i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <label class="form-label">HỆ ĐIỀU HÀNH *</label>
                    <div class="d-flex gap-2">
                        <select name="heDieuHanh" class="form-select" required>
                            <option value="Windows 11 Home">Windows 11 Home</option>
                            <option value="Windows 11 Pro">Windows 11 Pro</option>
                            <option value="macOS">macOS</option>
                        </select>
                        <button type="button" class="btn-plus-quick"><i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label">MÀN HÌNH *</label>
                    <div class="d-flex gap-2">
                        <select name="idManHinh" class="form-select" required>
                            <c:forEach items="${listManHinh}" var="mh"><option value="${mh.id}">${mh.tenManHinh} (${mh.kichThuoc})</option></c:forEach>
                        </select>
                        <button type="button" class="btn-plus-quick"><i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label">PIN *</label>
                    <div class="d-flex gap-2">
                        <select name="idPin" class="form-select" required>
                            <c:forEach items="${listPin}" var="p"><option value="${p.id}">${p.tenPin}</option></c:forEach>
                        </select>
                        <button type="button" class="btn-plus-quick"><i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
            </div>

            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">BỘ VI XỬ LÝ (CPU) *</label>
                    <div class="d-flex gap-2">
                        <select name="idCpu" class="form-select" required>
                            <c:forEach items="${listCpu}" var="cpu"><option value="${cpu.id}">${cpu.tenCpu}</option></c:forEach>
                        </select>
                        <button type="button" class="btn-plus-quick"><i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label">CARD ĐỒ HỌA (GPU) *</label>
                    <div class="d-flex gap-2">
                        <select name="idGpu" class="form-select" required>
                            <c:forEach items="${listGpu}" var="gpu"><option value="${gpu.id}">${gpu.tenGPU}</option></c:forEach>
                        </select>
                        <button type="button" class="btn-plus-quick"><i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
            </div>
        </div>


        <!-- ========================================================================= -->
        <!-- PHẦN 2: CHỌN TAG BIẾN THỂ ĐỂ GENERATE ĐỘNG -->
        <!-- ========================================================================= -->
        <div class="form-card">
            <div class="form-label text-dark mb-3" style="font-size: 13px; font-weight:600;">Biến thể sản phẩm</div>
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <label class="form-label">MÀU SẮC MÁY *</label>
                    <select id="selectMàu" class="form-select select2-tag-build" multiple="multiple" style="width: 100%">
                        <c:forEach items="${listMauSac}" var="ms"><option value="${ms.id}">${ms.tenMauSac}</option></c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">CẤU HÌNH BỘ NHỚ (RAM / Ổ CỨNG) *</label>
                    <select id="selectCấuHình" class="form-select select2-tag-build" multiple="multiple" style="width: 100%">
                        <c:forEach items="${listRam}" var="ram">
                            <option value="${ram.id}">${ram.dungLuongRam} / 256GB SSD</option>
                            <option value="${ram.id}">${ram.dungLuongRam} / 512GB SSD</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <button type="button" class="btn btn-dark-custom w-100 py-2.5" style="border-radius: 6px;" onclick="generateTổHợpBiếnThể()">
                <i class="fa-solid fa-bolt-lightning me-2"></i> TẠO BIẾN THỂ TỰ ĐỘNG
            </button>
        </div>


        <!-- ========================================================================= -->
        <!-- PHẦN 3: DANH SÁCH BIẾN THỂ PHÂN CỤM (Layout bàn cờ gọn gàng) -->
        <!-- ========================================================================= -->
        <div class="d-none" id="khungChứaBiếnThể">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="form-label text-dark mb-0" style="font-size: 14px;">Danh sách biến thể</div>
                <button type="button" class="btn btn-sm btn-outline-secondary" style="border-radius:6px;" onclick="clearBảng()"><i class="fa-solid fa-trash-can me-1"></i> Xóa tất cả</button>
            </div>

            <div id="vùngChứaBảngĐộng">
                <!-- Javascript sinh các cụm version-box chạy vào đây -->
            </div>
        </div>


        <!-- ========================================================================= -->
        <!-- PHẦN 4: KHU VỰC TẢI ẢNH THEO MÀU SẮC -->
        <!-- ========================================================================= -->
        <div class="form-card d-none" id="khungChứaẢnh">
            <div class="form-label text-dark mb-3" style="font-size: 13px;"><i class="fa-regular fa-image me-2"></i>Ảnh theo màu sắc</div>
            <div class="row g-3" id="vùngChứaKhungUploadẢnh"></div>

            <div class="d-flex justify-content-end gap-3 mt-5 pt-3 border-top">
                <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi" class="btn btn-light border px-4 py-2 fw-medium" style="border-radius:8px;">HỦY BỎ</a>
                <button type="submit" class="btn btn-dark-custom px-5 py-2">HOÀN TẤT LƯU BIẾN THỂ</button>
            </div>
        </div>

        <!-- ========================================================================= -->
        <!-- MODAL THÊM IMEI ĐỒNG BỘ KIỂU DÁNG MẪU MỚI -->
        <!-- ========================================================================= -->
        <div class="modal fade" id="imeiModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 12px; background-color: #ffffff;">
                    <div class="modal-header border-0 pt-4 px-4 pb-2 d-flex justify-content-between align-items-start">
                        <h5 class="modal-title fw-bold text-dark" id="modalImeiHeaderTitle" style="font-size: 16px; max-width: 85%;">
                            Nhập IMEI cho biến thể
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" style="font-size: 12px;"></button>
                    </div>
                    <div class="modal-body px-4">
                        <input type="hidden" id="currentInputIndexTarget">

                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <label class="fw-semibold text-secondary" style="font-size: 13px;">Nhập IMEI</label>
                            <button type="button" class="btn btn-sm btn-dark-custom px-3 d-flex align-items-center gap-1" style="font-size: 12px; border-radius: 6px; height:32px;">
                                <i class="fa-solid fa-qrcode"></i> Quét QR
                            </button>
                        </div>

                        <textarea id="txtAreaImeiTemp" class="form-control mb-2" rows="5"
                                  placeholder="Ví dụ: 123456789876543&#10;Mỗi IMEI trên một dòng, chỉ gồm chữ số, đúng 15 ký tự."
                                  style="font-size: 13px; font-family: monospace; border-color: #cbd5e1; background-color: #ffffff;"></textarea>

                        <div id="imeiErrorBox" class="d-none mb-2 p-2 rounded" style="background:#fff1f2; border:1px solid #fca5a5; font-size:12px; color:#dc2626; line-height:1.6;"></div>

                        <div class="mb-3 fw-medium text-dark" style="font-size: 13px;">
                            Danh sách IMEI: <span id="lblCountImeiModal" class="fw-bold text-success">0 IMEI</span>
                        </div>

                        <div class="p-3 bg-light text-center border rounded mb-4 text-muted small" id="boxImeiListPreview" style="border-radius:6px;">
                            Chưa có text IMEI nào được nhập
                        </div>

                        <h6 class="fw-bold text-dark mb-2" style="font-size: 14px;">Nhập từ file Excel</h6>
                        <div class="mb-3">
                            <input type="file" class="form-control form-control-sm w-100" style="height: auto; padding: 6px 12px; background-color:#ffffff;">
                        </div>
                        <button type="button" class="btn btn-sm btn-light border text-dark px-3" style="border-radius: 6px; font-size: 12px; font-weight:500;">Tải mẫu IMEI</button>
                    </div>

                    <div class="modal-footer border-0 p-4 d-flex justify-content-between gap-2">
                        <button type="button" class="btn btn-outline-danger fw-semibold" style="font-size: 14px; width: 30%; border-radius: 8px;" onclick="clearModalTextArea()">XÓA TRỐNG</button>
                        <button type="button" class="btn btn-light border fw-semibold" style="font-size: 14px; width: 30%; border-radius: 8px;" data-bs-dismiss="modal">ĐÓNG</button>
                        <button type="button" class="btn btn-dark-custom fw-semibold" style="font-size: 14px; width: 30%; border-radius: 8px;" onclick="xacNhanLuuImeiModal()">LƯU LẠI</button>
                    </div>
                </div>
            </div>
        </div>

    </form>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function() {
        $('.select2-tag-build').select2({ placeholder: "Tìm và chọn...", allowClear: true });
        $('#selectMàu').on('change', function() { sinhKhungUploadAnh(); });

        $('#txtAreaImeiTemp').on('input', function() {
            const txt = $(this).val().trim();
            const lines = txt ? txt.split('\n').map(s => s.trim()).filter(l => l.length > 0) : [];
            const imeiRegex = /^\d{15}$/;

            // Ẩn error box khi người dùng đang gõ lại
            $('#imeiErrorBox').addClass('d-none').html('');

            $('#lblCountImeiModal').text(lines.length + " IMEI mới");
            if (lines.length > 0) {
                $('#boxImeiListPreview').html(lines.map(l => {
                    const ok = imeiRegex.test(l);
                    return `<span class="badge me-1 mb-1 ${ok
                        ? 'bg-light text-dark border border-secondary-subtle'
                        : 'text-danger border border-danger-subtle'}"
                        style="font-size:11px; background-color:${ok ? '' : '#fff1f2'};">${l}${ok ? '' : ' ⚠️'}</span>`;
                }).join(''));
            } else {
                $('#boxImeiListPreview').text("Chưa có text IMEI nào được nhập");
            }
        });
    });

    function dongBoTenBienThe() {
        const selectBox = document.getElementById("selectSanPhamCha");
        const selectedOption = selectBox.options[selectBox.selectedIndex];
        const textName = selectedOption.getAttribute("data-name") || "Tên sản phẩm";
        document.querySelectorAll(".sync-name-label").forEach(el => el.innerText = textName);
    }

    function generateTổHợpBiếnThể() {
        const màuSelected = $('#selectMàu').select2('data');
        const cấuHìnhSelected = $('#selectCấuHình').select2('data');
        const vungChua = document.getElementById("vùngChứaBảngĐộng");
        const selectBox = document.getElementById("selectSanPhamCha");
        const tenSp = selectBox.options[selectBox.selectedIndex].getAttribute("data-name") || "Sản phẩm Laptop";

        if (màuSelected.length === 0 || cấuHìnhSelected.length === 0) {
            alert("⚠️ Vui lòng chọn đầy đủ Màu sắc và Cấu hình!");
            return;
        }

        vungChua.innerHTML = "";
        let globalIndex = 0;

        cấuHìnhSelected.forEach(ch => {
            let htmlCum = `
                <div class="version-box">
                    <div class="version-header">
                        <div class="version-title">PIÊN BẢN ${ch.text}</div>
                        <div class="d-flex gap-2">
                            <input type="number" class="form-control form-control-sm text-center" placeholder="Nhập giá trị..." style="width: 140px; height: 32px; background-color:#ffffff;">
                            <button type="button" class="btn btn-sm btn-dark-custom" style="height: 32px; font-size:12px; line-height:1;">ÁP DỤNG</button>
                            <button type="button" class="btn btn-sm btn-outline-danger px-3" style="height: 32px; font-size:12px; line-height:1; border-radius:6px;" onclick="this.closest('.version-box').remove()">XÓA NHÓM</button>
                        </div>
                    </div>
                    <table class="table align-middle mb-0 text-center text-secondary table-hover" style="font-size:13px; font-weight:500;">
                        <thead class="table-light text-dark" style="font-size:12px; font-weight:600; text-transform:uppercase; letter-spacing:0.5px;">
                            <tr>
                                <th style="width: 60px; padding:12px;">STT</th>
                                <th>TÊN SẢN PHẨM</th>
                                <th>MÀU SẮC</th>
                                <th style="width: 140px;">SỐ LƯỢNG</th>
                                <th style="width: 200px;">ĐƠN GIÁ (VND)</th>
                                <th style="width: 200px;">GIÁ NHẬP (VND)</th>
                                <th style="width: 150px;">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
            `;

            màuSelected.forEach((m, idx) => {
                globalIndex++;
                htmlCum += `
                    <tr>
                        <td class="padding:14px;">${idx + 1}</td>
                        <td class="text-start ps-3 text-dark font-medium sync-name-label">${tenSp}</td>
                        <td class="text-start ps-3"><span class="d-inline-block rounded-circle me-2" style="width:10px; height:10px; background-color:#475569; vertical-align:middle;"></span>${m.text}</td>
                        <td>
                            <button type="button" class="badge-imei-green" id="badge-count-${globalIndex}" onclick="moModalImei(${globalIndex}, '${ch.text}', '${m.text}')">0 IMEI</button>
                            <textarea name="soSeriMảng" id="imei-hidden-${globalIndex}" class="d-none"></textarea>
                            <input type="hidden" name="tonKhoMảng" id="tonkho-hidden-${globalIndex}" value="0">
                        </td>
                        <td><input type="number" name="giaBanMảng" class="form-control form-control-sm text-center mx-auto" value="15000000" style="width:90%; height:36px; background-color:#ffffff;" required></td>
                        <td><input type="number" name="giaNhapMảng" class="form-control form-control-sm text-center mx-auto" value="12000000" style="width:90%; height:36px; background-color:#ffffff;" required></td>
                        <td>
                            <div class="d-flex justify-content-center gap-2">
                                <button type="button" class="btn btn-sm btn-outline-danger" style="height:32px; width:32px; padding:0; border-radius:6px;" onclick="this.closest('tr').remove()"><i class="fa-regular fa-trash-can"></i></button>
                                <button type="button" class="btn-grey-import" onclick="moModalImei(${globalIndex}, '${ch.text}', '${m.text}')"><i class="fa-solid fa-arrow-right-to-bracket me-1"></i> THÊM IMEI</button>
                            </div>
                        </td>
                    </tr>
                `;
            });

            htmlCum += `</tbody></table></div>`;
            vungChua.insertAdjacentHTML('beforeend', htmlCum);
        });

        document.getElementById("khungChứaBiếnThể").classList.remove("d-none");
        dongBoTenBienThe();
    }

    function moModalImei(index, nameVersion, nameColor) {
        document.getElementById("currentInputIndexTarget").value = index;
        document.getElementById("modalImeiHeaderTitle").innerText = "Nhập IMEI cho biến thể " + nameVersion + " - " + nameColor;

        // Xóa trắng textarea — không cho sửa IMEI đã lưu
        document.getElementById("txtAreaImeiTemp").value = "";

        // Ẩn error box
        const errorBox = document.getElementById("imeiErrorBox");
        errorBox.classList.add("d-none");
        errorBox.innerHTML = "";

        // Hiển thị IMEI đã lưu ở preview (chỉ đọc)
        const textDaLuu = document.getElementById("imei-hidden-" + index).value;
        const mangDaLuu = textDaLuu ? textDaLuu.split('\n').filter(s => s.trim().length > 0) : [];

        if (mangDaLuu.length > 0) {
            $('#lblCountImeiModal').text(mangDaLuu.length + " IMEI đã lưu");
            $('#boxImeiListPreview').html(
                '<div class="mb-1 fw-semibold text-secondary" style="font-size:11px;">IMEI đã lưu (không thể chỉnh sửa):</div>' +
                mangDaLuu.map(l =>
                    `<span class="badge me-1 mb-1 border border-success-subtle"
                        style="font-size:11px; background-color:#f0fdf4; color:#16a34a;">${l.trim()}</span>`
                ).join('')
            );
        } else {
            $('#lblCountImeiModal').text("0 IMEI đã lưu");
            $('#boxImeiListPreview').text("Chưa có IMEI nào được lưu");
        }

        const myModal = new bootstrap.Modal(document.getElementById('imeiModal'));
        myModal.show();
    }

    function xacNhanLuuImeiModal() {
        const index = document.getElementById("currentInputIndexTarget").value;
        const text = document.getElementById("txtAreaImeiTemp").value.trim();
        const errorBox = document.getElementById("imeiErrorBox");
        const imeiRegex = /^\d{15}$/;

        // Lấy danh sách IMEI mới nhập (bỏ dòng trống)
        const dongMoi = text ? text.split('\n').map(s => s.trim()).filter(s => s.length > 0) : [];

        if (dongMoi.length === 0) {
            errorBox.innerHTML = "<strong>⚠️ Vui lòng nhập ít nhất một IMEI.</strong>";
            errorBox.classList.remove("d-none");
            return;
        }

        // Validate từng IMEI: chỉ số, đúng 15 ký tự
        const loiList = [];
        dongMoi.forEach((imei, i) => {
            if (!imeiRegex.test(imei)) {
                loiList.push(`Dòng ${i + 1}: <strong>"${imei}"</strong> — IMEI chỉ gồm chữ số, đúng 15 ký tự.`);
            }
        });

        if (loiList.length > 0) {
            errorBox.innerHTML = "⚠️ Có IMEI không hợp lệ:<br>" + loiList.join("<br>");
            errorBox.classList.remove("d-none");
            return; // Dừng, không lưu
        }

        // Hợp lệ — ẩn error box
        errorBox.classList.add("d-none");
        errorBox.innerHTML = "";

        // Gộp IMEI cũ đã lưu + IMEI mới (cộng dồn, không ghi đè)
        const textDaLuu = document.getElementById("imei-hidden-" + index).value;
        const mangDaLuu = textDaLuu ? textDaLuu.split('\n').filter(s => s.trim().length > 0) : [];
        const mangGop = mangDaLuu.concat(dongMoi);

        // Lưu và cập nhật UI
        document.getElementById("imei-hidden-" + index).value = mangGop.join('\n');
        document.getElementById("badge-count-" + index).innerText = mangGop.length + " Máy";
        document.getElementById("tonkho-hidden-" + index).value = mangGop.length;

        bootstrap.Modal.getInstance(document.getElementById('imeiModal')).hide();
    }

    function clearModalTextArea() {
        document.getElementById("txtAreaImeiTemp").value = "";
        const errorBox = document.getElementById("imeiErrorBox");
        errorBox.classList.add("d-none");
        errorBox.innerHTML = "";
        $('#lblCountImeiModal').text("0 IMEI mới");
        $('#boxImeiListPreview').text("Chưa có text IMEI nào được nhập");
    }

    function sinhKhungUploadAnh() {
        const màuSelected = $('#selectMàu').select2('data');
        const vungAnh = document.getElementById("vùngChứaKhungUploadẢnh");
        vungAnh.innerHTML = "";

        if (màuSelected.length > 0) {
            màuSelected.forEach(m => {
                vungAnh.insertAdjacentHTML('beforeend', `
                    <div class="col-md-2 text-center">
                        <div class="img-box-container">
                            <span class="d-block small fw-bold text-secondary mb-2">⚫ Màu ${m.text}</span>
                            <div class="img-placeholder" onclick="document.getElementById('img-${m.id}').click()">
                                <i class="fa-regular fa-image text-muted fs-4 d-block mb-1"></i>
                                <span class="text-muted small" style="font-size:11px;">Chưa có ảnh</span>
                                <input type="file" name="anhTheoMau" id="img-${m.id}" class="d-none" accept="image/*">
                            </div>
                        </div>
                    </div>
                `);
            });
            document.getElementById("khungChứaẢnh").classList.remove("d-none");
        } else {
            document.getElementById("khungChứaẢnh").classList.add("d-none");
        }
    }

    function clearBảng() {
        document.getElementById("vùngChứaBảngĐộng").innerHTML = "";
        document.getElementById("khungChứaBiếnThể").classList.add("d-none");
    }
</script>
</body>
</html>