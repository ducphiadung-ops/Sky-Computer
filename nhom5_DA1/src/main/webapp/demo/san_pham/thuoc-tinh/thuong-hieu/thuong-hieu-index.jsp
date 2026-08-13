<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    request.setAttribute("isNhanVien", _isNhanVien);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Thương hiệu - Skycomputer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--primary:#1a56db;--sidebar-active:#eef2ff;--text-main:#1f2937;--text-muted:#6b7280;--bg-body:#f8f9fa;--border-color:#e5e7eb;--success-text:#047857;--success-bg:#d1fae5;--danger-text:#be123c;--danger-bg:#ffe4e6;}
        *{margin:0;padding:0;box-sizing:border-box;font-family:'Inter',sans-serif;}
        body{display:flex;height:100vh;background-color:var(--bg-body);color:var(--text-main);overflow:hidden;}
        .sidebar{width:260px;background-color:#fff;border-right:1px solid var(--border-color);display:flex;flex-direction:column;height:100vh;padding-bottom:16px;z-index:10;}
        .brand{display:flex;align-items:center;padding:20px;gap:12px;border-bottom:1px solid var(--border-color);margin-bottom:12px;}
        .brand-logo{width:40px;height:40px;border-radius:8px;overflow:hidden;display:flex;align-items:center;justify-content:center;background:#fff;}
        .brand-logo img{width:100%;height:100%;object-fit:contain;}
        .brand-text h1{font-size:16px;font-weight:700;color:#1e3a8a;margin-bottom:0;}
        .brand-text p{font-size:11px;color:var(--text-muted);margin-bottom:0;}
        .nav-menu{list-style:none;padding:0 12px;flex:1;overflow-y:auto;}
        .nav-item{margin-bottom:4px;}
        .nav-link-custom{display:flex;align-items:center;padding:11px 16px;color:var(--text-muted);text-decoration:none;border-radius:8px;font-size:14px;font-weight:500;transition:all 0.2s;gap:12px;}
        .nav-link-custom i{font-size:16px;width:20px;text-align:center;}
        .nav-link-custom:hover{background-color:#f3f4f6;color:var(--text-main);}
        .nav-link-custom.active{background-color:var(--sidebar-active);color:var(--primary);font-weight:600;}
        .sub-menu{list-style:none;padding-left:0;margin-top:4px;display:flex;flex-direction:column;gap:2px;}
        .sub-menu .nav-link-custom{padding:9px 16px 9px 44px !important;font-size:13px;}
        .sub-menu .nav-link-custom.active-sub{background-color:var(--sidebar-active);color:var(--primary);font-weight:600;}
        .logout-item{margin-top:auto;padding:0 12px;}
        .nav-link-custom.logout-link{color:#dc2626;border-top:1px solid var(--border-color);border-radius:0;padding-top:16px;}
        .nav-link-custom.logout-link:hover{background-color:var(--danger-bg);color:var(--danger-text);border-radius:8px;}
        .main-wrapper{flex:1;display:flex;flex-direction:column;overflow:hidden;}
        .top-header{height:65px;background-color:#fff;display:flex;align-items:center;padding:0 32px;border-bottom:1px solid var(--border-color);}
        .header-actions{display:flex;align-items:center;gap:24px;margin-left:auto;}
        .user-profile{display:flex;align-items:center;gap:12px;}
        .user-info{text-align:right;}
        .user-name{font-size:13px;font-weight:600;color:var(--text-main);}
        .user-role{font-size:10px;color:var(--text-muted);text-transform:uppercase;}
        .avatar{width:34px;height:34px;border-radius:50%;object-fit:cover;}
        .content-area{flex:1;padding:24px 32px;overflow-y:auto;}
        .card-custom{background-color:#fff;border:1px solid var(--border-color);border-radius:12px;box-shadow:0 1px 3px rgba(0,0,0,.02);}
        .table-custom th{background-color:#f8fafc;color:var(--text-muted);font-weight:600;font-size:12px;text-transform:uppercase;padding:14px 16px;}
        .table-custom td{padding:16px;vertical-align:middle;font-size:13px;border-bottom:1px solid var(--border-color);}
        .badge-active{background-color:var(--success-bg);color:var(--success-text);padding:5px 12px;border-radius:6px;font-weight:500;white-space:nowrap;display:inline-block;}
        .badge-inactive{background-color:var(--danger-bg);color:var(--danger-text);padding:5px 12px;border-radius:6px;font-weight:500;white-space:nowrap;display:inline-block;}
        .form-label{font-size:12px;font-weight:600;color:#475569;text-transform:uppercase;}
        .filter-bar{background:#fff;border:1px solid var(--border-color);border-radius:12px;padding:16px 20px;margin-bottom:20px;display:flex;align-items:flex-end;gap:12px;flex-wrap:wrap;}
        .filter-bar .fb-group{display:flex;flex-direction:column;gap:4px;flex:1;min-width:160px;}
        .filter-bar .fb-label{font-size:11px;font-weight:600;color:#475569;text-transform:uppercase;}
        .filter-bar .form-control{font-size:13px;padding:7px 12px;border-radius:8px;border:1px solid var(--border-color);}
        .btn-filter-apply{background:var(--primary);color:#fff;border:none;padding:8px 18px;border-radius:8px;font-size:13px;font-weight:500;cursor:pointer;white-space:nowrap;display:inline-flex;align-items:center;gap:6px;}
        .btn-filter-apply:hover{background:#1648c0;}
        .btn-filter-reset{background:#f3f4f6;color:var(--text-muted);border:1px solid var(--border-color);padding:8px 14px;border-radius:8px;font-size:13px;font-weight:500;cursor:pointer;white-space:nowrap;text-decoration:none;display:inline-flex;align-items:center;gap:6px;}
        .btn-filter-reset:hover{background:#e5e7eb;color:var(--text-main);}
    </style>
</head>
<body>

<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="thuoc-tinh"/>
    <jsp:param name="activeSub"  value="thuong-hieu"/>
</jsp:include>

<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">

        <c:if test="${not empty sessionScope.successMessage}">
            <input type="hidden" id="toastMsg" data-type="success" value="<c:out value='${sessionScope.successMessage}'/>">
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <input type="hidden" id="toastMsg" data-type="error" value="<c:out value='${sessionScope.errorMessage}'/>">
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        <div class="mb-4">
            <h4 class="fw-bold mb-1">Quản lý thuộc tính Thương hiệu</h4>
            <p class="text-muted mb-0">Quản lý danh sách các hãng sản xuất laptop trong hệ thống.</p>
        </div>
        <div class="row g-4">
            <c:if test="${not isNhanVien}">
            <div class="col-md-4">
                <div class="card card-custom p-4">
                    <h6 class="fw-bold mb-3 text-uppercase" style="font-size:13px;color:#475569;"><i class="fa-solid fa-plus me-2"></i>Thêm Thương hiệu mới</h6>
                    <form id="formThemThuocTinh" action="${pageContext.request.contextPath}/thuoc-tinh/thuong-hieu/them" method="POST">
                        <div class="mb-3">
                            <label class="form-label">Tên thương hiệu <span class="text-danger">*</span></label>
                            <input type="text" name="tenThuongHieu" class="form-control py-2" placeholder="Ví dụ: Dell, HP, Lenovo" required>
                        </div>
                        <button type="button" class="btn btn-primary w-100 py-2 fw-medium" style="border-radius:8px;" onclick="moModalXacNhanThem('Thương hiệu')"><i class="fa-solid fa-save me-2"></i>Lưu thuộc tính</button>
                    </form>
                </div>
            </div>
            </c:if>
            <div class="${isNhanVien ? 'col-md-12' : 'col-md-8'}">
                <div class="card card-custom p-4">
                    <h6 class="fw-bold text-uppercase mb-3" style="font-size:13px;color:#475569;"><i class="fa-solid fa-list me-2"></i>Danh sách thương hiệu</h6>
                    <form class="filter-bar" method="GET" action="${pageContext.request.contextPath}/thuoc-tinh/thuong-hieu/hien-thi">
                        <div class="fb-group">
                            <span class="fb-label">Tên thương hiệu</span>
                            <input type="text" name="tuKhoa" class="form-control" placeholder="Tìm theo tên hãng..." value="${filterTuKhoa}">
                        </div>
                        <div class="fb-group" style="max-width:180px;">
                            <span class="fb-label">Trạng thái</span>
                            <select name="trangThai" class="form-control">
                                <option value="">Tất cả</option>
                                <option value="1" ${filterTrangThai == '1' ? 'selected' : ''}>Hoạt động</option>
                                <option value="0" ${filterTrangThai == '0' ? 'selected' : ''}>Ngừng hoạt động</option>
                            </select>
                        </div>
                        <button type="submit" class="btn-filter-apply"><i class="fa-solid fa-filter"></i> Lọc</button>
                        <a href="${pageContext.request.contextPath}/thuoc-tinh/thuong-hieu/hien-thi" class="btn-filter-reset"><i class="fa-solid fa-rotate-left"></i> Xóa</a>
                    </form>
                    <div class="table-responsive">
                        <table class="table table-custom table-hover align-middle text-center mb-0">
                            <thead><tr>
                                <th style="width:60px;">STT</th>
                                <th class="text-start">Tên thương hiệu</th>
                                <th>Trạng thái</th>
                                <c:if test="${not isNhanVien}"><th style="width:120px;">Thao tác</th></c:if>
                            </tr></thead>
                            <tbody>
                            <c:forEach items="${listThuongHieu}" var="th" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td class="text-start fw-semibold text-dark">${th.tenThuongHieu}</td>
                                    <td><c:choose><c:when test="${th.trangThai == 1}"><span class="badge-active">Hoạt động</span></c:when><c:otherwise><span class="badge-inactive">Ngừng hoạt động</span></c:otherwise></c:choose></td>
                                    <c:if test="${not isNhanVien}">
                                    <td>
                                        <div class="d-flex justify-content-center gap-2">
                                            <button type="button" class="btn btn-sm btn-outline-secondary" style="border-radius:6px;"
                                                onclick="moModalSua(${th.id}, '${fn:escapeXml(th.tenThuongHieu)}')">
                                                <i class="fa-regular fa-pen-to-square"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/thuoc-tinh/thuong-hieu/xoa?id=${th.id}" class="btn btn-sm btn-outline-danger" style="border-radius:6px;" onclick="return confirm('Ngừng kích hoạt Thương hiệu này?');"><i class="fa-regular fa-trash-can"></i></a>
                                        </div>
                                    </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listThuongHieu}"><tr><td colspan="4" class="text-center py-5 text-muted">Chưa có dữ liệu Thương hiệu nào!</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Modal Sửa Thương hiệu -->
<div class="modal fade" id="modalSuaThuongHieu" tabindex="-1" aria-labelledby="modalSuaThuongHieuLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:12px;border:1px solid var(--border-color);">
            <div class="modal-header" style="border-bottom:1px solid var(--border-color);">
                <h5 class="modal-title fw-bold" id="modalSuaThuongHieuLabel"><i class="fa-regular fa-pen-to-square me-2 text-primary"></i>Đổi tên Thương hiệu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <form action="${pageContext.request.contextPath}/thuoc-tinh/thuong-hieu/sua" method="POST">
                <div class="modal-body p-4">
                    <input type="hidden" name="id" id="suaThId">
                    <div class="mb-3">
                        <label class="form-label">Tên thương hiệu <span class="text-danger">*</span></label>
                        <input type="text" name="tenThuongHieu" id="suaThTen" class="form-control py-2" required>
                    </div>
                </div>
                <div class="modal-footer" style="border-top:1px solid var(--border-color);">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary px-4"><i class="fa-solid fa-save me-2"></i>Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function moModalSua(id, ten) {
    document.getElementById('suaThId').value = id;
    document.getElementById('suaThTen').value = ten;
    new bootstrap.Modal(document.getElementById('modalSuaThuongHieu')).show();
}
(function() {
    const el = document.getElementById('toastMsg');
    if (!el) return;
    const type = el.dataset.type, msg = el.value, isSuccess = type === 'success';
    const toast = document.createElement('div');
    toast.style.cssText = 'position:fixed;top:20px;right:20px;z-index:9999;min-width:280px;max-width:380px;padding:14px 18px;border-radius:10px;box-shadow:0 4px 16px rgba(0,0,0,.15);display:flex;align-items:center;gap:10px;font-family:Inter,sans-serif;font-size:14px;font-weight:500;transition:opacity .4s;opacity:1;' + (isSuccess ? 'background:#d1fae5;color:#047857;border:1px solid #6ee7b7;' : 'background:#ffe4e6;color:#be123c;border:1px solid #fca5a5;');
    toast.innerHTML = '<i class="fa-solid ' + (isSuccess ? 'fa-circle-check' : 'fa-circle-xmark') + '" style="font-size:16px;flex-shrink:0;"></i><span>' + msg + '</span>';
    document.body.appendChild(toast);
    setTimeout(() => { toast.style.opacity = '0'; setTimeout(() => toast.remove(), 400); }, 3000);
})();
</script>

<!-- ===== MODAL XÁC NHẬN THÊM THUỘC TÍNH ===== -->
<div class="modal fade" id="modalXacNhanThemThuocTinh" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;overflow:hidden;">
            <div class="p-4 d-flex align-items-start gap-3">
                <div style="width:44px;height:44px;background:#eff6ff;border-radius:10px;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                    <i class="fa-solid fa-circle-question" style="font-size:20px;color:#1a56db;"></i>
                </div>
                <div>
                    <h5 class="fw-bold mb-1" style="font-size:16px;color:#1f2937;">Xác nhận lưu thuộc tính</h5>
                    <p id="txtXacNhanThem" class="text-secondary mb-0" style="font-size:13px;line-height:1.6;">Bạn có chắc chắn muốn thêm thuộc tính này vào hệ thống không?</p>
                </div>
            </div>
            <div class="d-flex justify-content-end gap-2 px-4 pb-4">
                <button type="button" class="btn btn-outline-secondary fw-semibold px-4"
                        style="font-size:13px;border-radius:8px;" data-bs-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-primary fw-semibold px-4"
                        style="font-size:13px;border-radius:8px;"
                        onclick="xacNhanThucSuThem()">
                    <i class="fa-solid fa-check me-1"></i>Xác nhận lưu
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function moModalXacNhanThem(tenLoai) {
    var form = document.getElementById('formThemThuocTinh');
    if (form && !form.checkValidity()) { form.reportValidity(); return; }
    document.getElementById('txtXacNhanThem').textContent =
        'Bạn có chắc chắn muốn thêm ' + tenLoai + ' mới này vào hệ thống không?';
    new bootstrap.Modal(document.getElementById('modalXacNhanThemThuocTinh')).show();
}
function xacNhanThucSuThem() {
    bootstrap.Modal.getInstance(document.getElementById('modalXacNhanThemThuocTinh')).hide();
    document.getElementById('formThemThuocTinh').submit();
}
</script>
</body>
</html>
