<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/7/2026
  Time: 11:30 PM
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo tài khoản - Skycomputer</title>

    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

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
        .register-container {
            display: flex;
            width: 100%;
            max-width: 1000px;
            padding: 0 40px;
            align-items: center;
            gap: 80px; /* Khoảng cách giữa logo và form */
        }

        /* --- PHẦN LOGO BÊN TRÁI --- */
        .register-logo-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            max-width: 450px;
            height: 450px;
        }

        .register-logo-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: contain; /* Đảm bảo giữ nguyên tỷ lệ của logo Sky Computer */
        }

        /* --- PHẦN FORM ĐĂNG KÝ BÊN PHẢI --- */
        .register-form-wrapper {
            width: 380px;
            display: flex;
            flex-direction: column;
        }

        .register-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .register-header h2 {
            font-size: 28px;
            font-weight: 700;
            color: #1f2937;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 16px;
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

        /* Dòng ghi chú nhỏ dưới ô mật khẩu giống thiết kế mẫu */
        .hint-text {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
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
        }

        .btn-submit {
            background-color: var(--primary-color);
            color: #ffffff;
            margin-top: 24px;
            margin-bottom: 12px;
        }

        .btn-submit:hover {
            background-color: var(--primary-hover);
        }

        .btn-google {
            background-color: #ffffff;
            color: var(--text-main);
            border: 1px solid var(--border-color);
            margin-bottom: 24px;
        }

        .btn-google:hover {
            background-color: #f9fafb;
        }

        /* Hàng đăng nhập cuối cùng */
        .login-text {
            text-align: center;
            font-size: 13px;
            color: var(--text-muted);
        }

        .login-text a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 600;
        }

        .login-text a:hover {
            text-decoration: underline;
        }

        /* Responsive cho màn hình nhỏ */
        @media (max-width: 850px) {
            .register-container {
                justify-content: center;
                padding: 20px;
            }
            .register-logo-wrapper {
                display: none; /* Ẩn logo ở màn hình điện thoại nhỏ */
            }
        }
    </style>
</head>
<body>

<div class="register-container">

    <!-- 1. KHU VỰC LOGO BÊN TRÁI -->
    <div class="register-logo-wrapper">
        <img src="/img/logo.jpg">
    </div>

    <!-- 2. KHU VỰC FORM ĐĂNG KÝ BÊN PHẢI -->
    <div class="register-form-wrapper">
        <div class="register-header">
            <h2>Tạo tài khoản</h2>
        </div>

        <form action="/login/dang_nhap" method="POST">
            <!-- Name* -->
            <div class="form-group">
                <label for="fullName">Name*</label>
                <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Nhập tên của bạn" required>
            </div>

            <!-- Email* -->
            <div class="form-group">
                <label for="email">Email*</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="Nhập Email của bạn" required>
            </div>

            <!-- Password* -->
            <div class="form-group">
                <label for="password">Password*</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Tạo mật khẩu" minlength="8" required>
                <div class="hint-text">Mật khẩu phải có ít nhất 8 ký tự.</div>
            </div>

            <!-- Nút Tạo tài khoản -->
            <button type="submit" class="btn btn-submit">Đăng kí</button>

            <!-- Nút Sign up với Google -->
            <button type="button" class="btn btn-google">
                <svg width="18" height="18" viewBox="0 0 24 24">
                    <path fill="#4285F4" d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v3.92h6.61c-.29 1.53-1.14 2.82-2.4 3.68v3.05h3.88c2.27-2.09 3.66-5.17 3.66-8.58z"/>
                    <path fill="#34A853" d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.88-3.05c-1.08.72-2.45 1.16-4.05 1.16-3.11 0-5.74-2.11-6.68-4.96H1.21v3.15C3.18 21.88 7.31 24 12 24z"/>
                    <path fill="#FBBC05" d="M5.32 14.24A7.16 7.16 0 0 1 5 12c0-.79.13-1.57.32-2.34V6.51H1.21A11.94 11.94 0 0 0 0 12c0 1.92.45 3.74 1.21 5.39l4.11-3.15z"/>
                    <path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.31 0 3.18 2.12 1.21 5.65l4.11 3.15c.94-2.85 3.57-4.96 6.68-4.96z"/>
                </svg>
                Sign up with Google
            </button>
        </form>

        <!-- Chuyển hướng về đăng nhập -->
        <div class="login-text">
            Already have an account? <a href="/login/dang_nhap">Log in</a>
        </div>
    </div>

</div>

</body>
</html>