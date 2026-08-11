<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết hóa đơn - Skycomputer</title>

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

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { display: flex; height: 100vh; background-color: var(--bg-body); color: var(--text-main); overflow: hidden; }

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
        .top-header { height: 60px; background-color: #fff; display: flex; align-items: center; padding: 0 24px; border-bottom: 1px solid var(--border-color); }
        .header-actions { display: flex; align-items: center; gap: 20px; margin-left: auto; }
        .notification { position: relative; color: var(--text-muted); cursor: pointer; font-size: 18px; }
        .notification::after { content: ''; position: absolute; top: -2px; right: 0px; width: 6px; height: 6px; background: #ef4444; border-radius: 50%; border: 2px solid #fff; }
        .user-profile { display: flex; align-items: center; gap: 10px; }
        .user-info { text-align: right; }
        .user-name { font-size: 13px; font-weight: 600; color: var(--text-main); }
        .user-role { font-size: 10px; color: var(--text-muted); text-transform: uppercase; }
        .avatar { width: 32px; height: 32px; border-radius: 50%; object-fit: cover; }

        .content-area { flex: 1; padding: 20px 24px; overflow-y: auto; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .page-title h2 { font-size: 18px; font-weight: 600; margin-bottom: 2px; }
        .page-title p { font-size: 12px; color: var(--text-muted); }

        .btn { padding: 8px 14px; border-radius: 6px; font-size: 12px; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 6px; border: none; transition: 0.2s; text-decoration: none;}
        .btn-outline { background: #fff; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-outline:hover { background: #f9fafb; }

        /* --- TRẠNG THÁI HÓA ĐƠN (STEPPER) --- */
        .status-stepper-wrap { background: #fff; border: 1px solid var(--border-color); border-radius: 12px; padding: 28px 48px; margin-bottom: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
        .status-stepper { display: flex; align-items: flex-start; }
        .status-step { display: flex; flex-direction: column; align-items: center; flex: 1 1 0; text-align: center; }
        .status-step .step-circle { width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 15px; font-weight: 700; margin-bottom: 10px; border: 2px solid var(--border-color); background: #fff; color: #9ca3af; transition: 0.25s; }
        .status-step.completed .step-circle { background: var(--primary); border-color: var(--primary); color: #fff; }
        .status-step .step-label { font-size: 13px; font-weight: 600; color: #9ca3af; transition: 0.25s; }
        .status-step.completed .step-label { color: var(--text-main); }
        .status-line { flex: 0 0 auto; width: 15%; height: 3px; background: var(--border-color); margin-top: 18px; transition: 0.25s; }
        .status-line.completed { background: var(--primary); }

        /* --- TOP 3 COLUMNS GRID --- */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .info-card { background: #fff; border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
        .card-title { font-size: 14px; font-weight: 600; color: var(--primary); margin-bottom: 16px; display: flex; align-items: center; gap: 8px; border-bottom: 1px dashed var(--border-color); padding-bottom: 10px; }

        .info-item { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 13px; line-height: 1.5; }
        .info-label { color: var(--text-muted); font-weight: 500; min-width: 100px; }
        .info-value { color: var(--text-main); font-weight: 600; text-align: right; word-break: break-word; }

        /* Highlight Total Amount */
        .info-item.total-highlight { margin-top: 14px; padding-top: 14px; border-top: 1px solid var(--border-color); }
        .info-item.total-highlight .info-value { font-size: 16px; color: #dc2626; font-weight: 700; }

        /* --- TABLES & CONTAINERS --- */
        .section-title { font-size: 15px; font-weight: 600; margin-bottom: 14px; color: var(--text-main); display: flex; align-items: center; gap: 8px; }
        .table-container { background: #fff; border: 1px solid var(--border-color); border-radius: 12px; overflow: hidden; margin-bottom: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8fafc; padding: 14px 18px; text-align: left; font-size: 12px; font-weight: 600; color: var(--text-main); border-bottom: 1px solid var(--border-color); letter-spacing: 0.5px; }
        td { padding: 14px 18px; border-bottom: 1px solid var(--border-color); font-size: 13px; vertical-align: middle; }

        /* Badges */
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 500; display: inline-block; }
        .badge-success { background: var(--success-bg); color: var(--success-text); }
        .badge-warning { background: var(--warning-bg); color: var(--warning-text); }

        .product-spec { font-size: 11px; color: var(--text-muted); margin-top: 4px; display: flex; gap: 8px; flex-wrap: wrap; }
        .spec-tag { background: #f3f4f6; padding: 2px 6px; border-radius: 4px; }
    </style>
</head>
<body>

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
            <a class="nav-link-custom d-flex justify-content-between align-items-center" data-bs-toggle="collapse" role="button" aria-expanded="false">
                <span><i class="fa-solid fa-box"></i> Quản lý sản phẩm</span>
                <i class="fa-solid fa-chevron-down" style="font-size: 10px; transition: transform 0.2s;"></i>
            </a>
            <div class="collapse" id="sub-san-pham">
                <ul class="sub-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="nav-link-custom">
                            <i class="fa-solid fa-list me-1"></i> Danh sách sản phẩm
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi" class="nav-link-custom">
                            <i class="fa-solid fa-circle-info me-1"></i> Sản phẩm chi tiết
                        </a>
                    </li>
                </ul>
            </div>
        </li>

        <!-- QUẢN LÝ HÓA ĐƠN -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/hoa-don/hien-thi" class="nav-link-custom active"><i class="fa-solid fa-file-invoice"></i> Quản lý hóa đơn</a>
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

<main class="main-wrapper">
    <header class="top-header">
        <div class="header-actions">
            <div class="notification"><i class="fa-regular fa-bell"></i></div>
            <div class="user-profile">
                <div class="user-info">
                    <div class="user-name">Admin User</div>
                    <div class="user-role">QUẢN TRỊ VIÊN</div>
                </div>
                <img src="https://i.pravatar.cc/150?img=11" alt="Avatar" class="avatar">
            </div>
        </div>
    </header>

    <div class="content-area">
        <div class="page-header">
            <div class="page-title">
                <h2>Chi tiết hóa đơn: ${hoaDon.maHoaDon}</h2>
                <p>Quản lý chi tiết luồng tiền, thông tin khách nhận và sản phẩm xuất.</p>
            </div>
            <div class="page-actions">
                <a href="/hoa-don/hien-thi" class="btn btn-outline"><i class="fa-solid fa-arrow-left"></i> Quay lại danh sách</a>
            </div>
        </div>

        <%-- ===== TRẠNG THÁI HÓA ĐƠN (STEPPER) =====
             hoaDon.trangThai == 1  -> đã xử lý   -> cả 2 bước completed
             hoaDon.trangThai == 2  -> chờ xử lý  -> chỉ bước đầu completed
        --%>
        <c:set var="daXuLy" value="${hoaDon.trangThai == 1}" />
        <div class="status-stepper-wrap">
            <div class="status-stepper">
                <div class="status-step completed">
                    <div class="step-circle"><i class="fa-solid fa-check"></i></div>
                    <div class="step-label">Chờ xử lý</div>
                </div>
                <div class="status-line ${daXuLy ? 'completed' : ''}"></div>

                <div class="status-step ${daXuLy ? 'completed' : ''}">
                    <div class="step-circle">
                        <c:choose>
                            <c:when test="${daXuLy}"><i class="fa-solid fa-check"></i></c:when>
                            <c:otherwise><i class="fa-solid fa-hourglass-half"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="step-label">Đã xử lý</div>
                </div>
            </div>
        </div>

        <div class="info-grid">
            <%-- ===== CARD 1: Thông tin khách hàng ===== --%>
            <div class="info-card">
                <div class="card-title"><i class="fa-solid fa-user"></i> Thông tin khách hàng</div>
                <div class="info-item">
                    <span class="info-label">Tên khách hàng</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${not empty khachHang.tenKhachHang}">${khachHang.tenKhachHang}</c:when>
                            <c:otherwise>Khách lẻ</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">Số điện thoại</span>
                    <span class="info-value">${khachHang.sdt}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Email</span>
                    <span class="info-value">${khachHang.email}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Địa chỉ</span>
                    <span class="info-value">
                        ${diaChi.tinhThanh}, ${diaChi.quanHuyen}, ${diaChi.phuongXa}, ${diaChi.diaChiCuThe}
                    </span>
                </div>
            </div>

            <%-- ===== CARD 2: Thông tin thanh toán ===== --%>
            <div class="info-card">
                <div class="card-title"><i class="fa-solid fa-calculator"></i> Thông tin thanh toán</div>

                <%-- Đơn giá sản phẩm: Lấy đơn giá của sản phẩm đầu tiên trong hóa đơn --%>
                <div class="info-item">
                    <span class="info-label">Đơn giá</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${not empty hoaDon.listChiTiet}">
                                <fmt:formatNumber value="${hoaDon.listChiTiet[0].donGia}" pattern="#,###"/> ₫
                            </c:when>
                            <c:otherwise>0 ₫</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <%-- Số lượng: Đếm tổng số lượng sản phẩm chi tiết trong hóa đơn --%>
                <div class="info-item">
                    <span class="info-label">Số lượng</span>
                    <span class="info-value">${fn:length(hoaDon.listChiTiet)}</span>
                </div>

                <%-- Thành tiền --%>
                <div class="info-item total-highlight">
                    <span class="info-label" style="color: var(--text-main); font-weight: 700;">Thành tiền</span>
                    <span class="info-value">
                        <fmt:formatNumber value="${hoaDon.tongTien}" pattern="#,###"/> ₫
                    </span>
                </div>
            </div>

            <%-- ===== CARD 3: Lịch sử thanh toán ===== --%>
            <div class="info-card">
                <div class="card-title"><i class="fa-solid fa-clock-history"></i> Lịch sử thanh toán</div>
                <c:forEach items="${hoaDon.lichSuThanhToan}" var="ls">
                    <div class="info-item">
                        <span class="info-label">Hình thức</span>
                        <span class="info-value">${ls.phuongThucThanhToan}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Trạng thái</span>
                        <span class="info-value">
                        <span class="badge ${ls.hoaDon.trangThai == 1 ? 'badge-success' : 'badge-warning'}">
                                ${ls.hoaDon.trangThai == 1 ? 'Đã thanh toán' : 'Chưa thanh toán'}
                        </span>
                    </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ngày thanh toán</span>
                        <span class="info-value">${ls.ngayThanhToan}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ghi chú</span>
                        <span class="info-value" style="font-weight: 400; font-style: italic;">${ls.ghiChu}</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <%-- ===== BẢNG SẢN PHẨM ===== --%>
        <div class="section-title"><i class="fa-solid fa-cubes"></i> Danh sách sản phẩm</div>
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th style="width: 60px; text-align: center;">STT</th>
                    <th>Tên sản phẩm</th>
                    <th>Thông số ổ cứng</th>
                    <th>Mã Serial</th>
                    <th style="text-align: right;">Đơn giá</th>
                    <th>Ghi chú</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${hoaDon.listChiTiet}" var="ct" varStatus="loop">
                    <tr>
                        <td style="text-align: center; color: var(--text-muted); font-weight: 500;">${loop.count}</td>
                        <td>
                            <div style="font-weight: 600; color: var(--text-main); margin-bottom: 4px;">${ct.cauHinhSanPham.sanPham.tenSanPham}</div>
                            <div class="product-spec">
                                <span class="spec-tag">Hãng: <strong>${ct.cauHinhSanPham.sanPham.thuongHieu.tenThuongHieu}</strong></span>
                                <span class="spec-tag">Màu: <strong>${ct.cauHinhSanPham.mauSac.tenMauSac}</strong></span>
                            </div>
                        </td>
                        <td>
                            <div style="font-weight: 500;">${ct.cauHinhSanPham.OCung.tenOCung}</div>
                            <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">Dung lượng: ${ct.cauHinhSanPham.OCung.dungLuongOCung}</div>
                        </td>
                        <td>
                            <span style="font-family: monospace; font-weight: 600; background: #f8fafc; padding: 4px 8px; border-radius: 4px; border: 1px dashed #cbd5e1; font-size: 13px; color: #334155; display: inline-block;">
                                <i class="fa-solid fa-barcode" style="margin-right: 4px; color: #94a3b8;"></i>
                                ${ct.idSeri.soSeri}
                            </span>
                        </td>
                        <td style="text-align: right; font-weight: 700; color: var(--text-main);">
                            <fmt:formatNumber value="${ct.donGia}" pattern="#,###"/> ₫
                        </td>
                        <td style="color: var(--text-muted); font-style: italic; font-size: 12px;">${ct.hoaDon.ghiChu}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div style="padding: 16px; display: flex; justify-content: flex-end;">
                <a href="/hoa-don/print-view?id=${hoaDon.id}" target="_blank" class="btn btn-danger">
                    <i class="fa-solid fa-print"></i> Xem trước & In hóa đơn
                </a>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
