document.addEventListener('DOMContentLoaded', function() {
    // Select the element where we will display the protected data.
    const profileMessageContainer = document.getElementById('profile-message');

    // 1. Retrieve the token from local storage.
    const token = sessionStorage.getItem('authToken');

    // 2. If no token is found, the user is not logged in. Redirect immediately.
    if (!token) {
        console.error('No authentication token found. Redirecting to login.');
        // Clear any potentially lingering session data.
        sessionStorage.removeItem('loginInstanceId');
        window.location.href = 'login.html';
        return; // Stop the script execution.
    }
    // 3. If a token exists, send it to the server for validation.
    fetch('ProfileServlet', {
        method: 'GET',
        headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        // 4. Check if the server responded with an unauthorized status.
        if (response.status === 401 || response.status === 403) {
            // The token is invalid or expired.
            console.error('Invalid or expired token. Redirecting to login.');
            // Clean up stale tokens from storage.
            sessionStorage.removeItem('authToken');
            sessionStorage.removeItem('loginInstanceId');
            window.location.href = 'login.html';
            // Throw an error to stop the promise chain.
            throw new Error('Unauthorized');
        }
        if (!response.ok) {
            throw new Error('Network response was not ok.');
        }
        // If the response is OK, parse the JSON data.
        return response.json();
    })
    .then(data => {
        // 5. The token is valid. Display the protected data from the server.
        if (profileMessageContainer) {
            profileMessageContainer.textContent = data.message;
            profileMessageContainer.style.color = '#155724'; // Success color
            profileMessageContainer.style.backgroundColor = '#d4edda'; // Success background
            profileMessageContainer.style.borderColor = '#c3e6cb';
        }
    })
    .catch(error => {
        // 6. Handle any errors (e.g., network failure, unauthorized).
        console.error('Error fetching profile:', error);
        if (profileMessageContainer) {
            // Do not redirect here unless it's an auth error, which is handled above.
            // Just inform the user that data couldn't be loaded.
            if (error.message !== 'Unauthorized') {
                 profileMessageContainer.textContent = 'Could not load profile data. Please check your connection.';
                 profileMessageContainer.style.color = '#721c24'; // Error color
                 profileMessageContainer.style.backgroundColor = '#f8d7da'; // Error background
                 profileMessageContainer.style.borderColor = '#f5c6cb';
            }
        }
    });
});
/**
 * 
 */