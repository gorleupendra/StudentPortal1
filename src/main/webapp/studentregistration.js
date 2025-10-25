
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
		for (let year = currentYear; year >= startYear; year--) {
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
				reader.readAsDataURL(file);
			} else {
				filenameSpan.textContent = defaultText;
				uploadLabel.classList.remove('has-file');
			}
		});
	}

	// --- Initial Setup ---
	populateYears();
	generateCaptcha();
	captchaRefreshBtn.addEventListener('click', generateCaptcha);

	handleFileInputChange(document.getElementById('photo-upload'), document.getElementById('photo-filename'), document.getElementById('photo-preview'), document.getElementById('photo-upload-label'), 'Upload a photo');
	handleFileInputChange(document.getElementById('sign-upload'), document.getElementById('sign-filename'), document.getElementById('sign-preview'), document.getElementById('sign-upload-label'), 'Upload signature');

	// --- Form Submission Validation & AJAX ---
	form.addEventListener('submit', (event) => {
		event.preventDefault();
		let isValid = true;

		// Reset previous errors
		passwordErrorMessage.style.display = 'none';
		captchaErrorMessage.style.display = 'none';

		// Password match validation
		if (passwordInput.value !== confirmPasswordInput.value) {
			passwordErrorMessage.textContent = 'Passwords do not match.';
			passwordErrorMessage.style.display = 'block';
			isValid = false;
		}

		// Captcha validation (case-insensitive)
		if (captchaInput.value.trim().toLowerCase() !== currentCaptcha.toLowerCase()) {
			captchaErrorMessage.textContent = 'Captcha is incorrect. Please try again.';
			captchaErrorMessage.style.display = 'block';
			generateCaptcha(); // Generate a new captcha
			isValid = false;
		}

		if (!isValid) return; // Stop submission if validation fails

		// --- AJAX form submission ---
		const formData = new FormData(form); // Collect all form data
		fetch('studentRegistration', {
			method: 'POST',
			body: formData
		})

			.then(response => response.text()) // Servlet should return "success" or "fail"
			.then(data => {
       			 const isSuccess = data.toLowerCase().includes("success");
        			showToast(data, isSuccess);
        			if(isSuccess)
        			{
        			form.reset();
					}
    })
			.catch(error => {
				console.error('Error:', error);
				showToast('An error occurred. Please try again.', false);
				generateCaptcha();  // Refresh captcha
			});
	});

	// --- Toast Function ---
	function showToast(message, isSuccess = true) {
		const toast = document.getElementById("toast");
		if (!toast) return; // Ensure toast container exists
		toast.textContent = message;
		toast.className = "show " + (isSuccess ? "success" : "error");
		setTimeout(() => { toast.className = ""; }, 5000);
	}
});
