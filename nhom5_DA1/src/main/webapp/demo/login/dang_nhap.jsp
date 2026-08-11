<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/7/2026
  Time: 11:15 PM
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Skycomputer</title>

    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- FontAwesome Icons (Dùng cho icon Google nếu cần) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary-color: #1a56db;
            --primary-hover: #154cbf;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border-color: #e5e7eb;
            --bg-body: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-color: var(--bg-body);
            color: var(--text-main);
        }

        /* Container bao trọn 2 bên */
        .login-container {
            display: flex;
            width: 100%;
            max-width: 1000px;
            padding: 0 40px;
            align-items: center;
            gap: 80px; /* Khoảng cách giữa logo và form */
        }

        /* --- PHẦN LOGO BÊN TRÁI (ĐÃ CẤU HÌNH ĐỂ THAY ẢNH DỄ DÀNG) --- */
        .login-logo-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            max-width: 450px;
            height: 450px; /* Khung cố định chiều cao */
        }

        .login-logo-wrapper img {
            width: 100%;
            height: 100%;
            /*
               Mẹo: 'contain' giúp ảnh tự co giãn vừa khung mà KHÔNG bị bóp méo tỉ lệ.
               Bạn chỉ cần thay đường dẫn ảnh ở thẻ <img> bên dưới là xong.
            */
            object-fit: contain;
        }

        /* --- PHẦN FORM ĐĂNG NHẬP BÊN PHẢI --- */
        .login-form-wrapper {
            width: 380px;
            display: flex;
            flex-direction: column;
        }

        .login-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .login-header h2 {
            font-size: 28px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .login-header p {
            font-size: 14px;
            color: var(--text-muted);
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 20px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-main);
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
            color: var(--text-main);
        }

        .form-control::placeholder {
            color: #9ca3af;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(26, 86, 219, 0.1);
        }

        /* Remember và Forgot password */
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            margin-bottom: 24px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-muted);
            cursor: pointer;
        }

        .remember-me input {
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .forgot-link {
            color: #2563eb;
            text-decoration: none;
            font-weight: 500;
        }

        .forgot-link:hover {
            text-decoration: underline;
        }

        /* Các nút bấm */
        .btn {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            border: none;
            transition: background 0.2s;
            margin-bottom: 12px;
        }

        .btn-submit {
            background-color: var(--primary-color);
            color: #ffffff;
        }

        .btn-submit:hover {
            background-color: var(--primary-hover);
        }

        .btn-google {
            background-color: #ffffff;
            color: var(--text-main);
            border: 1px solid var(--border-color);
        }

        .btn-google:hover {
            background-color: #f9fafb;
        }

        .btn-google img {
            width: 18px;
            height: 18px;
        }

        /* Hàng đăng ký cuối cùng */
        .signup-text {
            text-align: center;
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 16px;
        }

        .signup-text a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 600;
        }

        .signup-text a:hover {
            text-decoration: underline;
        }

        /* Responsive cho màn hình nhỏ */
        @media (max-width: 850px) {
            .login-container {
                justify-content: center;
                padding: 20px;
            }
            .login-logo-wrapper {
                display: none; /* Ẩn logo ở màn hình điện thoại nhỏ */
            }
        }
    </style>
</head>
<body>

<div class="login-container">

    <!-- 1. KHU VỰC LOGO BÊN TRÁI -->
    <div class="login-logo-wrapper">
        <!-- Sau này bạn chỉ cần sửa đường dẫn src này thành ảnh mới của bạn -->
        <img src="/img/logo.jpg">
    </div>

    <!-- 2. KHU VỰC FORM ĐĂNG NHẬP BÊN PHẢI -->
    <div class="login-form-wrapper">
        <div class="login-header">
            <h2>Đăng nhập</h2>
            <p>Chào mừng bạn quay trở lại</p>
        </div>

        <form action="/login/dang_nhap" method="POST">
            <!-- Thông báo lỗi -->
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div style="background:#fef2f2; border:1px solid #fca5a5; border-radius:8px; padding:12px 16px; margin-bottom:20px; display:flex; align-items:center; gap:10px; font-size:13px; color:#dc2626;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>

            <!-- Tài khoản -->
            <div class="form-group">
                <label for="username">Tài khoản</label>
                <input type="text" id="username" name="username" class="form-control"
                       placeholder="Nhập tên tài khoản" required
                       value="<%= request.getAttribute("oldUsername") != null ? request.getAttribute("oldUsername") : "" %>">
            </div>

            <!-- Mật khẩu -->
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="********" required>
            </div>

            <!-- Tuỳ chọn mở rộng -->
            <div class="form-options">
                <label class="remember-me">
                    <input type="checkbox" name="remember"> Ghi nhớ đăng nhập
                </label>
            </div>

            <!-- Nút đăng nhập -->
            <button type="submit" class="btn btn-submit">Đăng nhập</button>
        </form>

        <div class="signup-text">
            Skycomputer &copy; 2025 &mdash; Hệ thống quản lý nội bộ
        </div>
    </div>

</div>

</body>
</html>