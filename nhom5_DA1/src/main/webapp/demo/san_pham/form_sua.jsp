<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>Sửa sản phẩm - Skycomputer</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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

        /* 🎨 SIDEBAR TRẮNG SÁNG CÂN ĐỐI */
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

        /* --- MAIN WRAPPER --- */
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

        /* Khung Card Form */
        .form-card {
            background-color: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 28px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            margin-bottom: 24px;
        }
        .section-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            margin-bottom: 6px;
            letter-spacing: 0.5px;
        }
        .form-control, .form-select {
            border-color: var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            height: 42px;
            color: var(--text-main);
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-light);
        }

        /* POPUP XÁC NHẬN VÀ TOAST THÔNG BÁO */
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
                <div class="mb-1 small text-muted">
                    <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="text-decoration-none text-muted">Quản lý sản phẩm</a>
                    <i class="fa-solid fa-chevron-right mx-2" style="font-size: 10px;"></i> Sửa sản phẩm
                </div>
                <h4 class="fw-bold mb-0" style="color: var(--text-main);">Sửa thông tin dòng sản phẩm</h4>
            </div>
            <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="btn btn-outline-secondary btn-sm px-3 py-2" style="border-radius: 8px;">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách
            </a>
        </div>

        <!-- FORM CẬP NHẬT SẢN PHẨM -->
        <form id="formRealSuaSanPham" action="${pageContext.request.contextPath}/san-pham/sua" method="POST">
            <input type="hidden" name="id" value="${sanPham.id}">

            <div class="row">
                <div class="col-lg-8">
                    <div class="form-card">
                        <div class="section-title">
                            <i class="fa-solid fa-pen-to-square text-primary"></i> Thông tin cơ bản dòng sản phẩm
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Tên dòng máy sản phẩm *</label>
                            <input type="text" id="tenSanPhamInput" name="tenSanPham" class="form-control" value="${sanPham.tenSanPham}" required placeholder="Ví dụ: Dell Vostro 5620...">
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label">Thương hiệu sản xuất *</label>
                                <select name="idThuongHieu" class="form-select" required>
                                    <option value="">-- Chọn thương hiệu --</option>
                                    <c:forEach items="${listThuongHieu}" var="th">
                                        <option value="${th.id}" ${sanPham.thuongHieu.id == th.id ? 'selected' : ''}>${th.tenThuongHieu}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Danh mục sản phẩm *</label>
                                <select name="idDanhMuc" class="form-select" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach items="${listDanhMuc}" var="dm">
                                        <option value="${dm.id}" ${sanPham.danhMuc.id == dm.id ? 'selected' : ''}>${dm.tenDanhMuc}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">Trạng thái kinh doanh *</label>
                            <select name="trangThai" class="form-select">
                                <option value="1" ${sanPham.trangThai == 1 ? 'selected' : ''}>Đang kinh doanh</option>
                                <option value="0" ${sanPham.trangThai != 1 ? 'selected' : ''}>Ngừng kinh doanh</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <!-- NÚT THAO TÁC SUBMIT -->
            <div class="d-flex justify-content-start gap-3 mt-2">
                <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="btn btn-light border px-4 py-2" style="border-radius: 8px;">Hủy bỏ</a>
                <button type="button" class="btn btn-primary px-5 py-2" style="border-radius: 8px; background-color: var(--primary); font-weight: 600;" onclick="xuLySubmitKiemTraSua()">
                    <i class="fa-solid fa-check me-2"></i>Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</main>

<!-- POPUP XÁC NHẬN SỬA SẢN PHẨM -->
<div class="modal fade modal-confirm-custom" id="saveConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 440px;">
        <div class="modal-content">
            <div class="p-4 d-flex align-items-start gap-3">
                <div class="info-icon-wrapper">
                    <i class="fa-solid fa-pen-to-square"></i>
                </div>
                <div>
                    <h5 class="fw-bold text-dark mb-1" style="font-size: 18px;">Xác nhận cập nhật</h5>
                    <p class="text-secondary mb-0" style="font-size: 14px;">Bạn có chắc chắn muốn lưu thông tin cập nhật cho dòng sản phẩm này?</p>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-end gap-2">
                <button type="button" class="btn-cancel" data-bs-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn-save-confirm" onclick="dongYSubmitFormSua()">Xác nhận lưu</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function hienThongBaoToast(message, type = 'error') {
        const isSuccess = type === 'success';
        const colorBorder = isSuccess ? '#16a34a' : '#dc2626';
        const iconClass = isSuccess ? 'fa-circle-check text-success' : 'fa-circle-exclamation text-danger';
        const titleText = isSuccess ? 'Thành công' : 'Thông báo lỗi';

        const toastHtml = `
            <div class="custom-toast" style="border-left: 4px solid ${colorBorder};">
                <i class="fa-solid ${iconClass} fs-4"></i>
                <div>
                    <h6 class="mb-0 fw-bold text-dark" style="font-size: 14px;">${titleText}</h6>
                    <small class="text-muted" style="font-size: 13px;">${message}</small>
                </div>
            </div>
        `;

        const box = document.getElementById("boxDynamicToast");
        box.innerHTML = toastHtml;

        setTimeout(function() {
            const toastEl = box.querySelector('.custom-toast');
            if(toastEl) {
                toastEl.style.transition = "all 0.5s ease";
                toastEl.style.opacity = "0";
                toastEl.style.transform = "translateX(100%)";
                setTimeout(() => toastEl.remove(), 500);
            }
        }, 3500);
    }

    function xuLySubmitKiemTraSua() {
        const tenSp = document.getElementById("tenSanPhamInput").value.trim();
        const regexTen = /^[a-zA-Z0-9 ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰYÝỲỶỸỵỷỹýỳỹ\-_.]+$/;

        if (!tenSp) {
            hienThongBaoToast("Tên sản phẩm không được để trống!", "error");
            document.getElementById("tenSanPhamInput").focus();
            return;
        }

        if (!regexTen.test(tenSp)) {
            hienThongBaoToast("Tên sản phẩm chứa ký tự đặc biệt không hợp lệ!", "error");
            document.getElementById("tenSanPhamInput").focus();
            return;
        }

        const saveModal = new bootstrap.Modal(document.getElementById('saveConfirmModal'));
        saveModal.show();
    }

    function dongYSubmitFormSua() {
        document.getElementById("formRealSuaSanPham").submit();
    }
</script>
</body>
</html>