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
    <title>Danh sách Sản phẩm chi tiết - Skycomputer</title>

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

        .toast-notification {
            position: fixed;
            top: 24px;
            right: 24px;
            z-index: 1050;
            min-width: 320px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            border-radius: 8px;
            border: none;
        }

        .action-icon-btn {
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            text-decoration: none;
            display: inline-block;
        }
        .action-icon-btn:hover {
            color: var(--primary);
            transform: scale(1.2);
        }
        .action-icon-btn.text-danger:hover {
            color: #dc2626 !important;
        }
        .action-icon-btn.text-success:hover {
            color: #059669 !important;
        }

        #tabBienTheImei .nav-link { color: var(--text-muted); background: transparent; }
        #tabBienTheImei .nav-link.active { color: var(--primary); background: #fff; border-bottom-color: #fff !important; }
        #tabBienTheImei .nav-link:hover:not(.active) { background: #f3f4f6; color: var(--text-main); }

        .badge-active   { background-color: #d1fae5; color: #047857; padding: 4px 10px; border-radius: 6px; font-weight: 500; font-size: 12px; display: inline-block; }
        .badge-inactive { background-color: #ffe4e6; color: #be123c; padding: 4px 10px; border-radius: 6px; font-weight: 500; font-size: 12px; display: inline-block; }
        .badge-pending  { background-color: #fef3c7; color: #b45309; padding: 4px 10px; border-radius: 6px; font-weight: 500; font-size: 12px; display: inline-block; }

        .filter-card { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); margin-bottom: 20px; border: 1px solid var(--border-color); }
        .search-input-wrapper { position: relative; }
        .search-input-wrapper i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 14px; }
        .search-input-wrapper input { padding-left: 36px; }

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
            cursor: pointer; pointer-events: all;
        }
    </style>
</head>
<body>

<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="san-pham"/>
    <jsp:param name="activeSub"  value="chi-tiet-sp"/>
</jsp:include>

<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success fade show toast-notification" role="alert">
                    ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger fade show toast-notification" role="alert">
                    ${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <c:choose>
            <c:when test="${not empty idSanPhamFilter}">
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/san-pham/hien-thi"
                       class="text-decoration-none text-muted" style="font-size: 13px;">
                        <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách sản phẩm
                    </a>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span class="badge bg-light text-dark border px-2 py-1 fw-medium" style="font-size: 12px;">
                                #${maSanPhamHienTai}
                            </span>
                            <h4 class="fw-bold mb-0" style="color: var(--text-main);">${tenDongMayHienTai}</h4>
                        </div>
                        <small class="text-muted">Danh sách biến thể (${fn:length(listChiTiet)} biến thể)</small>
                    </div>
                    <c:if test="${not isNhanVien}">
                        <a href="${pageContext.request.contextPath}/san-pham/giao-dien-them" class="btn btn-primary px-4 py-2" style="border-radius: 8px; font-weight: 500; font-size: 14px;">
                            <i class="fa-solid fa-plus me-2"></i>Thêm biến thể mới
                        </a>
                    </c:if>
                </div>

                <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi" method="GET"
                      class="filter-card" id="formLocBienTheSP">
                    <input type="hidden" name="idSanPham" value="${idSanPhamFilter}">
                    <input type="hidden" name="page" value="1">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label small fw-medium text-muted mb-1">CPU</label>
                            <select name="idCpu" class="form-select form-select-sm py-2">
                                <option value="">Tất cả CPU</option>
                                <c:forEach items="${listCpuFilter}" var="cpu">
                                    <option value="${cpu.id}" ${oldIdCpu == cpu.id ? 'selected' : ''}>${cpu.tenCpu}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-medium text-muted mb-1">GPU</label>
                            <select name="idGpu" class="form-select form-select-sm py-2">
                                <option value="">Tất cả GPU</option>
                                <c:forEach items="${listGpuFilter}" var="gpu">
                                    <option value="${gpu.id}" ${oldIdGpu == gpu.id ? 'selected' : ''}>${gpu.tenGpu}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-medium text-muted mb-1">Màu sắc</label>
                            <select name="idMauSac" class="form-select form-select-sm py-2">
                                <option value="">Tất cả màu</option>
                                <c:forEach items="${listMauSacFilter}" var="ms">
                                    <option value="${ms.id}" ${oldIdMauSac == ms.id ? 'selected' : ''}>${ms.tenMauSac}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label small fw-medium text-muted mb-1">RAM</label>
                            <select name="idRam" class="form-select form-select-sm py-2">
                                <option value="">Tất cả RAM</option>
                                <c:forEach items="${listRamFilter}" var="ram">
                                    <option value="${ram.id}" ${oldIdRam == ram.id ? 'selected' : ''}>${ram.dungLuongRam}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label small fw-medium text-muted mb-1">Ổ cứng</label>
                            <select name="idOCung" class="form-select form-select-sm py-2">
                                <option value="">Tất cả ổ cứng</option>
                                <c:forEach items="${listOCungFilter}" var="oc">
                                    <option value="${oc.id}" ${oldIdOCung == oc.id ? 'selected' : ''}>${oc.dungLuongOCung}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label small fw-medium text-muted mb-1">Trạng thái</label>
                            <select name="trangThai" class="form-select form-select-sm py-2">
                                <option value="">Tất cả</option>
                                <option value="1" ${oldTrangThai == '1' ? 'selected' : ''}>Còn hàng</option>
                                <option value="0" ${oldTrangThai == '0' ? 'selected' : ''}>Đã bán</option>
                            </select>
                        </div>

                        <div class="col-md-2 d-flex align-items-end gap-2">
                            <button type="submit" class="btn btn-primary btn-sm px-4 py-2">
                                <i class="fa-solid fa-filter me-1"></i>Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi?idSanPham=${idSanPhamFilter}"
                               class="btn btn-outline-secondary btn-sm py-2" title="Xoá bộ lọc">
                                <i class="fa-solid fa-rotate-left"></i>
                            </a>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-medium text-muted mb-1">
                                Khoảng giá bán &nbsp;(từ <strong>0 đ</strong> đến <span id="lblGiaMaxSPFilter" class="text-primary fw-bold"></span>)
                            </label>
                            <div class="price-range-wrapper">
                                <div class="range-slider-container">
                                    <div class="range-slider-fill" id="sliderFillSPFilter"></div>
                                    <input type="range" class="price-slider" id="sliderMaxSPFilter" name="giaMax"
                                           min="${priceAbsMin}" max="${priceAbsMax}"
                                           value="${oldGiaMax}" step="100000">
                                </div>
                                <div class="price-range-label mt-2">
                                    <span>0 ₫</span>
                                    <span id="lblRightSPFilter"></span>
                                </div>
                            </div>
                            <input type="hidden" name="giaMin" value="0">
                        </div>

                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold mb-1" style="color: var(--text-main);">Quản lý Biến thể Sản phẩm</h4>
                        <small class="text-muted">Danh sách các phiên bản cấu hình thương mại trong kho</small>
                    </div>
                    <c:if test="${not isNhanVien}">
                        <a href="${pageContext.request.contextPath}/san-pham/giao-dien-them" class="btn btn-primary px-4 py-2" style="border-radius: 8px; font-weight: 500; font-size: 14px;">
                            <i class="fa-solid fa-plus me-2"></i>Thêm biến thể mới
                        </a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>

        <c:if test="${empty idSanPhamFilter}">
            <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi" method="GET"
                  class="filter-card" id="formLocBienThe">
                <input type="hidden" name="page" value="1">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label small fw-medium text-muted mb-1">Tên sản phẩm</label>
                        <div class="search-input-wrapper">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" name="tenSanPham" class="form-control form-control-sm py-2"
                                   placeholder="Tìm theo tên SP..." value="${oldTenSanPham}">
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small fw-medium text-muted mb-1">CPU</label>
                        <select name="idCpu" class="form-select form-select-sm py-2">
                            <option value="">Tất cả CPU</option>
                            <c:forEach items="${listCpuFilter}" var="cpu">
                                <option value="${cpu.id}" ${oldIdCpu == cpu.id ? 'selected' : ''}>${cpu.tenCpu}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small fw-medium text-muted mb-1">GPU</label>
                        <select name="idGpu" class="form-select form-select-sm py-2">
                            <option value="">Tất cả GPU</option>
                            <c:forEach items="${listGpuFilter}" var="gpu">
                                <option value="${gpu.id}" ${oldIdGpu == gpu.id ? 'selected' : ''}>${gpu.tenGpu}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small fw-medium text-muted mb-1">Màu sắc</label>
                        <select name="idMauSac" class="form-select form-select-sm py-2">
                            <option value="">Tất cả màu</option>
                            <c:forEach items="${listMauSacFilter}" var="ms">
                                <option value="${ms.id}" ${oldIdMauSac == ms.id ? 'selected' : ''}>${ms.tenMauSac}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small fw-medium text-muted mb-1">RAM</label>
                        <select name="idRam" class="form-select form-select-sm py-2">
                            <option value="">Tất cả RAM</option>
                            <c:forEach items="${listRamFilter}" var="ram">
                                <option value="${ram.id}" ${oldIdRam == ram.id ? 'selected' : ''}>${ram.dungLuongRam}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small fw-medium text-muted mb-1">Ổ cứng</label>
                        <select name="idOCung" class="form-select form-select-sm py-2">
                            <option value="">Tất cả ổ cứng</option>
                            <c:forEach items="${listOCungFilter}" var="oc">
                                <option value="${oc.id}" ${oldIdOCung == oc.id ? 'selected' : ''}>${oc.dungLuongOCung}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label small fw-medium text-muted mb-1">Trạng thái</label>
                        <select name="trangThai" class="form-select form-select-sm py-2">
                            <option value="">Tất cả</option>
                            <option value="1" ${oldTrangThai == '1' ? 'selected' : ''}>Còn hàng</option>
                            <option value="0" ${oldTrangThai == '0' ? 'selected' : ''}>Đã bán</option>
                        </select>
                    </div>

                    <div class="col-md-4 d-flex align-items-end gap-2">
                        <button type="submit" class="btn btn-primary btn-sm px-4 py-2">
                            <i class="fa-solid fa-filter me-1"></i>Lọc
                        </button>
                        <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi"
                           class="btn btn-outline-secondary btn-sm py-2" title="Xoá bộ lọc">
                            <i class="fa-solid fa-rotate-left"></i>
                        </a>
                    </div>

                    <div class="col-12">
                        <label class="form-label small fw-medium text-muted mb-1">
                            Khoảng giá bán &nbsp;(từ <strong>0 đ</strong> đến <span id="lblGiaMaxCT" class="text-primary fw-bold"></span>)
                        </label>
                        <div class="price-range-wrapper">
                            <div class="range-slider-container">
                                <div class="range-slider-fill" id="sliderFillCT"></div>
                                <input type="range" class="price-slider" id="sliderMaxCT" name="giaMax"
                                       min="${priceAbsMin}" max="${priceAbsMax}"
                                       value="${oldGiaMax}" step="100000">
                            </div>
                            <div class="price-range-label mt-2">
                                <span>0 ₫</span>
                                <span id="lblRightCT"></span>
                            </div>
                        </div>
                        <input type="hidden" name="giaMin" value="0">
                    </div>

                </div>
            </form>
        </c:if>

        <ul class="nav nav-tabs mb-0" id="tabBienTheImei" role="tablist"
            style="border-bottom: 2px solid var(--border-color); gap: 4px;">
            <li class="nav-item" role="presentation">
                <button class="nav-link active px-4 py-2 fw-semibold" id="tab-bienthe-btn"
                        data-bs-toggle="tab" data-bs-target="#tab-bienthe"
                        type="button" role="tab"
                        style="font-size:14px; border-radius:8px 8px 0 0; border:1px solid var(--border-color); border-bottom:none;">
                    <i class="fa-solid fa-table-list me-2"></i>Danh sách biến thể
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link px-4 py-2 fw-semibold" id="tab-imei-btn"
                        data-bs-toggle="tab" data-bs-target="#tab-imei"
                        type="button" role="tab"
                        style="font-size:14px; border-radius:8px 8px 0 0; border:1px solid var(--border-color); border-bottom:none;">
                    <i class="fa-solid fa-qrcode me-2"></i>Tất cả IMEI / Seri
                </button>
            </li>
        </ul>

        <div class="tab-content">

            <!-- TAB 1: Bảng biến thể -->
            <div class="tab-pane fade show active" id="tab-bienthe" role="tabpanel">
                <div class="content-card" style="border-top-left-radius:0; border-top-right-radius:0;">
                    <table class="table table-custom align-middle">
                        <thead>
                        <tr>
                            <th style="width: 50px;">STT</th>
                            <c:if test="${empty idSanPhamFilter}">
                                <th>Tên SP Cha</th>
                            </c:if>
                            <th>Màu Sắc</th>
                            <th>RAM</th>
                            <th>Ổ Cứng</th>
                            <th>Giá Bán</th>
                            <th>Tồn Kho</th>
                            <th class="text-center" style="width: 120px;">Thao Tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${listChiTiet}" var="ct" varStatus="stt">
                            <tr>
                                <td class="text-muted fw-semibold">${offset + stt.index + 1}</td>
                                <c:if test="${empty idSanPhamFilter}">
                                    <td class="fw-bold text-dark">${ct.sanPham.tenSanPham}</td>
                                </c:if>
                                <td><span class="badge border text-dark bg-light px-2 py-1"><i class="fa-solid fa-circle me-1 text-secondary" style="font-size:8px;"></i>${ct.cauHinhSanPham.mauSac.tenMauSac}</span></td>
                                <td class="fw-medium">${ct.cauHinhSanPham.ram.dungLuongRam}</td>
                                <td class="fw-medium">${ct.cauHinhSanPham.OCung.dungLuongOCung}</td>
                                <td class="text-success fw-bold"><fmt:formatNumber value="${ct.donGia}" type="currency" currencySymbol="₫"/></td>
                                <td><span class="badge bg-success px-2 py-1">${ct.tonKho}</span></td>

                                <!-- Thao tác -->
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-3 align-items-center">

                                        <!-- 🟢 NÚT IN TEM PDF MÃ QR TỪNG BIẾN THỂ -->
                                        <a href="${pageContext.request.contextPath}/san-pham/xuat-tem-pdf?idCauHinh=${ct.cauHinhSanPham.id}"
                                           target="_blank"
                                           class="action-icon-btn text-success"
                                           title="In tem mã QR Code IMEI (PDF)">
                                            <i class="fa-solid fa-print fs-5"></i>
                                        </a>

                                        <c:if test="${not isNhanVien}">
                                            <i class="fa-solid fa-circle-plus fs-5 action-icon-btn text-primary"
                                               title="Thêm IMEI cho biến thể này"
                                               onclick="moModalThemImei(${ct.id}, '${ct.cauHinhSanPham.mauSac.tenMauSac}', '${ct.cauHinhSanPham.ram.dungLuongRam}', '${ct.cauHinhSanPham.OCung.dungLuongOCung}')">
                                            </i>
                                            <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/xoa" method="POST" id="formDelete-${ct.id}" style="margin:0;">
                                                <input type="hidden" name="id" value="${ct.id}">
                                                <i class="fa-regular fa-trash-can fs-5 action-icon-btn text-danger" title="Xóa bản ghi này"
                                                   onclick="if(confirm('Bạn có chắc chắn muốn xóa bản ghi này không?')) document.getElementById('formDelete-${ct.id}').submit();">
                                                </i>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listChiTiet}">
                            <tr><td colspan="${not empty idSanPhamFilter ? '7' : '8'}" class="text-center py-5 text-muted">Kho hàng biến thể trống!</td></tr>
                        </c:if>
                        </tbody>
                    </table>

                    <%-- PHÂN TRANG --%>
                    <c:if test="${totalPages > 1}">
                    <div class="d-flex align-items-center justify-content-between mt-3 pt-3" style="border-top: 1px solid var(--border-color);">
                        <p class="text-muted mb-0" style="font-size:13px;">
                            Hiển thị <strong>${offset + 1}</strong> –
                            <strong>${offset + fn:length(listChiTiet)}</strong>
                            trong tổng số <strong>${totalRecords}</strong> biến thể
                        </p>

                        <nav>
                            <ul class="pagination pagination-sm mb-0" style="gap:4px;">

                                <%-- Nút « Trước --%>
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" style="border-radius:8px;"
                                       href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi?page=${currentPage - 1}&idSanPham=${idSanPhamFilter != null ? idSanPhamFilter : ''}&tenSanPham=${oldTenSanPham}&idCpu=${oldIdCpu != null ? oldIdCpu : ''}&idGpu=${oldIdGpu != null ? oldIdGpu : ''}&idMauSac=${oldIdMauSac != null ? oldIdMauSac : ''}&idRam=${oldIdRam != null ? oldIdRam : ''}&idOCung=${oldIdOCung != null ? oldIdOCung : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">
                                        <i class="fa-solid fa-chevron-left" style="font-size:11px;"></i>
                                    </a>
                                </li>

                                <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}"/>
                                <c:set var="endPage"   value="${startPage + 4 < totalPages ? startPage + 4 : totalPages}"/>
                                <c:set var="startPage" value="${endPage - 4 > 1 ? endPage - 4 : 1}"/>

                                <c:if test="${startPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" style="border-radius:8px;"
                                           href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi?page=1&idSanPham=${idSanPhamFilter != null ? idSanPhamFilter : ''}&tenSanPham=${oldTenSanPham}&idCpu=${oldIdCpu != null ? oldIdCpu : ''}&idGpu=${oldIdGpu != null ? oldIdGpu : ''}&idMauSac=${oldIdMauSac != null ? oldIdMauSac : ''}&idRam=${oldIdRam != null ? oldIdRam : ''}&idOCung=${oldIdOCung != null ? oldIdOCung : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">1</a>
                                    </li>
                                    <c:if test="${startPage > 2}">
                                        <li class="page-item disabled"><span class="page-link" style="border-radius:8px;">…</span></li>
                                    </c:if>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="p">
                                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                                        <a class="page-link" style="border-radius:8px; ${p == currentPage ? 'background-color:var(--primary);border-color:var(--primary);' : ''}"
                                           href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi?page=${p}&idSanPham=${idSanPhamFilter != null ? idSanPhamFilter : ''}&tenSanPham=${oldTenSanPham}&idCpu=${oldIdCpu != null ? oldIdCpu : ''}&idGpu=${oldIdGpu != null ? oldIdGpu : ''}&idMauSac=${oldIdMauSac != null ? oldIdMauSac : ''}&idRam=${oldIdRam != null ? oldIdRam : ''}&idOCung=${oldIdOCung != null ? oldIdOCung : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">${p}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${endPage < totalPages}">
                                    <c:if test="${endPage < totalPages - 1}">
                                        <li class="page-item disabled"><span class="page-link" style="border-radius:8px;">…</span></li>
                                    </c:if>
                                    <li class="page-item">
                                        <a class="page-link" style="border-radius:8px;"
                                           href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi?page=${totalPages}&idSanPham=${idSanPhamFilter != null ? idSanPhamFilter : ''}&tenSanPham=${oldTenSanPham}&idCpu=${oldIdCpu != null ? oldIdCpu : ''}&idGpu=${oldIdGpu != null ? oldIdGpu : ''}&idMauSac=${oldIdMauSac != null ? oldIdMauSac : ''}&idRam=${oldIdRam != null ? oldIdRam : ''}&idOCung=${oldIdOCung != null ? oldIdOCung : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">${totalPages}</a>
                                    </li>
                                </c:if>

                                <%-- Nút Sau » --%>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" style="border-radius:8px;"
                                       href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi?page=${currentPage + 1}&idSanPham=${idSanPhamFilter != null ? idSanPhamFilter : ''}&tenSanPham=${oldTenSanPham}&idCpu=${oldIdCpu != null ? oldIdCpu : ''}&idGpu=${oldIdGpu != null ? oldIdGpu : ''}&idMauSac=${oldIdMauSac != null ? oldIdMauSac : ''}&idRam=${oldIdRam != null ? oldIdRam : ''}&idOCung=${oldIdOCung != null ? oldIdOCung : ''}&trangThai=${oldTrangThai}&giaMin=0&giaMax=${oldGiaMax}">
                                        <i class="fa-solid fa-chevron-right" style="font-size:11px;"></i>
                                    </a>
                                </li>

                            </ul>
                        </nav>
                    </div>
                    </c:if>

                </div>
            </div>

            <!-- TAB 2: Tất cả IMEI / Seri theo từng biến thể -->
            <div class="tab-pane fade" id="tab-imei" role="tabpanel">
                <div class="content-card" style="border-top-left-radius:0; border-top-right-radius:0;">
                    <c:choose>
                        <c:when test="${empty imeiTheoChiTiet}">
                            <div class="text-center py-5 text-muted">Chưa có IMEI / Seri nào cho sản phẩm này!</div>
                        </c:when>
                        <c:otherwise>
                            <c:set var="isFirstGroup" value="true"/>
                            <c:forEach items="${imeiTheoChiTiet}" var="entry" varStatus="groupStatus">
                                <c:set var="ctEntry" value="${entry.key}"/>
                                <c:set var="imeiList" value="${entry.value}"/>

                                <c:if test="${not groupStatus.first}">
                                    <div class="d-flex justify-content-center my-3">
                                        <hr style="width:40%; border-color:#ffffff; border-width:2px; opacity:1; background-color:#e5e7eb; height:1px; border:none;">
                                    </div>
                                </c:if>

                                <div class="mb-2">
                                    <div class="d-flex align-items-center gap-2 mb-1">
                                        <span class="fw-bold text-dark" style="font-size:14px;">${ctEntry.sanPham.tenSanPham}</span>
                                        <span class="badge border text-dark bg-light px-2 py-1" style="font-size:12px;">
                                    <i class="fa-solid fa-palette me-1 text-secondary" style="font-size:9px;"></i>${ctEntry.cauHinhSanPham.mauSac.tenMauSac}
                                </span>
                                        <span class="badge bg-light border text-dark px-2 py-1" style="font-size:12px;">${ctEntry.cauHinhSanPham.ram.dungLuongRam}</span>
                                        <span class="badge bg-light border text-dark px-2 py-1" style="font-size:12px;">${ctEntry.cauHinhSanPham.OCung.dungLuongOCung}</span>
                                        <span class="ms-auto text-muted" style="font-size:12px;">Tổng: ${fn:length(imeiList)} mã</span>
                                    </div>
                                </div>

                                <c:choose>
                                    <c:when test="${empty imeiList}">
                                        <p class="text-muted small ms-1 mb-0">Chưa có mã IMEI nào.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <table class="table table-custom align-middle mb-0" style="font-size:13px;">
                                            <thead>
                                            <tr>
                                                <th style="width:50px;">STT</th>
                                                <th>Số Seri / IMEI</th>
                                                <th>Ngày nhập</th>
                                                <th>Trạng thái</th>
                                                <c:if test="${not isNhanVien}">
                                                    <th class="text-center" style="width:90px;">Thao tác</th>
                                                </c:if>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach items="${imeiList}" var="imei" varStatus="imeiStt">
                                                <tr>
                                                    <td class="text-muted fw-semibold">${imeiStt.index + 1}</td>
                                                    <td class="fw-bold font-monospace text-dark">${imei.soSeri}</td>
                                                    <td>${imei.ngayNhap}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${imei.trangThai == 1}"><span class="badge-active">Còn hàng</span></c:when>
                                                            <c:when test="${imei.trangThai == 2}"><span class="badge-pending">Chờ xử lý</span></c:when>
                                                            <c:otherwise><span class="badge-inactive">Đã bán</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <c:if test="${not isNhanVien}">
                                                        <td class="text-center">
                                                            <c:if test="${imei.trangThai == 1}">
                                                                <i class="fa-regular fa-trash-can fs-5 action-icon-btn text-danger"
                                                                   title="Xóa IMEI này khỏi danh sách"
                                                                   onclick="xacNhanXoaImeiNhanh('${imei.id}', '${imei.soSeri}')">
                                                                </i>
                                                            </c:if>
                                                        </td>
                                                    </c:if>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </div>
</main>

<form id="formXoaImeiNhanh" action="${pageContext.request.contextPath}/san-pham-chi-tiet/imei-xoa-nhanh" method="POST" style="display:none;">
    <input type="hidden" name="idImei" id="hiddenIdImeiXoaNhanh">
    <input type="hidden" name="redirectUrl" id="hiddenRedirectXoaNhanh">
</form>

<div class="modal fade" id="modalXacNhanXoaImeiNhanh" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 420px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 14px; overflow: hidden;">
            <div class="p-4 d-flex align-items-start gap-3">
                <div style="width:46px; height:46px; background-color:#fef2f2; color:#dc2626; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:20px; flex-shrink:0;">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div>
                    <h5 class="fw-bold text-dark mb-1" style="font-size: 16px;">Xác nhận xóa IMEI</h5>
                    <p class="text-secondary mb-0" id="lblXoaImeiNhanhText" style="font-size: 13px; line-height: 1.5;">
                        Bạn có chắc chắn muốn xóa mã IMEI này không?
                    </p>
                </div>
            </div>
            <div class="d-flex justify-content-end gap-2 px-4 pb-4">
                <button type="button" class="btn btn-outline-secondary fw-semibold px-4 py-2"
                        style="font-size:13px; border-radius:8px;"
                        data-bs-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-danger fw-semibold px-4 py-2"
                        style="font-size:13px; border-radius:8px;"
                        onclick="thucSuXoaImeiNhanh()">
                    <i class="fa-solid fa-trash-can me-1"></i>Xác nhận xóa
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalThemImeiNhanh" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 520px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 14px;">

            <div class="modal-header border-0 pt-4 px-4 pb-2 d-flex justify-content-between align-items-start">
                <div>
                    <h5 class="modal-title fw-bold text-dark mb-1" style="font-size: 16px;">
                        <i class="fa-solid fa-barcode me-2 text-primary"></i>Thêm IMEI / Số Seri
                    </h5>
                    <small class="text-muted" id="lblThemImeiSubtitle" style="font-size: 12px;">Biến thể đang chọn</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" style="font-size: 12px;"></button>
            </div>

            <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/imei-them-nhanh" method="POST" id="formThemImeiNhanh">
                <input type="hidden" name="idChiTiet" id="hiddenIdChiTietImei">
                <input type="hidden" name="redirectUrl" id="hiddenRedirectUrlImei" value="${pageContext.request.requestURL}?${pageContext.request.queryString}">

                <div class="modal-body px-4 pb-2">

                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <label class="fw-semibold text-secondary mb-0" style="font-size: 13px;">
                            Nhập IMEI <span class="text-danger">*</span>
                        </label>
                        <span class="text-muted" style="font-size: 11px;">Mỗi mã trên một dòng hoặc cách nhau bởi dấu phẩy</span>
                    </div>

                    <textarea id="txtAreaThemImei" name="chuoiImei" class="form-control font-monospace mb-2" rows="6"
                              placeholder="Ví dụ:&#10;358123456789012&#10;358123456789013&#10;358123456789014"
                              style="font-size: 13px; border-color: #cbd5e1; background-color: #f8fafc; resize: vertical;"
                              required></textarea>

                    <div id="imeiThemErrorBox" class="d-none mb-2 p-2 rounded" style="background:#fff1f2; border:1px solid #fca5a5; font-size:12px; color:#dc2626; line-height:1.6;"></div>

                    <div class="mb-2 d-flex justify-content-between align-items-center">
                        <span class="fw-medium text-dark" style="font-size: 13px;">
                            Số lượng: <span id="lblDemImeiNhanh" class="fw-bold text-success">0 IMEI</span>
                        </span>
                        <span id="lblCanhBaoImei" class="text-warning fw-semibold d-none" style="font-size: 12px;">
                            <i class="fa-solid fa-triangle-exclamation me-1"></i>Có mã không hợp lệ
                        </span>
                    </div>

                    <div id="boxPreviewImeiNhanh"
                         class="p-3 rounded border mb-1 text-muted small"
                         style="background:#f8fafc; min-height:42px; max-height:110px; overflow-y:auto; font-size:12px; line-height:1.8;">
                        Chưa có mã nào được nhập
                    </div>

                    <small class="text-muted d-block mt-1" style="font-size: 11px;">
                        <i class="fa-solid fa-circle-info me-1"></i>IMEI hợp lệ: chỉ chữ số, đúng 15 ký tự. Mã trùng lặp sẽ tự động bỏ qua.
                    </small>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 pt-2 d-flex gap-2 justify-content-between">
                    <button type="button" class="btn btn-outline-danger fw-semibold px-3 py-2"
                            style="font-size:13px; border-radius:8px; min-width:90px;"
                            onclick="document.getElementById('txtAreaThemImei').value=''; capNhatPreviewImei();">
                        Xóa trống
                    </button>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-secondary fw-semibold px-4 py-2"
                                style="font-size:13px; border-radius:8px;" data-bs-dismiss="modal">
                            Hủy bỏ
                        </button>
                        <button type="button" class="btn btn-primary fw-semibold px-4 py-2"
                                style="font-size:13px; border-radius:8px;"
                                onclick="moModalXacNhanImei()">
                            <i class="fa-solid fa-floppy-disk me-1"></i>Lưu IMEI
                        </button>
                    </div>
                </div>
            </form>

        </div>
    </div>
</div>

<div class="modal fade" id="modalXacNhanThemImei" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 420px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 14px; overflow: hidden;">
            <div class="p-4 d-flex align-items-start gap-3">
                <div style="width:46px; height:46px; background-color:#eff6ff; color:#1a56db; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:20px; flex-shrink:0;">
                    <i class="fa-solid fa-barcode"></i>
                </div>
                <div>
                    <h5 class="fw-bold text-dark mb-1" style="font-size: 16px;">Xác nhận thêm IMEI</h5>
                    <p class="text-secondary mb-0" id="lblXacNhanImeiText" style="font-size: 13px; line-height: 1.5;">
                        Bạn có chắc chắn muốn thêm các mã IMEI này vào biến thể không?
                    </p>
                </div>
            </div>
            <div class="d-flex justify-content-end gap-2 px-4 pb-4">
                <button type="button" class="btn btn-outline-secondary fw-semibold px-4 py-2"
                        style="font-size:13px; border-radius:8px;"
                        onclick="dongModalXacNhan()">
                    Quay lại
                </button>
                <button type="button" class="btn btn-primary fw-semibold px-4 py-2"
                        style="font-size:13px; border-radius:8px;"
                        onclick="thucSuSubmitImei()">
                    <i class="fa-solid fa-check me-1"></i>Xác nhận thêm
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        setTimeout(function() {
            let alertNode = document.querySelector('.toast-notification');
            if (alertNode) {
                let bsAlert = new bootstrap.Alert(alertNode);
                bsAlert.close();
            }
        }, 3000);

        document.getElementById('txtAreaThemImei').addEventListener('input', capNhatPreviewImei);

        document.getElementById('modalThemImeiNhanh').addEventListener('show.bs.modal', function() {
            document.getElementById('txtAreaThemImei').value = '';
            capNhatPreviewImei();
            document.getElementById('imeiThemErrorBox').classList.add('d-none');
            document.getElementById('imeiThemErrorBox').innerHTML = '';
        });
    });

    const IMEI_REGEX = /^\d{15}$/;

    function moModalThemImei(idChiTiet, mauSac, ram, oCung) {
        document.getElementById('hiddenIdChiTietImei').value = idChiTiet;
        document.getElementById('hiddenRedirectUrlImei').value = window.location.pathname + window.location.search;
        document.getElementById('lblThemImeiSubtitle').textContent =
            mauSac + ' · ' + ram + ' · ' + oCung;
        var modal = new bootstrap.Modal(document.getElementById('modalThemImeiNhanh'));
        modal.show();
    }

    function capNhatPreviewImei() {
        var raw = document.getElementById('txtAreaThemImei').value;
        var lines = raw.replace(/\r\n/g, '\n').replace(/\r/g, '\n')
            .split(/[,\n]+/)
            .map(function(s) { return s.trim().toUpperCase(); })
            .filter(function(s) { return s.length > 0; });

        var coKhongHopLe = false;
        var preview = '';

        if (lines.length === 0) {
            document.getElementById('boxPreviewImeiNhanh').textContent = 'Chưa có mã nào được nhập';
            document.getElementById('lblDemImeiNhanh').textContent = '0 IMEI';
            document.getElementById('lblCanhBaoImei').classList.add('d-none');
            return;
        }

        lines.forEach(function(code) {
            var valid = IMEI_REGEX.test(code);
            if (!valid) coKhongHopLe = true;
            preview += '<span class="badge me-1 mb-1 ' +
                (valid
                    ? 'bg-light text-dark border border-secondary-subtle'
                    : 'border border-danger-subtle text-danger') +
                '" style="font-size:11px;' +
                (valid ? '' : ' background-color:#fff1f2;') + '">' +
                code + (valid ? '' : ' ⚠') + '</span>';
        });

        document.getElementById('lblDemImeiNhanh').textContent = lines.length + ' IMEI';
        document.getElementById('boxPreviewImeiNhanh').innerHTML = preview;

        if (coKhongHopLe) {
            document.getElementById('lblCanhBaoImei').classList.remove('d-none');
        } else {
            document.getElementById('lblCanhBaoImei').classList.add('d-none');
        }
    }

    function guiFormThemImei() {
        var raw = document.getElementById('txtAreaThemImei').value.trim();
        var errorBox = document.getElementById('imeiThemErrorBox');
        errorBox.classList.add('d-none');
        errorBox.innerHTML = '';

        if (!raw) {
            errorBox.innerHTML = 'Vui lòng nhập ít nhất một mã IMEI trước khi lưu.';
            errorBox.classList.remove('d-none');
            return false;
        }

        var lines = raw.replace(/\r\n/g, '\n').replace(/\r/g, '\n')
            .split(/[,\n]+/)
            .map(function(s) { return s.trim().toUpperCase(); })
            .filter(function(s) { return s.length > 0; });

        var seen = {};
        var trungTrongInput = [];
        lines.forEach(function(code) {
            if (seen[code]) {
                if (trungTrongInput.indexOf(code) === -1) trungTrongInput.push(code);
            }
            seen[code] = true;
        });

        if (trungTrongInput.length > 0) {
            errorBox.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i>'
                + '<strong>Phát hiện ' + trungTrongInput.length + ' mã IMEI trùng lặp trong danh sách nhập:</strong><br>'
                + trungTrongInput.map(function(c){ return '<code style="background:#fef2f2;padding:1px 4px;border-radius:3px;">' + c + '</code>'; }).join(' &nbsp; ')
                + '<br><small>Vui lòng xóa các mã trùng trước khi tiếp tục.</small>';
            errorBox.classList.remove('d-none');
            return false;
        }

        var khongHopLe = lines.filter(function(c) { return !IMEI_REGEX.test(c); });

        if (khongHopLe.length > 0 && khongHopLe.length === lines.length) {
            errorBox.innerHTML = 'Tất cả mã IMEI đều không hợp lệ. IMEI phải là chữ số đúng 15 ký tự:<br>'
                + khongHopLe.map(function(c){ return '<code>' + c + '</code>'; }).join(', ');
            errorBox.classList.remove('d-none');
            return false;
        }

        return true;
    }

    function moModalXacNhanImei() {
        if (!guiFormThemImei()) return;

        var raw = document.getElementById('txtAreaThemImei').value.trim();
        var lines = raw.replace(/\r\n/g, '\n').replace(/\r/g, '\n')
            .split(/[,\n]+/)
            .map(function(s) { return s.trim().toUpperCase(); })
            .filter(function(s) { return s.length > 0; });

        var hopLe = lines.filter(function(c) { return IMEI_REGEX.test(c); });
        var khongHopLe = lines.filter(function(c) { return !IMEI_REGEX.test(c); });

        var msg = 'Bạn sắp thêm <strong>' + hopLe.length + ' mã IMEI</strong> vào biến thể <strong>'
            + document.getElementById('lblThemImeiSubtitle').textContent + '</strong>.';
        if (khongHopLe.length > 0) {
            msg += '<br><small class="text-warning"><i class="fa-solid fa-triangle-exclamation me-1"></i>'
                + khongHopLe.length + ' mã không hợp lệ sẽ bị bỏ qua.</small>';
        }
        document.getElementById('lblXacNhanImeiText').innerHTML = msg;

        bootstrap.Modal.getInstance(document.getElementById('modalThemImeiNhanh')).hide();
        setTimeout(function() {
            new bootstrap.Modal(document.getElementById('modalXacNhanThemImei')).show();
        }, 300);
    }

    function dongModalXacNhan() {
        bootstrap.Modal.getInstance(document.getElementById('modalXacNhanThemImei')).hide();
        setTimeout(function() {
            new bootstrap.Modal(document.getElementById('modalThemImeiNhanh')).show();
        }, 300);
    }

    function thucSuSubmitImei() {
        bootstrap.Modal.getInstance(document.getElementById('modalXacNhanThemImei')).hide();
        document.getElementById('formThemImeiNhanh').submit();
    }

    function xacNhanXoaImeiNhanh(idImei, soSeri) {
        document.getElementById('hiddenIdImeiXoaNhanh').value = idImei;
        document.getElementById('hiddenRedirectXoaNhanh').value = window.location.pathname + window.location.search;
        document.getElementById('lblXoaImeiNhanhText').innerHTML =
            'Mã IMEI <strong class="font-monospace">' + soSeri + '</strong> sẽ bị xóa khỏi danh sách (chuyển trạng thái về không hiển thị). Thao tác này không thể hoàn tác.';
        new bootstrap.Modal(document.getElementById('modalXacNhanXoaImeiNhanh')).show();
    }

    function thucSuXoaImeiNhanh() {
        bootstrap.Modal.getInstance(document.getElementById('modalXacNhanXoaImeiNhanh')).hide();
        document.getElementById('formXoaImeiNhanh').submit();
    }

    (function () {
        var absMin = ${priceAbsMin != null ? priceAbsMin : 0};
        var absMax = ${priceAbsMax != null ? priceAbsMax : 0};
        var curMax = ${oldGiaMax  != null ? oldGiaMax  : (priceAbsMax != null ? priceAbsMax : 0)};

        function fmt(v) { return Number(v).toLocaleString('vi-VN') + ' ₫'; }

        function initSlider(sliderId, fillId, lblMaxId, lblRightId) {
            var sliderMax = document.getElementById(sliderId);
            var fill      = document.getElementById(fillId);
            var lblMax    = document.getElementById(lblMaxId);
            var lblRight  = document.getElementById(lblRightId);
            if (!sliderMax) return;
            sliderMax.min   = absMin;
            sliderMax.max   = absMax;
            sliderMax.value = curMax;
            function update() {
                var val = parseInt(sliderMax.value);
                var pct = absMax > absMin ? ((val - absMin) / (absMax - absMin)) * 100 : 100;
                fill.style.left  = '0%';
                fill.style.width = pct + '%';
                if (lblMax)   lblMax.textContent   = fmt(val);
                if (lblRight) lblRight.textContent = fmt(absMax);
            }
            sliderMax.addEventListener('input', update);
            update();
        }

        initSlider('sliderMaxCT',       'sliderFillCT',       'lblGiaMaxCT',       'lblRightCT');
        initSlider('sliderMaxSPFilter', 'sliderFillSPFilter', 'lblGiaMaxSPFilter', 'lblRightSPFilter');
    })();
</script>
</body>
</html>