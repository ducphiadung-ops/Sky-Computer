<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    request.setAttribute("isNhanVien", _isNhanVien);
%>
<%-- Nhân viên không được vào trang thống kê --%>
<c:if test="${isNhanVien}">
    <c:redirect url="${pageContext.request.contextPath}/san-pham/hien-thi"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang thống kê - Skycomputer</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

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
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* HEADER */
        .top-header {
            height: 70px;
            background-color: #fff;
            display: flex;
            align-items: center;
            padding: 0 32px;
            border-bottom: 1px solid var(--border-color);
        }
        .header-actions { display: flex; align-items: center; gap: 24px; margin-left: auto; }
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

        .page-actions { display: flex; gap: 12px; }
        .btn { padding: 10px 16px; border-radius: 6px; font-size: 13px; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 8px; border: none; transition: 0.2s; }
        .btn-outline { background: #fff; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-outline:hover { background: #f9fafb; }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: #154cbf; }

        /* --- DASHBOARD CARDS --- */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
            margin-bottom: 24px;
        }
        .stat-card {
            background: #fff;
            padding: 24px;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            box-shadow: 0 1px 2px rgba(0,0,0,0.02);
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .stat-header { display: flex; justify-content: space-between; align-items: center; }
        .stat-title { font-size: 13px; font-weight: 500; color: var(--text-muted); }
        .stat-icon {
            width: 40px; height: 40px; border-radius: 8px;
            display: flex; align-items: center; justify-content: center; font-size: 18px;
        }
        .icon-blue { background: #e0e7ff; color: #4338ca; }
        .icon-green { background: #d1fae5; color: #047857; }
        .icon-orange { background: #ffedd5; color: #c2410c; }
        .icon-purple { background: #f3e8ff; color: #7e22ce; }

        .stat-value { font-size: 24px; font-weight: 700; color: var(--text-main); }
        .stat-trend { font-size: 12px; font-weight: 500; display: flex; align-items: center; gap: 4px; }
        .trend-up { color: var(--success-text); }
        .trend-down { color: var(--danger-text); }

        /* --- BOTTOM LAYOUT: TABLE & LIST --- */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
        }
        .panel {
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        .panel-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .panel-title { font-size: 16px; font-weight: 600; color: var(--text-main); }
        .panel-action { font-size: 13px; color: var(--primary); font-weight: 500; text-decoration: none; }
        .panel-action:hover { text-decoration: underline; }

        /* Bảng Đơn Hàng */
        table { width: 100%; border-collapse: collapse; }
        th {
            background: #EDEDF9;
            padding: 12px 24px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            color: var(--text-main);
            border-bottom: 1px solid var(--border-color);
        }
        td { padding: 16px 24px; border-bottom: 1px solid var(--border-color); font-size: 13px; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        .invoice-id { color: var(--primary); font-weight: 600; text-decoration: none;}
        .invoice-id:hover { text-decoration: underline; }

        .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 500; display: inline-block; }
        .badge-success { background: var(--success-bg); color: var(--success-text); }
        .badge-warning { background: var(--warning-bg); color: var(--warning-text); }

        /* Danh sách Top Sản Phẩm */
        .top-products-list { padding: 0 24px; }
        .top-product-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px 0;
            border-bottom: 1px solid var(--border-color);
        }
        .top-product-item:last-child { border-bottom: none; }
        .top-product-img {
            width: 48px;
            height: 48px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            object-fit: contain;
            background-color: #f8f9fa;
        }
        .top-product-info { flex: 1; }
        .top-product-name { font-size: 13px; font-weight: 600; color: var(--text-main); margin-bottom: 4px; display: block; text-decoration: none;}
        .top-product-name:hover { color: var(--primary); }
        .top-product-sales { font-size: 12px; color: var(--text-muted); }
        .top-product-price { font-size: 14px; font-weight: 600; color: var(--primary); }

    </style>
</head>
<body>

<!-- SIDEBAR & HEADER (dùng chung) -->
<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="tong-quan"/>
</jsp:include>

<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">
        <div class="page-header">
            <div class="page-title">
                <h2>Trang thống kê</h2>
                <p>Chào mừng trở lại! Dưới đây là tình hình kinh doanh hôm nay.</p>
            </div>
            <div class="page-actions">
                <form method="get" action="${pageContext.request.contextPath}/tong_quan"
                      id="formLocNgay" style="display:flex; align-items:center; gap:8px;">
                    <div style="position:relative; display:flex; align-items:center;">
                        <i class="fa-regular fa-calendar"
                           style="position:absolute; left:10px; color:var(--text-muted); pointer-events:none;"></i>
                        <input type="date" name="ngayLoc" id="inputNgayLoc"
                               value="${ngayLocValue}"
                               style="padding: 10px 12px 10px 34px; border: 1px solid var(--border-color);
                                      border-radius: 6px; font-size: 13px; font-family: inherit;
                                      color: var(--text-main); cursor: pointer; background: #fff;"
                               onchange="this.form.submit()"/>
                    </div>
                    <%-- Nút Hôm nay --%>
                    <button type="button" class="btn btn-outline" title="Xem ngày hôm nay"
                            onclick="document.getElementById('inputNgayLoc').value='${ngayTodayValue}';
                                     document.getElementById('formLocNgay').submit();">
                        <i class="fa-solid fa-calendar-day"></i> Hôm nay
                    </button>
                    <%-- Nút Tất cả --%>
                    <a href="${pageContext.request.contextPath}/tong_quan?ngayLoc=all"
                       class="btn ${isAll ? 'btn-primary' : 'btn-outline'}"
                       title="Xem toàn bộ thời gian">
                        <i class="fa-solid fa-globe"></i> Tất cả
                    </a>
                </form>
            </div>
        </div>

        <div class="dashboard-cards">
            <!-- 1. TỔNG DOANH THU -->
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-title">TỔNG DOANH THU</span>
                    <div class="stat-icon icon-blue"><i class="fa-solid fa-money-bill-wave"></i></div>
                </div>
                <!-- Sử dụng EL để lấy giá trị đã được format chuỗi từ Servlet -->
                <div class="stat-value">${tongDoanhThu != null ? tongDoanhThu : "0"}đ</div>
                <div class="stat-trend trend-up">
                    <i class="fa-solid fa-calendar-day" style="font-size:11px;"></i>
                    <c:choose>
                        <c:when test="${isAll}">
                            <span style="color:var(--text-muted); font-weight:400;">Toàn bộ thời gian</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color:var(--text-muted); font-weight:400;">Ngày ${ngayLocHienThi}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 2. TỔNG HÓA ĐƠN -->
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-title">ĐƠN HÀNG MỚI</span>
                    <div class="stat-icon icon-green"><i class="fa-solid fa-cart-shopping"></i></div>
                </div>
                <div class="stat-value">${tongHoaDon != null ? tongHoaDon : "0"}</div>
                <div class="stat-trend trend-up">
                    <i class="fa-solid fa-calendar-day" style="font-size:11px;"></i>
                    <c:choose>
                        <c:when test="${isAll}">
                            <span style="color:var(--text-muted); font-weight:400;">Toàn bộ thời gian</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color:var(--text-muted); font-weight:400;">Ngày ${ngayLocHienThi}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 3. TỔNG SẢN PHẨM ĐÃ BÁN -->
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-title">SẢN PHẨM ĐÃ BÁN</span>
                    <div class="stat-icon icon-orange"><i class="fa-solid fa-box-open"></i></div>
                </div>
                <div class="stat-value">${tongSanPham != null ? tongSanPham : "0"}</div>
                <div class="stat-trend trend-down">
                    <i class="fa-solid fa-calendar-day" style="font-size:11px;"></i>
                    <c:choose>
                        <c:when test="${isAll}">
                            <span style="color:var(--text-muted); font-weight:400;">Toàn bộ thời gian</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color:var(--text-muted); font-weight:400;">Ngày ${ngayLocHienThi}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 4. KHÁCH HÀNG -->
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-title">KHÁCH HÀNG</span>
                    <div class="stat-icon icon-purple"><i class="fa-solid fa-users"></i></div>
                </div>
                <%-- Số KH mua trong kỳ đang lọc --%>
                <div class="stat-value">${khachHangMua != null ? khachHangMua : "0"}</div>
                <div class="stat-trend trend-up">
                    <i class="fa-solid fa-calendar-day" style="font-size:11px;"></i>
                    <c:choose>
                        <c:when test="${isAll}">
                            <span style="color:var(--text-muted); font-weight:400;">Đã từng mua hàng</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color:var(--text-muted); font-weight:400;">Mua trong ngày ${ngayLocHienThi}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <%-- Tổng KH trong hệ thống (luôn cố định) --%>
                <div style="margin-top:6px; font-size:12px; color:var(--text-muted); display:flex; align-items:center; gap:6px;">
                    <i class="fa-solid fa-database" style="font-size:11px;"></i>
                    Tổng hệ thống: <strong style="color:var(--text-main);">${tongKhachHang != null ? tongKhachHang : "0"}</strong> khách hàng
                </div>
            </div>
        </div>

        <!-- BIỂU ĐỒ DOANH THU THEO TUẦN -->
        <div class="panel" style="margin-bottom: 24px;">
            <div class="panel-header">
                <div>
                    <h3 class="panel-title">Doanh thu theo tuần</h3>
                    <span style="font-size:12px; color:var(--text-muted);">
                        <c:choose>
                            <c:when test="${not empty dauTuan and not empty cuoiTuan}">
                                ${dauTuan} &ndash; ${cuoiTuan}
                            </c:when>
                        </c:choose>
                    </span>
                </div>
                <div style="display:flex; align-items:center; gap:12px;">
                    <%-- Điều hướng tuần --%>
                    <div style="display:flex; align-items:center; gap:6px;">
                        <%-- Nút tuần trước: offset - 1, giới hạn -52 --%>
                        <c:set var="prevOffset" value="${tuanOffset - 1}"/>
                        <c:choose>
                            <c:when test="${tuanOffset <= -52}">
                                <button class="btn btn-outline" disabled
                                        style="padding:5px 10px; font-size:12px; opacity:0.45; cursor:not-allowed;">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </button>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/tong_quan?tuanOffset=${prevOffset}<c:if test="${not empty ngayLocValue}">&amp;ngayLoc=${ngayLocValue}</c:if><c:if test="${isAll}">&amp;ngayLoc=all</c:if>"
                                   class="btn btn-outline" title="Tuần trước"
                                   style="padding:5px 10px; font-size:12px;">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <%-- Label "Tuần này" khi offset = 0 --%>
                        <c:choose>
                            <c:when test="${tuanOffset == 0}">
                                <span style="font-size:12px; font-weight:600; color:var(--primary); min-width:72px; text-align:center;">Tuần này</span>
                            </c:when>
                            <c:when test="${tuanOffset == -1}">
                                <a href="${pageContext.request.contextPath}/tong_quan?tuanOffset=0<c:if test="${not empty ngayLocValue}">&amp;ngayLoc=${ngayLocValue}</c:if><c:if test="${isAll}">&amp;ngayLoc=all</c:if>"
                                   class="btn btn-outline" title="Về tuần hiện tại"
                                   style="padding:5px 10px; font-size:12px; min-width:72px; text-align:center;">
                                    Tuần trước
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/tong_quan?tuanOffset=0<c:if test="${not empty ngayLocValue}">&amp;ngayLoc=${ngayLocValue}</c:if><c:if test="${isAll}">&amp;ngayLoc=all</c:if>"
                                   class="btn btn-outline" title="Về tuần hiện tại"
                                   style="padding:5px 10px; font-size:12px; min-width:72px; text-align:center;">
                                    ${tuanOffset} tuần trước
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <%-- Nút tuần sau: chỉ hiện khi đang xem tuần quá khứ --%>
                        <c:choose>
                            <c:when test="${tuanOffset >= 0}">
                                <button class="btn btn-outline" disabled
                                        style="padding:5px 10px; font-size:12px; opacity:0.45; cursor:not-allowed;">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </button>
                            </c:when>
                            <c:otherwise>
                                <c:set var="nextOffset" value="${tuanOffset + 1}"/>
                                <a href="${pageContext.request.contextPath}/tong_quan?tuanOffset=${nextOffset}<c:if test="${not empty ngayLocValue}">&amp;ngayLoc=${ngayLocValue}</c:if><c:if test="${isAll}">&amp;ngayLoc=all</c:if>"
                                   class="btn btn-outline" title="Tuần sau"
                                   style="padding:5px 10px; font-size:12px;">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div style="display:flex; align-items:center; gap:8px;">
                        <span style="width:12px; height:3px; background:#1a56db; border-radius:2px; display:inline-block;"></span>
                        <span style="font-size:12px; color:var(--text-muted);">Doanh thu (triệu đ)</span>
                    </div>
                </div>
            </div>
            <div style="padding: 20px 24px; position:relative; height:260px;">
                <canvas id="chartDoanhThu"></canvas>
            </div>
        </div>

        <div class="dashboard-grid">

            <!-- BẢNG ĐƠN HÀNG GẦN ĐÂY -->            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title">Đơn hàng gần đây</h3>
                    <a href="/hoa-don/hien-thi" class="panel-action">Xem tất cả</a>
                </div>
                <table>
                    <thead>
                    <tr>
                        <th>MÃ ĐH</th>
                        <th>KHÁCH HÀNG</th>
                        <th>TỔNG TIỀN</th>
                        <th>TRẠNG THÁI</th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- Dùng JSTL để lặp qua ListDonHangGanDay -->
                    <c:forEach items="${ListDonHangGanDay}" var="hd">
                        <tr>
                            <!-- Giả định Entity HoaDon có thuộc tính id -->
                            <td><a href="#" class="invoice-id">#HD${hd.id}</a></td>

                            <!-- Giả định Entity HoaDon quan hệ với KhachHang (hd.khachHang.ten) hoặc có thuộc tính tenNguoiNhan -->
                            <td>${hd.khachHang != null ? hd.khachHang.tenKhachHang : "Khách lẻ"}</td>

                            <!-- Format tiền tệ, giả định thuộc tính tongTien -->
                            <td style="font-weight: 600;">
                                <fmt:formatNumber value="${hd.tongTien}" type="number" pattern="#,###"/>đ
                            </td>

                            <!-- Kiểm tra trạng thái -->
                            <td>
                                <c:choose>
                                    <c:when test="${hd.trangThai == 1}">
                                        <span class="badge badge-success">Đã thanh toán</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-warning">Chưa thanh toán</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- Hiển thị thông báo nếu không có đơn hàng -->
                    <c:if test="${empty ListDonHangGanDay}">
                        <tr>
                            <td colspan="4" style="text-align: center; color: var(--text-muted);">Chưa có đơn hàng nào gần đây</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- DANH SÁCH SẢN PHẨM BÁN CHẠY -->
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title">Sản phẩm bán chạy</h3>
                    <a href="/san-pham/hien-thi" class="panel-action">Chi tiết</a>
                </div>
                <div class="top-products-list">

                    <!-- ListSanPhamBanChay là List<Object[]>: row[0]=SanPham, row[1]=Long soLuongBan -->
                    <c:forEach items="${ListSanPhamBanChay}" var="row">
                        <div class="top-product-item">
                            <div class="top-product-info">
                                <a href="#" class="top-product-name">${row[0].tenSanPham}</a>
                                <span class="top-product-sales">Đã bán: ${row[1]} lượt</span>
                            </div>
                            <div class="top-product-price">
                                <fmt:formatNumber value="${row[0].giaBan}" type="number" pattern="#,###"/>đ
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty ListSanPhamBanChay}">
                        <div style="padding: 16px; text-align: center; color: var(--text-muted);">Chưa có dữ liệu sản phẩm</div>
                    </c:if>

                </div>
            </div>

        </div>
    </div>
</main>

<script>
(function () {
    var labels = ${chartLabels};
    var rawData = ${chartData};

    // Tìm giá trị max để tính padding trục Y đẹp hơn
    var maxVal = 0;
    rawData.forEach(function(v) { if (v != null && v > maxVal) maxVal = v; });
    var suggestedMax = maxVal > 0 ? maxVal * 1.25 : 10;

    var ctx = document.getElementById('chartDoanhThu').getContext('2d');

    // Gradient fill bên dưới đường
    var gradient = ctx.createLinearGradient(0, 0, 0, 220);
    gradient.addColorStop(0, 'rgba(26, 86, 219, 0.18)');
    gradient.addColorStop(1, 'rgba(26, 86, 219, 0.01)');

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu (triệu đ)',
                data: rawData,
                borderColor: '#1a56db',
                backgroundColor: gradient,
                borderWidth: 2.5,
                pointBackgroundColor: '#1a56db',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 5,
                pointHoverRadius: 7,
                fill: true,
                tension: 0.35,
                spanGaps: false   // ngắt đoạn tại null (ngày chưa đến)
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(ctx) {
                            var v = ctx.parsed.y;
                            if (v == null) return '';
                            // Hiển thị lại đơn vị đầy đủ trong tooltip
                            var fullVal = (v * 1000000).toLocaleString('vi-VN');
                            return ' ' + fullVal + 'đ';
                        }
                    },
                    backgroundColor: '#1f2937',
                    titleColor: '#f9fafb',
                    bodyColor: '#d1fae5',
                    padding: 10,
                    cornerRadius: 8
                }
            },
            scales: {
                x: {
                    grid: { color: 'rgba(0,0,0,0.04)' },
                    ticks: {
                        font: { size: 12, family: 'Inter, sans-serif' },
                        color: '#6b7280'
                    }
                },
                y: {
                    beginAtZero: true,
                    suggestedMax: suggestedMax,
                    grid: { color: 'rgba(0,0,0,0.06)' },
                    ticks: {
                        font: { size: 12, family: 'Inter, sans-serif' },
                        color: '#6b7280',
                        callback: function(value) {
                            if (value === 0) return '0';
                            return value.toLocaleString('vi-VN') + ' tr';
                        }
                    }
                }
            }
        }
    });
})();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>