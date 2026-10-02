<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>In Hóa Đơn - ${hoaDon.maHoaDon}</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary: #1a56db;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --bg-body: #f1f5f9;
            --border-color: #e5e7eb;
            --success-text: #047857;
            --success-bg: #d1fae5;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background-color: var(--bg-body); color: var(--text-main); }

        /* Toolbar Xem trước */
        .preview-toolbar { background: #0f172a; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 100; }
        .preview-toolbar h4 { font-size: 16px; font-weight: 500; margin: 0; }
        .btn-toolbar { background: #10b981; color: white; border: none; padding: 8px 20px; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 14px; display: flex; align-items: center; gap: 8px; transition: 0.2s; }
        .btn-toolbar:hover { background: #059669; }

        /* Vùng nội dung hóa đơn */
        .content-area { max-width: 1100px; margin: 30px auto; padding: 30px; background: #fff; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); border-radius: 8px;}

        /* Header với logo bên trái và QR bên phải */
        .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px; }
        .page-header-left { display: flex; align-items: center; gap: 16px; }
        .logo-container img { height: 50px; }
        .page-title h2 { font-size: 20px; font-weight: 700; margin-bottom: 6px; color: var(--text-main); }
        .page-title p { font-size: 13px; color: var(--text-muted); }
        
        /* QR Code bên phải header */
        .header-qr-container { text-align: center; }
        .header-qr-title { font-size: 12px; font-weight: 600; color: var(--text-muted); margin-bottom: 8px; }
        .header-qr-box { padding: 10px; background: #fff; border: 2px solid var(--border-color); border-radius: 8px; display: inline-block; }
        .header-qr-box img { display: block; width: 120px; height: 120px; }
        .header-qr-note { font-size: 10px; color: var(--text-muted); margin-top: 6px; }

        /* Stepper Trạng thái */
        .status-stepper-wrap { border: 1px solid var(--border-color); border-radius: 8px; padding: 30px 40px; margin-bottom: 24px; }
        .status-stepper { display: flex; align-items: center; justify-content: space-between; position: relative; }
        .status-step { display: flex; flex-direction: column; align-items: center; z-index: 2; background: #fff; padding: 0 10px; }
        .status-step .step-circle { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: 700; margin-bottom: 10px; border: 2px solid var(--border-color); background: #fff; color: #9ca3af; }
        .status-step.completed .step-circle { background: var(--primary); border-color: var(--primary); color: #fff; }
        .status-step .step-label { font-size: 13px; font-weight: 600; color: #9ca3af; }
        .status-step.completed .step-label { color: var(--text-main); }
        .status-line { position: absolute; top: 20px; left: 10%; right: 10%; height: 2px; background: var(--primary); z-index: 1; }

        /* Grid 3 cột y hệt bản gốc */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .info-card { border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; }
        .card-title { font-size: 14px; font-weight: 600; color: var(--primary); margin-bottom: 16px; display: flex; align-items: center; gap: 8px; }
        .info-item { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 13px; }
        .info-label { color: var(--text-muted); font-weight: 500; }
        .info-value { color: var(--text-main); font-weight: 600; text-align: right; }
        .total-highlight { margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border-color); }
        .total-highlight .info-value { font-size: 16px; color: #dc2626; font-weight: 700; }
        .badge-success { background: var(--success-bg); color: var(--success-text); padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 500; }

        /* Bảng sản phẩm chuẩn */
        .section-title { font-size: 15px; font-weight: 700; margin-bottom: 16px; color: var(--text-main); display: flex; align-items: center; gap: 8px; }
        .table-container { border: 1px solid var(--border-color); border-radius: 8px; overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #fff; padding: 14px 16px; text-align: left; font-size: 13px; font-weight: 600; border-bottom: 1px solid var(--border-color); color: var(--text-muted); }
        td { padding: 14px 16px; border-bottom: 1px solid var(--border-color); font-size: 13px; vertical-align: top; }
        .spec-tag { background: #f1f5f9; padding: 2px 8px; border-radius: 4px; font-size: 11px; color: var(--text-muted); margin-right: 4px; display: inline-block; margin-top: 6px; }
        .barcode-wrap { border: 1px solid var(--border-color); padding: 4px 8px; border-radius: 4px; display: inline-flex; align-items: center; gap: 6px; background: #f8fafc; font-family: monospace; font-size: 12px; font-weight: 600;}
        
        /* Xóa CSS của QR section cũ - không cần nữa */

        /* ===== PRINT STYLES ===== */
        @media print {
            /* Ẩn toolbar khi in */
            .preview-toolbar { display: none !important; }
            /* Bỏ background, shadow để in sạch */
            body { background: #fff !important; }
            .content-area {
                box-shadow: none !important;
                border-radius: 0 !important;
                margin: 0 !important;
                padding: 16px !important;
                max-width: 100% !important;
            }
            /* Tránh page-break giữa hàng bảng */
            tr { page-break-inside: avoid; }
            /* Đảm bảo màu badge giữ khi in */
            .badge-success { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            .spec-tag      { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
        }
    </style>
</head>
<body>

<div class="preview-toolbar">
    <h4><i class="fa-solid fa-file-pdf" style="margin-right: 8px; color: #38bdf8;"></i> Bản xem trước Hóa đơn</h4>
    <button class="btn-toolbar" onclick="window.print()">
        <i class="fa-solid fa-print"></i> In hoá đơn
    </button>
</div>

<div class="content-area" id="invoice-content">
    <!-- Header: Logo bên trái, Mã HĐ giữa, QR bên phải -->
    <div class="page-header">
        <div class="page-header-left">
            <div class="logo-container">
                <img src="/img/logo.jpg" alt="Logo">
            </div>
            <div class="page-title">
                <h2>Hóa đơn: ${hoaDon.maHoaDon}</h2>
                <p>Ngày lập: <fmt:formatDate value="${hoaDon.ngayLap}" pattern="dd/MM/yyyy"/></p>
            </div>
        </div>
        
        <div class="header-qr-container">
            <div class="header-qr-title">MÃ QR HÓA ĐƠN</div>
            <div class="header-qr-box">
                <img src="${pageContext.request.contextPath}/qr-hoa-don?id=${hoaDon.id}&size=120" 
                     alt="QR Code ${hoaDon.maHoaDon}"
                     onerror="this.style.display='none';">
            </div>
            <div class="header-qr-note">Quét để xem chi tiết</div>
        </div>
    </div>

    <!-- Grid 3 thẻ thông tin -->
    <div class="info-grid">
        <div class="info-card">
            <div class="card-title"><i class="fa-solid fa-user"></i> Thông tin khách hàng</div>
            <div class="info-item"><span class="info-label">Tên khách hàng</span><span class="info-value"><c:choose><c:when test="${not empty khachHang.tenKhachHang}">${khachHang.tenKhachHang}</c:when><c:otherwise>Khách lẻ</c:otherwise></c:choose></span></div>
            <div class="info-item"><span class="info-label">Số điện thoại</span><span class="info-value">${khachHang.sdt}</span></div>
            <div class="info-item"><span class="info-label">Email</span><span class="info-value">${khachHang.email}</span></div>
            <div class="info-item" style="flex-direction: column;"><span class="info-label">Địa chỉ</span><span class="info-value" style="text-align: left; margin-top: 6px;">${diaChi.diaChiCuThe}, ${diaChi.phuongXa}, ${diaChi.quanHuyen}, ${diaChi.tinhThanh}</span></div>
        </div>

        <div class="info-card">
            <div class="card-title"><i class="fa-solid fa-file-invoice-dollar"></i> Thông tin thanh toán</div>
            <div class="info-item">
                <span class="info-label">Đơn giá</span>
                <span class="info-value"><fmt:formatNumber value="${hoaDon.tongTien}" pattern="#,###"/> ₫</span>
            </div>
            <div class="info-item">
                <span class="info-label">Số lượng</span>
                <span class="info-value">${fn:length(hoaDon.listChiTiet)}</span>
            </div>
            <div class="info-item total-highlight">
                <span class="info-label" style="color: var(--text-main); font-weight: 700;">Thành tiền</span>
                <span class="info-value"><fmt:formatNumber value="${hoaDon.tongTien}" pattern="#,###"/> ₫</span>
            </div>
        </div>

        <div class="info-card">
            <div class="card-title"><i class="fa-solid fa-clock-rotate-left"></i> Lịch sử thanh toán</div>
            <!-- Giả định lấy phần tử đầu tiên trong lịch sử nếu có -->
            <c:set var="lichSu" value="${hoaDon.lichSuThanhToan[0]}" />
            <div class="info-item"><span class="info-label">Hình thức</span><span class="info-value">${empty lichSu ? 'Tiền mặt' : lichSu.phuongThucThanhToan}</span></div>
            <div class="info-item">
                <span class="info-label">Trạng thái</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${hoaDon.trangThai == 1}">
                            <span class="badge-success">Đã thanh toán</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-success" style="background: #fee; color: #c00;">Chưa thanh toán</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="info-item"><span class="info-label">Ngày thanh toán</span><span class="info-value"><fmt:formatDate value="${hoaDon.ngayThanhToan != null ? hoaDon.ngayThanhToan : hoaDon.ngayLap}" pattern="dd/MM/yyyy HH:mm"/></span></div>
            <div class="info-item"><span class="info-label">Ghi chú</span><span class="info-value" style="font-weight: 400; font-style: italic;">${empty lichSu ? 'Đã thu đủ' : lichSu.ghiChu}</span></div>
        </div>
    </div>

    <!-- Bảng danh sách sản phẩm -->
    <div class="section-title"><i class="fa-solid fa-cubes"></i> Danh sách sản phẩm</div>
    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th style="width: 50px; text-align: center;">STT</th>
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
                    <td style="text-align: center; color: var(--text-muted); font-weight: 500; padding-top: 20px;">${loop.count}</td>
                    <td>
                        <div style="font-weight: 600; color: var(--text-main);">${ct.cauHinhSanPham.sanPham.tenSanPham}</div>
                        <div>
                            <span class="spec-tag">Hãng: ${ct.cauHinhSanPham.sanPham.thuongHieu.tenThuongHieu}</span>
                            <span class="spec-tag">Màu: ${ct.cauHinhSanPham.mauSac.tenMauSac}</span>
                        </div>
                    </td>
                    <td>
                        <div style="font-weight: 500; color: var(--text-main);">${ct.cauHinhSanPham.OCung.tenOCung}</div>
                        <div style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">Dung lượng: ${ct.cauHinhSanPham.OCung.dungLuongOCung}</div>
                    </td>
                    <td>
                        <div class="barcode-wrap">
                            <i class="fa-solid fa-barcode" style="color: #9ca3af;"></i> ${ct.idSeri.soSeri}
                        </div>
                    </td>
                    <td style="text-align: right; font-weight: 700; color: var(--text-main); padding-top: 20px;">
                        <fmt:formatNumber value="${ct.donGia}" pattern="#,###"/> ₫
                    </td>
                    <td></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script>
    // Tự động mở hộp thoại in khi trang load xong
    window.addEventListener('load', function() {
        // Nhỏ delay để trang render đầy đủ trước khi mở print dialog
        setTimeout(function() { window.print(); }, 600);
    });
</script>

</body>
</html>