package com.example;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * A reusable service class for sending WhatsApp messages via the Meta API.
 * This class holds the API credentials and provides methods to send messages.
 */
public class WhatsAppService {

    // --- Credentials from your SendWhatsAppServlet ---
    private static final String ACCESS_TOKEN = "EAAJVVZCE0LwYBP2pr7gX5Jk6S27C3JfTJwWnPUZAHpFBL9PUglWihWrvGTh9T4zHSvZCektnquggmsel6sG86WCPm9VrZBgoc5ZBFFe5H261s7TwCIUICXrUYngknPkvtELiwOZAOtAknzVLmZAPhBJB1ZBvBDTQCvduXhvi2vxx6C27Pd9aiuoE7hGULliya2kFg99eFgfh9in3ZA70ANYFrBP7f7N29bzkOXnxd6nr33dtQRuH0L9YEe8cKynK6VhSviZB8c99oDbfZBZAMLNqEnnCHFZC2";
    private static final String PHONE_NUMBER_ID = "850921621437694";
    
    // --- API Endpoint ---
    private static final String API_URL = "https://graph.facebook.com/v20.0/" + PHONE_NUMBER_ID + "/messages";

    /**
     * Sends a free-form text message.
     * * IMPORTANT: This will only be delivered if the user (recipient) has
     * messaged your business number within the last 24 hours.
     * * @param recipientPhoneNumber The user's phone number (e.g., "918309002327")
     * @param message The text message to send.
     * @return The response string from the Meta API.
     * @throws Exception if the API call fails.
     */
    public static String sendTextMessage(String recipientPhoneNumber, String message) throws Exception {
        String jsonPayload = "{"
            + "\"messaging_product\": \"whatsapp\","
            + "\"to\": \"" + recipientPhoneNumber + "\","
            + "\"type\": \"text\","
            + "\"text\": {\"body\": \"" + message + "\"}"
            + "}";
        
        return sendPostRequest(jsonPayload);
    }

    /**
     * Sends a pre-approved template message.
     * * This is the correct way to start a conversation with a user or send
     * a notification outside the 24-hour window.
     * * @param recipientPhoneNumber The user's phone number (e.g., "918309002327")
     * @param templateName The name of your approved template (e.g., "hello_world")
     * @param languageCode The language code of the template (e.g., "en_US")
     * @return The response string from the Meta API.
     * @throws Exception if the API call fails.
     */
    public static String sendTemplateMessage(String recipientPhoneNumber, String templateName, String languageCode) throws Exception {
        String jsonPayload = "{"
            + "\"messaging_product\": \"whatsapp\","
            + "\"to\": \"" + recipientPhoneNumber + "\","
            + "\"type\": \"template\","
            + "\"template\": {"
            + "  \"name\": \"" + templateName + "\","
            + "  \"language\": { \"code\": \"" + languageCode + "\" }"
            + "}"
            + "}";
        
        return sendPostRequest(jsonPayload);
    }
    
    // You can add more methods here, e.g., for sending templates with variables

    /**
     * Private helper method to send the actual HTTP request.
     * @param jsonPayload The fully formed JSON to send to the API.
     * @return The API's response body.
     * @throws Exception
     */
    private static String sendPostRequest(String jsonPayload) throws Exception {
        URL url = new URI(API_URL).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + ACCESS_TOKEN);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        
        if (responseCode == HttpURLConnection.HTTP_OK) {
            String responseBody = new String(conn.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
            conn.disconnect();
            return responseBody;
        } else {
            String errorBody = new String(conn.getErrorStream().readAllBytes(), StandardCharsets.UTF_8);
            conn.disconnect();
            throw new IOException("Error sending message. Response Code: " + responseCode + " | Error: " + errorBody);
        }
    }
}
