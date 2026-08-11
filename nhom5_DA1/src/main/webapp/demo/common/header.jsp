<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="nv" value="${sessionScope.nhanVien}" />
<c:set var="displayName" value="${nv != null ? nv.hoTen : 'Admin'}" />
<c:set var="displayRole" value="${nv != null ? nv.chucVu : 'Quản trị viên'}" />
<header class="top-header">
    <div class="header-actions">
        <div class="notification">
            <i class="fa-regular fa-bell"></i>
        </div>
        <div class="user-profile">
            <div class="user-info">
                <div class="user-name">${displayName}</div>
                <div class="user-role">${displayRole}</div>
            </div>
            <img src="https://i.pravatar.cc/150?img=11" alt="Avatar" class="avatar">
        </div>
    </div>
</header>
