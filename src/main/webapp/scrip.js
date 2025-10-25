// Flag to track OTP verification
let otpVerified = false;

// Show toast notification
function showToast(message, isSuccess = true) {
    const toast = document.getElementById("toast");
    toast.textContent = message;
    toast.className = "show " + (isSuccess ? "success" : "error");

    // Hide after 5 seconds
    setTimeout(() => {
        toast.className = "";
    }, 5000);
}

// Send OTP / Verify Email
function verifyEmail() {
    const email = document.getElementById("email").value.trim();
    if (!email) {
        showToast("Enter an email first!", false);
        return;
    }

    fetch("verifyEmail", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({ email: email })
    })
    .then(res => res.text())
    .then(data => {
        const isSuccess = data.toLowerCase().includes("success");
        showToast(data, isSuccess);

        if (isSuccess) {
            // Optionally enable OTP input & verify button
            document.getElementById("otp").disabled = false;
            document.querySelector('button[onclick="verifyOtp()"]').disabled = false;
        }
    })
    .catch(err => showToast("Error sending OTP", false));
}

// Verify OTP
function verifyOtp() {
    const otp = document.getElementById("otp").value.trim();
    if (!otp) {
        showToast("Enter OTP first!", false);
        return;
    }

    fetch("verifyOtp", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({ otp: otp })
    })
    .then(res => res.text())
    .then(data => {
        const isSuccess = data.toLowerCase().includes("success");
        showToast(data, isSuccess);

        if (isSuccess) {
            otpVerified = true;
            document.getElementById("sendPassword").disabled = false; // Enable submit
        } else {
            otpVerified = false;
            document.getElementById("sendPassword").disabled = true;
        }
    })
    .catch(err => showToast("Error verifying OTP", false));
}



