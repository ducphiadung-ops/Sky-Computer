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
    <title>Danh sách sản phẩm - Skycomputer</title>

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

        /* --- MAIN CONTENT --- */
        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }

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

        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .page-title h2 { font-size: 20px; font-weight: 600; margin-bottom: 4px; }
        .page-title p { font-size: 13px; color: var(--text-muted); margin-bottom: 0; }

        .filter-card { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); margin-bottom: 20px; border: 1px solid var(--border-color); }
        .search-input-wrapper { position: relative; }
        .search-input-wrapper i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 14px; }
        .search-input-wrapper input { padding-left: 36px; }

        .table-container { background: #fff; border: 1px solid var(--border-color); border-radius: 12px; margin-bottom: 24px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8fafc; padding: 14px 20px; text-align: left; font-size: 12px; font-weight: 600; color: var(--text-muted); border-bottom: 1px solid var(--border-color); text-transform: uppercase; }
        td { padding: 14px 20px; border-bottom: 1px solid var(--border-color); font-size: 13px; vertical-align: middle; }

        .badge-active { background-color: var(--success-bg); color: var(--success-text); padding: 5px 12px; border-radius: 20px; font-weight: 500; font-size: 12px; display: inline-block; }
        .badge-inactive { background-color: var(--danger-bg); color: var(--danger-text); padding: 5px 12px; border-radius: 20px; font-weight: 500; font-size: 12px; display: inline-block; }

        .action-icon-btn { color: var(--text-muted); cursor: pointer; transition: all 0.2s ease-in-out; }
        .action-icon-btn:hover { color: var(--primary); transform: scale(1.2); }

        /* POPUP CONFIRM XÓA */
        .modal-confirm-delete .modal-content { border-radius: 16px; border: none; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2); overflow: hidden; }
        .modal-confirm-delete .warning-icon-wrapper { width: 48px; height: 48px; background-color: #fef2f2; color: #dc2626; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .modal-confirm-delete .modal-footer { background-color: #f8fafc; border-top: 1px solid #f1f5f9; padding: 16px 24px; }
        .modal-confirm-delete .btn-delete-confirm { background-color: #dc2626; color: #ffffff; border: none; border-radius: 8px; padding: 8px 20px; font-weight: 600; font-size: 14px; transition: all 0.2s; }
        .modal-confirm-delete .btn-delete-confirm:hover { background-color: #b91c1c; }
        .modal-confirm-delete .btn-cancel { color: #475569; background: transparent; border: none; font-weight: 500; font-size: 14px; padding: 8px 20px; }

        /* TOAST THÔNG BÁO */
        .toast-container-custom { position: fixed; top: 24px; right: 24px; z-index: 1090; }
        .custom-toast { min-width: 300px; background-color: #ffffff; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; padding: 14px 18px; display: flex; align-items: center; gap: 12px; animation: slideInRight 0.3s ease; }
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

        /* PRICE RANGE SLIDER */
        .price-range-wrapper { padding: 4px 2px 0; }
        .price-range-label { display: flex; justify-content: space-between; font-size: 12px; color: var(--text-muted); margin-bottom: 6px; }
        .price-range-label span { font-weight: 600; color: var(--primary); }
        .range-slider-container { position: relative; height: 6px; background: #e2e8f0; border-radius: 4px; margin: 0 2px; }
        .range-slider-fill { position: absolute; height: 100%; background: var(--primary); border-radius: 4px; pointer-events: none; }
        input[type="range"].price-slider {
            -webkit-appearance: none; appearance: none;
            position: absolute; width: 100%; height: 6px;
            background: transparent; pointer-events: none; margin: 0;
        }
        input[type="range"].price-slider::-webkit-slider-thumb {
            -webkit-appearance: none; appearance: none;
            width: 18px; height: 18px; border-radius: 50%;
            background: var(--primary); border: 2px solid #fff;
            box-shadow: 0 1px 4px rgba(26,86,219,.4);
            cursor: pointer; pointer-events: all;
        }
        input[type="range"].price-slider::-moz-range-thumb {
            width: 18px; height: 18px; border-radius: 50%;
            background: var(--primary); border: 2px solid #fff;
            box-shadow: 0 1px 4px rgba(26,86,219,.4);
            cursor: pointer; pointer-events: all; border: 2px solid #fff;
        }
    </style>
</head>
<body>

<!-- SIDEBAR & HEADER (dùng chung) -->
<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="san-pham"/>
    <jsp:param name="activeSub"  value="hien-thi-sp"/>
</jsp:include>

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

        <div class="page-header">
            <div class="page-title">
                <h2>Quản lý sản phẩm</h2>
                <p>Quản lý danh mục và tồn kho các sản phẩm laptop.</p>
            </div>
        </div>

        <!-- BỘ LỌC TÌM KIẾM -->
        <form action="${pageContext.request.contextPath}/san-pham/hien-thi" method="GET" class="filter-card" id="formLocSanPham">
            <input type="hidden" name="page" value="1">
            <div class="row g-3">

                <!-- Tìm theo tên hoặc mã sản phẩm -->
                <div class="col-md-4">
                    <label class="form-label small fw-medium text-muted mb-1">Tìm kiếm sản phẩm</label>
                    <div class="search-input-wrapper">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" name="keyword" class="form-control form-control-sm py-2"
                               placeholder="Tìm theo tên hoặc mã sản phẩm..." value="${oldKeyword}">
                    </div>
                </div>

                <!-- Hãng sản xuất -->
                <div class="col-md-3">
                    <label class="form-label small fw-medium text-muted mb-1">Hãng sản xuất</label>
                    <select name="idThuongHieu" class="form-select form-select-sm py-2">
                        <option value="">Tất cả hãng</option>
                        <c:forEach items="${listThuongHieu}" var="th">
                            <option value="${th.id}" ${oldThuongHieu == th.id ? 'selected' : ''}>${th.tenThuongHieu}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Trạng thái -->
                <div class="col-md-2">
                    <label class="form-label small fw-medium text-muted mb-1">Trạng thái</label>
                    <select name="trangThai" class="form-select form-select-sm py-2">
                        <option value="">Tất cả trạng thái</option>
                        <option value="1" ${oldTrangThai == '1' ? 'selected' : ''}>Hoạt động</option>
                        <option value="0" ${oldTrangThai == '0' ? 'selected' : ''}>Không hoạt động</option>
                    </select>
                </div>

                <!-- Nút lọc -->
                <div class="col-md-2 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-primary btn-sm px-4 py-2">
                        <i class="fa-solid fa-filter me-1"></i>Lọc
                    </button>
                    <a href="${pageContext.request.contextPath}/san-pham/hien-thi"
                       class="btn btn-outline-secondary btn-sm py-2" title="Xoá bộ lọc">
                        <i class="fa-solid fa-rotate-left"></i>
                    </a>
                </div>

                <!-- Thanh kéo lọc khoảng giá -->
                <div class="col-12">
                    <label class="form-label small fw-medium text-muted mb-1">
                        Khoảng giá bán &nbsp;(từ <strong>0 đ</strong> đến <span id="lblGiaMaxSP" class="text-primary fw-bold"></span>)
                    </label>
                    <div class="price-range-wrapper">
                        <div class="range-slider-container">
                            <div class="range-slider-fill" id="sliderFillSP"></div>
                            <input type="range" class="price-slider" id="sliderMaxSP" name="giaMax"
                                   min="${priceAbsMin}" max="${priceAbsMax}"
                                   value="${oldGiaMax}" step="100000">
                        </div>
                        <div class="price-range-label mt-2">
                            <span>0 ₫</span>
                            <span id="lblRightSP"></span>
                        </div>
                    </div>
                    <input type="hidden" name="giaMin" value="0">
                </div>

            </div>
        </form>

        <!-- NÚT THÊM MỚI: chỉ admin mới thấy -->
        <c:if test="${not isNhanVien}">
        <div class="d-flex justify-content-end mb-3">
            <a href="${pageContext.request.contextPath}/san-pham/giao-dien-them" class="btn btn-primary px-4 py-2" style="border-radius: 8px; font-weight: 500; font-size: 14px;">
                <i class="fa-solid fa-plus me-2"></i>Thêm sản phẩm mới
            </a>
        </div>
        </c:if>

        <!-- BẢNG HỂN THỊ DỮ LIỆU CHÍNH -->
        <div class="table-container">
            <table style="width: 100%; table-layout: fixed;">
                <thead>
                <tr>
                    <th class="text-center" style="width: 5%;">STT</th>
                    <th style="width: 14%;">Mã sản phẩm</th>
                    <th style="width: 24%;">Tên sản phẩm</th>
                    <th style="width: 15%;">Danh mục</th>
                    <th class="text-end" style="width: 14%;">Khoảng giá</th>
                    <th class="text-center" style="width: 8%;">Số lượng</th>
                    <th class="text-center" style="width: 12%;">Trạng thái</th>
                    <th class="text-center" style="width: 11%;">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${listSanPham}" var="sp" varStatus="stt">
                    <tr>
                        <td class="text-center text-muted fw-semibold">${offset + stt.index + 1}</td>

                        <td>
                            <span class="badge bg-light text-dark border px-2 py-1 fw-medium">#${sp.maSanPham}</span>
                        </td>

                        <!-- Dùng text-truncate để nếu tên quá dài sẽ hiển thị dấu ... tránh làm vỡ dòng -->
                        <td class="fw-semibold text-dark text-truncate" title="${sp.tenSanPham}">
                                ${sp.tenSanPham}
                        </td>

                        <td class="text-truncate" title="${sp.danhMuc.tenDanhMuc}">
                                ${sp.danhMuc.tenDanhMuc}
                        </td>

                        <!-- Khoảng giá từ biến thể: min - max, hoặc 1 mức nếu min = max -->
                        <td class="text-end fw-semibold" style="color: var(--text-main);">
                            <c:choose>
                                <c:when test="${mapKhoangGia[sp.id] != null}">
                                    <c:set var="minGia" value="${mapKhoangGia[sp.id][0]}"/>
                                    <c:set var="maxGia" value="${mapKhoangGia[sp.id][1]}"/>
                                    <c:choose>
                                        <c:when test="${minGia == maxGia}">
                                            <fmt:formatNumber value="${minGia}" pattern="#,###"/> đ
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${minGia}" pattern="#,###"/> đ
                                            <span class="text-muted fw-normal">–</span>
                                            <fmt:formatNumber value="${maxGia}" pattern="#,###"/> đ
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted fst-italic" style="font-size:12px;">Chưa có giá</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="text-center">
                            <span class="badge bg-light text-primary border border-primary-subtle px-2 py-1" style="font-size: 13px;">${mapSoBienThe[sp.id] != null ? mapSoBienThe[sp.id] : 0}</span>
                        </td>

                        <td class="text-center">
                            <c:choose>
                                <c:when test="${sp.trangThai == 1}">
                                    <span class="badge-active">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-inactive">Không hoạt động</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="text-center">
                            <div class="d-flex justify-content-center gap-3">
                                <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi?idSanPham=${sp.id}"
                                   title="Xem biến thể theo sản phẩm"
                                   style="color: var(--text-muted); text-decoration: none; transition: all 0.2s ease-in-out; display: inline-block;"
                                   onmouseover="this.style.color='var(--primary)';this.style.transform='scale(1.2)'"
                                   onmouseout="this.style.color='var(--text-muted)';this.style.transform='scale(1)'">
                                    <i class="fa-solid fa-list-ul fs-5"></i>
                                </a>
                                <c:if test="${not isNhanVien}">
                                <a href="${pageContext.request.contextPath}/san-pham/sua?id=${sp.id}" title="Sửa">
                                    <i class="fa-regular fa-pen-to-square fs-5 action-icon-btn"></i>
                                </a>
                                <i class="fa-regular fa-trash-can fs-5 action-icon-btn text-danger" title="Xóa / Đổi trạng thái"
                                   onclick="moModalXacNhanXoa('${sp.id}', '${sp.tenSanPham}')">
                                </i>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty listSanPham}">
                    <tr>
                        <td colspan="8" class="text-center py-5 text-muted">
                            <i class="fa-regular fa-folder-open d-block fs-2 mb-2"></i>Chưa có sản phẩm nào!
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div><!-- end table-container -->

        <!-- PHÂN TRANG -->
        <c:if test="${totalPages > 1}">
        <div class="d-flex align-items-center justify-content-between mt-3 mb-4 px-1">
            <p class="text-muted mb-0" style="font-size:13px;">
                Hiển thị <strong>${offset + 1}</strong> –
                <strong>${offset + fn:length(listSanPham)}</strong>
                trong tổng số <strong>${totalRecords}</strong> sản phẩm
            </p>

            <nav>
                <ul class="pagination pagination-sm mb-0" style="gap:4px;">

                    <%-- Nút « Trước --%>
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" style="border-radius:8px;"
                           href="${pageContext.request.contextPath}/san-pham/hien-thi?page=${currentPage - 1}&keyword=${oldKeyword}&idThuongHieu=${oldThuongHieu != null ? oldThuongHieu : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">
                            <i class="fa-solid fa-chevron-left" style="font-size:11px;"></i>
                        </a>
                    </li>

                    <%-- Các số trang: hiện tối đa 5 nút xung quanh trang hiện tại --%>
                    <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}"/>
                    <c:set var="endPage"   value="${startPage + 4 < totalPages ? startPage + 4 : totalPages}"/>
                    <%-- Điều chỉnh lại startPage nếu endPage bị clamp --%>
                    <c:set var="startPage" value="${endPage - 4 > 1 ? endPage - 4 : 1}"/>

                    <c:if test="${startPage > 1}">
                        <li class="page-item">
                            <a class="page-link" style="border-radius:8px;"
                               href="${pageContext.request.contextPath}/san-pham/hien-thi?page=1&keyword=${oldKeyword}&idThuongHieu=${oldThuongHieu != null ? oldThuongHieu : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">1</a>
                        </li>
                        <c:if test="${startPage > 2}">
                            <li class="page-item disabled"><span class="page-link" style="border-radius:8px;">…</span></li>
                        </c:if>
                    </c:if>

                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                            <a class="page-link" style="border-radius:8px; ${p == currentPage ? 'background-color:var(--primary);border-color:var(--primary);' : ''}"
                               href="${pageContext.request.contextPath}/san-pham/hien-thi?page=${p}&keyword=${oldKeyword}&idThuongHieu=${oldThuongHieu != null ? oldThuongHieu : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">${p}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${endPage < totalPages}">
                        <c:if test="${endPage < totalPages - 1}">
                            <li class="page-item disabled"><span class="page-link" style="border-radius:8px;">…</span></li>
                        </c:if>
                        <li class="page-item">
                            <a class="page-link" style="border-radius:8px;"
                               href="${pageContext.request.contextPath}/san-pham/hien-thi?page=${totalPages}&keyword=${oldKeyword}&idThuongHieu=${oldThuongHieu != null ? oldThuongHieu : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">${totalPages}</a>
                        </li>
                    </c:if>

                    <%-- Nút Sau » --%>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" style="border-radius:8px;"
                           href="${pageContext.request.contextPath}/san-pham/hien-thi?page=${currentPage + 1}&keyword=${oldKeyword}&idThuongHieu=${oldThuongHieu != null ? oldThuongHieu : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">
                            <i class="fa-solid fa-chevron-right" style="font-size:11px;"></i>
                        </a>
                    </li>

                </ul>
            </nav>
        </div>
        </c:if>

    </div>
</main>

<!-- POPUP XÁC NHẬN XÓA -->
<div class="modal fade modal-confirm-delete" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 440px;">
        <div class="modal-content">
            <div class="p-4 d-flex align-items-start gap-3">
                <div class="warning-icon-wrapper">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div>
                    <h5 class="fw-bold text-dark mb-1" style="font-size: 18px;">Xác nhận xóa sản phẩm</h5>
                    <p class="text-secondary mb-0" style="font-size: 14px;" id="lblTenSanPhamXoa">Bạn có chắc chắn muốn xóa sản phẩm này?</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/san-pham/xoa" method="POST" id="formConfirmDeleteReal">
                <input type="hidden" name="id" id="idTargetDelete">
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
        const toastEl = document.getElementById('toastAlert');
        if (toastEl) {
            setTimeout(function () {
                toastEl.style.transition = "all 0.5s ease";
                toastEl.style.opacity = "0";
                toastEl.style.transform = "translateX(100%)";
                setTimeout(() => toastEl.remove(), 500);
            }, 3500);
        }
    });

    function moModalXacNhanXoa(id, tenSp) {
        document.getElementById("idTargetDelete").value = id;
        document.getElementById("lblTenSanPhamXoa").innerText = "Bạn có chắc chắn muốn chuyển trạng thái / xóa dòng máy [" + tenSp + "] này không?";

        const myModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
        myModal.show();
    }

    /* ======= PRICE RANGE SLIDER ======= */
    (function () {
        var absMin  = ${priceAbsMin};
        var absMax  = ${priceAbsMax};
        var curMax  = ${oldGiaMax};

        var sliderMax = document.getElementById('sliderMaxSP');
        var fill      = document.getElementById('sliderFillSP');
        var lblMax    = document.getElementById('lblGiaMaxSP');
        var lblRight  = document.getElementById('lblRightSP');

        function fmt(v) {
            return Number(v).toLocaleString('vi-VN') + ' ₫';
        }
        function updateSlider() {
            var val = parseInt(sliderMax.value);
            var pct = absMax > absMin ? ((val - absMin) / (absMax - absMin)) * 100 : 100;
            fill.style.left  = '0%';
            fill.style.width = pct + '%';
            lblMax.textContent  = fmt(val);
            lblRight.textContent = fmt(absMax);
        }

        if (sliderMax) {
            sliderMax.min   = absMin;
            sliderMax.max   = absMax;
            sliderMax.value = curMax;
            sliderMax.addEventListener('input', updateSlider);
            updateSlider();
        }
    })();
</script>
</body>
</html>