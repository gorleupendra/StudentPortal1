document.addEventListener('DOMContentLoaded', function() {
    // --- Element Selections ---
    const form = document.getElementById('login-form');
    const emailInput = document.getElementById("student-id");
    const passwordInput = document.getElementById('login-password');
    const passwordToggles = document.querySelectorAll('.password-toggle');

    // --- NEW: Clear the form on every page refresh ---
    if (form) {
        form.reset();
    }

    // --- Password Visibility Toggle Logic ---
    passwordToggles.forEach(toggle => {
        toggle.addEventListener('click', function() {
            const wrapper = this.closest('.input-wrapper');
            const input = wrapper.querySelector('input');
            const eyeIcon = wrapper.querySelector('.eye-icon');
            const eyeOffIcon = wrapper.querySelector('.eye-off-icon');
            const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
            input.setAttribute('type', type);
            eyeIcon.classList.toggle('hidden');
            eyeOffIcon.classList.toggle('hidden');
        });
    });

    // --- Form Submission Logic ---
    if (form) { 
        form.addEventListener('submit', (event) => {
            event.preventDefault();

            const formData = new URLSearchParams();
            formData.append('emailid', emailInput.value);
            formData.append('password', passwordInput.value);
            
            showToast('Wait....', true);

            fetch('LoginPage', { 
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(errorText => {
                        throw new Error(errorText || 'An unknown server error occurred.');
                    });
                }
                return response.text();
            })
            .then(responseText => {
                if (responseText.trim().toLowerCase().startsWith('success')) {
                    // REMOVED: The line that saved the studentId to sessionStorage
                    sessionStorage.setItem('justLoggedIn', 'true');

                    showToast("Login successful! Redirecting...", true);
                    
                    const parts = responseText.split(':');
                    const redirectUrl = parts.length > 1 ? parts[1].trim() : "studentDashboard.jsp";

                    setTimeout(() => {
                        window.location.href = redirectUrl;
                    }, 1500);

                } else {
                    showToast(responseText, false);
                }
            })
            .catch(error => {
                console.error('Error during login fetch:', error);
                showToast(error.message, false);
            });
        });
    }
});

/**
 * Displays a toast notification message.
 */
function showToast(message, isSuccess = true) {
    const toast = document.getElementById("toast");
    if (!toast) return;
    toast.textContent = message;
    toast.className = "show " + (isSuccess ? "success" : "error");
    
    setTimeout(() => { 
        toast.className = toast.className.replace("show", ""); 
    }, 5000);
}