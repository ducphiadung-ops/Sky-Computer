<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm khách hàng - Skycomputer</title>

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
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { display: flex; height: 100vh; background-color: var(--bg-body); color: var(--text-main); overflow: hidden; }

        /* --- SIDEBAR --- */
        .sidebar { width: 260px; background-color: #fff; border-right: 1px solid var(--border-color); display: flex; flex-direction: column; height: 100vh; padding-bottom: 16px; z-index: 10; }
        .brand { display: flex; align-items: center; padding: 20px; gap: 12px; border-bottom: 1px solid var(--border-color); margin-bottom: 12px; }
        .brand-logo { width: 40px; height: 40px; border-radius: 8px; overflow: hidden; display: flex; align-items: center; justify-content: center; background: #fff; }
        .brand-logo img { width: 100%; height: 100%; object-fit: contain; }
        .brand-text h1 { font-size: 16px; font-weight: 700; color: #1e3a8a; margin-bottom: 0; }
        .brand-text p { font-size: 11px; color: var(--text-muted); margin-bottom: 0; }
        .nav-menu { list-style: none; padding: 0 12px; flex: 1; overflow-y: auto; }
        .nav-item { margin-bottom: 4px; }
        .nav-link-custom { display: flex; align-items: center; padding: 11px 16px; color: var(--text-muted); text-decoration: none; border-radius: 8px; font-size: 14px; font-weight: 500; transition: all 0.2s; gap: 12px; }
        .nav-link-custom i { font-size: 16px; width: 20px; text-align: center; }
        .nav-link-custom:hover { background-color: #f3f4f6; color: var(--text-main); }
        .nav-link-custom.active { background-color: var(--sidebar-active); color: var(--primary); font-weight: 600; }
        .sub-menu { list-style: none; padding-left: 0; margin-top: 4px; display: flex; flex-direction: column; gap: 2px; }
        .sub-menu .nav-link-custom { padding: 9px 16px 9px 44px !important; font-size: 13px; }
        .sub-menu .nav-link-custom.active-sub { background-color: var(--sidebar-active); color: var(--primary); font-weight: 600; }
        .logout-item { margin-top: auto; padding: 0 12px; }
        .nav-link-custom.logout-link { color: #dc2626; border-top: 1px solid var(--border-color); border-radius: 0; padding-top: 16px; }
        .nav-link-custom.logout-link:hover { background-color: #ffe4e6; color: #be123c; border-radius: 8px; }

        /* --- HEADER --- */
        .top-header { height: 70px; background-color: #fff; display: flex; align-items: center; justify-content: flex-end; padding: 0 32px; border-bottom: 1px solid var(--border-color); }
        .header-actions { display: flex; align-items: center; gap: 24px; }
        .notification { position: relative; color: var(--text-muted); cursor: pointer; font-size: 20px; }
        .notification::after { content: ''; position: absolute; top: -2px; right: 0; width: 8px; height: 8px; background: #ef4444; border-radius: 50%; border: 2px solid #fff; }
        .user-profile { display: flex; align-items: center; gap: 12px; }
        .user-info { text-align: right; }
        .user-name { font-size: 14px; font-weight: 600; color: var(--text-main); }
        .user-role { font-size: 11px; color: var(--text-muted); text-transform: uppercase; }
        .avatar { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; }

        /* --- MAIN CONTENT LAYOUT --- */
        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .content-area { flex: 1; padding: 24px 32px; overflow-y: auto; }

        /* --- PAGE HEADER WITH BACK ARROW --- */
        .page-header { display: flex; align-items: center; gap: 16px; margin-bottom: 24px; }
        .btn-back { display: flex; align-items: center; justify-content: center; width: 36px; height: 36px; border-radius: 50%; background: #fff; border: 1px solid var(--border-color); color: var(--text-main); text-decoration: none; transition: 0.2s; }
        .btn-back:hover { background: #f3f4f6; }

        .page-title { display: flex; align-items: center; gap: 10px; }
        .page-title i { font-size: 20px; color: #10b981; }
        .page-title h2 { font-size: 20px; font-weight: 600; }

        /* --- FORM STYLES --- */
        .form-card {
            background: #fff;
            border-radius: 12px;
            padding: 28px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            border: 1px solid var(--border-color);
            margin-bottom: 24px;
        }

        .form-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .form-card-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-main);
        }

        .info-layout { display: block; }

        .avatar-upload-section { display: none; }

        .form-grid-fields { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 20px 24px; 
            width: 100%;
            margin-left: 0;
        }

        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group label { font-size: 13px; font-weight: 500; color: var(--text-main); }
        .form-group label span { color: #ef4444; margin-left: 2px; }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 13px;
            color: var(--text-main);
            outline: none;
            transition: border-color 0.2s;
        }
        .form-control:focus { border-color: var(--primary); }
        .form-control::placeholder { color: #9ca3af; }

        select.form-control {
            appearance: none;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="%236b7280" viewBox="0 0 16 16"><path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/></svg>') no-repeat right 14px center;
            background-color: #fff;
        }

        .radio-group { display: flex; gap: 24px; margin-top: 6px; }
        .radio-label { display: flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 500; color: var(--text-main); cursor: pointer; }
        .radio-label input[type="radio"] {
            appearance: none;
            width: 18px;
            height: 18px;
            border: 2px solid var(--border-color);
            border-radius: 50%;
            outline: none;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        .radio-label input[type="radio"]:checked { border-color: #10b981; }
        .radio-label input[type="radio"]:checked::before { content: ""; width: 10px; height: 10px; background-color: #10b981; border-radius: 50%; display: block; }

        /* ADDRESS CARD STYLES */
        .address-card {
            border: 1px solid #10b981;
            box-shadow: 0 0 0 1px #10b981;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            background: #fff;
            position: relative;
        }

        .address-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .address-card-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-main);
        }

        .address-card-title i { color: #10b981; }

        .address-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .address-detail-grid {
            display: grid;
            grid-template-columns: 3fr 1fr;
            gap: 20px;
        }

        .btn-add-address {
            background: #e6efff;
            color: var(--primary);
            border: 1px dashed var(--primary);
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: 0.2s;
        }
        .btn-add-address:hover { background: #dbe7ff; }

        .btn-delete-address {
            background: none;
            border: none;
            color: #ef4444;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .btn-delete-address:hover { text-decoration: underline; }

        .form-actions-footer { display: flex; justify-content: flex-end; gap: 12px; margin-top: 12px; margin-bottom: 40px; }
        .btn { padding: 10px 20px; border-radius: 6px; font-size: 13px; font-weight: 500; cursor: pointer; border: none; transition: 0.2s; }
        .btn-outline { background: #fff; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-outline:hover { background: #f9fafb; }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: #154cbf; }

        /* ===== SEARCHABLE DROPDOWN ===== */
        .searchable-select-wrapper { position: relative; }

        .searchable-input {
            cursor: text;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="%236b7280" viewBox="0 0 16 16"><path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/></svg>') no-repeat 12px center;
            padding-left: 34px !important;
        }

        .searchable-input:disabled {
            background-color: #f9fafb;
            cursor: not-allowed;
            opacity: 0.6;
        }

        .searchable-dropdown {
            display: none;
            position: absolute;
            top: calc(100% + 4px);
            left: 0;
            right: 0;
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            z-index: 9999;
            max-height: 220px;
            overflow-y: auto;
        }

        .searchable-dropdown::-webkit-scrollbar { width: 6px; }
        .searchable-dropdown::-webkit-scrollbar-track { background: #f1f5f9; border-radius: 4px; }
        .searchable-dropdown::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }

        .sd-item {
            padding: 10px 14px;
            font-size: 13px;
            color: var(--text-main);
            cursor: pointer;
            transition: background 0.15s;
        }
        .sd-item:hover { background-color: #eef2ff; color: var(--primary); }
        .sd-item.sd-empty { color: var(--text-muted); cursor: default; font-style: italic; }
        .sd-item.sd-selected { background-color: #e6efff; color: var(--primary); font-weight: 600; }

        /* ===== VALIDATE STYLES ===== */
        .input-error { border-color: #ef4444 !important; box-shadow: 0 0 0 3px rgba(239,68,68,0.12) !important; }
        .field-error { font-size: 12px; color: #dc2626; margin-top: 4px; display: none; }
        .field-error.show { display: block; }
        .alert-error {
            background: #fef2f2; border: 1px solid #fca5a5; color: #991b1b;
            border-radius: 8px; padding: 12px 16px; margin-bottom: 20px;
            font-size: 13px; display: flex; align-items: center; gap: 10px;
        }
        .alert-error i { font-size: 16px; flex-shrink: 0; }
    </style>
</head>
<body>

<%-- SIDEBAR --%>
<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="khach-hang"/>
</jsp:include>

<main class="main-wrapper">
    <%-- HEADER --%>
    <jsp:include page="/demo/common/header.jsp"/>

    <div class="content-area">

        <div class="page-header">
            <a href="javascript:history.back()" class="btn-back">
                <i class="fa-solid fa-arrow-left"></i>
            </a>
            <div class="page-title">
                <i class="fa-regular fa-address-book"></i>
                <h2>Thêm khách hàng</h2>
            </div>
        </div>

        <!-- FORM CHÍNH -->
        <form id="formAddKH" action="${pageContext.request.contextPath}/khach-hang/add" method="post" novalidate>

            <%-- Hiển thị lỗi từ server (nếu có) --%>
            <c:if test="${not empty errorMsg}">
                <div class="alert-error">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <span>${errorMsg}</span>
                </div>
            </c:if>

            <!-- THÔNG TIN CHUNG -->
            <div class="form-card">
                <div class="form-card-header">
                    <div class="form-card-title">Thông tin chung</div>
                </div>

                <div class="info-layout">
                    <div class="avatar-upload-section">
                    </div>

                    <div class="form-grid-fields">
                        <div class="form-group">
                            <label>Họ và tên<span>*</span></label>
                            <input type="text" id="tenKhachHang" name="tenKhachHang" class="form-control"
                                   placeholder="Nhập họ và tên" autocomplete="off">
                            <span class="field-error" id="errTen"></span>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại<span>*</span></label>
                            <input type="text" id="sdt" name="sdt" class="form-control"
                                   placeholder="Nhập số điện thoại" inputmode="numeric">
                            <span class="field-error" id="errSdt"></span>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" id="email" name="email" class="form-control"
                                   placeholder="example@email.com">
                            <span class="field-error" id="errEmail"></span>
                        </div>

                        <div class="form-group">
                            <label>Ngày sinh</label>
                            <input type="date" id="ngaySinh" name="ngaySinh" class="form-control">
                            <span class="field-error" id="errNgaySinh"></span>
                        </div>

                        <div class="form-group" style="grid-column: span 2;">
                            <label>Giới tính<span>*</span></label>
                            <div class="radio-group">
                                <label class="radio-label">
                                    <input type="radio" name="gioiTinh" value="true" checked> Nam
                                </label>
                                <label class="radio-label">
                                    <input type="radio" name="gioiTinh" value="false"> Nữ
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- DANH SÁCH ĐỊA CHỈ -->
            <div class="form-card">
                <div class="form-card-header">
                    <div class="form-card-title">Danh sách địa chỉ</div>
                    <button type="button" class="btn-add-address" id="btnAddAddress">
                        <i class="fa-solid fa-plus"></i> Thêm địa chỉ
                    </button>
                </div>

                <!-- KHU VỰC CHỨA CÁC THẺ ĐỊA CHỈ -->
                <div id="addressContainer">
                    <!-- Dynamic Address Cards will be rendered here -->
                </div>
            </div>

            <div class="form-actions-footer">
                <button type="button" class="btn btn-outline" onclick="javascript:history.back()">Hủy bỏ</button>
                <button type="button" class="btn btn-primary" onclick="kichHoatXacNhanLuuKH()">Thêm khách hàng</button>
            </div>
        </form>

    </div>
</main>

<script>
    let addressIndex = 0;

    // ================================================================
    //  UTILITY
    // ================================================================
    function removeAccents(str) {
        return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '')
                  .replace(/đ/g,'d').replace(/Đ/g,'D');
    }

    function chuanHoaTen(str) {
        return str.trim().replace(/\s+/g, ' ')
            .split(' ')
            .map(w => w ? w.charAt(0).toUpperCase() + w.slice(1).toLowerCase() : '')
            .join(' ');
    }

    function setError(el, errId, msg) {
        el.classList.add('input-error');
        const sp = document.getElementById(errId);
        if (sp) { sp.textContent = msg; sp.classList.add('show'); }
    }

    function clearError(el, errId) {
        el.classList.remove('input-error');
        const sp = document.getElementById(errId);
        if (sp) { sp.textContent = ''; sp.classList.remove('show'); }
    }

    // ================================================================
    //  VALIDATE KHI SUBMIT
    // ================================================================
    document.getElementById('formAddKH').addEventListener('submit', function(e) {
        e.preventDefault(); // luôn chặn submit thật — chỉ submit qua modal

        let valid = true;

        // --- Họ tên ---
        const tenEl  = document.getElementById('tenKhachHang');
        const tenVal = tenEl.value.trim().replace(/\s+/g, ' ');
        if (!tenVal) {
            setError(tenEl, 'errTen', 'Họ và tên không được để trống.');
            valid = false;
        } else if (!/^[\p{L} ]+$/u.test(tenVal)) {
            setError(tenEl, 'errTen', 'Họ và tên không được chứa số hoặc ký tự đặc biệt.');
            valid = false;
        } else {
            tenEl.value = chuanHoaTen(tenVal);
            clearError(tenEl, 'errTen');
        }

        // --- SĐT ---
        const sdtEl  = document.getElementById('sdt');
        const sdtVal = sdtEl.value.trim();
        if (!sdtVal) {
            setError(sdtEl, 'errSdt', 'Số điện thoại không được để trống.');
            valid = false;
        } else if (!/^0\d{9,10}$/.test(sdtVal)) {
            setError(sdtEl, 'errSdt', 'Số điện thoại phải bắt đầu bằng 0 và có 10–11 chữ số.');
            valid = false;
        } else {
            clearError(sdtEl, 'errSdt');
        }

        // --- Email (tùy chọn, nhưng nếu nhập phải đúng định dạng) ---
        const emailEl  = document.getElementById('email');
        const emailVal = emailEl.value.trim();
        if (emailVal && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailVal)) {
            setError(emailEl, 'errEmail', 'Email không đúng định dạng.');
            valid = false;
        } else {
            clearError(emailEl, 'errEmail');
        }

        // --- Ngày sinh (tùy chọn, nhưng không được ở tương lai) ---
        const nsEl  = document.getElementById('ngaySinh');
        const nsVal = nsEl.value;
        if (nsVal) {
            const ns    = new Date(nsVal);
            const today = new Date(); today.setHours(0,0,0,0);
            if (ns > today) {
                setError(nsEl, 'errNgaySinh', 'Ngày sinh không được lớn hơn ngày hiện tại.');
                valid = false;
            } else {
                clearError(nsEl, 'errNgaySinh');
            }
        }

        if (!valid) {
            const firstErr = document.querySelector('.input-error');
            if (firstErr) firstErr.scrollIntoView({ behavior: 'smooth', block: 'center' });
        } else {
            // Validation pass → mở modal xác nhận
            new bootstrap.Modal(document.getElementById('modalXacNhanLuuKH')).show();
        }
    });

    // ================================================================
    //  XÓA LỖI KHI SỬA
    // ================================================================
    document.getElementById('tenKhachHang').addEventListener('input', function() { clearError(this, 'errTen'); });
    document.getElementById('tenKhachHang').addEventListener('blur', function() {
        if (this.value.trim()) this.value = chuanHoaTen(this.value);
    });
    document.getElementById('sdt').addEventListener('input', function() { clearError(this, 'errSdt'); });
    document.getElementById('email').addEventListener('input', function() { clearError(this, 'errEmail'); });
    document.getElementById('ngaySinh').addEventListener('change', function() { clearError(this, 'errNgaySinh'); });

    // ================================================================
    //  KHỞI TẠO ADDRESS CARD
    // ================================================================
    document.addEventListener('DOMContentLoaded', function () {
        addAddressCard(true);
        document.getElementById('btnAddAddress').addEventListener('click', function () {
            addAddressCard(false);
        });
    });

    function addAddressCard(isFirst = false) {
        const container = document.getElementById('addressContainer');
        const currentIndex = addressIndex++;

        const cardDiv = document.createElement('div');
        cardDiv.className = 'address-card';
        cardDiv.setAttribute('data-index', currentIndex);
        if (isFirst) cardDiv.classList.add('default-address');

        cardDiv.innerHTML = `
        <div class="address-card-header">
            <div class="address-card-title">
                <i class="fa-solid fa-location-dot"></i>
                <span class="card-title-text">\${isFirst ? 'Địa chỉ mặc định' : 'Địa chỉ ' + container.children.length}</span>
            </div>
            \${!isFirst
                ? `<button type="button" class="btn-delete-address" onclick="removeAddressCard(this)">
                    <i class="fa-solid fa-trash"></i> Xóa
                   </button>`
                : '<span style="font-size:12px;color:#10b981;font-weight:600;"><i class="fa-solid fa-check-circle"></i> Mặc định</span>'
            }
        </div>

        <div class="address-grid">
            <div class="form-group">
                <label>Tỉnh/Thành phố <span>*</span></label>
                <div class="searchable-select-wrapper">
                    <input type="text" class="form-control searchable-input province-input"
                           placeholder="Tìm tỉnh/thành..." autocomplete="off"
                           onfocus="openDropdown(this)" oninput="filterOptions(this)">
                    <div class="searchable-dropdown province-dropdown"></div>
                </div>
                <input type="hidden" name="tinhThanh" class="province-name">
                <input type="hidden" name="provinceCode" class="province-code" value="0">
            </div>
            <div class="form-group">
                <label>Quận/Huyện <span>*</span></label>
                <div class="searchable-select-wrapper">
                    <input type="text" class="form-control searchable-input district-input"
                           placeholder="Tìm quận/huyện..." autocomplete="off" disabled
                           onfocus="openDropdown(this)" oninput="filterOptions(this)">
                    <div class="searchable-dropdown district-dropdown"></div>
                </div>
                <input type="hidden" name="quanHuyen" class="district-name">
                <input type="hidden" name="districtCode" class="district-code" value="0">
            </div>
            <div class="form-group">
                <label>Phường/Xã <span>*</span></label>
                <div class="searchable-select-wrapper">
                    <input type="text" class="form-control searchable-input ward-input"
                           placeholder="Tìm phường/xã..." autocomplete="off" disabled
                           onfocus="openDropdown(this)" oninput="filterOptions(this)">
                    <div class="searchable-dropdown ward-dropdown"></div>
                </div>
                <input type="hidden" name="phuongXa" class="ward-name">
                <input type="hidden" name="wardCode" class="ward-code" value="0">
            </div>
        </div>

        <div class="address-detail-grid">
            <div class="form-group">
                <label>Địa chỉ cụ thể <span>*</span></label>
                <input type="text" name="diaChiCuThe" class="form-control" placeholder="Số nhà, tên đường...">
            </div>
            <div class="form-group">
                <label>Loại địa chỉ</label>
                <select name="loaiDiaChi" class="form-control">
                    <option value="Nhà riêng">Nhà riêng</option>
                    <option value="Văn phòng">Văn phòng</option>
                </select>
            </div>
        </div>`;

        container.appendChild(cardDiv);
        loadProvinces(cardDiv.querySelector('.province-input'));
    }

    function removeAddressCard(btn) {
        const container = document.getElementById('addressContainer');
        const card = btn.closest('.address-card');
        if (card.classList.contains('default-address')) {
            alert('Bạn không thể xóa địa chỉ mặc định!');
            return;
        }
        card.remove();
        const cards = container.getElementsByClassName('address-card');
        for (let i = 1; i < cards.length; i++) {
            const titleSpan = cards[i].querySelector('.card-title-text');
            if (titleSpan) titleSpan.textContent = 'Địa chỉ ' + i;
        }
    }

    // ================================================================
    //  SEARCHABLE DROPDOWN
    // ================================================================
    const inputData = new WeakMap();

    function loadProvinces(inputEl) {
        fetch('https://provinces.open-api.vn/api/p/')
            .then(r => r.json())
            .then(data => { inputData.set(inputEl, data.map(p => ({ code: p.code, name: p.name }))); })
            .catch(err => console.error("Lỗi tải Tỉnh/Thành:", err));
    }

    function openDropdown(inputEl) { renderDropdown(inputEl, inputData.get(inputEl) || []); }

    function filterOptions(inputEl) {
        const kw = inputEl.value.trim().toLowerCase();
        const data = inputData.get(inputEl) || [];
        renderDropdown(inputEl, kw
            ? data.filter(i => removeAccents(i.name).toLowerCase().includes(removeAccents(kw)))
            : data);
    }

    function renderDropdown(inputEl, items) {
        const dropdown = inputEl.closest('.searchable-select-wrapper').querySelector('.searchable-dropdown');
        dropdown.innerHTML = '';
        if (!items.length) {
            dropdown.innerHTML = '<div class="sd-item sd-empty">Không tìm thấy kết quả</div>';
        } else {
            items.forEach(item => {
                const div = document.createElement('div');
                div.className = 'sd-item';
                div.textContent = item.name;
                div.addEventListener('mousedown', e => { e.preventDefault(); selectItem(inputEl, item); });
                dropdown.appendChild(div);
            });
        }
        dropdown.style.display = 'block';
    }

    function selectItem(inputEl, item) {
        const card = inputEl.closest('.address-card');
        inputEl.value = item.name;
        inputEl.closest('.searchable-select-wrapper').querySelector('.searchable-dropdown').style.display = 'none';

        if (inputEl.classList.contains('province-input')) {
            card.querySelector('.province-name').value = item.name;
            card.querySelector('.province-code').value = item.code;
            const dInput = card.querySelector('.district-input');
            const wInput = card.querySelector('.ward-input');
            dInput.value = ''; dInput.disabled = false;
            wInput.value = ''; wInput.disabled = true;
            card.querySelector('.district-name').value = '';
            card.querySelector('.district-code').value = '0';
            card.querySelector('.ward-name').value = '';
            card.querySelector('.ward-code').value = '0';
            inputData.delete(dInput); inputData.delete(wInput);
            fetch('https://provinces.open-api.vn/api/p/' + item.code + '?depth=2')
                .then(r => r.json())
                .then(d => { inputData.set(dInput, d.districts.map(x => ({ code: x.code, name: x.name }))); })
                .catch(err => console.error(err));

        } else if (inputEl.classList.contains('district-input')) {
            card.querySelector('.district-name').value = item.name;
            card.querySelector('.district-code').value = item.code;
            const wInput = card.querySelector('.ward-input');
            wInput.value = ''; wInput.disabled = false;
            card.querySelector('.ward-name').value = '';
            card.querySelector('.ward-code').value = '0';
            inputData.delete(wInput);
            fetch('https://provinces.open-api.vn/api/d/' + item.code + '?depth=2')
                .then(r => r.json())
                .then(d => { inputData.set(wInput, d.wards.map(x => ({ code: x.code, name: x.name }))); })
                .catch(err => console.error(err));

        } else if (inputEl.classList.contains('ward-input')) {
            card.querySelector('.ward-name').value = item.name;
            card.querySelector('.ward-code').value = item.code;
        }
    }

    document.addEventListener('click', function(e) {
        if (!e.target.closest('.searchable-select-wrapper')) {
            document.querySelectorAll('.searchable-dropdown').forEach(d => d.style.display = 'none');
        }
    });
</script>

<!-- ===== MODAL XÁC NHẬN THÊM KHÁCH HÀNG ===== -->
<div class="modal fade" id="modalXacNhanLuuKH" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius:16px;overflow:hidden;">
            <div class="p-4 d-flex align-items-start gap-3">
                <div style="width:44px;height:44px;background:#eff6ff;border-radius:10px;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                    <i class="fa-solid fa-user-plus" style="font-size:20px;color:#1a56db;"></i>
                </div>
                <div>
                    <h5 class="fw-bold mb-1" style="font-size:16px;color:#1f2937;">Xác nhận thêm khách hàng</h5>
                    <p class="text-secondary mb-0" style="font-size:13px;line-height:1.6;">
                        Bạn có chắc chắn muốn lưu thông tin khách hàng mới này vào hệ thống không?
                    </p>
                </div>
            </div>
            <div class="d-flex justify-content-end gap-2 px-4 pb-4">
                <button type="button" class="btn btn-outline-secondary fw-semibold px-4"
                        style="font-size:13px;border-radius:8px;" data-bs-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-primary fw-semibold px-4"
                        style="font-size:13px;border-radius:8px;" onclick="xacNhanThucSuLuuKH()">
                    <i class="fa-solid fa-check me-1"></i>Xác nhận lưu
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function kichHoatXacNhanLuuKH() {
    document.getElementById('formAddKH').requestSubmit();
}
function xacNhanThucSuLuuKH() {
    bootstrap.Modal.getInstance(document.getElementById('modalXacNhanLuuKH')).hide();
    document.getElementById('formAddKH').submit();
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
