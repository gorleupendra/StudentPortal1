<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Password Reset</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <%-- Link to main layout CSS (for header/footer/variables) --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/header/style.css">

    <%-- Embedded CSS for this page --%>
    <style>
        /* Inherit variables from main CSS */
        :root {
            --primary-color: #2563eb;
            --primary-hover-color: #1d4ed8;
            --error-color: #ef4444;
            --success-color: #16a34a;
            --warning-color: #f59e0b; /* For timer */
            --background-color: #f0f9ff; 
            --form-background: #ffffff;
            --text-color: #1f2937; 
            --label-color: #4b5563; 
            --border-color: #d1d5db; 
            --placeholder-color: #9ca3af; 
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

         /* Using .main-content from layout.css for centering */
         .main-content {
             display: flex; 
             justify-content: center;
             align-items: center;
             padding: 2rem 1rem; 
         }


        .form-container {
            font-family: 'Poppins', sans-serif; 
            background-color: var(--form-background);
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 520px;
            border: 1px solid var(--border-color); 
            margin: 2rem 0; 
        }

        .form-title {
            font-size: 1.75rem;
            font-weight: 600;
            text-align: center;
            margin-bottom: 2rem;
            color: var(--text-color);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.25rem;
        }

        .input-group {
            /* Removed margin-bottom */
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .input-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--label-color);
            margin-bottom: 0.5rem;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper .input-icon {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            left: 15px;
            color: var(--placeholder-color);
            z-index: 2;
            font-size: 0.9rem; 
        }

        .input-field {
            width: 100%;
            padding: 0.85rem 1rem 0.85rem 2.75rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            color: var(--text-color);
            background-color: #fff;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .input-field::placeholder { color: var(--placeholder-color); }

        .input-field:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
        }
        
        .input-field:disabled {
            background-color: #f3f4f6; 
            cursor: not-allowed;
            color: var(--placeholder-color);
        }

        input[type=number]::-webkit-inner-spin-button, 
        input[type=number]::-webkit-outer-spin-button { 
          -webkit-appearance: none; 
          margin: 0; 
        }
        input[type=number] {
          -moz-appearance: textfield;
        }

        .btn {
            width: 100%;
            padding: 0.9rem;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            border: 1px solid transparent;
        }

        .submit-btn {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            margin-top: 1rem; 
        }
        .submit-btn:hover {
            background-color: var(--primary-hover-color);
            box-shadow: 0 4px 10px rgba(37, 99, 235, 0.2); 
        }

        .secondary-btn {
            background-color: #fff;
            color: var(--primary-color);
            border-color: var(--border-color);
        }
        .secondary-btn:hover {
            border-color: var(--primary-color);
            background-color: #f0f9ff;
        }
        .secondary-btn:disabled {
            background-color: #f3f4f6;
            color: var(--placeholder-color);
            border-color: var(--border-color);
            cursor: not-allowed;
        }

        .status-message {
            font-size: 0.9em;
            margin-top: 8px;
            text-align: center;
            min-height: 1.2em; 
        }
        .status-message.success { color: var(--success-color); font-weight: 500;}
        .status-message.error { color: var(--error-color); font-weight: 500;}
        .status-message.loading { color: var(--label-color); font-style: italic;}
        .status-message.timer { color: var(--label-color); font-weight: 500;} /* Style for timer text */

        /* --- OTP Timer Display --- */
        .otp-timer-display {
            font-size: 0.85em;
            margin-top: 5px;
            text-align: right; 
            color: var(--warning-color); 
            font-weight: 500;
            height: 1.1em; 
        }
        .otp-timer-display.expired {
             color: var(--error-color); 
        }


        #toast {
            visibility: hidden;
            min-width: 250px;
            position: fixed;
            top: 80px; 
            left: 50%;
            transform: translateX(-50%) translateY(-20px); 
            background-color: #4CAF50; 
            color: #fff;
            text-align: left;
            border-radius: 8px;
            padding: 15px;
            z-index: 2000; 
            font-size: 1rem; 
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
            opacity: 0;
            transition: all 0.5s ease;
        }
        #toast.show {
            visibility: visible;
            opacity: 1;
            transform: translateX(-50%) translateY(0); 
        }
        #toast.error { background-color: #f44336; }
        #toast.success { background-color: #4CAF50; }


        @media (max-width: 600px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .form-container {
                padding: 1.5rem;
                margin: 1rem 0; 
            }
            #toast {
                top: 70px; 
                left: 50%;
                right: auto;
                transform: translateX(-50%) translateY(-20px);
                min-width: 90%;
                max-width: calc(100% - 2rem); 
            }
            #toast.show {
                transform: translateX(-50%) translateY(0);
            }
        }
    </style>
</head>
<body>

    <%@ include file="/header/header.jsp" %>

    <main class="main-content">
        <div class="form-container">
            <h2 class="form-title">Student Password Reset</h2>
            
            <form id="reset-form" action="${pageContext.request.contextPath}/ResetPassword" method="POST" novalidate>
                <div class="form-grid">
                    
                    <div class="input-group full-width">
                        <label for="email">Email Address</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-envelope input-icon"></i>
                            <input type="email" id="email" class="input-field" placeholder="Enter your registered email address" required name="email">
                        </div>
                    </div>

                    <div class="full-width">
                        <button type="button" id="generate-otp-btn" class="btn secondary-btn">
                            <i class="fa-solid fa-paper-plane"></i>
                            <span id="otp-btn-text">Generate OTP</span>
                        </button>
                        <p id="otp-status" class="status-message" aria-live="polite"></p>
                    </div>
                    
                    <div class="input-group full-width">
                        <label for="otp">Enter OTP</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-key input-icon"></i>
                            <input 
                                type="number" 
                                id="otp" 
                                class="input-field" 
                                placeholder="Enter the 6-digit OTP sent to your email" 
                                required 
                                disabled 
                                maxlength="6"
                                oninput="javascript: if (this.value.length > this.maxLength) this.value = this.value.slice(0, this.maxLength);"
                                inputmode="numeric"
                                name="enteredotp"
                            >
                        </div>
                        <%-- Element to display OTP validity timer --%>
                        <p id="otp-timer" class="otp-timer-display" aria-live="polite"></p> 
                    </div>

                    <div class="input-group">
                        <label for="new-password">New Password</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="new-password" class="input-field" placeholder="Min. 8 characters" required minlength="8" name="newpassword">
                        </div>
                    </div>

                    <div class="input-group">
                        <label for="confirm-password">Confirm New Password</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="confirm-password" class="input-field" placeholder="Re-enter password" required>
                        </div>
                    </div>

                </div> 
                
                <button type="submit" class="btn submit-btn">
                    <i class="fa-solid fa-check"></i>
                    Update Password
                </button>
            </form>
        </div>
    </main> 

    <div id="toast"></div>

    <%@ include file="/header/footer.jsp" %>

    <script src="resetpassword.js"></script>
</body>
</html>

