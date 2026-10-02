<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    request.setAttribute("isNhanVien", _isNhanVien);
%>
<%-- Nhân viên không được vào trang quản lý nhân viên --%>
<c:if test="${isNhanVien}">
    <c:redirect url="${pageContext.request.contextPath}/san-pham/hien-thi"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhân viên - Skycomputer</title>

    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- FontAwesome Icons -->
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

                /* 🎨 --- SIDEBAR --- */
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


        /* --- MAIN CONTENT LAYOUT --- */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .top-header {
            height: 70px;
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 32px;
            border-bottom: 1px solid var(--border-color);
        }

        .header-actions { display: flex; align-items: center; gap: 24px; }
        .notification { position: relative; color: var(--text-muted); cursor: pointer; font-size: 20px; }
        .notification::after { content: ''; position: absolute; top: -2px; right: 0px; width: 8px; height: 8px; background: #ef4444; border-radius: 50%; border: 2px solid #fff; }

        .user-profile { display: flex; align-items: center; gap: 12px; }
        .user-info { text-align: right; }
        .user-name { font-size: 14px; font-weight: 600; color: var(--text-main); }
        .user-role { font-size: 11px; color: var(--text-muted); text-transform: uppercase; }
        .avatar { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; }

        .content-area { flex: 1; padding: 24px 32px; overflow-y: auto; }

        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-title h2 { font-size: 20px; font-weight: 600; margin-bottom: 4px; }
        .page-title p { font-size: 13px; color: var(--text-muted); }

        .btn { padding: 10px 16px; border-radius: 6px; font-size: 13px; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 8px; border: none; transition: 0.2s; }
        .btn-outline { background: #fff; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-outline:hover { background: #f9fafb; }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: #154cbf; }

        .filter-card { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); margin-bottom: 24px; border: 1px solid var(--border-color); }
        .filter-grid { display: grid; grid-template-columns: 1.5fr 1fr 1fr 1fr; gap: 16px; align-items: end; }
        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group label { font-size: 13px; font-weight: 500; color: var(--text-main); }

        .input-wrapper { position: relative; }
        .input-wrapper i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 14px;}

        .form-control { width: 100%; padding: 10px 14px 10px 36px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 13px; color: var(--text-main); outline: none; }
        select.form-control { padding-left: 14px; appearance: none; background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="%236b7280" viewBox="0 0 16 16"><path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/></svg>') no-repeat right 14px center; }
        .btn-filter { background: var(--primary); color: #fff; border: none; padding: 8px 20px; border-radius: 6px; font-size: 13px; font-weight: 500; cursor: pointer; white-space: nowrap; display: inline-flex; align-items: center; gap: 6px; }

        /* --- TABS & ACTIONS TOOLBAR --- */
        .list-actions-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 15px;
        }
        .tabs { display: flex; gap: 32px; }
        .tab-item {
            padding: 12px 0;
            font-size: 14px;
            color: var(--text-muted);
            cursor: pointer;
            font-weight: 500;
            position: relative;
            margin-bottom: -1px;
            white-space: nowrap;
        }
        .tab-item.active { color: var(--primary); font-weight: 600; }
        .tab-item.active::after { content: ''; position: absolute; bottom: 0; left: 0; width: 100%; height: 2px; background: var(--primary); }

        /* --- CUSTOMER DATA TABLE --- */
        .table-container {
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            margin-bottom: 24px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        table { width: 100%; border-collapse: collapse; }

        th {
            background: #f8fafc;
            padding: 16px 20px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-main);
            border-bottom: 1px solid var(--border-color);
        }

        th:first-child, td:first-child { text-align: center; width: 55px; }

        td { padding: 16px 20px; border-bottom: 1px solid var(--border-color); font-size: 13px; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }

        .cust-code { font-family: monospace; font-size: 12.5px; color: var(--text-muted); font-weight: 500; }
        .cust-name { font-weight: 600; color: var(--text-main); }

        .gender-badge { display: inline-flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 500; }
        .gender-male { color: #1d4ed8; }
        .gender-female { color: #db2777; }

        .contact-info { display: flex; align-items: center; gap: 8px; color: var(--text-main); }
        .contact-info i { color: var(--text-muted); font-size: 14px; width: 16px; text-align: center; }

        /* --- UI SWITCH TOGGLE (THAY THẾ BADGE TRẠNG THÁI) --- */
        .switch-wrapper {
            display: inline-flex;
            align-items: center;
        }
        .switch {
            position: relative;
            display: inline-block;
            width: 38px;
            height: 20px;
        }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: #cbd5e1; /* Màu xám khi tắt */
            transition: .3s;
            border-radius: 20px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 14px;
            width: 14px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .3s;
            border-radius: 50%;
            box-shadow: 0 1px 2px rgba(0,0,0,0.2);
        }

        /* Màu xanh lá khi hoạt động */
        input:checked + .slider {
            background-color: #10b981; /* Hoặc #22c55e nếu muốn xanh sáng hơn */
        }
        input:checked + .slider:before { transform: translateX(18px); }

        /*CSS làm tối mờ cả dòng khi tắt công tắc */
        .row-inactive {
            opacity: 0.5;
            background-color: #f1f5f9 !important;
            color: #9ca3af !important;
            transition: all 0.25s ease;
        }
        .row-inactive .cust-name, .row-inactive td { color: #9ca3af !important; }

        /* Actions buttons */
        .table-actions { display: flex; gap: 8px; justify-content: center; align-items: center; }
        .btn-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 6px;
            background: #fff;
            border: 1px solid var(--border-color);
            font-size: 14px;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-icon.btn-edit { color: var(--text-muted); }
        .btn-icon.btn-edit:hover { color: var(--primary); background-color: var(--primary-light); border-color: var(--primary); }
        .btn-icon.btn-delete { color: var(--text-muted); }
        .btn-icon.btn-delete:hover { color: #dc2626; background-color: #fef2f2; border-color: #fca5a5; }
        .text-center { text-align: center; }

        .pagination-area { display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; border-top: 1px solid var(--border-color); background: #fff; }
        .page-info { font-size: 13px; color: var(--text-muted); }
        .pagination { display: flex; gap: 8px; list-style: none; align-items: center; }
        .page-item { width: 28px; height: 28px; display: flex; align-items: center; justify-content: center; border-radius: 4px; font-size: 13px; cursor: pointer; color: var(--text-main); }
        .page-item.active { background: var(--primary); color: #fff; }
        .page-item:not(.active):hover { background: #f3f4f6; }
        .page-item i { font-size: 10px; color: var(--text-muted); }
    </style>
</head>
<body>

<!-- SIDEBAR & HEADER (dùng chung) -->
<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="nhan-vien"/>
</jsp:include>

<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">
        <div class="page-header">
            <div class="page-title">
                <h2>Quản lý nhân viên</h2>
                <p>Xem danh sách hồ sơ, chức vụ, phòng ban và quản lý trạng thái hoạt động của nhân sự toàn hệ thống.</p>
            </div>
            <div class="page-actions">
                <button class="btn btn-outline"><i class="fa-solid fa-download"></i> Xuất file Excel</button>
            </div>
        </div>

        <div class="filter-card">
            <form method="GET" action="${pageContext.request.contextPath}/nhan-vien/hien-thi">
            <div class="filter-grid">
                <div class="form-group">
                    <label>Tìm kiếm</label>
                    <div class="input-wrapper">
                        <i class="fa-regular fa-user"></i>
                        <input type="text" name="tuKhoa" class="form-control"
                               placeholder="Tên nhân viên, SĐT, Mã NV..."
                               value="${filterTuKhoa}">
                    </div>
                </div>

                <div class="form-group">
                    <label>Chức vụ</label>
                    <select name="chucVu" class="form-control" style="padding-left: 14px;">
                        <option value="">Tất cả chức vụ</option>
                        <option value="Quản Lý"  ${filterChucVu == 'Quản Lý'  ? 'selected' : ''}>Quản Lý</option>
                        <option value="Nhân viên" ${filterChucVu == 'Nhân viên' ? 'selected' : ''}>Nhân viên</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Trạng thái nhân sự</label>
                    <select name="trangThai" class="form-control" style="padding-left: 14px;">
                        <option value="">Tất cả trạng thái</option>
                        <option value="1" ${filterTrangThai == '1' ? 'selected' : ''}>Đang làm việc</option>
                        <option value="0" ${filterTrangThai == '0' ? 'selected' : ''}>Đã nghỉ việc</option>
                    </select>
                </div>

                <div style="display:flex; align-items:flex-end; gap:8px;">
                    <button type="submit" class="btn-filter"><i class="fa-solid fa-filter"></i> Lọc</button>
                    <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi"
                       class="btn-filter" style="background:#6b7280; text-decoration:none;">
                        <i class="fa-solid fa-rotate-left"></i> Xóa lọc
                    </a>
                </div>
            </div>
            </form>
        </div>

        <div class="list-actions-toolbar">
            <div class="tabs">
                <div class="tab-item active">Tất cả nhân viên</div>
            </div>

            <button type="button"
                    class="btn btn-primary"
                    style="margin-bottom: 8px;"
                    onclick="location.href='${pageContext.request.contextPath}/nhan-vien/view-add'">
                <i class="fa-solid fa-plus"></i> Thêm nhân viên
            </button>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Mã NV</th>
                    <th>Tên nhân viên</th>
                    <th>Chức vụ</th>
                    <th>Giới tính</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                    <th>Địa chỉ</th>
                    <c:if test="${!isNhanVien}">
                        <th class="text-center" style="width: 110px;">Trạng thái</th>
                        <th class="text-center" style="width: 100px;">Hành động</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>

                <c:forEach items="${listNV}" var="nv" varStatus="status">
                    <!-- [CẬP NHẬT CHỖ NÀY]: Tự động tối dòng từ đầu nếu nhân viên đang ở trạng thái false (nghỉ việc) -->
                    <tr class="${nv.trangThai == 1 ? '' : 'row-inactive'}">
                        <td>${(currentPage - 1) * 10 + status.index + 1}</td>

                        <td><span class="cust-code">${nv.maNhanVien}</span></td>

                        <td><span class="cust-name">${nv.hoTen}</span></td>

                        <td><span class="badge btn-outline" style="font-weight: 500;">${nv.chucVu}</span></td>

                        <td>
                            <c:choose>
                                <c:when test="${nv.gioiTinh}">
                                    <span class="gender-badge gender-male"><i class="fa-solid fa-mars"></i> Nam</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="gender-badge gender-female"><i class="fa-solid fa-venus"></i> Nữ</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <div class="contact-info">
                                <i class="fa-solid fa-phone"></i> ${not empty nv.sdt ? nv.sdt : '---'}
                            </div>
                        </td>

                        <td>${nv.email}</td>

                        <td>${not empty nv.diaChi ? nv.diaChi : '---'}</td>

                        <c:if test="${!isNhanVien}">
                            <td class="text-center">
                                <div class="switch-wrapper">
                                    <label class="switch">
                                        <input type="checkbox"
                                            ${nv.trangThai == 1 ? 'checked' : ''}
                                               onchange="doiTrangThai(${nv.id}, this.checked, this)">
                                        <span class="slider"></span>
                                    </label>
                                </div>
                            </td>

                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/nhan-vien/view-update?id=${nv.id}" 
                                   class="btn-icon btn-edit" 
                                   title="Sửa thông tin">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </a>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>

                <c:if test="${empty listNV}">
                    <tr>
                        <td colspan="${isNhanVien ? '8' : '10'}" class="text-center" style="padding: 40px; color: var(--text-muted)">
                            Không có dữ liệu nhân viên nào tồn tại trên hệ thống.
                        </td>
                    </tr>
                </c:if>

                </tbody>
            </table>

            <div class="pagination-area">
                <div class="page-info">
                    Hiển thị ${(currentPage - 1) * 10 + 1} - ${(currentPage - 1) * 10 + fn:length(listNV)} 
                    trong tổng số ${totalRecords} nhân viên
                </div>
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item" onclick="chuyenTrang(${currentPage - 1})">
                            <i class="fa-solid fa-chevron-left"></i>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}" 
                                onclick="chuyenTrang(${i})">${i}</li>
                        </c:if>
                        <c:if test="${i == currentPage - 3 && currentPage > 4}">
                            <li class="page-item" style="pointer-events: none;">...</li>
                        </c:if>
                        <c:if test="${i == currentPage + 3 && currentPage < totalPages - 3}">
                            <li class="page-item" style="pointer-events: none;">...</li>
                        </c:if>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item" onclick="chuyenTrang(${currentPage + 1})">
                            <i class="fa-solid fa-chevron-right"></i>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>

    </div>
</main>

<!-- [CẬP NHẬT CHỖ NÀY]: Thay đổi logic cập nhật thời gian thực thông minh không cần reload -->
<script>
    function doiTrangThai(id, trangThai, element) {
        // 1. Định vị thẻ dòng <tr> chứa công tắc vừa gạt
        let row = element.closest('tr');

        // 2. Làm tối/sáng dòng đó LẬP TỨC để người dùng thấy trực quan
        if (!trangThai) {
            row.classList.add('row-inactive');
        } else {
            row.classList.remove('row-inactive');
        }

        // 3. Sử dụng Fetch API để gửi ngầm dữ liệu lên Server lưu Database (Không reload trang)
        let url = "${pageContext.request.contextPath}/nhan-vien/doi-trang-thai?id=" + id + "&trangThai=" + trangThai;

        fetch(url, {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        })
            .then(response => {
                if (!response.ok) throw new Error('Cập nhật thất bại');
                return response.json();
            })
            .then(data => {
                if (!data.success) throw new Error('Server báo lỗi');
                console.log("Đã đồng bộ DB thành công cho NV ID: " + id);
            })
            .catch(error => {
                console.error(error);
                alert("Có lỗi xảy ra khi đồng bộ dữ liệu về máy chủ!");
                element.checked = !trangThai;
                row.classList.toggle('row-inactive');
            });
    }

    function chuyenTrang(page) {
        const url = new URL(window.location.href);
        url.searchParams.set('page', page);
        window.location.href = url.toString();
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>