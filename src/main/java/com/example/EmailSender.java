package com.example; // Make sure this matches your package structure

// Import SendGrid classes
import com.sendgrid.Method;
import com.sendgrid.Request;
import com.sendgrid.Response;
import com.sendgrid.SendGrid;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Attachments;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;
import com.sendgrid.helpers.mail.objects.Personalization; // Import Personalization

import java.io.IOException;
import java.util.Base64;
import java.util.Collections;
import java.util.List;

/**
 * Utility class for sending emails via the SendGrid API.
 * Reads configuration (API Key, From Email) from environment variables.
 * Provides overloaded methods for sending different types of emails.
 */
public class EmailSender {

    /**
     * Helper class to represent an email attachment.
     */
    public static class EmailAttachment {
        private final byte[] contentBytes;
        private final String filename;
        private final String mimeType;
        private final String disposition; // e.g., "attachment" or "inline"

        /**
         * Creates an attachment.
         * @param contentBytes The raw byte data of the file.
         * @param filename The desired name for the attachment file (e.g., "document.pdf").
         * @param mimeType The MIME type of the file (e.g., "application/pdf", "image/jpeg").
         * @param disposition How the attachment should be treated ("attachment" for download, "inline" for display). Can be null (defaults to "attachment").
         */
        public EmailAttachment(byte[] contentBytes, String filename, String mimeType, String disposition) {
            if (contentBytes == null || filename == null || filename.trim().isEmpty() || mimeType == null || mimeType.trim().isEmpty()) {
                throw new IllegalArgumentException("Attachment content, filename, and mimeType cannot be null or empty.");
            }
            this.contentBytes = contentBytes;
            this.filename = filename.trim();
            this.mimeType = mimeType.trim();
            this.disposition = (disposition != null && !disposition.trim().isEmpty()) ? disposition.trim() : "attachment"; // Default to attachment
        }

        // Getters
        public byte[] getContentBytes() { return contentBytes; }
        public String getFilename() { return filename; }
        public String getMimeType() { return mimeType; }
        public String getDisposition() { return disposition; }
    }

    // Read "From" email and API Key from environment variables ONCE
    private static final String FROM_EMAIL = System.getenv("FROM_EMAIL");
    private static final String SENDGRID_API_KEY = System.getenv("SENDGRID_API_KEY");

    // --- Overloaded public sendEmail Methods ---

    /**
     * Sends a plain text email only.
     * @param to Recipient's email address.
     * @param subject Email subject.
     * @param textBody Plain text body (required).
     * @return true if SendGrid accepted the request, false otherwise.
     */
    public static boolean sendEmail(String to, String subject, String textBody) {
        // Delegate to the internal method with no HTML and no attachments
        return sendEmailInternal(to, subject, textBody, null, Collections.emptyList());
    }

    /**
     * Sends an email with both plain text (fallback) and HTML content.
     * @param to Recipient's email address.
     * @param subject Email subject.
     * @param textBody Plain text body (required).
     * @param htmlBody HTML body (required).
     * @return true if SendGrid accepted the request, false otherwise.
     */
    public static boolean sendEmail(String to, String subject, String textBody, String htmlBody) {
         // Basic validation specific to this overload
         if (htmlBody == null || htmlBody.trim().isEmpty()) {
              System.err.println("HTML body ('htmlBody') is required for this method overload. Email cannot be sent.");
              return false;
         }
        // Delegate to the internal method with no attachments
        return sendEmailInternal(to, subject, textBody, htmlBody, Collections.emptyList());
    }

    /**
     * Sends a plain text email with one or more attachments.
     * @param to Recipient's email address.
     * @param subject Email subject.
     * @param textBody Plain text body (required).
     * @param attachments List of EmailAttachment objects (required, must not be empty).
     * @return true if SendGrid accepted the request, false otherwise.
     */
    public static boolean sendEmail(String to, String subject, String textBody, List<EmailAttachment> attachments) {
         // Basic validation specific to this overload
         if (attachments == null || attachments.isEmpty()) {
             System.err.println("Attachments list cannot be null or empty for this method overload. Email cannot be sent.");
             return false;
         }
        // Delegate to the internal method with no HTML body
        return sendEmailInternal(to, subject, textBody, null, attachments);
    }

    /**
     * Sends an email with plain text (fallback), HTML content, and one or more attachments.
     * @param to Recipient's email address.
     * @param subject Email subject.
     * @param textBody Plain text body (required).
     * @param htmlBody HTML body (required).
     * @param attachments List of EmailAttachment objects (required, must not be empty).
     * @return true if SendGrid accepted the request, false otherwise.
     */
    public static boolean sendEmail(String to, String subject, String textBody, String htmlBody, List<EmailAttachment> attachments) {
         // Basic validation specific to this overload
         if (htmlBody == null || htmlBody.trim().isEmpty()) {
              System.err.println("HTML body ('htmlBody') is required for this method overload. Email cannot be sent.");
              return false;
         }
         if (attachments == null || attachments.isEmpty()) {
             System.err.println("Attachments list cannot be null or empty for this method overload. Email cannot be sent.");
             return false;
         }
        // Delegate to the internal method with all parameters
        return sendEmailInternal(to, subject, textBody, htmlBody, attachments);
    }


    // --- Private Helper Method for Actual Sending Logic ---

    /**
     * Internal core method to handle email construction and sending via SendGrid.
     * Assumes basic parameter validation (null/empty checks for required fields)
     * has been done by the public calling methods or here.
     */
    private static boolean sendEmailInternal(String to, String subject, String textBody, String htmlBody, List<EmailAttachment> attachments) {

        // 1. Validate required environment variables and essential parameters
        if (SENDGRID_API_KEY == null || SENDGRID_API_KEY.trim().isEmpty()) {
            System.err.println("CRITICAL: SENDGRID_API_KEY environment variable not set. Cannot send email.");
            return false;
        }
        if (FROM_EMAIL == null || FROM_EMAIL.trim().isEmpty()) {
            System.err.println("CRITICAL: FROM_EMAIL environment variable not set. Cannot send email.");
            return false;
        }
        if (to == null || to.trim().isEmpty()) {
             System.err.println("Recipient 'to' email address is missing. Email not sent.");
             return false;
        }
        if (textBody == null || textBody.trim().isEmpty()) {
              System.err.println("Plain text 'textBody' is required. Email not sent.");
              return false; // Plain text is a mandatory fallback
        }
        // Ensure subject is not null, default if necessary
        String emailSubject = (subject != null) ? subject : "(No Subject)";


        // 2. Set up the basic email objects
        Email from = new Email(FROM_EMAIL.trim());
        Email toEmail = new Email(to.trim());
        Content textContent = new Content("text/plain", textBody);
        Mail mail;

        // 3. Construct Mail object
        if (htmlBody != null && !htmlBody.trim().isEmpty()) {
            // Both HTML and Plain Text provided
            Content htmlContent = new Content("text/html", htmlBody);
            mail = new Mail(); // Use default constructor
            mail.setFrom(from);
            mail.setSubject(emailSubject);
            mail.addContent(textContent); // Add plain text first (fallback)
            mail.addContent(htmlContent); // Add HTML

            // Use Personalization object to add the recipient
            Personalization personalization = new Personalization();
            personalization.addTo(toEmail);
            mail.addPersonalization(personalization);

        } else {
            // Only Plain Text provided
            mail = new Mail(from, emailSubject, toEmail, textContent); // Use constructor
        }

        // 4. Add Attachments if provided
        if (attachments != null && !attachments.isEmpty()) {
            for (EmailAttachment attachmentData : attachments) {
                // Perform thorough validation within the loop
                if (attachmentData != null &&
                    attachmentData.getContentBytes() != null &&
                    attachmentData.getContentBytes().length > 0 &&
                    attachmentData.getFilename() != null && !attachmentData.getFilename().isEmpty() &&
                    attachmentData.getMimeType() != null && !attachmentData.getMimeType().isEmpty() &&
                    attachmentData.getDisposition() != null && !attachmentData.getDisposition().isEmpty())
                {
                    try {
                        String base64Content = Base64.getEncoder().encodeToString(attachmentData.getContentBytes());
                        Attachments sendGridAttachment = new Attachments.Builder(attachmentData.getFilename(), base64Content)
                                .withType(attachmentData.getMimeType())
                                .withDisposition(attachmentData.getDisposition())
                                // .withContentId("...") // Optional: for inline images referenced by CID
                                .build();
                        mail.addAttachments(sendGridAttachment);
                    } catch (Exception e) {
                        // Log error processing this specific attachment
                        System.err.println("Error processing or adding attachment '" + attachmentData.getFilename() + "': " + e.getMessage());
                        // Optional: Decide whether to fail the whole email send or just skip this attachment
                        // return false; // Fail entire email if one attachment fails
                    }
                } else {
                     // Log details about why the attachment was skipped
                     String filename = (attachmentData != null && attachmentData.getFilename() != null) ? attachmentData.getFilename() : "[Unknown Filename]";
                     System.err.println("Skipping invalid or incomplete attachment data for file: " + filename);
                }
            }
        }

        // 5. Send the email via SendGrid API
        SendGrid sg = new SendGrid(SENDGRID_API_KEY);
        Request request = new Request();

        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            String requestBody = mail.build(); // Build the request body
            // System.out.println("SendGrid Request Body: " + requestBody); // Optional: Log full request body for deep debugging
            request.setBody(requestBody);

            Response response = sg.api(request); // Make the API call

            // Log details for monitoring

            // Check if SendGrid accepted the request (2xx status codes)
            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                 return true; // Success!
            } else {
                // Log detailed error information from SendGrid
                System.err.println("SendGrid rejected the email request (Status: " + response.getStatusCode() + ").");
                System.err.println("SendGrid Response Body: " + response.getBody());
                System.err.println("SendGrid Response Headers: " + response.getHeaders());
                return false; // Failure
            }

        } catch (IOException ex) {
            // Handle network or API call exceptions
            System.err.println("IOException during SendGrid API call: " + ex.getMessage());
            ex.printStackTrace();
            return false; // Failure
        } catch (Exception e) {
             // Catch any other unexpected errors during the process
             System.err.println("Unexpected error during email sending process: " + e.getMessage());
             e.printStackTrace();
             return false; // Failure
        }
    }
}