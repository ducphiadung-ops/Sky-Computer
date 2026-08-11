<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
    Sidebar & Header dùng chung cho toàn bộ các trang quản trị.
    Truyền tham số:
        activeMenu  : tên menu đang active (san-pham | hoa-don | khach-hang | nhan-vien | thuoc-tinh | tong-quan | ban-hang)
        activeSub   : tên sub-menu đang active (hien-thi-sp | chi-tiet-sp | cpu | ram | o-cung | gpu | man-hinh | mau-sac | pin | danh-muc | thuong-hieu)
--%>
<c:set var="nv" value="${sessionScope.nhanVien}" />
<%-- Kiểm tra chức vụ nhân viên không phân biệt dấu/hoa/thường --%>
<%-- Chuẩn hóa: dùng Java scriptlet để normalize --%>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    request.setAttribute("isNhanVien", _isNhanVien);
%>
<%-- Map các jsp:param vào biến local để dùng trong EL --%>
<c:set var="activeMenu" value="${param.activeMenu}" />
<c:set var="activeSub"  value="${param.activeSub}" />

<!-- ===== SIDEBAR ===== -->
<aside class="sidebar">
    <div class="brand">
        <div class="brand-logo">
            <img src="${pageContext.request.contextPath}/img/logo.jpg" alt="Skycomputer Logo">
        </div>
        <div class="brand-text">
            <h1>Skycomputer</h1>
            <p>Hệ thống quản lý</p>
        </div>
    </div>

    <ul class="nav-menu">

        <%-- Trang thống kê: ẩn với nhân viên --%>
        <c:if test="${not isNhanVien}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/tong_quan"
                   class="nav-link-custom ${activeMenu == 'tong-quan' ? 'active' : ''}">
                    <i class="fa-solid fa-border-all"></i> Trang thống kê
                </a>
            </li>
        </c:if>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/hoa-don/ban-hang"
               class="nav-link-custom ${activeMenu == 'ban-hang' ? 'active' : ''}">
                <i class="fa-solid fa-store"></i> Bán hàng tại quầy
            </a>
        </li>

        <%-- Quản lý sản phẩm --%>
        <li class="nav-item">
            <button type="button"
               class="nav-link-custom d-flex justify-content-between align-items-center w-100 text-start bg-transparent border-0 ${activeMenu == 'san-pham' ? 'active' : ''}"
               data-bs-toggle="collapse" data-bs-target="#sub-san-pham"
               aria-expanded="${activeMenu == 'san-pham' ? 'true' : 'false'}">
                <span><i class="fa-solid fa-box"></i> Quản lý sản phẩm</span>
                <i class="fa-solid fa-chevron-down" style="font-size:10px;transition:transform 0.2s;"></i>
            </button>
            <div class="collapse ${activeMenu == 'san-pham' ? 'show' : ''}" id="sub-san-pham">
                <ul class="sub-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/san-pham/hien-thi"
                           class="nav-link-custom ${activeSub == 'hien-thi-sp' ? 'active-sub' : ''}">
                            <i class="fa-solid fa-list me-1"></i> Danh sách sản phẩm
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi"
                           class="nav-link-custom ${activeSub == 'chi-tiet-sp' ? 'active-sub' : ''}">
                            <i class="fa-solid fa-circle-info me-1"></i> Sản phẩm chi tiết
                        </a>
                    </li>
                </ul>
            </div>
        </li>

        <%-- Dropdown Quản lý thuộc tính --%>
        <li class="nav-item">
            <button type="button"
               class="nav-link-custom d-flex justify-content-between align-items-center w-100 text-start bg-transparent border-0 ${activeMenu == 'thuoc-tinh' ? 'active' : ''}"
               data-bs-toggle="collapse" data-bs-target="#sub-thuoc-tinh"
               aria-expanded="${activeMenu == 'thuoc-tinh' ? 'true' : 'false'}">
                <span><i class="fa-solid fa-sliders"></i> Quản lý thuộc tính</span>
                <i class="fa-solid fa-chevron-down" style="font-size:10px;transition:transform 0.2s;"></i>
            </button>
            <div class="collapse ${activeMenu == 'thuoc-tinh' ? 'show' : ''}" id="sub-thuoc-tinh">
                <ul class="sub-menu">
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/cpu/hien-thi"        class="nav-link-custom ${activeSub=='cpu'        ?'active-sub':''}"><i class="fa-solid fa-microchip me-1"></i> Cấu hình CPU</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/ram/hien-thi"        class="nav-link-custom ${activeSub=='ram'        ?'active-sub':''}"><i class="fa-solid fa-memory me-1"></i> Cấu hình RAM</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/o-cung/hien-thi"    class="nav-link-custom ${activeSub=='o-cung'     ?'active-sub':''}"><i class="fa-solid fa-hard-drive me-1"></i> Ổ cứng</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/gpu/hien-thi"        class="nav-link-custom ${activeSub=='gpu'        ?'active-sub':''}"><i class="fa-solid fa-clone me-1"></i> Card đồ họa (GPU)</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/man-hinh/hien-thi"  class="nav-link-custom ${activeSub=='man-hinh'   ?'active-sub':''}"><i class="fa-solid fa-display me-1"></i> Màn hình</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/hien-thi"   class="nav-link-custom ${activeSub=='mau-sac'    ?'active-sub':''}"><i class="fa-solid fa-palette me-1"></i> Màu sắc</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/pin/hien-thi"       class="nav-link-custom ${activeSub=='pin'        ?'active-sub':''}"><i class="fa-solid fa-battery-three-quarters me-1"></i> Thông số Pin</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/danh-muc/hien-thi"  class="nav-link-custom ${activeSub=='danh-muc'   ?'active-sub':''}"><i class="fa-solid fa-layer-group me-1"></i> Danh mục sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/thuong-hieu/hien-thi" class="nav-link-custom ${activeSub=='thuong-hieu'?'active-sub':''}"><i class="fa-solid fa-copyright me-1"></i> Thương hiệu</a></li>
                </ul>
            </div>
        </li>

        <%-- Quản lý hóa đơn --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/hoa-don/hien-thi"
               class="nav-link-custom ${activeMenu == 'hoa-don' ? 'active' : ''}">
                <i class="fa-solid fa-file-invoice"></i> Quản lý hóa đơn
            </a>
        </li>

        <%-- Quản lý khách hàng --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/khach-hang/hien-thi"
               class="nav-link-custom ${activeMenu == 'khach-hang' ? 'active' : ''}">
                <i class="fa-solid fa-users"></i> Quản lý khách hàng
            </a>
        </li>

        <%-- Quản lý nhân viên: ẩn với nhân viên --%>
        <c:if test="${not isNhanVien}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi"
                   class="nav-link-custom ${activeMenu == 'nhan-vien' ? 'active' : ''}">
                    <i class="fa-solid fa-id-badge"></i> Quản lý nhân viên
                </a>
            </li>
        </c:if>
    </ul>

    <div class="logout-item">
        <a href="${pageContext.request.contextPath}/dang-xuat" class="nav-link-custom logout-link">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</aside>

<%-- ===== HEADER được render bên trong main-wrapper của mỗi trang ===== --%>
<%-- Các trang sẽ mở <main class="main-wrapper"> sau khi include file này --%>

