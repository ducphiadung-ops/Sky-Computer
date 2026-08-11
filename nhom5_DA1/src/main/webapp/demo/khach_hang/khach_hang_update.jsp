<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sửa khách hàng - Skycomputer</title>

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
    .page-title i { font-size: 20px; color: #1a56db; }
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

    .form-grid-fields { display: grid; grid-template-columns: 1fr 1fr; gap: 20px 24px; width: 100%; margin-left: 0; }

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
    .form-control[readonly] { background-color: #f3f4f6; color: var(--text-muted); }

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
    .radio-label input[type="radio"]:checked { border-color: var(--primary); }
    .radio-label input[type="radio"]:checked::before { content: ""; width: 10px; height: 10px; background-color: var(--primary); border-radius: 50%; display: block; }

    /* ADDRESS CARD STYLES */
    .address-card {
      border: 1px solid var(--border-color);
      border-radius: 12px;
      padding: 24px;
      margin-bottom: 20px;
      background: #fff;
      position: relative;
    }

    .address-card.default-address {
      border: 1px solid #10b981;
      box-shadow: 0 0 0 1px #10b981;
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
        <i class="fa-solid fa-user-pen"></i>
        <h2>Sửa thông tin khách hàng</h2>
      </div>
    </div>

    <!-- FORM CẬP NHẬT -->
    <form action="${pageContext.request.contextPath}/khach-hang/cap-nhat" method="post">

      <!-- Giữ ID Khách Hàng dưới dạng hidden -->
      <input type="hidden" name="id" value="${kh.id}">

      <!-- THÔNG TIN CHUNG (ĐỌC DỮ LIỆU TỪ TÊN BIẾN kh) -->
      <div class="form-card">
        <div class="form-card-header">
          <div class="form-card-title">Thông tin chung</div>
        </div>

        <div class="info-layout">
          <!-- avatar-upload-section đã được ẩn, không hiển thị nút Đổi ảnh -->

          <div class="form-grid-fields">
            <div class="form-group">
              <label>Mã khách hàng<span>*</span></label>
              <input type="text" name="maKhachHang" class="form-control" value="${kh.maKhachHang}" readonly>
            </div>

            <div class="form-group">
              <label>Họ và tên<span>*</span></label>
              <input type="text" name="tenKhachHang" class="form-control" value="${kh.tenKhachHang}" required>
            </div>

            <div class="form-group">
              <label>Số điện thoại<span>*</span></label>
              <input type="text" name="sdt" class="form-control" value="${kh.sdt}" required>
            </div>

            <div class="form-group">
              <label>Email<span>*</span></label>
              <input type="email" name="email" class="form-control" value="${kh.email}">
            </div>

            <div class="form-group">
              <label>Ngày sinh<span>*</span></label>
              <input type="date" name="ngaySinh" class="form-control" value="${kh.ngaySinh}">
            </div>

            <div class="form-group">
              <label>Trạng thái</label>
              <select name="trangThai" class="form-control">
                <option value="1" ${kh.trangThai == 1 ? 'selected' : ''}>Hoạt động</option>
                <option value="0" ${kh.trangThai != 1 ? 'selected' : ''}>Ngừng hoạt động</option>
              </select>
            </div>

            <div class="form-group" style="grid-column: span 2;">
              <label>Giới tính<span>*</span></label>
              <div class="radio-group">
                <label class="radio-label">
                  <input type="radio" name="gioiTinh" value="true" ${kh.gioiTinh ? 'checked' : ''}> Nam
                </label>
                <label class="radio-label">
                  <input type="radio" name="gioiTinh" value="false" ${!kh.gioiTinh ? 'checked' : ''}> Nữ
                </label>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- DANH SÁCH ĐỊA CHỈ (DUYỆT TỪ DB BẰNG C:FOREACH) -->
      <div class="form-card">
        <div class="form-card-header">
          <div class="form-card-title">Danh sách địa chỉ</div>
          <button type="button" class="btn-add-address" id="btnAddAddress">
            <i class="fa-solid fa-plus"></i> Thêm địa chỉ
          </button>
        </div>

        <div id="addressContainer">
          <c:forEach var="dc" items="${kh.diaChiKhachHangList}" varStatus="loop">
            <div class="address-card ${loop.first ? 'default-address' : ''}">
              <div class="address-card-header">
                <div class="address-card-title">
                  <i class="fa-solid fa-location-dot"></i>
                  <span class="card-title-text">${loop.first ? 'Địa chỉ mặc định' : 'Địa chỉ '.concat(loop.index + 1)}</span>
                </div>
                <c:choose>
                  <c:when test="${loop.first}">
                                        <span style="font-size: 12px; color: #10b981; font-weight: 600;">
                                            <i class="fa-solid fa-check-circle"></i> Mặc định
                                        </span>
                  </c:when>
                  <c:otherwise>
                    <button type="button" class="btn-delete-address" onclick="removeAddressCard(this)">
                      <i class="fa-solid fa-trash"></i> Xóa
                    </button>
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="address-grid">
                <div class="form-group">
                  <label>Tỉnh/Thành phố <span>*</span></label>
                  <select class="form-control province-select" required onchange="onProvinceChange(this)">
                    <option value="">-- Chọn Tỉnh/Thành --</option>
                  </select>
                  <input type="hidden" name="tinhThanh" class="province-name" value="${dc.tinhThanh}">

                  <input type="hidden" name="provinceCode" class="province-code" value="${dc.diaChiApiMapping.provinceCode}">
                </div>

                <div class="form-group">
                  <label>Quận/Huyện <span>*</span></label>
                  <select class="form-control district-select" required onchange="onDistrictChange(this)">
                    <option value="">-- Chọn Quận/Huyện --</option>
                  </select>
                  <input type="hidden" name="quanHuyen" class="district-name" value="${dc.quanHuyen}">

                  <input type="hidden" name="districtCode" class="district-code" value="${dc.diaChiApiMapping.districtCode}">
                </div>

                <div class="form-group">
                  <label>Phường/Xã <span>*</span></label>
                  <select class="form-control ward-select" required onchange="onWardChange(this)">
                    <option value="">-- Chọn Phường/Xã --</option>
                  </select>
                  <input type="hidden" name="phuongXa" class="ward-name" value="${dc.phuongXa}">

                  <input type="hidden" name="wardCode" class="ward-code" value="${dc.diaChiApiMapping.wardCode}">
                </div>
              </div>

              <div class="address-detail-grid">
                <div class="form-group">
                  <label>Địa chỉ cụ thể <span>*</span></label>
                  <input type="text" name="diaChiCuThe" class="form-control" value="${dc.diaChiCuThe}" placeholder="Số nhà, tên đường..." required>
                </div>
                <div class="form-group">
                  <label>Loại địa chỉ</label>
                  <select name="loaiDiaChi" class="form-control">
                    <option value="Nhà riêng" ${dc.loaiDiaChi == 'Nhà riêng' ? 'selected' : ''}>Nhà riêng</option>
                    <option value="Văn phòng" ${dc.loaiDiaChi == 'Văn phòng' ? 'selected' : ''}>Văn phòng</option>
                  </select>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>

      <div class="form-actions-footer">
        <button type="button" class="btn btn-outline" onclick="javascript:history.back()">Hủy bỏ</button>
        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
      </div>
    </form>

  </div>
</main>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const container = document.getElementById('addressContainer');
    const existingCards = container.querySelectorAll('.address-card');

    // Nếu có địa chỉ truyền từ DB sang -> Nạp dữ liệu API để tự chọn (Selected)
    if (existingCards.length > 0) {
      existingCards.forEach((card) => {
        initExistingCard(card);
      });
    } else {
      // Nếu chưa có địa chỉ nào -> Tạo 1 ô mặc định
      addAddressCard(true);
    }

    document.getElementById('btnAddAddress').addEventListener('click', function () {
      addAddressCard(false);
    });
  });

  // Hàm gọi API load lại Tỉnh/Huyện/Xã đã lưu cho từng ô địa chỉ cũ
  async function initExistingCard(card) {
    const pSelect = card.querySelector('.province-select');
    const dSelect = card.querySelector('.district-select');
    const wSelect = card.querySelector('.ward-select');

    const savedPCode = card.querySelector('.province-code') ? card.querySelector('.province-code').value : '';
    const savedDCode = card.querySelector('.district-code') ? card.querySelector('.district-code').value : '';
    const savedWCode = card.querySelector('.ward-code') ? card.querySelector('.ward-code').value : '';

    const savedPName = card.querySelector('.province-name') ? card.querySelector('.province-name').value : '';
    const savedDName = card.querySelector('.district-name') ? card.querySelector('.district-name').value : '';
    const savedWName = card.querySelector('.ward-name') ? card.querySelector('.ward-name').value : '';

    try {
      // 1. Tải Tỉnh/Thành
      const resP = await fetch('https://provinces.open-api.vn/api/p/');
      const provinces = await resP.json();

      pSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành --</option>';
      provinces.forEach(p => {
        const opt = document.createElement('option');
        opt.value = p.code;
        opt.textContent = p.name;
        if ((savedPCode && savedPCode == p.code) || (savedPName && savedPName.trim() === p.name.trim())) {
          opt.selected = true;
          if(card.querySelector('.province-code')) card.querySelector('.province-code').value = p.code;
          if(card.querySelector('.province-name')) card.querySelector('.province-name').value = p.name;
        }
        pSelect.appendChild(opt);
      });

      const currentPCode = pSelect.value;
      if (!currentPCode) return;

      // 2. Tải Quận/Huyện
      const resD = await fetch('https://provinces.open-api.vn/api/p/' + currentPCode + '?depth=2');
      const pData = await resD.json();

      dSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
      pData.districts.forEach(d => {
        const opt = document.createElement('option');
        opt.value = d.code;
        opt.textContent = d.name;
        if ((savedDCode && savedDCode == d.code) || (savedDName && savedDName.trim() === d.name.trim())) {
          opt.selected = true;
          if(card.querySelector('.district-code')) card.querySelector('.district-code').value = d.code;
          if(card.querySelector('.district-name')) card.querySelector('.district-name').value = d.name;
        }
        dSelect.appendChild(opt);
      });
      dSelect.disabled = false;

      const currentDCode = dSelect.value;
      if (!currentDCode) return;

      // 3. Tải Phường/Xã
      const resW = await fetch('https://provinces.open-api.vn/api/d/' + currentDCode + '?depth=2');
      const dData = await resW.json();

      wSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
      dData.wards.forEach(w => {
        const opt = document.createElement('option');
        opt.value = w.code;
        opt.textContent = w.name;
        if ((savedWCode && savedWCode == w.code) || (savedWName && savedWName.trim() === w.name.trim())) {
          opt.selected = true;
          if(card.querySelector('.ward-code')) card.querySelector('.ward-code').value = w.code;
          if(card.querySelector('.ward-name')) card.querySelector('.ward-name').value = w.name;
        }
        wSelect.appendChild(opt);
      });
      wSelect.disabled = false;

    } catch (err) {
      console.error("Lỗi nạp danh sách địa chỉ cũ:", err);
    }
  }

  // Hàm thêm thẻ địa chỉ mới khi ấn "Thêm địa chỉ"
  function addAddressCard(isFirst = false) {
    const container = document.getElementById('addressContainer');
    const cardDiv = document.createElement('div');

    const currentCount = container.children.length + 1;
    const titleText = isFirst ? 'Địa chỉ mặc định' : 'Địa chỉ ' + currentCount;

    cardDiv.className = 'address-card ' + (isFirst ? 'default-address' : '');

    let headerActionHtml = isFirst
            ? '<span style="font-size: 12px; color: #10b981; font-weight: 600;"><i class="fa-solid fa-check-circle"></i> Mặc định</span>'
            : '<button type="button" class="btn-delete-address" onclick="removeAddressCard(this)"><i class="fa-solid fa-trash"></i> Xóa</button>';

    cardDiv.innerHTML =
            '<div class="address-card-header">' +
            '<div class="address-card-title">' +
            '<i class="fa-solid fa-location-dot"></i>' +
            '<span class="card-title-text">' + titleText + '</span>' +
            '</div>' +
            headerActionHtml +
            '</div>' +

            '<div class="address-grid">' +
            '<div class="form-group">' +
            '<label>Tỉnh/Thành phố <span>*</span></label>' +
            '<select class="form-control province-select" required onchange="onProvinceChange(this)">' +
            '<option value="">-- Chọn Tỉnh/Thành --</option>' +
            '</select>' +
            '<input type="hidden" name="tinhThanh" class="province-name">' +
            '<input type="hidden" name="provinceCode" class="province-code" value="0">' +
            '</div>' +

            '<div class="form-group">' +
            '<label>Quận/Huyện <span>*</span></label>' +
            '<select class="form-control district-select" required disabled onchange="onDistrictChange(this)">' +
            '<option value="">-- Chọn Quận/Huyện --</option>' +
            '</select>' +
            '<input type="hidden" name="quanHuyen" class="district-name">' +
            '<input type="hidden" name="districtCode" class="district-code" value="0">' +
            '</div>' +

            '<div class="form-group">' +
            '<label>Phường/Xã <span>*</span></label>' +
            '<select class="form-control ward-select" required disabled onchange="onWardChange(this)">' +
            '<option value="">-- Chọn Phường/Xã --</option>' +
            '</select>' +
            '<input type="hidden" name="phuongXa" class="ward-name">' +
            '<input type="hidden" name="wardCode" class="ward-code" value="0">' +
            '</div>' +
            '</div>' +

            '<div class="address-detail-grid">' +
            '<div class="form-group">' +
            '<label>Địa chỉ cụ thể <span>*</span></label>' +
            '<input type="text" name="diaChiCuThe" class="form-control" placeholder="Số nhà, tên đường..." required>' +
            '</div>' +
            '<div class="form-group">' +
            '<label>Loại địa chỉ</label>' +
            '<select name="loaiDiaChi" class="form-control">' +
            '<option value="Nhà riêng">Nhà riêng</option>' +
            '<option value="Văn phòng">Văn phòng</option>' +
            '</select>' +
            '</div>' +
            '</div>';

    container.appendChild(cardDiv);
    loadProvinces(cardDiv.querySelector('.province-select'));
  }

  // Xóa thẻ địa chỉ
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
      if (titleSpan) {
        titleSpan.textContent = 'Địa chỉ ' + (i + 1);
      }
    }
  }

  // Tải danh sách Tỉnh/Thành
  function loadProvinces(selectElement) {
    fetch('https://provinces.open-api.vn/api/p/')
            .then(res => res.json())
            .then(data => {
              data.forEach(p => {
                const opt = document.createElement('option');
                opt.value = p.code;
                opt.textContent = p.name;
                selectElement.appendChild(opt);
              });
            })
            .catch(err => console.error("Lỗi tải Tỉnh/Thành:", err));
  }

  function onProvinceChange(select) {
    const card = select.closest('.address-card');
    const pCode = select.value;
    const pText = select.options[select.selectedIndex] ? select.options[select.selectedIndex].text : '';

    const dSelect = card.querySelector('.district-select');
    const wSelect = card.querySelector('.ward-select');

    card.querySelector('.province-name').value = pCode ? pText : '';
    card.querySelector('.province-code').value = pCode || '0';

    dSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
    wSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
    wSelect.disabled = true;

    card.querySelector('.district-name').value = '';
    card.querySelector('.district-code').value = '0';
    card.querySelector('.ward-name').value = '';
    card.querySelector('.ward-code').value = '0';

    if (!pCode) {
      dSelect.disabled = true;
      return;
    }

    fetch('https://provinces.open-api.vn/api/p/' + pCode + '?depth=2')
            .then(res => res.json())
            .then(data => {
              data.districts.forEach(d => {
                const opt = document.createElement('option');
                opt.value = d.code;
                opt.textContent = d.name;
                dSelect.appendChild(opt);
              });
              dSelect.disabled = false;
            })
            .catch(err => console.error("Lỗi tải Quận/Huyện:", err));
  }

  function onDistrictChange(select) {
    const card = select.closest('.address-card');
    const dCode = select.value;
    const dText = select.options[select.selectedIndex] ? select.options[select.selectedIndex].text : '';

    const wSelect = card.querySelector('.ward-select');

    card.querySelector('.district-name').value = dCode ? dText : '';
    card.querySelector('.district-code').value = dCode || '0';

    wSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
    card.querySelector('.ward-name').value = '';
    card.querySelector('.ward-code').value = '0';

    if (!dCode) {
      wSelect.disabled = true;
      return;
    }

    fetch('https://provinces.open-api.vn/api/d/' + dCode + '?depth=2')
            .then(res => res.json())
            .then(data => {
              data.wards.forEach(w => {
                const opt = document.createElement('option');
                opt.value = w.code;
                opt.textContent = w.name;
                wSelect.appendChild(opt);
              });
              wSelect.disabled = false;
            })
            .catch(err => console.error("Lỗi tải Phường/Xã:", err));
  }

  function onWardChange(select) {
    const card = select.closest('.address-card');
    const wCode = select.value;
    const wText = select.options[select.selectedIndex] ? select.options[select.selectedIndex].text : '';

    card.querySelector('.ward-name').value = wCode ? wText : '';
    card.querySelector('.ward-code').value = wCode || '0';
  }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>