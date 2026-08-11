package demo.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailUtil {

    private static final String EMAIL = "giaphatdao2007@gmail.com";
    private static final String PASSWORD = "qems pehb bfyy laum";

    public static void sendMail(String toEmail, String taiKhoan, String matKhau) {

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        // Timeout kết nối TCP đến SMTP server: 10 giây
        props.put("mail.smtp.connectiontimeout", "10000");
        // Timeout chờ phản hồi từ SMTP server sau mỗi lệnh: 10 giây
        props.put("mail.smtp.timeout", "10000");
        // Timeout ghi dữ liệu lên socket: 10 giây
        props.put("mail.smtp.writetimeout", "10000");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL, PASSWORD);
            }
        });

        try {

            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(EMAIL));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail)
            );

            message.setSubject("Thông tin tài khoản nhân viên");

            String noiDung =
                    "<h2>Xin chào!</h2>"
                            + "<p>Tài khoản của bạn đã được tạo thành công.</p>"
                            + "<p><b>Tài khoản:</b> " + taiKhoan + "</p>"
                            + "<p><b>Mật khẩu:</b> " + matKhau + "</p>"
                            + "<br>"
                            + "<p>Vui lòng đổi mật khẩu sau lần đăng nhập đầu tiên.</p>"
                            + "<p>Trân trọng!</p>";

            message.setContent(noiDung, "text/html; charset=UTF-8");

            Transport.send(message);

            System.out.println("Gửi email thành công!");

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
}
