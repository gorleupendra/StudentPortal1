package com.example;

import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.imageio.ImageIO;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.graphics.state.PDExtendedGraphicsState;
import org.apache.pdfbox.util.Matrix; // UPDATED import for PDFBox

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/downloadStudentRecord")
public class DownloadStudentRecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int recordId = Integer.parseInt(request.getParameter("id"));

        HttpSession session = request.getSession(false);
        String studentName = (session != null) ? (String) session.getAttribute("userName") : "";
        if (studentName == null || studentName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in.");
            return;
        }

        try (Connection con = DbConnection.getConne();
             PreparedStatement ps = con.prepareStatement("SELECT file_name, file_content, file_type FROM student_records WHERE id=?")) {

            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                response.getWriter().println("File not found.");
                return;
            }

            String fileName = rs.getString("file_name");
            String fileType = rs.getString("file_type");
            
            // --- CHANGE 1: Get the binary data as an InputStream ---
            InputStream fileStream = rs.getBinaryStream("file_content");

            if (fileStream == null) {
                response.getWriter().println("File content is empty.");
                return;
            }

            if (fileType != null && fileType.equalsIgnoreCase("application/pdf")) {
                // PDF watermark
                try (PDDocument doc = PDDocument.load(fileStream);
                     ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

                    for (PDPage page : doc.getPages()) {
                        try (PDPageContentStream cs = new PDPageContentStream(doc, page, PDPageContentStream.AppendMode.APPEND, true, true)) {
                            PDExtendedGraphicsState gs = new PDExtendedGraphicsState();
                            gs.setNonStrokingAlphaConstant(0.4f);
                            cs.setGraphicsStateParameters(gs);

                            cs.beginText();
                            cs.setFont(PDType1Font.HELVETICA_BOLD, 50);
                            cs.setNonStrokingColor(150, 150, 150);
                            
                            // --- CHANGE 2: Updated PDFBox Matrix usage ---
                            cs.setTextMatrix(Matrix.getRotateInstance(Math.toRadians(20), page.getMediaBox().getWidth() / 2, page.getMediaBox().getHeight() / 2));
                            
                            cs.showText(studentName);
                            cs.endText();
                        }
                    }
                    doc.save(baos);
                    
                    response.setContentType(fileType);
                    response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
                    response.setContentLength(baos.size());
                    try (OutputStream out = response.getOutputStream()) {
                        baos.writeTo(out);
                    }
                }

            } else if (fileType != null && fileType.startsWith("image/")) {
                // Image watermark
                BufferedImage img = ImageIO.read(fileStream);
                Graphics2D g2d = img.createGraphics();
                g2d.setFont(new Font("Arial", Font.BOLD, img.getWidth() / 10));
                g2d.setColor(new java.awt.Color(150, 150, 150, 180));
                g2d.rotate(Math.toRadians(40), img.getWidth() / 2, img.getHeight() / 2);
                g2d.drawString(studentName, img.getWidth() / 4, img.getHeight() / 2);
                g2d.dispose();

                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                String format = fileType.substring(fileType.indexOf('/') + 1);
                ImageIO.write(img, format, baos);

                response.setContentType(fileType);
                response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
                response.setContentLength(baos.size());
                try (OutputStream out = response.getOutputStream()) {
                    baos.writeTo(out);
                }

            } else {
                // Other files: send as-is
                response.setContentType(fileType != null ? fileType : "application/octet-stream");
                response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
                try (OutputStream out = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = fileStream.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
            }
            fileStream.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}