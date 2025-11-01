/**
 * Manages the state of a button during an asynchronous request.
 * @param {HTMLButtonElement} button - The button element.
 * @param {boolean} isLoading - Whether to show the loading state.
 * @param {string} [loadingText] - RECTIFIED: Optional text to display when loading.
 */
function setButtonLoading(button, isLoading, loadingText = null) {
    if (!button) return;
    
    const loadingIcon = button.querySelector('.loading-icon');
    const defaultIcon = button.querySelector('.default-icon, .fa-user-graduate'); 
    const buttonText = button.querySelector('.btn-text'); // This is "Sign In"

    if (isLoading) {
        button.disabled = true;
        if (loadingIcon) loadingIcon.classList.remove('hidden');
        if (defaultIcon) defaultIcon.classList.add('hidden');
        
        // RECTIFIED: Show custom loading text if provided
        if (buttonText) {
            if (loadingText) {
                buttonText.textContent = loadingText; // Set new text
                buttonText.classList.remove('hidden'); // Make sure it's visible
            } else {
                buttonText.classList.add('hidden'); // Hide if no text provided
            }
        }
        
    } else {
        button.disabled = false;
        if (loadingIcon) loadingIcon.classList.add('hidden');
        if (defaultIcon) defaultIcon.classList.remove('hidden');
        
        // RECTIFIED: Reset text back to the default
        if (buttonText) {
            buttonText.textContent = "Sign In"; // Reset to original text
            buttonText.classList.remove('hidden');
        }
    }
}


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


document.addEventListener('DOMContentLoaded', function() {
    // --- Element Selections ---
    const form = document.getElementById('login-form');
    const emailInput = document.getElementById("student-id");
    const passwordInput = document.getElementById('login-password');
    const passwordToggles = document.querySelectorAll('.password-toggle');
    const submitBtn = document.getElementById('login-submit-btn');

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

            // Toggle input type
            const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
            input.setAttribute('type', type);

            // Toggle icon visibility
            if(eyeIcon) eyeIcon.classList.toggle('hidden');
            if(eyeOffIcon) eyeOffIcon.classList.toggle('hidden');
        });
    });

    // --- Form Submission Logic ---
    if (form) { 
        form.addEventListener('submit', (event) => {
            event.preventDefault();
            
            // RECTIFIED: Set button text to "Processing..."
            setButtonLoading(submitBtn, true, "Processing...");

            const formData = new URLSearchParams();
            formData.append('emailid', emailInput.value);
            formData.append('password', passwordInput.value);
           
            fetch(form.action, { 
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
                // RECTIFIED: Don't reset the button here on success yet.

                if (responseText.trim().toLowerCase().startsWith('success')) {
                    sessionStorage.setItem('justLoggedIn', 'true');
                    showToast("Login successful! Redirecting...", true);
                    
                    // RECTIFIED: Change button text to "Redirecting..."
                    setButtonLoading(submitBtn, true, "Redirecting...");

                    const parts = responseText.split(':');
                    const redirectUrl = parts.length > 1 ? parts[1].trim() : "studentDashboard.jsp";

                    setTimeout(() => {
                        window.location.href = redirectUrl;
                        // No need to reset the button, the page is changing
                    }, 1500);

                } else {
                    // RECTIFIED: Reset button ONLY on failure
                    setButtonLoading(submitBtn, false);
                    showToast(responseText, false);
                }
            })
            .catch(error => {
                // RECTIFIED: Reset button on error
                setButtonLoading(submitBtn, false);
                
                console.error('Error during login fetch:', error);
                showToast(error.message || "Login failed.", false); 
            });
        });
    }
});