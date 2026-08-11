<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    request.setAttribute("isNhanVien", _isNhanVien);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Biến thể - Skycomputer</title>

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

        /* 🎨 SIDEBAR CHUẨN ĐỒNG BỘ TRẮNG SÁNG */
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

        .content-card { background-color: #ffffff; border-radius: 12px; padding: 24px; border: 1px solid var(--border-color); box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
        .table-custom th { font-size: 12px; text-transform: uppercase; color: var(--text-muted); background-color: #f8fafc; padding: 14px; border-bottom: 1px solid var(--border-color); }
        .table-custom td { padding: 16px 14px; vertical-align: middle; font-size: 14px; border-bottom: 1px solid var(--border-color); }

        .info-tag { display: inline-block; padding: 6px 12px; border-radius: 6px; background-color: #f1f5f9; color: #334155; font-size: 13px; font-weight: 500; margin: 3px 6px 3px 0; }
        .info-tag i { color: var(--text-muted); margin-right: 6px; }

        .badge-active { background-color: var(--success-bg); color: var(--success-text); padding: 5px 10px; border-radius: 6px; font-weight: 500; font-size: 12px; }
        .badge-inactive { background-color: var(--danger-bg); color: var(--danger-text); padding: 5px 10px; border-radius: 6px; font-weight: 500; font-size: 12px; }

        /* 🟢 ICON THAO TÁC THUẦN TÚY (THỦY TINH/TINH TẾ) */
        .action-icon-btn { color: var(--text-muted); cursor: pointer; transition: all 0.2s ease-in-out; }
        .action-icon-btn:hover { color: var(--primary); transform: scale(1.2); }
        .action-icon-btn.text-danger:hover { color: #dc2626 !important; }

        /* POPUP XÁC NHẬN HỦY IMEI */
        .modal-confirm-delete .modal-content { border-radius: 16px; border: none; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2); overflow: hidden; }
        .modal-confirm-delete .warning-icon-wrapper { width: 48px; height: 48px; background-color: #fef2f2; color: #dc2626; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .modal-confirm-delete .modal-footer { background-color: #f8fafc; border-top: 1px solid #f1f5f9; padding: 16px 24px; }
        .modal-confirm-delete .btn-delete-confirm { background-color: #dc2626; color: #ffffff; border: none; border-radius: 8px; padding: 8px 20px; font-weight: 600; font-size: 14px; transition: all 0.2s; }
        .modal-confirm-delete .btn-delete-confirm:hover { background-color: #b91c1c; }
        .modal-confirm-delete .btn-cancel { color: var(--text-muted); background: transparent; border: none; font-weight: 500; font-size: 14px; padding: 8px 20px; }

        /* TOAST THÔNG BÁO GÓC PHẢI */
        .toast-container-custom { position: fixed; top: 24px; right: 24px; z-index: 1090; }
        .custom-toast { min-width: 300px; background-color: #ffffff; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); border: 1px solid var(--border-color); padding: 14px 18px; display: flex; align-items: center; gap: 12px; animation: slideInRight 0.3s ease; }
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

        /* TAB CHI TIẾT BIẾN THỂ */
        #tabChiTietBienThe .nav-link { color: var(--text-muted); background: transparent; font-size: 14px; font-weight: 600; border-radius: 8px 8px 0 0; border: 1px solid var(--border-color); border-bottom: none; }
        #tabChiTietBienThe .nav-link.active { color: var(--primary); background: #fff; border-bottom-color: #fff !important; }
        #tabChiTietBienThe .nav-link:hover:not(.active) { background: #f3f4f6; color: var(--text-main); }
        .tab-pane-card { background: #fff; border: 1px solid var(--border-color); border-top: none; border-radius: 0 12px 12px 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
        .tab-pane-card-full { background: #fff; border: 1px solid var(--border-color); border-top: none; border-radius: 0 0 12px 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
    </style>
</head>
<body>

<!-- SIDEBAR & HEADER (dùng chung) -->
<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="san-pham"/>
    <jsp:param name="activeSub"  value="chi-tiet-sp"/>
</jsp:include>

<!-- MAIN WRAPPER -->
<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">

        <!-- TOAST THÔNG BÁO GÓC PHẢI -->
        <div class="toast-container-custom">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="custom-toast" id="toastAlert" style="border-left: 4px solid #16a34a;">
                    <i class="fa-solid fa-circle-check text-success fs-4"></i>
                    <div>
                        <h6 class="mb-0 fw-bold text-dark" style="font-size: 14px;">Thành công</h6>
                        <small class="text-muted" style="font-size: 13px;">${sessionScope.successMessage}</small>
                    </div>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="custom-toast" id="toastAlert" style="border-left: 4px solid #dc2626;">
                    <i class="fa-solid fa-circle-exclamation text-danger fs-4"></i>
                    <div>
                        <h6 class="mb-0 fw-bold text-dark" style="font-size: 14px;">Thông báo lỗi</h6>
                        <small class="text-muted" style="font-size: 13px;">${sessionScope.errorMessage}</small>
                    </div>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>
        </div>

        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi" class="text-decoration-none text-muted" style="font-size:13px;">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách biến thể
            </a>
        </div>

        <div class="d-flex justify-content-between align-items-start mb-4">
            <div>
                <h4 class="fw-bold mb-1" style="color: var(--text-main);">${chiTiet.sanPham.tenSanPham}</h4>
                <small class="text-muted">Chi tiết cấu hình &amp; danh sách mã IMEI trong kho</small>
            </div>
            <c:if test="${not isNhanVien}">
            <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/sua?id=${chiTiet.id}" class="btn btn-primary px-4 py-2" style="border-radius:8px; font-weight:500; font-size:14px;">
                <i class="fa-solid fa-pen me-2"></i>Sửa biến thể
            </a>
            </c:if>
        </div>

        <!-- TAB NAV -->
        <ul class="nav nav-tabs mb-0" id="tabChiTietBienThe" role="tablist"
            style="border-bottom: 2px solid var(--border-color); gap: 4px;">
            <li class="nav-item" role="presentation">
                <button class="nav-link active px-4 py-2" id="tab-cauhinh-btn"
                        data-bs-toggle="tab" data-bs-target="#tab-cauhinh"
                        type="button" role="tab">
                    <i class="fa-solid fa-microchip me-2"></i>Thông tin cấu hình
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link px-4 py-2" id="tab-imei-btn"
                        data-bs-toggle="tab" data-bs-target="#tab-imei"
                        type="button" role="tab">
                    <i class="fa-solid fa-qrcode me-2"></i>IMEI / Seri
                    <span class="badge rounded-pill ms-1"
                          style="background:#e6efff; color:var(--primary); font-size:11px; font-weight:600;">${listImei.size()}</span>
                </button>
            </li>
        </ul>

        <div class="tab-content">

            <!-- TAB 1: THÔNG TIN CẤU HÌNH & GIÁ -->
            <div class="tab-pane fade show active" id="tab-cauhinh" role="tabpanel">
                <div class="tab-pane-card">
                    <h6 class="fw-bold mb-3" style="color: var(--text-main);">Thông tin cấu hình</h6>
                    <div class="mb-3">
                        <span class="info-tag"><i class="fa-solid fa-microchip"></i>${chiTiet.cauHinhSanPham.cpu.tenCpu}</span>
                        <span class="info-tag"><i class="fa-solid fa-memory"></i>${chiTiet.cauHinhSanPham.ram.dungLuongRam}</span>
                        <span class="info-tag"><i class="fa-solid fa-hard-drive"></i>${chiTiet.cauHinhSanPham.OCung.dungLuongOCung}</span>
                        <span class="info-tag"><i class="fa-solid fa-clone"></i>${chiTiet.cauHinhSanPham.gpu.tenGpu}</span>
                        <span class="info-tag"><i class="fa-solid fa-display"></i>${chiTiet.cauHinhSanPham.manHinh.tenManHinh}</span>
                        <span class="info-tag"><i class="fa-solid fa-palette"></i>${chiTiet.cauHinhSanPham.mauSac.tenMauSac}</span>
                        <span class="info-tag"><i class="fa-solid fa-battery-three-quarters"></i>${chiTiet.cauHinhSanPham.pin.tenPin}</span>
                        <span class="info-tag"><i class="fa-solid fa-window-restore"></i>${chiTiet.cauHinhSanPham.heDieuHanh}</span>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <small class="text-muted d-block">Đơn giá bán</small>
                            <span class="fw-bold text-success fs-6"><fmt:formatNumber value="${chiTiet.donGia}" pattern="#,###"/> đ</span>
                        </div>
                        <div class="col-md-3">
                            <small class="text-muted d-block">Giá nhập</small>
                            <span class="fw-bold fs-6"><fmt:formatNumber value="${chiTiet.giaNhap}" pattern="#,###"/> đ</span>
                        </div>
                        <div class="col-md-3">
                            <small class="text-muted d-block">Tồn kho</small>
                            <span class="badge bg-success px-2 py-1 fs-6">${chiTiet.tonKho}</span>
                        </div>
                        <div class="col-md-3">
                            <small class="text-muted d-block">Trạng thái</small>
                            <c:choose>
                                <c:when test="${chiTiet.trangThai == 1}"><span class="badge-active">Đang kinh doanh</span></c:when>
                                <c:otherwise><span class="badge-inactive">Ngừng kinh doanh</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TAB 2: DANH SÁCH MÃ IMEI / SỐ SERI -->
            <div class="tab-pane fade" id="tab-imei" role="tabpanel">
                <div class="tab-pane-card-full">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0" style="color: var(--text-main);">Danh sách mã IMEI / Số Seri</h6>
                        <small class="text-muted">Tổng: ${listImei.size()} mã</small>
                    </div>
                    <table class="table table-custom align-middle">
                        <thead>
                        <tr>
                            <th style="width: 50px;">STT</th>
                            <th>Số Seri / IMEI</th>
                            <th>Ngày nhập</th>
                            <th>Trạng thái</th>
                            <th class="text-center" style="width: 120px;">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${listImei}" var="imei" varStatus="stt">
                            <tr>
                                <td class="text-muted fw-semibold">${stt.index + 1}</td>
                                <td class="fw-bold text-dark font-monospace">${imei.soSeri}</td>
                                <td>${imei.ngayNhap}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${imei.trangThai == 1}"><span class="badge-active">Còn hàng</span></c:when>
                                        <c:otherwise><span class="badge-inactive">Đã bán</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <!-- Thao tác IMEI -->
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-3">
                                        <c:if test="${not isNhanVien}">
                                        <i class="fa-regular fa-pen-to-square fs-5 action-icon-btn" title="Sửa IMEI"
                                           data-bs-toggle="modal" data-bs-target="#modalSuaImei"
                                           data-id="${imei.id}" data-soseri="${imei.soSeri}">
                                        </i>
                                        <c:if test="${imei.trangThai == 1}">
                                            <i class="fa-regular fa-trash-can fs-5 action-icon-btn text-danger" title="Xóa / Hủy IMEI"
                                               onclick="moModalXoaImei('${imei.id}', '${imei.soSeri}')">
                                            </i>
                                        </c:if>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listImei}">
                            <tr><td colspan="5" class="text-center py-5 text-muted">Chưa có mã IMEI nào cho cấu hình này!</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div><%-- end tab-content --%>
    </div>
</main>

<!-- MODAL SỬA NHANH IMEI -->
<div class="modal fade" id="modalSuaImei" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:12px;">
            <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/imei-sua" method="POST">
                <div class="modal-header border-0 pt-4 px-4 pb-2">
                    <h5 class="modal-title fw-bold text-dark" style="font-size: 16px;">Sửa mã IMEI / Số Seri</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body px-4">
                    <input type="hidden" name="idImei" id="inputIdImei">
                    <input type="hidden" name="idChiTiet" value="${chiTiet.id}">
                    <label class="form-label small fw-medium text-muted">Số Seri / IMEI mới *</label>
                    <input type="text" name="soSeriMoi" id="inputSoSeriMoi" class="form-control font-monospace" style="text-transform: uppercase;" required>
                </div>
                <div class="modal-footer border-0 p-4 pt-2">
                    <button type="button" class="btn btn-sm btn-outline-secondary px-3" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-sm btn-primary px-4" style="background-color: var(--primary);">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 🟢 POPUP XÁC NHẬN XÓA IMEI CHUẨN UI -->
<div class="modal fade modal-confirm-delete" id="deleteImeiConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 440px;">
        <div class="modal-content">
            <div class="p-4 d-flex align-items-start gap-3">
                <div class="warning-icon-wrapper">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div>
                    <h5 class="fw-bold text-dark mb-1" style="font-size: 18px;">Xác nhận hủy IMEI</h5>
                    <p class="text-secondary mb-0" style="font-size: 14px;" id="lblTextXoaImei">Bạn có chắc chắn muốn hủy mã IMEI này?</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/imei-xoa" method="POST" id="formDeleteImeiReal">
                <input type="hidden" name="idImei" id="idImeiTargetDelete">
                <input type="hidden" name="idChiTiet" value="${chiTiet.id}">
                <div class="modal-footer d-flex justify-content-end gap-2">
                    <button type="button" class="btn-cancel" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn-delete-confirm">Xác nhận xóa</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Tự động ẩn Toast
        const toastEl = document.getElementById('toastAlert');
        if (toastEl) {
            setTimeout(function () {
                toastEl.style.transition = "all 0.5s ease";
                toastEl.style.opacity = "0";
                toastEl.style.transform = "translateX(100%)";
                setTimeout(() => toastEl.remove(), 500);
            }, 3500);
        }

        // Lắng nghe sự kiện đổ dữ liệu vào Modal Sửa IMEI
        const modalSuaImei = document.getElementById('modalSuaImei');
        modalSuaImei.addEventListener('show.bs.modal', function (event) {
            const btn = event.relatedTarget;
            document.getElementById('inputIdImei').value = btn.getAttribute('data-id');
            document.getElementById('inputSoSeriMoi').value = btn.getAttribute('data-soseri');
        });
    });

    // Mở Popup xác nhận xóa IMEI
    function moModalXoaImei(idImei, soSeri) {
        document.getElementById("idImeiTargetDelete").value = idImei;
        document.getElementById("lblTextXoaImei").innerText = "Bạn có chắc chắn muốn hủy mã IMEI [" + soSeri + "] ra khỏi kho hàng?";

        const deleteModal = new bootstrap.Modal(document.getElementById('deleteImeiConfirmModal'));
        deleteModal.show();
    }
</script>
</body>
</html>