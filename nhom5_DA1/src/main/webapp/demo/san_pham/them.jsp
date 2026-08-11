<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    request.setAttribute("isNhanVien", _isNhanVien);
%>
<c:if test="${isNhanVien}">
    <c:redirect url="${pageContext.request.contextPath}/san-pham/hien-thi"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm - Skycomputer</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

    <style>
        :root {
            --primary: #1a56db;
            --primary-light: #e6efff;
            --sidebar-active: #eef2ff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --bg-body: #f8f9fa;
            --border-color: #e5e7eb;
            --success-text: #047857;
            --success-bg: #d1fae5;
            --warning-text: #b45309;
            --warning-bg: #fef3c7;
            --danger-text: #be123c;
            --danger-bg: #ffe4e6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            display: flex;
            height: 100vh;
            background-color: var(--bg-body);
            color: var(--text-main);
            overflow: hidden;
        }

        /* 🎨 SIDEBAR TRẮNG SÁNG */
        .sidebar {
            width: 260px;
            background-color: #fff;
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            height: 100vh;
            padding-bottom: 16px;
            z-index: 10;
        }

        .brand {
            display: flex;
            align-items: center;
            padding: 20px 20px;
            gap: 12px;
            border-bottom: 1px solid var(--border-color);
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
        .brand-text p { font-size: 11px; color: var(--text-muted); margin-bottom: 0; }

        .nav-menu { list-style: none; padding: 0 12px; flex: 1; overflow-y: auto; }
        .nav-item { margin-bottom: 4px; }

        .nav-link-custom {
            display: flex;
            align-items: center;
            padding: 11px 16px;
            color: var(--text-muted);
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            gap: 12px;
        }
        .nav-link-custom i { font-size: 16px; width: 20px; text-align: center; }
        .nav-link-custom:hover { background-color: #f3f4f6; color: var(--text-main); }
        .nav-link-custom.active { background-color: var(--sidebar-active); color: var(--primary); font-weight: 600; }

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
            background-color: var(--sidebar-active);
            color: var(--primary);
            font-weight: 600;
        }

        .logout-item { margin-top: auto; padding: 0 12px; }
        .nav-link-custom.logout-link { color: #dc2626; border-top: 1px solid var(--border-color); border-radius: 0; padding-top: 16px; }
        .nav-link-custom.logout-link:hover { background-color: var(--danger-bg); color: var(--danger-text); border-radius: 8px; }

        /* 🎨 MAIN CONTENT ĐỒNG BỘ MÀU VỚI MENU */
        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; background-color: var(--bg-body); }

        .top-header {
            height: 65px;
            background-color: #fff;
            display: flex;
            align-items: center;
            padding: 0 32px;
            border-bottom: 1px solid var(--border-color);
        }
        .header-actions { display: flex; align-items: center; gap: 24px; margin-left: auto; }
        .notification { position: relative; color: var(--text-muted); cursor: pointer; font-size: 18px; }
        .notification::after { content: ''; position: absolute; top: -2px; right: 0px; width: 8px; height: 8px; background: #ef4444; border-radius: 50%; border: 2px solid #fff; }

        .user-profile { display: flex; align-items: center; gap: 12px; }
        .user-info { text-align: right; }
        .user-name { font-size: 13px; font-weight: 600; color: var(--text-main); }
        .user-role { font-size: 10px; color: var(--text-muted); text-transform: uppercase; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; object-fit: cover; }

        .content-area { flex: 1; padding: 24px 32px; overflow-y: auto; }

        .form-card {
            background-color: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            margin-bottom: 24px;
        }
        .form-label { font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 6px; letter-spacing: 0.5px; }
        .form-control, .form-select { border-color: var(--border-color); border-radius: 8px; font-size: 14px; height: 42px; color: var(--text-main); }
        .form-control:focus, .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-light); }

        .btn-dark-custom { background-color: var(--primary); color: white; border: none; font-weight: 600; border-radius: 8px; height: 44px; transition: all 0.2s; }
        .btn-dark-custom:hover { background-color: #154cbf; }

        .version-box { border: 1px solid var(--border-color); border-radius: 12px; margin-bottom: 24px; overflow: hidden; background: #ffffff; }
        .version-header { background-color: #f8fafc; padding: 14px 20px; border-bottom: 1px solid var(--border-color); font-weight: 700; color: var(--text-main); font-size: 13px; }

        .btn-nhap-imei-chuan { background-color: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; font-weight: 600; font-size: 13px; padding: 6px 14px; border-radius: 6px; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
        .btn-nhap-imei-chuan:hover { background-color: #a7f3d0; }

        /* POPUP XÁC NHẬN VÀ TOAST */
        .modal-confirm-custom .modal-content { border-radius: 16px; border: none; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2); overflow: hidden; }
        .modal-confirm-custom .info-icon-wrapper { width: 48px; height: 48px; background-color: var(--primary-light); color: var(--primary); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .modal-confirm-custom .modal-footer { background-color: #f8fafc; border-top: 1px solid var(--border-color); padding: 16px 24px; }
        .modal-confirm-custom .btn-save-confirm { background-color: var(--primary); color: #ffffff; border: none; border-radius: 8px; padding: 8px 24px; font-weight: 600; font-size: 14px; transition: all 0.2s; }
        .modal-confirm-custom .btn-save-confirm:hover { background-color: #154cbf; }
        .modal-confirm-custom .btn-cancel { color: var(--text-muted); background: transparent; border: none; font-weight: 500; font-size: 14px; padding: 8px 20px; }

        .toast-container-custom { position: fixed; top: 24px; right: 24px; z-index: 1090; }
        .custom-toast { min-width: 320px; background-color: #ffffff; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); border: 1px solid var(--border-color); padding: 14px 18px; display: flex; align-items: center; gap: 12px; animation: slideInRight 0.3s ease; }
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>
<body>

<!-- SIDEBAR & HEADER (dùng chung) -->
<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="san-pham"/>
    <jsp:param name="activeSub"  value="hien-thi-sp"/>
</jsp:include>

<!-- MAIN WRAPPER -->
<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">

        <!-- TOAST THÔNG BÁO -->
        <div class="toast-container-custom" id="boxDynamicToast"></div>

        <div class="mb-4 d-flex justify-content-between align-items-center">
            <div>
                <h4 class="fw-bold mb-1" style="color: var(--text-main);">Thêm dòng máy & Biến thể</h4>
                <small class="text-muted">Thiết kế chuẩn hóa thuộc tính vật lý và cấu hình thương mại</small>
            </div>
            <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách</a>
        </div>

        <form id="formRealThemSanPham" action="${pageContext.request.contextPath}/san-pham/them" method="POST">

            <div class="form-card">
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <label class="form-label">Tên dòng máy sản phẩm *</label>
                        <input type="text" id="tenSanPhamInput" name="tenSanPham" class="form-control" placeholder="Ví dụ: Dell Vostro 5620..." required oninput="dongBoTenBienThe()">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Danh mục nhóm *</label>
                        <select name="idDanhMuc" class="form-select" required>
                            <c:forEach items="${listDanhMuc}" var="dm"><option value="${dm.id}">${dm.tenDanhMuc}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Thương hiệu sản xuất *</label>
                        <select name="idThuongHieu" class="form-select" required>
                            <c:forEach items="${listThuongHieu}" var="th"><option value="${th.id}">${th.tenThuongHieu}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Nhà cung cấp lô hàng *</label>
                        <select name="idNhaCungCapForm" class="form-select" required>
                            <c:forEach items="${listNhaCungCap}" var="ncc"><option value="${ncc.id}">${ncc.tenNhaCungCap}</option></c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label">Hệ điều hành tích hợp *</label>
                        <select name="heDieuHanh" class="form-select" required>
                            <option value="Windows 11 Home">Windows 11 Home</option>
                            <option value="Windows 11 Pro">Windows 11 Pro</option>
                            <option value="macOS">macOS</option>
                            <option value="FreeDOS">FreeDOS</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Kích thước màn hình *</label>
                        <select name="idManHinh" class="form-select" required>
                            <c:forEach items="${listManHinh}" var="mh"><option value="${mh.id}">${mh.tenManHinh} (${mh.kichThuoc})</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Thông số Pin máy *</label>
                        <select name="idPin" class="form-select" required>
                            <c:forEach items="${listPin}" var="p"><option value="${p.id}">${p.tenPin}</option></c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Bộ vi xử lý (CPU) *</label>
                        <select name="idCpu" class="form-select" required>
                            <c:forEach items="${listCpu}" var="cpu"><option value="${cpu.id}">${cpu.tenCpu}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Card đồ họa (GPU) *</label>
                        <select name="idGpu" class="form-select" required>
                            <c:forEach items="${listGpu}" var="gpu"><option value="${gpu.id}">${gpu.tenGpu}</option></c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-card">
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label">Chọn các Màu sắc *</label>
                        <select id="selectMàu" class="form-select select2-tag-build" multiple="multiple" style="width: 100%">
                            <c:forEach items="${listMauSac}" var="ms"><option value="${ms.id}">${ms.tenMauSac}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Chọn dung lượng RAM *</label>
                        <select id="selectRam" class="form-select select2-tag-build" multiple="multiple" style="width: 100%">
                            <c:forEach items="${listRam}" var="ram"><option value="${ram.id}">${ram.dungLuongRam}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Chọn dung lượng Ổ cứng SSD *</label>
                        <select id="selectOCung" class="form-select select2-tag-build" multiple="multiple" style="width: 100%">
                            <c:forEach items="${listOCung}" var="oc"><option value="${oc.id}">${oc.dungLuongOCung}</option></c:forEach>
                        </select>
                    </div>
                </div>
                <button type="button" class="btn btn-dark-custom w-100" onclick="generateTổHợpBiếnThể()">
                    <i class="fa-solid fa-bolt me-2"></i> Ren Mã Biến Thể
                </button>
            </div>

            <div class="d-none" id="khungChứaBiếnThể">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold text-dark mb-0"><i class="fa-solid fa-layer-group me-1"></i> Danh sách biến thể thương mại cấu hình độc lập</h6>
                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="clearBảng()"><i class="fa-solid fa-trash-can me-1"></i> Xóa bảng</button>
                </div>

                <div id="vùngChứaBảngĐộng"></div>

                <div class="d-flex justify-content-end gap-3 mt-4">
                    <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="btn btn-light border px-4">HỦY BỎ</a>
                    <button type="button" class="btn btn-dark-custom px-5" onclick="xuLySubmitKiemTra()">HOÀN TẤT LƯU TOÀN BỘ SẢN PHẨM</button>
                </div>
            </div>

            <!-- MODAL QUÉT IMEI -->
            <div class="modal fade" id="imeiModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-0 shadow-lg" style="border-radius: 12px;">
                        <div class="modal-header border-0 pt-4 px-4 pb-2">
                            <h5 class="modal-title fw-bold text-dark" id="modalImeiHeaderTitle" style="font-size: 15px;">Nhập số Seri / IMEI vật lý</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body px-4">
                            <input type="hidden" id="currentInputIndexTarget">
                            <label class="form-label text-secondary mb-2">Chỉ nhập số, đúng 15 ký tự. Mỗi IMEI trên một dòng.</label>
                            <textarea id="txtAreaImeiTemp" class="form-control font-monospace" rows="5"
                                      placeholder="Ví dụ: 12345678987654"
                                      style="font-size: 13px;"></textarea>

                            <div id="imeiErrorBox" class="d-none mt-2 p-2 rounded" style="background:#fff1f2; border:1px solid #fca5a5; font-size:12px; color:#dc2626; line-height:1.7;"></div>

                            <div class="mt-3 d-flex justify-content-between align-items-center">
                                <span class="small text-muted fw-semibold">Số lượng máy đếm thực tế:</span>
                                <span id="lblCountImeiModal" class="badge bg-success font-monospace" style="font-size:13px;">0 Máy</span>
                            </div>
                            <div class="p-2 bg-light border rounded mt-2 font-monospace" id="boxImeiListPreview" style="max-height:100px; overflow-y:auto; font-size:11px;">Chưa có mã nào</div>
                        </div>
                        <div class="modal-footer border-0 p-4 pt-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearModalTextArea()">XÓA TRỐNG</button>
                            <button type="button" class="btn btn-sm btn-dark-custom px-4" onclick="xacNhanLuuImeiModal()">XÁC NHẬN LƯU</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<!-- POPUP XÁC NHẬN LƯU -->
<div class="modal fade modal-confirm-custom" id="saveConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 440px;">
        <div class="modal-content">
            <div class="p-4 d-flex align-items-start gap-3">
                <div class="info-icon-wrapper">
                    <i class="fa-solid fa-box-archive"></i>
                </div>
                <div>
                    <h5 class="fw-bold text-dark mb-1" style="font-size: 18px;">Xác nhận thêm sản phẩm</h5>
                    <p class="text-secondary mb-0" style="font-size: 14px;">Bạn có chắc chắn muốn lưu toàn bộ thông tin dòng sản phẩm và ma trận biến thể này vào kho?</p>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-end gap-2">
                <button type="button" class="btn-cancel" data-bs-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn-save-confirm" onclick="dongYSubmitForm()">Xác nhận lưu</button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Context path để dùng cho fetch API
    const contextPath = '${pageContext.request.contextPath}';
    let globalIndex = 0;

    $(document).ready(function() {
        $('.select2-tag-build').select2({
            placeholder: "Bấm chọn thuộc tính...",
            allowClear: true
        });

        $('#txtAreaImeiTemp').on('input', function() {
            const imeiRegex = /^\d{15}$/;
            const txt = $(this).val().trim();
            const lines = txt ? txt.split('\n').map(s => s.trim()).filter(s => s.length > 0) : [];

            // Ẩn error box khi người dùng đang gõ lại
            $('#imeiErrorBox').addClass('d-none').html('');

            $('#lblCountImeiModal').text(lines.length + " Máy mới");

            if (lines.length > 0) {
                let htmlPreview = lines.map((l, index) => {
                    const ok = imeiRegex.test(l);
                    return '<span class="badge me-1 mb-1 d-inline-flex align-items-center ' +
                        (ok ? 'bg-white text-dark border' : 'border border-danger-subtle text-danger') + '" ' +
                        'style="font-size:11px; background-color:' + (ok ? '#ffffff' : '#fff1f2') + ';">' +
                        l + (ok ? '' : ' ⚠️') +
                        '<i class="fa-solid fa-xmark ms-1 text-danger" style="cursor:pointer; font-size:10px;" onclick="xóaNhanhMotMaImei(' + index + ')"></i>' +
                        '</span>';
                }).join('');
                $('#boxImeiListPreview').html(htmlPreview);
            } else {
                $('#boxImeiListPreview').html("Chưa có mã nào");
            }
        });
    });

    function dongBoTenBienThe() {
        const textName = document.getElementById("tenSanPhamInput").value || "Sản phẩm mới";
        document.querySelectorAll(".sync-name-label").forEach(el => el.innerText = textName);
    }

    function moModalImei(index) {
        document.getElementById("currentInputIndexTarget").value = index;
        const targetBtn = document.getElementById("badge-count-" + index);
        if (targetBtn) {
            document.getElementById("modalImeiHeaderTitle").innerText = "Nhập kho: " + targetBtn.getAttribute("data-config") + " - " + targetBtn.getAttribute("data-color");
        }

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
            $('#lblCountImeiModal').text(mangDaLuu.length + " Máy đã lưu");
            $('#boxImeiListPreview').html(
                '<div class="mb-1 fw-semibold text-secondary" style="font-size:11px;">IMEI đã lưu (không thể chỉnh sửa):</div>' +
                mangDaLuu.map(l =>
                    '<span class="badge me-1 mb-1 border border-success-subtle" ' +
                    'style="font-size:11px; background-color:#f0fdf4; color:#16a34a;">' + l.trim() + '</span>'
                ).join('')
            );
        } else {
            $('#lblCountImeiModal').text("0 Máy đã lưu");
            $('#boxImeiListPreview').html("Chưa có mã nào");
        }

        $('#imeiModal').modal('show');
    }

    // 🟢 HÀM ĐỊNH DẠNG TIỀN TỆ TRONG BẢNG: ĐẶT GIÁ TRỊ KHỞI TẠO LÀ 0
    function formatInputTienTe(inputEl, hiddenId) {
        let rawValue = inputEl.value.replace(/[^0-9]/g, '');
        const hiddenEl = document.getElementById(hiddenId);

        if (hiddenEl) {
            hiddenEl.value = rawValue ? rawValue : "0";
        }

        if (rawValue) {
            inputEl.value = Number(rawValue).toLocaleString('vi-VN').replace(/,/g, '.');
        } else {
            inputEl.value = '';
        }
    }

    function generateTổHợpBiếnThể() {
        const mauSel = $('#selectMàu').select2('data');
        const ramSel = $('#selectRam').select2('data');
        const ocSel = $('#selectOCung').select2('data');
        const vungChua = document.getElementById("vùngChứaBảngĐộng");
        const tenSp = document.getElementById("tenSanPhamInput").value || "Sản phẩm mới";

        if (mauSel.length === 0 || ramSel.length === 0 || ocSel.length === 0) {
            hienThongBaoToast("Vui lòng chọn đầy đủ các thông số Màu sắc, RAM và Ổ cứng trước!", "error");
            return;
        }

        let biTrungCount = 0;
        let demBienTheMoiCreated = 0;

        ramSel.forEach(r => {
            ocSel.forEach(oc => {
                let idBox = "box-" + r.id + "-" + oc.id;
                let boxElement = document.getElementById(idBox);

                // 1. NẾU CỤM CẤU HÌNH (RAM + SSD) CHƯA CÓ TRÊN BẢNG -> TẠO KHUNG CỤM MỚI
                if (!boxElement) {
                    let htmlHeader = '' +
                        '<div class="version-box" id="' + idBox + '">' +
                        '   <div class="version-header"><i class="fa-solid fa-gear me-1 text-secondary"></i> CẤU HÌNH MÁY: RAM ' + r.text + ' | SSD Ổ CỨNG ' + oc.text + '</div>' +
                        '   <table class="table align-middle text-center mb-0 table-hover" style="font-size:13px;">' +
                        '       <thead class="table-light text-secondary" style="font-size:11px; font-weight:600; text-transform:uppercase;">' +
                        '           <tr>' +
                        '               <th style="width:60px;">STT</th>' +
                        '               <th>TÊN BIẾN THỂ SẢN PHẨM</th>' +
                        '               <th>MÀU SẮC</th>' +
                        '               <th style="width:180px;">QUÉT SỐ IMEI (SỐ LƯỢNG)</th>' +
                        '               <th style="width:180px;">ĐƠN GIÁ BÁN (VND)</th>' +
                        '               <th style="width:180px;">GIÁ NHẬP KHO (VND)</th>' +
                        '               <th style="width:80px;">HÀNH ĐỘNG</th>' +
                        '           </tr>' +
                        '       </thead>' +
                        '       <tbody></tbody>' +
                        '   </table>' +
                        '</div>';
                    vungChua.insertAdjacentHTML('beforeend', htmlHeader);
                    boxElement = document.getElementById(idBox);
                }

                const tbody = boxElement.querySelector("tbody");

                // 2. DUYỆT TỪNG MÀU SẮC ĐƯỢC CHỌN ĐỂ CHÈN VÀO KHUNG
                mauSel.forEach(function(m) {
                    // Kiểm tra xem dòng trùng khớp 3 thông số (RAM + SSD + MÀU) đã có chưa
                    let rowExist = tbody.querySelector('tr[data-ram="' + r.id + '"][data-ocung="' + oc.id + '"][data-mau="' + m.id + '"]');

                    if (rowExist) {
                        // Nếu đã có rồi -> Bỏ qua và tăng biến đếm trùng
                        biTrungCount++;
                    } else {
                        // Nếu chưa có -> Render thêm dòng biến thể màu đó vào
                        globalIndex++;
                        demBienTheMoiCreated++;
                        let currentStt = tbody.querySelectorAll("tr").length + 1;

                        let htmlRow = '' +
                            '<tr id="tr-row-' + globalIndex + '" data-ram="' + r.id + '" data-ocung="' + oc.id + '" data-mau="' + m.id + '">' +
                            '   <td class="fw-semibold text-secondary text-center stt-index-cell">' + currentStt + '</td>' +
                            '   <td class="sync-name-label fw-bold text-dark text-center">' + tenSp + '</td>' +
                            '   <td class="fw-medium text-dark text-center">' +
                            '       <i class="fa-solid fa-palette me-1 text-muted"></i> ' + m.text +
                            '   </td>' +
                            '   <td class="text-center">' +
                            '       <button type="button" class="btn-nhap-imei-chuan" id="badge-count-' + globalIndex + '" ' +
                            '               data-config="RAM ' + r.text + ' - SSD ' + oc.text + '" data-color="' + m.text + '" ' +
                            '               onclick="moModalImei(' + globalIndex + ')">' +
                            '           <i class="fa-solid fa-barcode"></i> <span class="txt-count-imei-label">0 Máy</span>' +
                            '       </button>' +
                            '       <input type="hidden" name="idRamDong" value="' + r.id + '">' +
                            '       <input type="hidden" name="idOCungDong" value="' + oc.id + '">' +
                            '       <input type="hidden" name="idMauSacDong" value="' + m.id + '">' +
                            '       <textarea name="soSeriDong" id="imei-hidden-' + globalIndex + '" class="d-none"></textarea>' +
                            '   </td>' +
                            '   <td>' +
                            '       <input type="text" class="form-control form-control-sm text-center font-monospace mx-auto" ' +
                            '              value="0" placeholder="0 ₫" style="width:90%; height:36px; background-color:#ffffff;" required ' +
                            '              oninput="formatInputTienTe(this, \'giaBanHidden_' + globalIndex + '\')">' +
                            '       <input type="hidden" name="giaBanDong" id="giaBanHidden_' + globalIndex + '" value="0">' +
                            '   </td>' +
                            '   <td>' +
                            '       <input type="text" class="form-control form-control-sm text-center font-monospace mx-auto" ' +
                            '              value="0" placeholder="0 ₫" style="width:90%; height:36px; background-color:#ffffff;" required ' +
                            '              oninput="formatInputTienTe(this, \'giaNhapHidden_' + globalIndex + '\')">' +
                            '       <input type="hidden" name="giaNhapDong" id="giaNhapHidden_' + globalIndex + '" value="0">' +
                            '   </td>' +
                            '   <td class="text-center">' +
                            '       <button type="button" class="btn btn-sm btn-link text-danger p-0" onclick="gỡDòngDữLiệu(' + globalIndex + ', \'' + idBox + '\')">' +
                            '           <i class="fa-regular fa-trash-can" style="font-size:15px;"></i>' +
                            '       </button>' +
                            '   </td>' +
                            '</tr>';
                        tbody.insertAdjacentHTML('beforeend', htmlRow);
                    }
                });
            });
        });

        if (biTrungCount > 0 && demBienTheMoiCreated === 0) {
            hienThongBaoToast("Tất cả các biến thể vừa chọn đã tồn tại trên bảng!", "error");
        } else if (biTrungCount > 0 && demBienTheMoiCreated > 0) {
            hienThongBaoToast("Đã thêm " + demBienTheMoiCreated + " biến thể mới (Bỏ qua " + biTrungCount + " biến thể đã có sẵn).", "warning");
        } else if (demBienTheMoiCreated > 0) {
            hienThongBaoToast("Đã sinh thành công " + demBienTheMoiCreated + " biến thể mới!", "success");
        }

        document.getElementById("khungChứaBiếnThể").classList.remove("d-none");
        dongBoTenBienThe();
    }

    function gỡDòngDữLiệu(idx, idBox) {
        const rowTarget = document.getElementById("tr-row-" + idx);
        if (rowTarget) {
            const box = document.getElementById(idBox);
            rowTarget.remove();

            if (box) {
                let remainingRows = box.querySelectorAll("tbody tr");
                if (remainingRows.length === 0) {
                    box.remove();
                } else {
                    remainingRows.forEach((tr, index) => {
                        let sttCell = tr.querySelector(".stt-index-cell");
                        if (sttCell) sttCell.innerText = index + 1;
                    });
                }
            }
        }

        const vungChua = document.getElementById("vùngChứaBảngĐộng");
        if (vungChua && vungChua.querySelectorAll(".version-box").length === 0) {
            clearBảng();
        }
    }

    function xacNhanLuuImeiModal() {
        const index = document.getElementById("currentInputIndexTarget").value;
        const rawText = document.getElementById("txtAreaImeiTemp").value.trim();
        const errorBox = document.getElementById("imeiErrorBox");
        const imeiRegex = /^\d{15}$/;

        // Lấy danh sách IMEI mới nhập (bỏ dòng trống)
        const dongMoi = rawText
            ? rawText.split('\n').map(s => s.trim()).filter(s => s.length > 0)
            : [];

        // Không nhập gì thì đóng modal, không thay đổi dữ liệu cũ
        if (dongMoi.length === 0) {
            errorBox.innerHTML = "<strong>⚠️ Vui lòng nhập ít nhất một IMEI.</strong>";
            errorBox.classList.remove("d-none");
            return;
        }

        // ── BƯỚC 1: Validate format — chỉ số, đúng 15 ký tự ──
        const loiList = [];
        dongMoi.forEach(function(imei, i) {
            if (!imeiRegex.test(imei)) {
                loiList.push("Dòng " + (i + 1) + ": <strong>\"" + imei + "\"</strong> — IMEI chỉ gồm chữ số, đúng 15 ký tự.");
            }
        });

        if (loiList.length > 0) {
            errorBox.innerHTML = "⚠️ Có IMEI không hợp lệ:<br>" + loiList.join("<br>");
            errorBox.classList.remove("d-none");
            return; // Dừng hoàn toàn, không gọi API
        }

        // Format hợp lệ — ẩn error box
        errorBox.classList.add("d-none");
        errorBox.innerHTML = "";

        // ── BƯỚC 2: Deduplicate nội bộ ──
        const seenInBox = new Set();
        const trungNoiBo = new Set();
        const mangImeiMoi = [];

        dongMoi.forEach(function(im) {
            if (seenInBox.has(im)) {
                trungNoiBo.add(im);
            } else {
                seenInBox.add(im);
                mangImeiMoi.push(im);
            }
        });

        if (trungNoiBo.size > 0) {
            document.getElementById("txtAreaImeiTemp").value = mangImeiMoi.join("\n");
            $('#txtAreaImeiTemp').trigger('input');
            hienThongBaoToast(
                "Đã xoá " + trungNoiBo.size + " IMEI nhập trùng, chỉ giữ lại 1 bản: <b>" + Array.from(trungNoiBo).join(", ") + "</b>",
                "warning"
            );
        }

        // ── BƯỚC 3: Thu thập IMEI đã điền ở các biến thể KHÁC ──
        const imeiDaDiem = [];
        document.querySelectorAll("textarea[name='soSeriDong']").forEach(function(ta) {
            const taIndex = ta.id.replace("imei-hidden-", "");
            if (taIndex !== String(index) && ta.value.trim()) {
                ta.value.trim().split('\n').forEach(function(s) {
                    const clean = s.trim();
                    if (clean.length > 0) imeiDaDiem.push(clean);
                });
            }
        });

        // ── BƯỚC 3b: Check IMEI mới nhập có trùng IMEI đã lưu của CHÍNH biến thể này không ──
        const hiddenTaHienTai = document.getElementById("imei-hidden-" + index);
        const textDaLuuHienTai = hiddenTaHienTai ? hiddenTaHienTai.value.trim() : "";
        const mangDaLuuHienTai = textDaLuuHienTai
            ? textDaLuuHienTai.split('\n').filter(s => s.trim().length > 0)
            : [];
        const setDaLuuHienTai = new Set(mangDaLuuHienTai);

        const trungVoiDaLuu = mangImeiMoi.filter(im => setDaLuuHienTai.has(im));
        if (trungVoiDaLuu.length > 0) {
            errorBox.innerHTML = "⚠️ Các IMEI sau đã được lưu trước đó cho biến thể này, không thể nhập lại:<br><strong>" + trungVoiDaLuu.join(", ") + "</strong>";
            errorBox.classList.remove("d-none");
            return; // Dừng, không lưu
        }

        // ── BƯỚC 4: Hiển thị trạng thái đang kiểm tra, gọi API check trùng DB ──
        const btnXacNhan = document.querySelector('#imeiModal .btn-dark-custom');
        const originalText = btnXacNhan.innerHTML;
        btnXacNhan.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i> Đang kiểm tra...';
        btnXacNhan.disabled = true;

        const params = new URLSearchParams();
        params.append("imeiList", mangImeiMoi.join(","));
        params.append("imeiDaDiem", imeiDaDiem.join(","));

        fetch(contextPath + "/san-pham/check-imei", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: params.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            btnXacNhan.innerHTML = originalText;
            btnXacNhan.disabled = false;

            const trungDB = data.trungDB || [];
            const trungForm = data.trungForm || [];
            const tatCaTrung = [...new Set([...trungDB, ...trungForm])];

            const imeiHopLe = mangImeiMoi.filter(function(im) {
                return !tatCaTrung.includes(im);
            });

            if (tatCaTrung.length > 0) {
                let thongBaoPhan = [];
                if (trungDB.length > 0) thongBaoPhan.push("Trùng DB: <b>" + trungDB.join(", ") + "</b>");
                if (trungForm.length > 0) thongBaoPhan.push("Trùng form: <b>" + trungForm.join(", ") + "</b>");

                let msg = "Đã xoá " + tatCaTrung.length + " IMEI bị trùng. ";
                msg += imeiHopLe.length > 0 ? "Giữ lại " + imeiHopLe.length + " IMEI hợp lệ." : "Không có IMEI hợp lệ nào.";
                hienThongBaoToast(msg + "<br><small>" + thongBaoPhan.join("<br>") + "</small>", "warning");

                document.getElementById("txtAreaImeiTemp").value = imeiHopLe.join("\n");
                $('#txtAreaImeiTemp').trigger('input');
            }

            // ── BƯỚC 5: Gộp IMEI mới vào IMEI cũ đã lưu (cộng dồn) ──
            _luuImeiVaoDong(index, imeiHopLe);
            $('#imeiModal').modal('hide');
        })
        .catch(function(err) {
            btnXacNhan.innerHTML = originalText;
            btnXacNhan.disabled = false;
            console.error("Lỗi check IMEI:", err);
            hienThongBaoToast("Không thể kết nối kiểm tra IMEI. Vui lòng thử lại!", "error");
        });
    }

    // Hàm nội bộ: gộp IMEI mới vào IMEI cũ và cập nhật badge đếm
    function _luuImeiVaoDong(index, imeiMoi) {
        const hiddenTa = document.getElementById("imei-hidden-" + index);
        const textDaLuu = hiddenTa ? hiddenTa.value.trim() : "";
        const mangDaLuu = textDaLuu ? textDaLuu.split('\n').filter(s => s.trim().length > 0) : [];
        const mangGop = mangDaLuu.concat(imeiMoi);

        hiddenTa.value = mangGop.join("\n");

        const targetBtn = document.getElementById("badge-count-" + index);
        if (targetBtn) {
            targetBtn.querySelector(".txt-count-imei-label").innerText = mangGop.length + " Máy";
            targetBtn.style.backgroundColor = mangGop.length > 0 ? "#d1fae5" : "#ecfdf5";
        }
    }

    function clearModalTextArea() {
        document.getElementById("txtAreaImeiTemp").value = "";
        $('#txtAreaImeiTemp').trigger('input');
    }

    function clearBảng() {
        document.getElementById("vùngChứaBảngĐộng").innerHTML = "";
        document.getElementById("khungChứaBiếnThể").classList.add("d-none");
    }

    function xóaNhanhMotMaImei(viTriXoa) {
        const currentText = document.getElementById("txtAreaImeiTemp").value;
        let lines = currentText.split(/[,\n\r]+/).map(s => s.trim()).filter(s => s.length > 0);

        if (viTriXoa >= 0 && viTriXoa < lines.length) {
            lines.splice(viTriXoa, 1);
        }

        document.getElementById("txtAreaImeiTemp").value = lines.join("\n");
        $('#txtAreaImeiTemp').trigger('input');
    }

    function hienThongBaoToast(message, type) {
        if (!type) type = 'error';
        const isSuccess = (type === 'success');
        const isWarning = (type === 'warning');

        let colorBorder = '#dc2626';
        let iconClass = 'fa-circle-exclamation text-danger';
        let titleText = 'Thông báo lỗi';

        if (isSuccess) {
            colorBorder = '#16a34a';
            iconClass = 'fa-circle-check text-success';
            titleText = 'Thành công';
        } else if (isWarning) {
            colorBorder = '#d97706';
            iconClass = 'fa-triangle-exclamation text-warning';
            titleText = 'Cảnh báo';
        }

        const toastHtml = '' +
            '<div class="custom-toast" style="border-left: 4px solid ' + colorBorder + ';">' +
            '    <i class="fa-solid ' + iconClass + ' fs-4 flex-shrink-0"></i>' +
            '    <div>' +
            '        <h6 class="mb-0 fw-bold text-dark" style="font-size: 14px;">' + titleText + '</h6>' +
            '        <small class="text-muted" style="font-size: 13px;">' + message + '</small>' +
            '    </div>' +
            '</div>';

        const box = document.getElementById("boxDynamicToast");
        box.innerHTML = toastHtml;

        setTimeout(function() {
            const toastEl = box.querySelector('.custom-toast');
            if(toastEl) {
                toastEl.style.transition = "all 0.5s ease";
                toastEl.style.opacity = "0";
                toastEl.style.transform = "translateX(100%)";
                setTimeout(function() { toastEl.remove(); }, 500);
            }
        }, 3500);
    }

    function xuLySubmitKiemTra() {
        const tenInput = document.getElementById("tenSanPhamInput");
        let tenSp = tenInput.value.trim();

        if (!tenSp) {
            hienThongBaoToast("Tên sản phẩm không được để trống!", "error");
            tenInput.focus();
            return;
        }

        tenSp = tenSp.replace(/\s+/g, ' ');
        tenInput.value = tenSp;

        if (tenSp.length < 5 || tenSp.length > 150) {
            hienThongBaoToast("Tên sản phẩm phải từ 5 đến 150 ký tự!", "error");
            tenInput.focus();
            return;
        }

        const regexTen = /^[a-zA-Z0-9 ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰYÝỲỶỸỵỷỹýỳỹ\-_ .()]+$/;
        if (!regexTen.test(tenSp)) {
            hienThongBaoToast("Tên sản phẩm chứa ký tự đặc biệt không hợp lệ!", "error");
            tenInput.focus();
            return;
        }

        const rows = document.querySelectorAll("#vùngChứaBảngĐộng table tbody tr");
        if (rows.length === 0) {
            hienThongBaoToast("Bạn chưa sinh ma trận cấu hình biến thể!", "error");
            return;
        }

        let listTatCaImei = [];
        let trungFormSet = new Set();
        let imeiLoiDinhDang = [];
        let coLoiTrongForm = false;

        const regexImeiHopLe = /^[A-Z0-9\-_]{8,30}$/;

        rows.forEach(function(row) {
            if (coLoiTrongForm) return;

            const txtImei = row.querySelector("textarea[name='soSeriDong']").value.trim();
            const giaBanHidden = row.querySelector("input[name='giaBanDong']");
            const giaNhapHidden = row.querySelector("input[name='giaNhapDong']");
            const tenMau = row.querySelector("td:nth-child(3)").innerText.trim();

            const giaBan = parseFloat(giaBanHidden ? giaBanHidden.value : 0) || 0;
            const giaNhap = parseFloat(giaNhapHidden ? giaNhapHidden.value : 0) || 0;

            if (giaNhap <= 0 || giaBan <= 0) {
                hienThongBaoToast("Biến thể [" + tenMau + "] có đơn giá bán hoặc giá nhập chưa hợp lệ (> 0đ)!", "error");
                coLoiTrongForm = true;
                return;
            }

            if (giaBan < giaNhap) {
                hienThongBaoToast("Biến thể [" + tenMau + "] có giá bán nhỏ hơn giá nhập kho!", "error");
                coLoiTrongForm = true;
                return;
            }

            if (!txtImei) {
                hienThongBaoToast("Biến thể màu [" + tenMau + "] chưa được nhập mã IMEI nào!", "error");
                coLoiTrongForm = true;
                return;
            }

            const mangImeiDong = txtImei.split(/[,\n\r]+/)
                .map(function(s) { return s.trim().replace(/\s+/g, '').toUpperCase(); })
                .filter(function(s) { return s.length > 0; });

            for (let i = 0; i < mangImeiDong.length; i++) {
                let imei = mangImeiDong[i];
                if (!regexImeiHopLe.test(imei)) {
                    imeiLoiDinhDang.push(imei);
                }

                if (listTatCaImei.indexOf(imei) !== -1) {
                    trungFormSet.add(imei);
                }
                listTatCaImei.push(imei);
            }
        });

        if (coLoiTrongForm) return;

        if (imeiLoiDinhDang.length > 0) {
            hienThongBaoToast("Có mã IMEI sai định dạng (phải từ 8-30 ký tự, A-Z, 0-9): " + imeiLoiDinhDang.join(", "), "error");
            return;
        }

        if (trungFormSet.size > 0) {
            hienThongBaoToast("Phát hiện mã IMEI bị trùng lặp ngay trên Form: " + Array.from(trungFormSet).join(", "), "error");
            return;
        }

        const saveModal = new bootstrap.Modal(document.getElementById('saveConfirmModal'));
        saveModal.show();
    }

    function dongYSubmitForm() {
        const btnXacNhan = document.querySelector('#saveConfirmModal .btn-save-confirm');
        const originalText = btnXacNhan.innerHTML;
        btnXacNhan.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i> Đang kiểm tra...';
        btnXacNhan.disabled = true;

        const tenSanPham = document.getElementById("tenSanPhamInput").value.trim().replace(/\s+/g, ' ');

        const params = new URLSearchParams();
        params.append("tenSanPham", tenSanPham);

        fetch(contextPath + "/san-pham/check-ten", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: params.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.trung) {
                // Tên đã tồn tại — đóng modal xác nhận, hiện toast lỗi
                btnXacNhan.innerHTML = originalText;
                btnXacNhan.disabled = false;
                bootstrap.Modal.getInstance(document.getElementById('saveConfirmModal')).hide();
                hienThongBaoToast("Tên sản phẩm <b>\"" + tenSanPham + "\"</b> đã tồn tại trong hệ thống. Vui lòng đổi tên khác!", "error");
            } else {
                // Tên hợp lệ — submit form
                document.getElementById("formRealThemSanPham").submit();
            }
        })
        .catch(function(err) {
            btnXacNhan.innerHTML = originalText;
            btnXacNhan.disabled = false;
            console.error("Lỗi check tên:", err);
            hienThongBaoToast("Không thể kiểm tra tên sản phẩm. Vui lòng thử lại!", "error");
        });
    }
</script>
</body>
</html>