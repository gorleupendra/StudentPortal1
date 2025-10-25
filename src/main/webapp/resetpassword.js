document.addEventListener('DOMContentLoaded', () => {
    // --- Element Selections ---
    const form = document.getElementById('reset-form');
    const emailInput = document.getElementById('email');
    const generateOtpBtn = document.getElementById('generate-otp-btn');
    const otpStatus = document.getElementById('otp-status');
    const otpInput = document.getElementById('otp');
    const newPasswordInput = document.getElementById('new-password');
    const confirmPasswordInput = document.getElementById('confirm-password');
    const devAutofillBtn = document.getElementById('dev-autofill-btn');

    // --- Helper Functions ---
    function showToast(message, isSuccess = true) {
        const toast = document.getElementById("toast");
        toast.textContent = message;
        toast.className = "show " + (isSuccess ? "success" : "error");
        setTimeout(() => {
            toast.className = "";
        }, 5000);
    }
    
    function isValidEmail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    }
    
    function isValidOtp(otp) {
        const regex = /^\d{6}$/;
        return regex.test(otp);
    }

    function autofill() {
        emailInput.value = "gorleupendra32@gmail.com";
        newPasswordInput.value = "12345678";
        confirmPasswordInput.value = "12345678";
        showToast("Dev autofill complete.", true);
    }

    // --- Event Listeners ---
    generateOtpBtn.addEventListener('click', () => {
        otpStatus.textContent = '';
        otpStatus.className = 'status-message';
        const email = emailInput.value.trim();

        if (!email || !isValidEmail(email)) {
            showToast('Please enter a valid email address.', false);
            emailInput.focus();
            return;
        }

        otpStatus.textContent = 'Verifying & Sending OTP...';
        generateOtpBtn.disabled = true;

        const dataToSend = new URLSearchParams();
        dataToSend.append('email', email);

        fetch('verifyEmail', {
            method: 'POST',
            body: dataToSend
        })
        .then(response => response.text())
        .then(data => {
            const [responseType, ...messageParts] = data.split(':');
            const responseMessage = messageParts.join(':').trim();
            const isSuccess = responseType.toLowerCase() === "success";

            if (isSuccess) {
                otpStatus.textContent = responseMessage;
                otpStatus.classList.add('success');
                otpInput.disabled = false;
                otpInput.focus();
            } else {
                showToast(responseMessage || "An unknown error occurred.", false);
                otpStatus.textContent = '';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('Could not connect to the server. Please try again.', false);
            otpStatus.textContent = '';
        })
        .finally(() => {
            generateOtpBtn.disabled = false;
        });
    });
    
    form.addEventListener('submit', (event) => {
        event.preventDefault();
        let isValid = true;

        if (!isValidOtp(otpInput.value.trim())) {
            showToast('OTP must be exactly 6 digits.', false);
            isValid = false;
        }
        
        if (newPasswordInput.value.length < 8) {
            showToast('Password must be at least 8 characters long.', false);
            isValid = false;
        } else if (newPasswordInput.value !== confirmPasswordInput.value) {
            showToast('Passwords do not match.', false);
            isValid = false;
        }
        
        if (isValid) {
            // --- FIX HERE: Define variables by getting values from inputs ---
            const email = emailInput.value;
            const enteredotp = otpInput.value;
            const newpassword = newPasswordInput.value;

            const dataToSend = new URLSearchParams();
            dataToSend.append('email', email);
            dataToSend.append('enteredotp', enteredotp);
            dataToSend.append('newpassword', newpassword);

            fetch('ResetPassword', {
                method: 'POST',
                body: dataToSend
            })
            .then(response => response.text())
            .then(data => {
                const isSuccess = data.toLowerCase().includes("success");
                showToast(data, isSuccess);
                if (isSuccess) {
                    form.reset();
                    otpInput.disabled = true;
                    otpStatus.textContent = '';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('An error occurred. Please try again.', false);
            });
        }
    });

    devAutofillBtn.addEventListener('click', autofill);
});