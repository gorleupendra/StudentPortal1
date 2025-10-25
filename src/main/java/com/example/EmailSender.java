package com.example;

// Import SendGrid classes
import com.sendgrid.Method;
import com.sendgrid.Request;
import com.sendgrid.Response;
import com.sendgrid.SendGrid;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;
import java.io.IOException;

public class EmailSender {

    // Your verified "From" email
    final static String fromEmail = "gorleupendra42@gmail.com";
    
    /**
     * Sends an email using the SendGrid API.
     * @param to The recipient's email address.
     * @param subject The subject of the email.
     * @param body The plain text body of the email.
     * @return true if the email was sent successfully, false otherwise.
     */
    public static boolean sendEmail(String to, String subject, String body) {
        
        // 1. Get the API Key from the environment variable (Set this in Render!)
        String sendGridApiKey = System.getenv("SENDGRID_API_KEY");
        
        if (sendGridApiKey == null || sendGridApiKey.isEmpty()) {
            System.err.println("SENDGRID_API_KEY not set. Email will not be sent.");
            return false;
        }

        // 2. Set up the email objects
        Email from = new Email(fromEmail);
        Email toEmail = new Email(to);
        Content content = new Content("text/plain", body);
        Mail mail = new Mail(from, subject, toEmail, content);

        // 3. Send the email
        SendGrid sg = new SendGrid(sendGridApiKey);
        Request request = new Request();

        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            
            Response response = sg.api(request);
            
            // Log the response
            System.out.println("SendGrid Response Status Code: " + response.getStatusCode());

            // SendGrid returns 202 (Accepted) for a successful send
            return (response.getStatusCode() >= 200 && response.getStatusCode() < 300);

        } catch (IOException ex) {
            System.err.println("Error sending email via SendGrid: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        }
    }
}
