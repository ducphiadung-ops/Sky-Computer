<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ví dụ hiển thị QR Code Hóa Đơn</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .qr-section {
            margin: 30px 0;
            padding: 20px;
            border: 2px dashed #ddd;
            text-align: center;
        }
        .qr-code-img {
            max-width: 300px;
            height: auto;
            border: 1px solid #ddd;
            padding: 10px;
            background-color: white;
        }
        .demo-section {
            margin: 20px 0;
            padding: 15px;
            background-color: #f9f9f9;
            border-left: 4px solid #007bff;
        }
        .demo-section h3 {
            margin-top: 0;
            color: #007bff;
        }
        .code-block {
            background-color: #f4f4f4;
            padding: 15px;
            border-radius: 4px;
            overflow-x: auto;
            font-family: 'Courier New', monospace;
            font-size: 14px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px 5px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Ví dụ hiển thị QR Code cho Hóa Đơn</h1>

        <!-- Cách 1: Hiển thị QR code trực tiếp từ Servlet -->
        <div class="demo-section">
            <h3>Cách 1: Hiển thị QR Code từ Servlet (IMG tag)</h3>
            <p>Cách đơn giản nhất - sử dụng thẻ &lt;img&gt; trỏ đến servlet.</p>
            
            <div class="qr-section">
                <h4>Ví dụ: QR Code cho Hóa Đơn ID = 1</h4>
                <!-- Thay số 1 bằng ID hóa đơn thực tế -->
                <img src="${pageContext.request.contextPath}/qr-hoa-don?id=1" 
                     alt="QR Code Hóa Đơn"
                     class="qr-code-img"
                     onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgZmlsbD0iI2VlZSIvPjx0ZXh0IHg9IjUwJSIgeT0iNTAlIiBmb250LXNpemU9IjE2IiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBkeT0iLjNlbSI+S2jDtG5nIHTDrG0gdGjhuqV5IGjDs2EgxJHGoW48L3RleHQ+PC9zdmc+';">
                
                <p style="margin-top: 15px;">
                    <button class="btn" onclick="testQRCode(1)">Test với Hóa Đơn ID = 1</button>
                    <button class="btn" onclick="downloadQRCode(1)">Tải QR Code</button>
                </p>
            </div>

            <div class="code-block">
&lt;!-- Trong JSP --&gt;
&lt;img src="${pageContext.request.contextPath}/qr-hoa-don?id=${hoaDon.id}" 
     alt="QR Code Hóa Đơn"
     width="300"&gt;

&lt;!-- Với kích thước tùy chỉnh --&gt;
&lt;img src="${pageContext.request.contextPath}/qr-hoa-don?id=${hoaDon.id}&size=200" 
     alt="QR Code Hóa Đơn"&gt;
            </div>
        </div>

        <!-- Cách 2: Sử dụng JSTL để tạo URL động -->
        <div class="demo-section">
            <h3>Cách 2: Sử dụng JSTL để tạo URL động</h3>
            
            <div class="code-block">
&lt;%@ taglib prefix="c" uri="jakarta.tags.core" %&gt;

&lt;c:if test="${not empty hoaDon}"&gt;
    &lt;c:url var="qrCodeUrl" value="/qr-hoa-don"&gt;
        &lt;c:param name="id" value="${hoaDon.id}"/&gt;
        &lt;c:param name="size" value="300"/&gt;
    &lt;/c:url&gt;
    
    &lt;img src="${qrCodeUrl}" alt="QR Code Hóa Đơn"&gt;
&lt;/c:if&gt;
            </div>
        </div>

        <!-- Cách 3: Sử dụng JavaScript để load QR code động -->
        <div class="demo-section">
            <h3>Cách 3: Sử dụng JavaScript để load QR Code động</h3>
            
            <div class="qr-section">
                <h4>QR Code được load bằng JavaScript</h4>
                <img id="dynamicQR" src="" alt="QR Code" class="qr-code-img" style="display:none;">
                <div id="loadingText">Đang tải QR Code...</div>
                <br>
                <label for="hoaDonIdInput">Nhập ID Hóa Đơn: </label>
                <input type="number" id="hoaDonIdInput" value="1" min="1" style="padding: 5px;">
                <button class="btn" onclick="loadQRCode()">Tải QR Code</button>
            </div>

            <div class="code-block">
&lt;script&gt;
function loadQRCode() {
    const hoaDonId = document.getElementById('hoaDonIdInput').value;
    const img = document.getElementById('dynamicQR');
    const loading = document.getElementById('loadingText');
    
    if (!hoaDonId) {
        alert('Vui lòng nhập ID hóa đơn');
        return;
    }
    
    loading.style.display = 'block';
    img.style.display = 'none';
    
    const qrUrl = '${pageContext.request.contextPath}/qr-hoa-don?id=' + hoaDonId;
    
    img.onload = function() {
        loading.style.display = 'none';
        img.style.display = 'block';
    };
    
    img.onerror = function() {
        loading.style.display = 'none';
        alert('Lỗi: Không thể tải QR Code. Hóa đơn không tồn tại.');
    };
    
    img.src = qrUrl;
}
&lt;/script&gt;
            </div>
        </div>

        <!-- Cách 4: Tải QR Code dạng Base64 -->
        <div class="demo-section">
            <h3>Cách 4: Tải QR Code dạng Base64 (AJAX)</h3>
            
            <div class="qr-section">
                <h4>QR Code từ Base64</h4>
                <img id="base64QR" src="" alt="QR Code Base64" class="qr-code-img" style="display:none;">
                <div id="base64Loading">Chưa tải...</div>
                <br>
                <button class="btn" onclick="loadBase64QRCode(1)">Tải QR Base64 (ID=1)</button>
            </div>

            <div class="code-block">
&lt;script&gt;
function loadBase64QRCode(hoaDonId) {
    const img = document.getElementById('base64QR');
    const loading = document.getElementById('base64Loading');
    
    loading.textContent = 'Đang tải...';
    img.style.display = 'none';
    
    fetch('${pageContext.request.contextPath}/qr-hoa-don?id=' + hoaDonId + '&format=base64')
        .then(response => response.json())
        .then(data => {
            img.src = 'data:image/png;base64,' + data.qrCodeBase64;
            img.style.display = 'block';
            loading.style.display = 'none';
        })
        .catch(error => {
            loading.textContent = 'Lỗi: ' + error.message;
        });
}
&lt;/script&gt;
            </div>
        </div>

        <!-- Hướng dẫn sử dụng -->
        <div class="demo-section">
            <h3>📝 Hướng dẫn sử dụng</h3>
            <ol>
                <li><strong>URL Pattern:</strong> <code>/qr-hoa-don?id={hoaDonId}</code></li>
                <li><strong>Tham số:</strong>
                    <ul>
                        <li><code>id</code> (bắt buộc): ID của hóa đơn</li>
                        <li><code>size</code> (tùy chọn): Kích thước QR code (mặc định: 300px)</li>
                        <li><code>format</code> (tùy chọn): "image" (mặc định) hoặc "base64"</li>
                    </ul>
                </li>
                <li><strong>Ví dụ URLs:</strong>
                    <ul>
                        <li><code>/qr-hoa-don?id=1</code> - QR mặc định 300x300px</li>
                        <li><code>/qr-hoa-don?id=1&size=200</code> - QR 200x200px</li>
                        <li><code>/qr-hoa-don?id=1&format=base64</code> - Trả về JSON với Base64</li>
                    </ul>
                </li>
            </ol>
        </div>

        <!-- Lưu ý -->
        <div class="demo-section" style="border-left-color: #ffc107;">
            <h3 style="color: #ffc107;">⚠️ Lưu ý quan trọng</h3>
            <ul>
                <li>QR Code được tạo động, không cần lưu vào database</li>
                <li>Thông tin trong QR Code bao gồm: Mã HĐ, Ngày lập, Khách hàng, SĐT, Tổng tiền, Trạng thái</li>
                <li>Nếu hóa đơn không tồn tại, servlet sẽ trả về lỗi 404</li>
                <li>QR Code được cache trong 1 giờ để tăng hiệu suất</li>
                <li>Có thể tùy chỉnh nội dung QR trong class <code>QRCodeHoaDonUtil</code></li>
            </ul>
        </div>
    </div>

    <script>
        // Hàm test QR Code
        function testQRCode(hoaDonId) {
            const url = '${pageContext.request.contextPath}/qr-hoa-don?id=' + hoaDonId;
            window.open(url, '_blank');
        }

        // Hàm download QR Code
        function downloadQRCode(hoaDonId) {
            const url = '${pageContext.request.contextPath}/qr-hoa-don?id=' + hoaDonId;
            const link = document.createElement('a');
            link.href = url;
            link.download = 'QR_HoaDon_' + hoaDonId + '.png';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        // Hàm load QR Code động
        function loadQRCode() {
            const hoaDonId = document.getElementById('hoaDonIdInput').value;
            const img = document.getElementById('dynamicQR');
            const loading = document.getElementById('loadingText');
            
            if (!hoaDonId) {
                alert('Vui lòng nhập ID hóa đơn');
                return;
            }
            
            loading.style.display = 'block';
            img.style.display = 'none';
            
            const qrUrl = '${pageContext.request.contextPath}/qr-hoa-don?id=' + hoaDonId;
            
            img.onload = function() {
                loading.style.display = 'none';
                img.style.display = 'block';
            };
            
            img.onerror = function() {
                loading.style.display = 'none';
                alert('Lỗi: Không thể tải QR Code. Hóa đơn không tồn tại.');
            };
            
            img.src = qrUrl;
        }

        // Hàm load Base64 QR Code
        function loadBase64QRCode(hoaDonId) {
            const img = document.getElementById('base64QR');
            const loading = document.getElementById('base64Loading');
            
            loading.textContent = 'Đang tải...';
            loading.style.display = 'block';
            img.style.display = 'none';
            
            fetch('${pageContext.request.contextPath}/qr-hoa-don?id=' + hoaDonId + '&format=base64')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Không tìm thấy hóa đơn');
                    }
                    return response.json();
                })
                .then(data => {
                    img.src = 'data:image/png;base64,' + data.qrCodeBase64;
                    img.style.display = 'block';
                    loading.style.display = 'none';
                })
                .catch(error => {
                    loading.textContent = 'Lỗi: ' + error.message;
                    img.style.display = 'none';
                });
        }
    </script>
</body>
</html>
