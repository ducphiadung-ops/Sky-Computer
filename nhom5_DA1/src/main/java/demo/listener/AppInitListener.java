package demo.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

/**
 * Warm-up listener: trigger HibernateConfig static block sớm
 * trên servlet thread để tránh lazy-init trên cron/RMI thread.
 */
// Thứ tự khởi tạo được quản lý qua web.xml — không dùng @WebListener
// để tránh bị đăng ký 2 lần và đảm bảo AppInitListener chạy trước
public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Đảm bảo Hibernate init chạy trên đúng WebApp ClassLoader
        ClassLoader webCL = sce.getServletContext().getClassLoader();
        Thread currentThread = Thread.currentThread();
        ClassLoader originalCL = currentThread.getContextClassLoader();
        try {
            currentThread.setContextClassLoader(webCL);
            System.out.println("[AppInit] Triggering Hibernate init...");
            demo.util.HibernateConfig.getFACTORY();
            System.out.println("[AppInit] Hibernate ready.");
        } catch (Throwable e) {
            System.err.println("[AppInit] FAILED: " + e.getMessage());
            e.printStackTrace();
        } finally {
            currentThread.setContextClassLoader(originalCL);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try { demo.util.HibernateConfig.close(); } catch (Exception ignored) {}
    }
}
