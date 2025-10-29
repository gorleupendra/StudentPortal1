<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - University Portal</title>
    
    <%-- Fonts and Icons --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Main layout CSS (Header/Footer) --%>
    <%-- This file provides all the color variables like --primary-blue --%>
    <%--<link rel="stylesheet" href="${pageContext.request.contextPath}/header/style.css"> --%>
    
    <%-- Page-Specific CSS for Contact Form --%>
    <style>
        .contact-container {
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
            background-color: #ffffff;
            border: 1px solid var(--border-color, #e5e7eb);
            border-radius: 0.75rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            overflow: hidden; /* To keep the rounded corners */
        }
        
        .contact-layout {
            display: grid;
            grid-template-columns: 1fr 1.2fr; /* 2 columns: info and form */
        }
        
        /* Left Column: Contact Info */
        .contact-info {
            background-color: #f9fafb; /* A very light gray */
            padding: 3rem;
            border-right: 1px solid var(--border-color, #e5e7eb);
        }
        
        .contact-info h1 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark, #1f2937);
            margin-bottom: 1rem;
        }
        
        .contact-info p {
            font-size: 1rem;
            color: var(--text-medium, #4b5563);
            line-height: 1.6;
            margin-bottom: 2rem;
        }
        
        .info-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }
        
        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            color: var(--text-dark, #1f2937);
        }
        
        .info-item i {
            font-size: 1.25rem;
            color: var(--primary-blue, #3b82f6);
            margin-top: 0.25rem;
            width: 20px; /* Aligns text */
            text-align: center;
        }
        
        .info-item span {
            font-size: 0.95rem;
            line-height: 1.5;
        }

        /* Right Column: Contact Form */
        .contact-form-container {
            padding: 3rem;
        }
        
        #contact-form {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .form-group label {
            font-weight: 500;
            color: var(--text-dark, #1f2937);
            font-size: 0.9rem;
        }
        
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group textarea {
            width: 100%;
            padding: 0.85rem 1rem;
            border: 1px solid var(--border-color, #d1d5db);
            border-radius: 0.375rem;
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        
        .form-group input[type="text"]:focus,
        .form-group input[type="email"]:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-blue, #3b82f6);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }
        
        .contact-submit-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.85rem 1.5rem;
            border: none;
            border-radius: 0.375rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            background-color: var(--primary-blue, #3b82f6);
            color: white;
            align-self: flex-start; /* Don't stretch button */
        }
        
        .contact-submit-btn:hover {
            background-color: var(--primary-blue-hover, #2563eb);
        }

        .contact-submit-btn:disabled {
            background-color: var(--text-light, #9ca3af);
            cursor: not-allowed;
        }
        
        /* Alert Message for JS */
        #form-alert {
            display: none; /* Hidden by default */
            padding: 1rem;
            border-radius: 0.375rem;
            font-weight: 500;
            margin-bottom: 1rem;
        }
        
        #form-alert.success {
            background-color: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }
        
        #form-alert.error {
            background-color: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .contact-layout {
                grid-template-columns: 1fr; /* Stack columns on tablet */
            }
            .contact-info {
                border-right: none;
                border-bottom: 1px solid var(--border-color, #e5e7eb);
            }
        }
        
        @media (max-width: 600px) {
            .contact-info, .contact-form-container {
                padding: 2rem 1.5rem; /* Reduce padding on mobile */
            }
            .contact-info h1 {
                font-size: 1.75rem;
            }
        }
        
    </style>
</head>
<body>

    <%-- Include the header --%>
    <%@ include file="/header/header.jsp" %>

    <%-- Main content area --%>
    <main class="main-content">
        
        <div class="contact-container">
            <div class="contact-layout">
                
                <!-- Left Column: Info -->
                <div class="contact-info">
                    <h1>Get in Touch</h1>
                    <p>We'd love to hear from you. Please fill out the form or use the contact details below to reach our administrative office.</p>
                    
                    <ul class="info-list">
                        <li class="info-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <span>
                                <strong>Andhra University</strong><br>
                                Waltair Junction, Visakhapatnam<br>
                                Andhra Pradesh 530003, India
                            </span>
                        </li>
                        <li class="info-item">
                            <i class="fas fa-phone-alt"></i>
                            <span>
                                <strong>Phone</strong><br>
                                +91-8309002327
                            </span>
                        </li>
                        <li class="info-item">
                            <i class="fas fa-envelope"></i>
                            <span>
                                <strong>Email</strong><br>
                                gorleupendra42@gmail.com
                            </span>
                        </li>
                    </ul>
                </div>
                
                <!-- Right Column: Form -->
                <div class="contact-form-container">
                    
                    <!-- This alert box is used by the JavaScript -->
                    <div id="form-alert"></div>
                    
                    <form id="contact-form" novalidate>
                        <div class="form-group">
                            <label for="name">Your Name</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Your Email</label>
                            <input type="email" id="email" name="email" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <input type="text" id="subject" name="subject" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="message">Your Message</label>
                            <textarea id="message" name="message" rows="5" required></textarea>
                        </div>
                        
                        <button type="submit" class="contact-submit-btn" id="submit-btn">
                            <i class="fas fa-paper-plane"></i>
                            <span>Send Message</span>
                        </button>
                    </form>
                </div>
                
            </div>
        </div>
        
    </main>

    <%-- Include the footer --%>
    <%@ include file="/header/footer.jsp" %>

    <%-- Page-Specific JavaScript for Form Validation --%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('contact-form');
            const submitBtn = document.getElementById('submit-btn');
            const alertBox = document.getElementById('form-alert');

            // Helper function to show alerts
            function showAlert(message, type) {
                alertBox.textContent = message;
                alertBox.className = type; // 'success' or 'error'
                alertBox.style.display = 'block';
            }

            // Hide alert on input
            form.addEventListener('input', () => {
                alertBox.style.display = 'none';
            });

            form.addEventListener('submit', function(event) {
                event.preventDefault(); // Stop form from reloading page

                const name = document.getElementById('name').value;
                const email = document.getElementById('email').value;
                const subject = document.getElementById('subject').value;
                const message = document.getElementById('message').value;

                // Simple Validation
                if (!name || !email || !subject || !message) {
                    showAlert('Please fill out all required fields.', 'error');
                    return;
                }

                // ---
                // NOTE: In a real application, you would send this data to a Servlet
                // For this example, we will simulate a successful submission.
                // ---

                // Disable button and show loading text
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span>Sending...</span>';

                // Simulate a network delay (1.5 seconds)
                setTimeout(() => {
                    // Show success message
                    showAlert('Thank you for your message! We will get back to you soon.', 'success');
                    
                    // Reset the form
                    form.reset();
                    
                    // Re-enable the button
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i><span>Send Message</span>';

                }, 1500);
            });
        });
    </script>

</body>
</html>
