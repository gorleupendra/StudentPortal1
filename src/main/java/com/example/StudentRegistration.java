package com.example; // Ensure this matches your package structure

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.annotation.WebServlet; // Ensure this is uncommented if not mapped in web.xml
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

// PDF Generation Imports (iText 7) - Remain the same
import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Image;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.properties.VerticalAlignment;

// Removed SendGrid specific imports from THIS file
// Assuming DbConnection and HashPassword are in com.example

@WebServlet("/studentRegistration") // Ensure the URL mapping is correct
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1MB
    maxFileSize = 1024 * 1024 * 5,     // 5MB
    maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class StudentRegistration extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // FROM_EMAIL is handled within EmailSender now, no need here

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/plain");
        PrintWriter out = res.getWriter();
        Connection con = null;
        PreparedStatement psStudentDetails = null;
        byte[] photoBytes = null;
        byte[] signBytes = null;
        String email = null; // Declare email here for use in finally/catch if needed
        String name = null; // Declare name here for use in finally/catch if needed
        String regdno = null; // Declare regdno here for use in finally/catch

        try {
            // --- 1. Get All Form Parameters ---
            name = req.getParameter("fullname");
            regdno = req.getParameter("regdno");
          String  fathername = req.getParameter("fathername");
          String mothername = req.getParameter("mothername");
          String  admno = req.getParameter("admno");
          String  rankStr = req.getParameter("rank");
          String  adtype = req.getParameter("admtype");
          String  joincate = req.getParameter("joincate");
          String  joinyear = req.getParameter("joinyear");
            email = req.getParameter("email");
          String phone = req.getParameter("phone");
          String  gender = req.getParameter("gender");
          String  village = req.getParameter("village");
          String  mandal = req.getParameter("mandal");
          String   dist = req.getParameter("dist");
          String  dept = req.getParameter("dept");
          String  clas = req.getParameter("class");
          String  pincodeStr = req.getParameter("pincode");
          String  password = req.getParameter("password");
          String  dateStr = req.getParameter("date");
          String  monthStr = req.getParameter("month");
          String  yearStr = req.getParameter("year");

            // --- Basic Input Validation (Example) ---
            if (name == null || name.trim().isEmpty() || regdno == null || regdno.trim().isEmpty() ||
                email == null || email.trim().isEmpty() || password == null || password.isEmpty() ||
                dateStr == null || monthStr == null || yearStr == null || rankStr == null || pincodeStr == null ) {
                 throw new IllegalArgumentException("Required form fields are missing.");
            }

            // Parse numbers after validation
            int rank = Integer.parseInt(rankStr.trim());
            int pincode = Integer.parseInt(pincodeStr.trim());
            int day = Integer.parseInt(dateStr.trim());
            int month = Integer.parseInt(monthStr.trim());
            int year = Integer.parseInt(yearStr.trim());
            int joinyear1=Integer.parseInt(joinyear.trim());
            LocalDate dob = LocalDate.of(year, month, day);


            // --- Handle File Uploads ---
            Part photoPart = req.getPart("photo");
            Part signPart = req.getPart("sign");

            if (photoPart != null && photoPart.getSize() > 0) {
                try (InputStream is = photoPart.getInputStream()) {
                    photoBytes = is.readAllBytes();
                }
            }
            if (signPart != null && signPart.getSize() > 0) {
                try (InputStream is = signPart.getInputStream()) {
                    signBytes = is.readAllBytes();
                }
            }

            // --- 2. Start Transaction ---
            con = DbConnection.getConne(); // Use your updated DbConnection class
             if (con == null) {
                 throw new SQLException("Failed to establish database connection.");
             }
            con.setAutoCommit(false);

            // --- 3. Insert into 'STUDENTS' details table ---
            String sqlStudentDetails = "INSERT INTO STUDENTS (REGD_NO, NAME, FATHERNAME, MOTHERNAME, ADMNO, RANK, ADTYPE, JOINCATE, EMAIL, PHONE, DOB, GENDER, VILLAGE, MANDAL, DIST, PINCODE, PHOTO, SIGN, PASSWORD, DEPT, CLASS,JOINYEAR) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            psStudentDetails = con.prepareStatement(sqlStudentDetails);

            // ... (Setting parameters for psStudentDetails - code remains exactly the same as before) ...
            psStudentDetails.setString(1, regdno.trim());
            psStudentDetails.setString(2, name.trim());
            psStudentDetails.setString(3, fathername != null ? fathername.trim() : null);
            psStudentDetails.setString(4, mothername != null ? mothername.trim() : null);
            psStudentDetails.setString(5, admno != null ? admno.trim() : null);
            psStudentDetails.setInt(6, rank);
            psStudentDetails.setString(7, adtype != null ? adtype.trim() : null);
            psStudentDetails.setString(8, joincate != null ? joincate.trim() : null);
            psStudentDetails.setString(9, email.trim());
            psStudentDetails.setString(10, phone != null ? phone.trim() : null);
            psStudentDetails.setDate(11, java.sql.Date.valueOf(dob));
            psStudentDetails.setString(12, gender != null ? gender.trim() : null);
            psStudentDetails.setString(13, village != null ? village.trim() : null);
            psStudentDetails.setString(14, mandal != null ? mandal.trim() : null);
            psStudentDetails.setString(15, dist != null ? dist.trim() : null);
            psStudentDetails.setInt(16, pincode);
            if (photoBytes != null) psStudentDetails.setBytes(17, photoBytes); else psStudentDetails.setNull(17, java.sql.Types.VARBINARY);
            if (signBytes != null) psStudentDetails.setBytes(18, signBytes); else psStudentDetails.setNull(18, java.sql.Types.VARBINARY);
            String passwordHash = HashPassword.hashPassword(password);
            psStudentDetails.setString(19, passwordHash);
            psStudentDetails.setString(20, dept != null ? dept.trim() : null);
            psStudentDetails.setString(21, clas != null ? clas.trim() : null);
            psStudentDetails.setInt(22, joinyear1);
            
            // ... (End of setting parameters) ...
            int studentDetailRows=0;
            try
            {
            	
            	 studentDetailRows = psStudentDetails.executeUpdate();
            }catch(SQLException e) {
            	if ("23505".equals(e.getSQLState())) {
                    // --- This is a Duplicate Key Violation ---
                    out.println("Registartion Number is already Exist");
                    return;
                    // Inform the user, log, or take alternative action
                    // Example: response.getWriter().write("Error: Registration Number already exists.");
                }
            }

            // --- 4. Commit Transaction & Trigger Post-Registration Actions ---
            if (studentDetailRows > 0) {
                con.commit();

                // --- POST-COMMIT ACTIONS: PDF Generation and Email Sending ---
                byte[] pdfBytes = null; // Initialize pdfBytes
                try {
                    // 1. Create the PDF in memory
                    pdfBytes = createPdf(req, photoBytes, signBytes);

                } catch (Exception pdfEx) {
                     System.err.println("Error generating PDF for regdno: " + regdno + " - " + pdfEx.getMessage());
                     pdfEx.printStackTrace();
                     // Decide if you still want to send email without PDF
                }

                try {
                     // 2. Prepare email content and attachments
                     String subject = "Registration Confirmation - Andhra University";
                     String textBody = "Dear " + (name != null ? name : "Student") + ",\n\n" +
                                       "Thank you for registering. ";
                     // Add attachment info only if PDF generation was successful
                     if (pdfBytes != null && pdfBytes.length > 0) {
                         textBody += "Your application form is attached to this email for your records.\n\n";
                     } else {
                         textBody += "There was an issue generating your application PDF, please contact support if needed.\n\n";
                     }
                     textBody += "Best regards,\nAndhra University Admissions";

                     List<EmailSender.EmailAttachment> attachments = new ArrayList<>();
                     if (pdfBytes != null && pdfBytes.length > 0) {
                         String safeStudentName = (name != null) ? name.replaceAll("[^a-zA-Z0-9_.-]", "_") : "Student";
                         String filename = "ApplicationForm_" + safeStudentName + ".pdf";
                         attachments.add(new EmailSender.EmailAttachment(pdfBytes, filename, "application/pdf", "attachment"));
                     }

                     // 3. Send the email using EmailSender class
                     // Using the method for text body and attachments
                     boolean emailSent = EmailSender.sendEmail(email, subject, textBody, attachments);

                     if (emailSent) {
                         System.out.println("Registration email sent successfully via EmailSender to: " + email);
                         out.write("Registration successful! A confirmation PDF has been sent to your email (" + email + ").");
                     } else {
                         System.err.println("EmailSender failed to send email to: " + email);
                         // Modify success message slightly to indicate email failure
                         out.write("Registration successful! Your data has been saved. However, the confirmation email could not be sent. Please contact support.");
                     }

                } catch (Exception emailEx) {
                    System.err.println("Error preparing or sending email for regdno: " + regdno + " - " + emailEx.getMessage());
                    emailEx.printStackTrace();
                    out.write("Registration successful! Your data has been saved. However, there was an issue sending the confirmation email (" + emailEx.getMessage() + "). Please contact support.");
                }

            } else { // if (studentDetailRows <= 0)
                con.rollback();
                out.write("Registration failed. Could not save student details.");
            }

        } catch (IllegalArgumentException valEx) { // Catch validation errors specifically
            // No rollback needed as transaction likely didn't start or failed early
             System.err.println("Validation error during registration: " + valEx.getMessage());
             valEx.printStackTrace();
             res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
             out.write("Error: Registration failed. " + valEx.getMessage());

        } catch (SQLException dbEx) { // Catch database errors
            if (con != null) { try { con.rollback(); } catch (SQLException exRb) { System.err.println("Rollback failed: " + exRb.getMessage()); } }
             System.err.println("Database error during registration: " + dbEx.getMessage());
            dbEx.printStackTrace();
            // Check for specific constraint violation
             if (dbEx.getMessage() != null && dbEx.getMessage().contains("duplicate key value violates unique constraint")) {
                  res.setStatus(HttpServletResponse.SC_CONFLICT); // 409 Conflict is suitable
                  out.write("Error: Registration failed. A student with this Registration Number (" + regdno + ") already exists.");
             } else {
                  res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 for other DB errors
                  out.write("Error: Registration failed due to a database issue. Please contact support.");
             }

        } catch (Exception e) { // Catch all other unexpected errors
            if (con != null) { try { con.rollback(); } catch (SQLException ex) { System.err.println("Rollback failed: " + ex.getMessage()); } }
             System.err.println("Unexpected error during registration: " + e.getMessage());
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("Error: An unexpected error occurred during registration. Please try again later.");

        } finally {
            // Ensure resources are closed safely
            try { if (psStudentDetails != null) psStudentDetails.close(); } catch (SQLException e) { e.printStackTrace(); }
            try {
                if (con != null) {
                    con.setAutoCommit(true); // Reset autoCommit
                    con.close();
                }
             } catch (SQLException e) { e.printStackTrace(); }
            // Let the container manage closing the PrintWriter 'out'
        }
    }


    // ===============================================
    // ==     IMPROVED createPdf METHOD             ==
    // ===============================================
    // This method remains unchanged from the previous version
    private byte[] createPdf(HttpServletRequest req, byte[] photoBytes, byte[] signBytes) throws IOException {
         ByteArrayOutputStream baos = new ByteArrayOutputStream();
         PdfWriter writer = new PdfWriter(baos);
         PdfDocument pdf = new PdfDocument(writer);
         Document document = new Document(pdf, PageSize.A4);
         document.setMargins(40f, 40f, 40f, 40f);

         // --- Header ---
         Paragraph header = new Paragraph("Student Registration Application Form")
                 .setTextAlignment(TextAlignment.CENTER)
                 .setBold().setFontSize(18).setMarginBottom(5f);
         Paragraph subHeader = new Paragraph("Andhra University College of Engineering (A)")
                 .setTextAlignment(TextAlignment.CENTER)
                 .setFontSize(14).setMarginBottom(20f);
         document.add(header);
         document.add(subHeader);

         // --- Top Section: Key Info + Photo ---
         Table topTable = new Table(UnitValue.createPercentArray(new float[]{75, 25})).useAllAvailableWidth();
         topTable.setBorder(Border.NO_BORDER);

         Cell infoCell = new Cell().setBorder(Border.NO_BORDER).setPaddingRight(20f);
         infoCell.add(new Paragraph("Name: " + req.getParameter("fullname")).setBold().setFontSize(11));
         infoCell.add(new Paragraph("Registration No.: " + req.getParameter("regdno")).setFontSize(10));
         infoCell.add(new Paragraph("Admission No.: " + req.getParameter("admno")).setFontSize(10));
         infoCell.add(new Paragraph("Department: " + req.getParameter("dept")).setFontSize(10));
         infoCell.add(new Paragraph("Class: " + req.getParameter("class")).setFontSize(10));
         topTable.addCell(infoCell);

         Cell photoCell = new Cell().setBorder(Border.NO_BORDER).setTextAlignment(TextAlignment.RIGHT).setVerticalAlignment(VerticalAlignment.TOP);
         if (photoBytes != null) {
             try {
                 Image photo = new Image(ImageDataFactory.create(photoBytes))
                         .setAutoScaleWidth(true).setMaxHeight(120f);
                 photoCell.add(photo);
             } catch (Exception e) {
                 photoCell.add(new Paragraph("[Photo Error]").setFontColor(ColorConstants.RED).setFontSize(8));
                 System.err.println("Error adding photo to PDF: " + e.getMessage());
             }
         } else {
              Paragraph placeholder = new Paragraph("Photo")
                                         .setTextAlignment(TextAlignment.CENTER).setFontSize(10)
                                         .setWidth(100f).setHeight(120f)
                                         .setBorder(new SolidBorder(ColorConstants.LIGHT_GRAY, 1f))
                                         .setPaddingTop(50f);
              photoCell.add(placeholder);
         }
         topTable.addCell(photoCell);
         document.add(topTable);
         document.add(new Paragraph("\n").setFontSize(6));

         // --- Main Details Table ---
         Table detailsTable = new Table(UnitValue.createPercentArray(new float[]{35, 65})).useAllAvailableWidth();
         detailsTable.setMarginTop(15f);

         addTableRow(detailsTable, "Father's Name:", req.getParameter("fathername"));
         addTableRow(detailsTable, "Mother's Name:", req.getParameter("mothername"));
         addTableRow(detailsTable, "Email:", req.getParameter("email"));
         addTableRow(detailsTable, "Phone:", req.getParameter("phone"));

         String dobString = "N/A";
         try {
             LocalDate dob = LocalDate.of(
                 Integer.parseInt(req.getParameter("year")),
                 Integer.parseInt(req.getParameter("month")),
                 Integer.parseInt(req.getParameter("date"))
             );
             dobString = dob.format(DateTimeFormatter.ofPattern("dd-MM-yyyy"));
         } catch (Exception e) { System.err.println("Could not parse DOB for PDF: " + e.getMessage()); }
         addTableRow(detailsTable, "Date of Birth:", dobString);

         addTableRow(detailsTable, "Gender:", req.getParameter("gender"));
         addTableRow(detailsTable, "Admission Type:", req.getParameter("admtype"));
         addTableRow(detailsTable, "Join Category:", req.getParameter("joincate"));
         addTableRow(detailsTable, "Rank:", req.getParameter("rank"));

         List<String> addressParts = new ArrayList<>();
         String village = req.getParameter("village");
         String mandal = req.getParameter("mandal");
         String dist = req.getParameter("dist");
         String pincode = req.getParameter("pincode");
         if (village != null && !village.trim().isEmpty()) addressParts.add(village.trim());
         if (mandal != null && !mandal.trim().isEmpty()) addressParts.add(mandal.trim());
         if (dist != null && !dist.trim().isEmpty()) addressParts.add(dist.trim());
         if (pincode != null && !pincode.trim().isEmpty()) addressParts.add(pincode.trim());
         String address = addressParts.isEmpty() ? "N/A" : String.join(", ", addressParts);
         addTableRow(detailsTable, "Address:", address);

         document.add(detailsTable);

         // --- Signature Section ---
         if (signBytes != null) {
             try {
                 Image signature = new Image(ImageDataFactory.create(signBytes))
                         .setAutoScaleWidth(true).setMaxWidth(150f).setMaxHeight(60f);

                 Paragraph signParagraph = new Paragraph()
                         .add(signature).add("\n")
                         .add(new Paragraph("(Signature)").setFontSize(9).setMarginLeft(5f))
                         .setTextAlignment(TextAlignment.RIGHT).setMarginTop(30f);
                 document.add(signParagraph);
             } catch (Exception e) {
                 document.add(new Paragraph("[Signature Error]").setFontColor(ColorConstants.RED).setFontSize(8).setTextAlignment(TextAlignment.RIGHT).setMarginTop(30f));
                 System.err.println("Error adding signature to PDF: " + e.getMessage());
             }
         } else {
              Paragraph noSignParagraph = new Paragraph("(No Signature Provided)")
                                             .setFontSize(9).setTextAlignment(TextAlignment.RIGHT).setMarginTop(30f);
              document.add(noSignParagraph);
         }

         document.close();
         return baos.toByteArray();
     }

    // Helper method to add rows to a table (unchanged)
    private void addTableRow(Table table, String label, String value) {
        String displayValue = (value != null && !value.trim().isEmpty()) ? value.trim() : "N/A";
        table.addCell(new Cell().add(new Paragraph(label).setBold().setFontSize(10)).setPadding(4).setBorder(Border.NO_BORDER));
        table.addCell(new Cell().add(new Paragraph(displayValue).setFontSize(10)).setPadding(4).setBorder(Border.NO_BORDER));
    }

    // REMOVED the sendRegistrationEmail method from this servlet
}