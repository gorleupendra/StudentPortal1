/**
 * Manages the state of a button during an asynchronous request.
 * @param {HTMLButtonElement} button - The button element.
 * @param {boolean} isLoading - Whether to show the loading state.
 */
function setButtonLoading(button, isLoading) {
    if (!button) return;
    
    // Updated selectors to be more generic for any button
    const loadingIcon = button.querySelector('.loading-icon');
    const defaultIcon = button.querySelector('.default-icon, .send-icon, .check-icon, .fa-right-to-bracket'); // Find any default icon
    const buttonText = button.querySelector('.btn-text');

    if (isLoading) {
        button.disabled = true; // Disable button to prevent multiple clicks
        if (loadingIcon) loadingIcon.classList.remove('hidden');
        if (defaultIcon) defaultIcon.classList.add('hidden');
        // Hide text if a buttonText span exists
        if (buttonText) buttonText.classList.add('hidden'); 
        // Also hide text if it's just a span (like in your original button)
        const textSpan = button.querySelector('span:not(.btn-text)');
        if(textSpan && !loadingIcon) textSpan.classList.add('hidden'); // Hide simple span if loading
        
    } else {
        button.disabled = false; // Re-enable button
        if (loadingIcon) loadingIcon.classList.add('hidden');
        if (defaultIcon) defaultIcon.classList.remove('hidden');
        // Show text if a buttonText span exists
        if (buttonText) buttonText.classList.remove('hidden');
        // Also show text if it's just a span
        const textSpan = button.querySelector('span:not(.btn-text)');
        if(textSpan) textSpan.classList.remove('hidden');
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
    const submitBtn = document.getElementById('login-submit-btn'); // ADDED: Select submit button

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
            // Ensure both icons exist before toggling
            if(eyeIcon) eyeIcon.classList.toggle('hidden');
            if(eyeOffIcon) eyeOffIcon.classList.toggle('hidden');
        });
    });

    // --- Form Submission Logic ---
    if (form) { 
        form.addEventListener('submit', (event) => {
            event.preventDefault();
            
            // ADDED: Set button to loading state
            setButtonLoading(submitBtn, true);

            const formData = new URLSearchParams();
            formData.append('emailid', emailInput.value);
            formData.append('password', passwordInput.value);
           
            // Removed the initial "Validating..." toast, the button state is enough
            // showToast('Validating....', true);
            
            fetch(form.action, { 
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(errorText => {
                        // Throw the server's error message
                        throw new Error(errorText || 'An unknown server error occurred.');
                    });
                }
                return response.text();
            })
            .then(responseText => {
                // ADDED: Reset button state
                setButtonLoading(submitBtn, false);

                if (responseText.trim().toLowerCase().startsWith('success')) {
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
                // ADDED: Reset button state
                setButtonLoading(submitBtn, false);
                
                console.error('Error during login fetch:', error);
                // Show the specific error message from the server
                showToast(error.message || "Login failed.", false); 
            });
        });
    }
});
