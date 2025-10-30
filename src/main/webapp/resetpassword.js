 document.addEventListener('DOMContentLoaded', () => {
            const form = document.getElementById('reset-form');
            const emailInput = document.getElementById('email');
            const generateOtpBtn = document.getElementById('generate-otp-btn');
            const otpBtnText = document.getElementById('otp-btn-text'); 
            const otpStatus = document.getElementById('otp-status'); 
            const otpInput = document.getElementById('otp');
            const otpTimerDisplay = document.getElementById('otp-timer'); // Timer display element
            const newPasswordInput = document.getElementById('new-password');
            const confirmPasswordInput = document.getElementById('confirm-password');
            

            let otpResendTimerInterval = null; // Timer for RESEND button cooldown
            let otpValidityTimerInterval = null; // Timer for OTP VALIDITY period
            let otpResendCooldownSeconds = 60; // Resend cooldown is 1 minute
            let otpValiditySeconds = 600; // OTP is valid for 10 minutes (600 seconds)
            let isOtpExpired = true; // Flag to track if the current OTP is valid

            function showToast(message, isSuccess = true) {
                const toast = document.getElementById("toast");
                if (!toast) return; 
                toast.textContent = message;
                toast.className = "show " + (isSuccess ? "success" : "error");
                clearTimeout(toast.timer); 
                toast.timer = setTimeout(() => {
                    toast.className = toast.className.replace("show", ""); 
                }, 5000); 
            }
            
            function isValidEmail(email) {
                return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
            }
            
            function isValidOtp(otp) {
                return /^\d{6}$/.test(otp);
            }
            
            // --- Resend OTP Timer Function (Updates status paragraph below button) ---
            function startOtpResendTimer() {
                generateOtpBtn.disabled = true; 
                otpBtnText.textContent = 'Generate OTP'; 
                let secondsRemaining = otpResendCooldownSeconds;
                
                // Show resend timer in the status paragraph
                otpStatus.textContent = `You can resend OTP in ${secondsRemaining}s`; 
                otpStatus.className = 'status-message timer'; // Use timer style

                clearInterval(otpResendTimerInterval); 
                
                otpResendTimerInterval = setInterval(() => {
                    secondsRemaining--;
                    if (secondsRemaining >= 0) { // Keep showing 0s
                        otpStatus.textContent = `You can resend OTP in ${secondsRemaining}s`;
                    } else {
                        clearInterval(otpResendTimerInterval); 
                        otpStatus.textContent = 'You can now request a new OTP.'; 
                        otpStatus.className = 'status-message'; 
                        generateOtpBtn.disabled = false; 
                        otpBtnText.textContent = 'Generate OTP'; 
                    }
                }, 1000); 
            }

            // --- OTP Validity Timer Function (Uses corrected structure) ---
            function startOtpValidityTimer() {
                isOtpExpired = false; // Mark OTP as valid
                let timeLeft = otpValiditySeconds; // Use the 10-minute value
                
                // Function to format time (MM:SS) - defined within this scope
                function formatTime(seconds) {
                    const minutes = Math.floor(seconds / 60);
                    const remainingSeconds = seconds % 60;
                    // Ensure seconds are padded with a leading zero if less than 10
                    return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
                }

                // Update timer display immediately
                // *** FIX: Escaped the $ for JSP ***
                otpTimerDisplay.textContent = `OTP expires in ${formatTime(timeLeft)}`; 
                otpTimerDisplay.className = 'otp-timer-display'; // Reset style

                clearInterval(otpValidityTimerInterval); // Clear previous interval

                // Create an interval that runs every 1 second
                otpValidityTimerInterval = setInterval(function() {
                    timeLeft--; // Decrease the time
                    
                    if (timeLeft >= 0) {
                         // Update the display element with MM:SS format
                         // *** FIX: Escaped the $ for JSP ***
                         otpTimerDisplay.textContent = `OTP expires in ${formatTime(timeLeft)}`;
                    }

                    // When time reaches 0 or less
                    if (timeLeft < 0) { // Check less than 0 to ensure message shows after 00:00
                        clearInterval(otpValidityTimerInterval); // Stop the timer
                        otpTimerDisplay.textContent = "OTP has expired. Please request a new one."; // Final message
                        otpTimerDisplay.className = 'otp-timer-display expired'; // Style as expired
                        isOtpExpired = true; // Mark OTP as expired
                    }
                }, 1000); // 1000 ms = 1 second
            }


            // --- Generate OTP Button Click Listener ---
            generateOtpBtn.addEventListener('click', () => {
                otpStatus.textContent = '';
                otpStatus.className = 'status-message'; 
                otpTimerDisplay.textContent = ''; 
                otpTimerDisplay.className = 'otp-timer-display';
                clearInterval(otpValidityTimerInterval); 
                isOtpExpired = true; 

                const email = emailInput.value.trim();

                if (!email || !isValidEmail(email)) {
                    showToast('Please enter a valid email address.', false);
                    emailInput.focus();
                    return;
                }

                otpStatus.textContent = 'Verifying & Sending OTP...';
                otpStatus.classList.add('loading'); 
                generateOtpBtn.disabled = true; 
                otpBtnText.textContent = 'Sending...'; 

                const dataToSend = new URLSearchParams();
                dataToSend.append('email', email);

                const basePath = form.action.substring(0, form.action.lastIndexOf('/')); 
                const verifyEmailUrl = `${basePath}/verifyEmail`; 
                
                fetch(verifyEmailUrl, { // Corrected fetch URL usage
                    method: 'POST',
                    body: dataToSend
                })
                .then(response => {
                    const statusOk = response.ok; 
                    return response.text().then(text => ({ ok: statusOk, text: text, status: response.status })); 
                })
                .then(result => {
                    const responseMessage = result.text.replace(/^(success|error):?\s*/i, '').trim(); 
                    const isSuccess = result.text.toLowerCase().trim().startsWith("success");

                    if (isSuccess) {
                        showToast(responseMessage || 'OTP sent successfully!', true); 
                        otpStatus.textContent = ''; 
                        otpStatus.className = 'status-message'; 
                        otpInput.disabled = false; 
                        otpInput.focus();
                        startOtpResendTimer(); // Start the RESEND timer 
                        startOtpValidityTimer(); // Start the OTP VALIDITY timer
                    } else {
                        showToast(responseMessage || `Failed to send OTP. Email might not be registered.`, false); 
                        otpStatus.textContent = ''; 
                        otpStatus.className = 'status-message'; 
                        generateOtpBtn.disabled = false; 
                        otpBtnText.textContent = 'Generate OTP'; 
                    }
                })
                .catch(error => {
                    console.error('Error sending OTP:', error);
                    showToast(`Error: ${error.message || 'Could not connect. Please try again.'}`, false);
                    otpStatus.textContent = ''; 
                    otpStatus.className = 'status-message'; 
                    generateOtpBtn.disabled = false;
                    otpBtnText.textContent = 'Generate OTP'; 
                });
            });
            
            // --- Form Submission Listener ---
            form.addEventListener('submit', (event) => {
                event.preventDefault(); 
                let isValid = true;
                
                if (isOtpExpired) {
                     showToast('Your OTP has expired. Please request a new one.', false);
                     isValid = false;
                }
                
                if (otpInput.disabled || !isValidOtp(otpInput.value.trim())) {
                    showToast('OTP must be exactly 6 digits.', false);
                    if (!otpInput.disabled && isValid) otpInput.focus(); 
                    isValid = false;
                }
                
                if (newPasswordInput.value.length < 8) {
                    showToast('New password must be at least 8 characters long.', false);
                     if(isValid) newPasswordInput.focus(); 
                    isValid = false;
                } else if (newPasswordInput.value !== confirmPasswordInput.value) {
                    showToast('New passwords do not match.', false);
                     if(isValid) confirmPasswordInput.focus();
                    isValid = false;
                }
                
                if (isValid) {
                    const email = emailInput.value;
                    const enteredotp = otpInput.value;
                    const newpassword = newPasswordInput.value;

                    const dataToSend = new URLSearchParams();
                    dataToSend.append('email', email);
                    dataToSend.append('enteredotp', enteredotp);
                    dataToSend.append('newpassword', newpassword);
                    
                    fetch(form.action, { // Uses form's action attribute
                        method: 'POST',
                        body: dataToSend
                    })
                    .then(response => {
                        const statusOk = response.ok;
                        return response.text().then(text => ({ ok: statusOk, text: text, status: response.status }));
                     })
                    .then(result => {
                        const isSuccess = result.ok && result.text.toLowerCase().trim().startsWith("success"); 
                        const responseMessage = result.text.replace(/^(success|error):?\s*/i, '').trim(); 
                        
                        showToast(responseMessage || (isSuccess ? "Password updated!" : `Update failed`), isSuccess);
                        
                        if (isSuccess) {
                            form.reset(); 
                            otpInput.disabled = true; 
                            otpStatus.textContent = ''; 
                            otpStatus.className = 'status-message';
                            otpTimerDisplay.textContent = ''; 
                            otpTimerDisplay.className = 'otp-timer-display';
                            clearInterval(otpResendTimerInterval); 
                            clearInterval(otpValidityTimerInterval); 
                            generateOtpBtn.disabled = false; 
                            otpBtnText.textContent = 'Generate OTP';
                             setTimeout(() => { 
                                 window.location.href = 'login/login.jsp'; 
                             }, 5000);
                        }
                    })
                    .catch(error => {
                        console.error('Error resetting password:', error);
                        showToast(`Error: ${error.message || 'An error occurred.'}`, false);
                    });
                }
            });
            
        });