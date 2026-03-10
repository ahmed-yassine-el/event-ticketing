package com.eventapp.util;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Authenticator;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;

import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.Properties;

public final class MailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USERNAME = "elghazzaliyassine122@gmail.com";
    private static final String SMTP_PASSWORD = "nmbt dsnp jgnz vdby";
    private static final String SMTP_AUTH = "true";
    private static final String SMTP_STARTTLS = "true";

    private MailUtil() {
    }

    public static void sendTicketConfirmation(Session mailSession,
                                              String toEmail,
                                              String eventName,
                                              String eventDate,
                                              String location,
                                              Long ticketId,
                                              String qrCodeBase64) {
        if (toEmail == null || toEmail.isBlank()) {
            return;
        }

        try {
            Session gmailSession = createGmailSession();
            MimeMessage message = new MimeMessage(gmailSession);
            message.setFrom(new InternetAddress(SMTP_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Ticket Confirmation - " + eventName, StandardCharsets.UTF_8.name());

            MimeBodyPart htmlPart = new MimeBodyPart();
            String html = "<h3>Your ticket is confirmed</h3>"
                    + "<p><strong>Event:</strong> " + escape(eventName) + "</p>"
                    + "<p><strong>Date:</strong> " + escape(eventDate) + "</p>"
                    + "<p><strong>Location:</strong> " + escape(location) + "</p>"
                    + "<p><strong>Ticket ID:</strong> " + ticketId + "</p>"
                    + "<p><img src='cid:ticketQr' alt='QR Code'/></p>";
            htmlPart.setContent(html, "text/html; charset=UTF-8");

            MimeMultipart multipart = new MimeMultipart("related");
            multipart.addBodyPart(htmlPart);
            if (qrCodeBase64 != null && !qrCodeBase64.isBlank()) {
                MimeBodyPart imagePart = new MimeBodyPart();
                byte[] imageBytes = Base64.getDecoder().decode(qrCodeBase64);
                imagePart.setDataHandler(new jakarta.activation.DataHandler(
                        new ByteArrayDataSource(imageBytes, "image/png")));
                imagePart.setHeader("Content-ID", "<ticketQr>");
                imagePart.setDisposition(MimeBodyPart.INLINE);
                multipart.addBodyPart(imagePart);
            }
            message.setContent(multipart);

            jakarta.mail.Transport.send(message);
        } catch (MessagingException ex) {
            throw new IllegalStateException("Failed to send confirmation email", ex);
        }
    }

    private static Session createGmailSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", SMTP_AUTH);
        props.put("mail.smtp.starttls.enable", SMTP_STARTTLS);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });
    }

    public static String formatDate(java.time.LocalDateTime dateTime) {
        if (dateTime == null) {
            return "N/A";
        }
        return dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }

    private static String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }
}
