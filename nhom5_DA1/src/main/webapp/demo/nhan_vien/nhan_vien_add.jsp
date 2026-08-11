<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm nhân viên mới - Skycomputer</title>

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

        /* --- FORM HEADER & CARD --- */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-title h2 { font-size: 20px; font-weight: 600; margin-bottom: 4px; }
        .page-title p { font-size: 13px; color: var(--text-muted); }

        .btn { padding: 10px 20px; border-radius: 6px; font-size: 13px; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 8px; border: none; transition: 0.2s; text-decoration: none;}
        .btn-outline { background: #fff; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-outline:hover { background: #f9fafb; }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: #154cbf; }

        .form-card {
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            margin-bottom: 32px;
        }

        .section-title {
            font-size: 14px;
            font-weight: 600;
            color: #1e3a8a;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 20px;
            padding-bottom: 8px;
            border-bottom: 2px solid var(--primary-light);
        }

        /* --- FORM GRID SYSTEM --- */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-bottom: 32px;
        }

        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group.span-2 { grid-column: span 2; }
        .form-group.span-3 { grid-column: span 3; }

        .form-group label { font-size: 13px; font-weight: 500; color: var(--text-main); }
        .form-group label span { color: #dc2626; margin-left: 2px; }

        .input-wrapper { position: relative; }
        .input-wrapper i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 14px;}

        .form-control { width: 100%; padding: 11px 14px 11px 38px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 13.5px; color: var(--text-main); outline: none; transition: 0.2s; }
        .form-control:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(26,86,219,0.1); }

        select.form-control { padding-left: 14px; appearance: none; background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="%236b7280" viewBox="0 0 16 16"><path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/></svg>') no-repeat right 14px center; }
        select.form-control:focus { padding-left: 14px; }

        /* --- RADIO OPTIONS GROUP --- */
        .radio-group {
            display: flex;
            gap: 24px;
            padding: 11px 0;
        }
        .radio-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13.5px;
            cursor: pointer;
            color: var(--text-main);
        }
        .radio-label input[type="radio"] {
            width: 16px;
            height: 16px;
            accent-color: var(--primary);
            cursor: pointer;
        }

        /* --- ACTION BUTTONS --- */
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
        }

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
        /* Alert lỗi từ server */
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
    <jsp:param name="activeMenu" value="nhan-vien"/>
</jsp:include>

<main class="main-wrapper">
    <%-- HEADER --%>
    <jsp:include page="/demo/common/header.jsp"/>

    <!-- Content Area -->
    <div class="content-area">

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title">
                <h2>Thêm nhân viên mới</h2>
                <p>Khởi tạo thông tin hồ sơ nhân sự và phân quyền tài khoản làm việc trên hệ thống.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-outline">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </div>

        <!-- FORM CARD CHÍNH -->
        <div class="form-card">
            <form id="formAddNV" action="${pageContext.request.contextPath}/nhan-vien/add" method="POST" novalidate>

                <%-- Hiển thị lỗi từ server (nếu có) --%>
                <c:if test="${not empty errorMsg}">
                    <div class="alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <span>${errorMsg}</span>
                    </div>
                </c:if>

                <!-- PHẦN 1: THÔNG TIN CÁ NHÂN -->
                <div class="section-title">Thông tin cơ bản</div>
                <div class="form-grid">

                    <div class="form-group">
                        <label>Họ và tên <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-user"></i>
                            <input type="text" id="hoTen" name="hoTen" class="form-control"
                                   placeholder="Nhập tên nhân viên" autocomplete="off">
                        </div>
                        <span class="field-error" id="errHoTen"></span>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-phone"></i>
                            <input type="tel" id="sdt" name="sdt" class="form-control"
                                   placeholder="Nhập số điện thoại" inputmode="numeric">
                        </div>
                        <span class="field-error" id="errSdt"></span>
                    </div>

                    <div class="form-group">
                        <label>Giới tính <span>*</span></label>
                        <div class="radio-group">
                            <label class="radio-label">
                                <input type="radio" name="gioiTinh" value="true" checked>
                                <i class="fa-solid fa-mars" style="color: #1d4ed8;"></i> Nam
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="gioiTinh" value="false">
                                <i class="fa-solid fa-venus" style="color: #db2777;"></i> Nữ
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Ngày sinh <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-calendar"></i>
                            <input type="date" id="ngaySinh" name="ngaySinh" class="form-control">
                        </div>
                        <span class="field-error" id="errNgaySinh"></span>
                    </div>

                    <div class="form-group">
                        <label>Email <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-envelope"></i>
                            <input type="email" id="email" name="email" class="form-control"
                                   placeholder="example@skycomputer.com">
                        </div>
                        <span class="field-error" id="errEmail"></span>
                    </div>

                    <div class="form-group">
                        <label>Chức vụ <span>*</span></label>
                        <select name="chucVu" class="form-control" required>
                            <option value="" disabled selected>Chọn chức vụ...</option>
                            <option value="Quản Lý">Quản Lý</option>
                            <option value="Nhân viên">Nhân viên</option>
                        </select>
                    </div>

                </div>

                <!-- ĐỊA CHỈ CƯ TRÚ (SEARCHABLE DROPDOWN) -->
                <div class="section-title">Địa chỉ cư trú</div>
                <div class="form-grid">

                    <div class="form-group">
                        <label>Tỉnh / Thành phố <span>*</span></label>
                        <div class="searchable-select-wrapper">
                            <input type="text" id="provinceInput" class="form-control searchable-input province-input"
                                   placeholder="Tìm tỉnh/thành..."
                                   autocomplete="off"
                                   onfocus="openDropdown(this)"
                                   oninput="filterOptions(this)">
                            <div class="searchable-dropdown province-dropdown"></div>
                        </div>
                        <input type="hidden" name="tinhThanh" class="province-name">
                    </div>

                    <div class="form-group">
                        <label>Quận / Huyện <span>*</span></label>
                        <div class="searchable-select-wrapper">
                            <input type="text" id="districtInput" class="form-control searchable-input district-input"
                                   placeholder="Tìm quận/huyện..."
                                   autocomplete="off"
                                   disabled
                                   onfocus="openDropdown(this)"
                                   oninput="filterOptions(this)">
                            <div class="searchable-dropdown district-dropdown"></div>
                        </div>
                        <input type="hidden" name="quanHuyen" class="district-name">
                    </div>

                    <div class="form-group">
                        <label>Phường / Xã <span>*</span></label>
                        <div class="searchable-select-wrapper">
                            <input type="text" id="wardInput" class="form-control searchable-input ward-input"
                                   placeholder="Tìm phường/xã..."
                                   autocomplete="off"
                                   disabled
                                   onfocus="openDropdown(this)"
                                   oninput="filterOptions(this)">
                            <div class="searchable-dropdown ward-dropdown"></div>
                        </div>
                        <input type="hidden" name="phuongXa" class="ward-name">
                    </div>

                    <div class="form-group span-3">
                        <label>Số nhà, tên đường, ngõ hẻm <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-location-dot"></i>
                            <input type="text" id="diaChiChiTiet" name="diaChiChiTiet" class="form-control"
                                   placeholder="Ví dụ: Số 45 Nguyễn Văn Linh...">
                        </div>
                        <span class="field-error" id="errDiaChi"></span>
                    </div>

                </div>

                <!-- CỤM NÚT LƯU FORM -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-outline">Hủy bỏ</a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu nhân viên
                    </button>
                </div>

            </form>
        </div>

    </div>
</main>

<!-- JAVASCRIPT XỬ LÝ VALIDATE + ĐỊA CHỈ -->
<script>
    // ================================================================
    //  UTILITY
    // ================================================================
    function removeAccents(str) {
        return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '')
                  .replace(/đ/g, 'd').replace(/Đ/g, 'D');
    }

    // Viết hoa chữ cái đầu mỗi từ, thu gọn khoảng trắng
    function chuanHoaTen(str) {
        return str.trim().replace(/\s+/g, ' ')
            .split(' ')
            .map(w => w ? w.charAt(0).toUpperCase() + w.slice(1).toLowerCase() : '')
            .join(' ');
    }

    function setError(inputEl, errSpanId, msg) {
        inputEl.classList.add('input-error');
        const span = document.getElementById(errSpanId);
        if (span) { span.textContent = msg; span.classList.add('show'); }
    }

    function clearError(inputEl, errSpanId) {
        inputEl.classList.remove('input-error');
        const span = document.getElementById(errSpanId);
        if (span) { span.textContent = ''; span.classList.remove('show'); }
    }

    // ================================================================
    //  VALIDATE KHI SUBMIT
    // ================================================================
    document.getElementById('formAddNV').addEventListener('submit', function(e) {
        let valid = true;

        // --- Họ tên ---
        const hoTenEl = document.getElementById('hoTen');
        const tenVal  = hoTenEl.value.trim().replace(/\s+/g, ' ');
        if (!tenVal) {
            setError(hoTenEl, 'errHoTen', 'Họ và tên không được để trống.');
            valid = false;
        } else if (!/^[\p{L} ]+$/u.test(tenVal)) {
            setError(hoTenEl, 'errHoTen', 'Họ và tên không được chứa số hoặc ký tự đặc biệt.');
            valid = false;
        } else {
            hoTenEl.value = chuanHoaTen(tenVal);
            clearError(hoTenEl, 'errHoTen');
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

        // --- Email ---
        const emailEl  = document.getElementById('email');
        const emailVal = emailEl.value.trim();
        if (!emailVal) {
            setError(emailEl, 'errEmail', 'Email không được để trống.');
            valid = false;
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailVal)) {
            setError(emailEl, 'errEmail', 'Email không đúng định dạng.');
            valid = false;
        } else {
            clearError(emailEl, 'errEmail');
        }

        // --- Ngày sinh ---
        const nsEl  = document.getElementById('ngaySinh');
        const nsVal = nsEl.value;
        if (!nsVal) {
            setError(nsEl, 'errNgaySinh', 'Ngày sinh không được để trống.');
            valid = false;
        } else {
            const ns    = new Date(nsVal);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            if (ns > today) {
                setError(nsEl, 'errNgaySinh', 'Ngày sinh không được lớn hơn ngày hiện tại.');
                valid = false;
            } else {
                // Kiểm tra >= 18 tuổi
                const age18 = new Date(ns);
                age18.setFullYear(age18.getFullYear() + 18);
                if (age18 > today) {
                    setError(nsEl, 'errNgaySinh', 'Nhân viên phải đủ 18 tuổi trở lên.');
                    valid = false;
                } else {
                    clearError(nsEl, 'errNgaySinh');
                }
            }
        }

        // --- Địa chỉ (Tỉnh/Huyện/Xã + số nhà) ---
        const tinhEl     = document.querySelector('.province-name');
        const huyenEl    = document.querySelector('.district-name');
        const xaEl       = document.querySelector('.ward-name');
        const soNhaEl    = document.getElementById('diaChiChiTiet');
        const tinhInput  = document.querySelector('.province-input');

        const diaChiThieu = !tinhEl.value.trim() || !huyenEl.value.trim()
                          || !xaEl.value.trim()  || !soNhaEl.value.trim();
        if (diaChiThieu) {
            tinhInput.classList.add('input-error');
            soNhaEl.classList.add('input-error');
            const errDC = document.getElementById('errDiaChi');
            if (errDC) {
                errDC.textContent = 'Vui lòng điền đầy đủ địa chỉ (Tỉnh/Thành, Quận/Huyện, Phường/Xã và số nhà).';
                errDC.classList.add('show');
            }
            valid = false;
        } else {
            tinhInput.classList.remove('input-error');
            soNhaEl.classList.remove('input-error');
            const errDC = document.getElementById('errDiaChi');
            if (errDC) { errDC.textContent = ''; errDC.classList.remove('show'); }
        }

        if (!valid) {
            e.preventDefault();
            // Cuộn lên lỗi đầu tiên
            const firstErr = document.querySelector('.input-error');
            if (firstErr) firstErr.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    });

    // ================================================================
    //  XÓA LỖI KHI NGƯỜI DÙNG BẮT ĐẦU SỬA
    // ================================================================
    document.getElementById('hoTen').addEventListener('input', function() {
        clearError(this, 'errHoTen');
    });
    document.getElementById('hoTen').addEventListener('blur', function() {
        if (this.value.trim()) this.value = chuanHoaTen(this.value);
    });
    document.getElementById('sdt').addEventListener('input', function() {
        clearError(this, 'errSdt');
    });
    document.getElementById('email').addEventListener('input', function() {
        clearError(this, 'errEmail');
    });
    document.getElementById('ngaySinh').addEventListener('change', function() {
        clearError(this, 'errNgaySinh');
    });
    document.getElementById('diaChiChiTiet').addEventListener('input', function() {
        clearError(this, 'errDiaChi');
    });

    // ================================================================
    //  SEARCHABLE DROPDOWN — ĐỊA CHỈ
    // ================================================================
    const inputData = new WeakMap(); // input → [{code, name}]

    document.addEventListener('DOMContentLoaded', function () {
        const provinceInput = document.querySelector('.province-input');
        loadProvinces(provinceInput);

        document.addEventListener('click', function (e) {
            if (!e.target.closest('.searchable-select-wrapper')) {
                document.querySelectorAll('.searchable-dropdown').forEach(d => d.style.display = 'none');
            }
        });
    });

    function loadProvinces(inputEl) {
        fetch('https://provinces.open-api.vn/api/p/')
            .then(res => res.json())
            .then(data => { inputData.set(inputEl, data.map(p => ({ code: p.code, name: p.name }))); })
            .catch(err => console.error("Lỗi tải Tỉnh/Thành:", err));
    }

    function openDropdown(inputEl) {
        renderDropdown(inputEl, inputData.get(inputEl) || []);
    }

    function filterOptions(inputEl) {
        const kw   = inputEl.value.trim().toLowerCase();
        const data = inputData.get(inputEl) || [];
        renderDropdown(inputEl, kw
            ? data.filter(i => removeAccents(i.name).toLowerCase().includes(removeAccents(kw)))
            : data);
    }

    function renderDropdown(inputEl, items) {
        const wrapper  = inputEl.closest('.searchable-select-wrapper');
        const dropdown = wrapper.querySelector('.searchable-dropdown');
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
        const formGrid = inputEl.closest('.form-grid');
        inputEl.value  = item.name;
        inputEl.classList.remove('input-error');
        wrapper_hide(inputEl);

        if (inputEl.classList.contains('province-input')) {
            formGrid.querySelector('.province-name').value = item.name;
            const dInput = formGrid.querySelector('.district-input');
            const wInput = formGrid.querySelector('.ward-input');
            dInput.value = ''; dInput.disabled = false;
            wInput.value = ''; wInput.disabled = true;
            formGrid.querySelector('.district-name').value = '';
            formGrid.querySelector('.ward-name').value = '';
            inputData.delete(dInput); inputData.delete(wInput);
            fetch('https://provinces.open-api.vn/api/p/' + item.code + '?depth=2')
                .then(r => r.json())
                .then(d => { inputData.set(dInput, d.districts.map(x => ({ code: x.code, name: x.name }))); })
                .catch(err => console.error(err));

        } else if (inputEl.classList.contains('district-input')) {
            formGrid.querySelector('.district-name').value = item.name;
            const wInput = formGrid.querySelector('.ward-input');
            wInput.value = ''; wInput.disabled = false;
            formGrid.querySelector('.ward-name').value = '';
            inputData.delete(wInput);
            fetch('https://provinces.open-api.vn/api/d/' + item.code + '?depth=2')
                .then(r => r.json())
                .then(d => { inputData.set(wInput, d.wards.map(x => ({ code: x.code, name: x.name }))); })
                .catch(err => console.error(err));

        } else if (inputEl.classList.contains('ward-input')) {
            formGrid.querySelector('.ward-name').value = item.name;
        }
    }

    function wrapper_hide(inputEl) {
        inputEl.closest('.searchable-select-wrapper')
               .querySelector('.searchable-dropdown').style.display = 'none';
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>