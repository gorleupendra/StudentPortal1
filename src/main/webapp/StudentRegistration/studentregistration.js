document.addEventListener('DOMContentLoaded', () => {
	const form = document.getElementById("studentForm");
	const passwordInput = document.getElementById('password');
	const confirmPasswordInput = document.getElementById('confirm-password');
	const passwordErrorMessage = document.getElementById('password-error-message');
	const yearSelect = document.getElementById('dob-year');

	// Captcha elements
	const captchaDisplay = document.getElementById('captcha-display');
	const captchaInput = document.getElementById('captcha-input');
	const captchaRefreshBtn = document.getElementById('captcha-refresh');
	const captchaErrorMessage = document.getElementById('captcha-error-message');
	let currentCaptcha = '';

	// --- Captcha Generation ---
	function generateCaptcha() {
		const chars = '1234567890';
		let captcha = '';
		for (let i = 0; i < 6; i++) {
			captcha += chars.charAt(Math.floor(Math.random() * chars.length));
		}
		currentCaptcha = captcha;
		captchaDisplay.textContent = currentCaptcha;
		captchaErrorMessage.style.display = 'none';
		captchaInput.value = '';
	}

	// --- Populate Year Dropdown ---
	function populateYears() {
		const currentYear = new Date().getFullYear();
		const startYear = currentYear - 100;
		for (let year = currentYear - 15; year >= startYear; year--) {
			const option = document.createElement('option');
			option.value = year;
			option.textContent = year;
			yearSelect.appendChild(option);
		}
	}

	// --- File Input Preview ---
	function handleFileInputChange(inputElement, filenameSpan, previewImg, uploadLabel, defaultText) {
		inputElement.addEventListener('change', () => {
			if (inputElement.files.length > 0) {
				const file = inputElement.files[0];
				filenameSpan.textContent = file.name;
				filenameSpan.style.color = 'var(--text-color)';
				const reader = new FileReader();
				reader.onload = (e) => {
					previewImg.src = e.target.result;
					uploadLabel.classList.add('has-file');
				};
				reader.readDataURL(file);
			} else {
				filenameSpan.textContent = defaultText;
				filenameSpan.style.color = 'var(--placeholder-color)';
				uploadLabel.classList.remove('has-file');
				previewImg.src = '';
			}
		});
	}

	// --- Initial Setup ---
	populateYears();
	generateCaptcha();
	captchaRefreshBtn.addEventListener('click', generateCaptcha);

	handleFileInputChange(document.getElementById('photo-upload'), document.getElementById('photo-filename'), document.getElementById('photo-preview'), document.getElementById('photo-upload-label'), 'Upload a photo');
	handleFileInputChange(document.getElementById('sign-upload'), document.getElementById('sign-filename'), document.getElementById('sign-preview'), document.getElementById('sign-upload-label'), 'Upload signature');


	// --- Toast Function ---
	function showToast(message, isSuccess = true) {
		const toast = document.getElementById("toast");
		if (!toast) return; // Ensure toast container exists
		toast.textContent = message;
		toast.className = "show " + (isSuccess ? "success" : "error");

		// Hide the toast after 5 seconds
		setTimeout(() => {
			toast.className = toast.className.replace("show", "");
		}, 5000);
	}


	// --- Validation Function ---
	function validateForm() {
		// Clear previous dynamic errors
		passwordErrorMessage.style.display = 'none';
		captchaErrorMessage.style.display = 'none';

		// 1. Check all 'required' text/number/email/tel inputs
		// We use querySelectorAll to find inputs and selects that have the 'required' attribute
		const requiredFields = form.querySelectorAll('input[required], select[required]');

		for (const field of requiredFields) {
			const label = field.labels[0] ? field.labels[0].textContent : field.name;

			// Check text/number/password/email/tel fields
			if (field.type !== 'file' && field.tagName !== 'SELECT' && field.value.trim() === "") {
				showToast(`Error: '${label}' is required.`, false);
				field.focus();
				return false;
			}

			// Check select fields
			if (field.tagName === 'SELECT' && field.value === "") {
				showToast(`Error: Please select a value for '${label}'.`, false);
				field.focus();
				return false;
			}

			// Check file fields (photo and sign)
			if (field.type === 'file' && field.files.length === 0) {
				showToast(`Error: Please upload a file for '${label}'.`, false);
				// Note: focusing a file input is tricky, we just show the error.
				return false;
			}
		}

		// 2. Specific Format Validations
		const emailInput = document.getElementById('email');
		// A simple regex for email validation
		const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		if (!emailRegex.test(emailInput.value)) {
			showToast('Error: Please enter a valid email address.', false);
			emailInput.focus();
			return false;
		}

		const phoneInput = document.getElementById('phone');
		const phoneRegex = /^\d{10}$/; // Simple 10-digit phone regex
		if (!phoneRegex.test(phoneInput.value)) {
			showToast('Error: Phone number must be 10 digits.', false);
			phoneInput.focus();
			return false;
		}

		const pincodeInput = document.getElementById('pincode');
		const pincodeRegex = /^\d{6}$/; // Simple 6-digit pincode regex
		if (!pincodeRegex.test(pincodeInput.value)) {
			showToast('Error: Pincode must be 6 digits.', false);
			pincodeInput.focus();
			return false;
		}

		// 3. Password Match
		if (passwordInput.value !== confirmPasswordInput.value) {
			// Use the specific error message <p> tag for password
			passwordErrorMessage.textContent = 'Passwords do not match.';
			passwordErrorMessage.style.display = 'block';
			confirmPasswordInput.focus();
			return false;
		}

		// 4. Captcha Validation
		if (captchaInput.value.trim() !== currentCaptcha) {
			// Use the specific error message <p> tag for captcha
			captchaErrorMessage.textContent = 'Captcha is incorrect. Please try again.';
			captchaErrorMessage.style.display = 'block';
			generateCaptcha(); // Generate a new captcha
			captchaInput.focus();
			return false;
		}

		// If all checks pass
		return true;
	}
	// --- End of Validation Function ---


	// --- Form Submission Event Listener ---
	form.addEventListener('submit', (event) => {
		event.preventDefault(); // Always stop the default submission

		// Run the validation function.
		// If it returns false, stop right here.
		if (!validateForm()) {
			return;
		}

		// --- AJAX form submission (Only runs if validation passed) ---
		const formData = new FormData(form);
		const submitButton = form.querySelector('.submit-btn');
		submitButton.disabled = true;
		submitButton.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Submitting...';

		fetch(form.action, {
			method: 'POST',
			body: formData
		})
			.then(response => {
				// Check if the response status is OK (200-299) or Conflict (409)
				if (response.ok || response.status === 409) {
					// If it's OK or Conflict, we still want to read the text message from the body
					return response.text().then(text => ({ status: response.status, ok: response.ok, text: text }));
				} else {
					// For other server errors (like 500), throw an error immediately
					throw new Error(`Server error: ${response.status} ${response.statusText}`);
				}
			})
			.then(({ status, ok, text }) => { // Destructure the object passed from the previous .then
				let message = text; // Use the text from the response as the default message
				let isSuccess = ok && text.toLowerCase().includes("success"); // Success only if status is OK AND text includes "success"

				// Specifically check for the duplicate key error (HTTP status 409)
				if (status === 409) {
					isSuccess = false; // Ensure it's marked as not successful
					// The message 'text' already contains the specific duplicate error from the servlet
					console.error("Duplicate entry detected:", message); // Log the specific error
				} else if (!ok) {
					// Handle other potential non-OK statuses that might have slipped through (though unlikely with current logic)
					isSuccess = false;
					console.error("Server returned non-OK status:", status, message);
				}

				// Show the toast with the message received from the server
				showToast(message, isSuccess);

				// Reset form only on actual success
				if (isSuccess) {
					form.reset();
					// Manually reset file previews
					document.getElementById('photo-filename').textContent = 'Upload a photo';
					document.getElementById('sign-filename').textContent = 'Upload signature';
					document.getElementById('photo-upload-label').classList.remove('has-file');
					document.getElementById('sign-upload-label').classList.remove('has-file');
					// Clear previews safely
					const photoPreview = document.getElementById('photo-preview');
					const signPreview = document.getElementById('sign-preview');
					if (photoPreview) photoPreview.src = '#'; // Use '#' or ''
					if (signPreview) signPreview.src = '#'; // Use '#' or ''
				}
			})
			.catch(error => {
				// Handle network errors or errors thrown from the first .then()
				console.error('Fetch Error:', error);
				showToast(`Registration failed: ${error.message}`, false);
			})
        .finally(() => {
			generateCaptcha();
			submitButton.disabled = false;
			submitButton.innerHTML = '<i class="fa-solid fa-user-graduate"></i> Submit';
		});
	});

});