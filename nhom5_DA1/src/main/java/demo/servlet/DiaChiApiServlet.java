package demo.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import demo.data.DiaChiData;
import demo.data.PhuongXa;
import demo.data.TinhThanh;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * API nội bộ cung cấp dữ liệu địa chỉ (tỉnh/thành, quận/huyện, phường/xã)
 * Thay thế việc gọi provinces.open-api.vn từ phía client.
 *
 * Endpoints:
 *   GET /api/dia-chi/tinh              → danh sách tỉnh/thành
 *   GET /api/dia-chi/phuong?tinhId=1   → danh sách phường/xã theo tỉnh
 */
@WebServlet("/api/dia-chi/*")
public class DiaChiApiServlet extends HttpServlet {

    private static final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");

        String pathInfo = request.getPathInfo(); // "/tinh" hoặc "/phuong"

        if (pathInfo == null || pathInfo.equals("/tinh")) {
            // Trả danh sách tỉnh/thành
            List<Map<String, Object>> result = new ArrayList<>();
            for (TinhThanh t : DiaChiData.getAllTinh()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", t.getId());
                item.put("ten", t.getTen());
                result.add(item);
            }
            mapper.writeValue(response.getOutputStream(), result);

        } else if (pathInfo.equals("/phuong")) {
            // Trả danh sách phường/xã theo tỉnh
            String tinhIdStr = request.getParameter("tinhId");
            List<Map<String, Object>> result = new ArrayList<>();

            if (tinhIdStr != null && !tinhIdStr.isEmpty()) {
                try {
                    int tinhId = Integer.parseInt(tinhIdStr);
                    for (PhuongXa p : DiaChiData.getPhuongTheoTinh(tinhId)) {
                        Map<String, Object> item = new HashMap<>();
                        item.put("id", p.getId());
                        item.put("ten", p.getTen());
                        result.add(item);
                    }
                } catch (NumberFormatException ignored) {}
            }
            mapper.writeValue(response.getOutputStream(), result);

        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\":\"Not found\"}");
        }
    }
}
