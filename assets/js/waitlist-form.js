document.addEventListener('DOMContentLoaded', function () {
    const waitlistForm = document.getElementById('waitlist-form');
    const feedback = document.getElementById('waitlist-feedback');
    const submitButton = waitlistForm?.querySelector('button[type="submit"]');
    const waitlistRecipient = 'info@prosodylabs.com.au';

    if (!waitlistForm) {
        return;
    }

    // Form validation
    function validateField(field) {
        const errorElement = document.getElementById(field.id + '-error');
        let isValid = true;
        let errorMessage = '';

        if (field.hasAttribute('required') && !field.value.trim()) {
            isValid = false;
            errorMessage = 'This field is required.';
        } else if (field.type === 'email' && field.value.trim()) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(field.value.trim())) {
                isValid = false;
                errorMessage = 'Please enter a valid email address.';
            }
        }

        if (errorElement) {
            errorElement.textContent = errorMessage;
            field.setAttribute('aria-invalid', !isValid);
        }

        return isValid;
    }

    // Real-time validation
    const fields = waitlistForm.querySelectorAll('input, textarea');
    fields.forEach(field => {
        field.addEventListener('blur', () => validateField(field));
        field.addEventListener('input', () => {
            if (field.getAttribute('aria-invalid') === 'true') {
                validateField(field);
            }
        });
    });

    waitlistForm.addEventListener('submit', function (event) {
        event.preventDefault();

        // Clear previous feedback
        if (feedback) {
            feedback.innerHTML = '';
        }

        // Validate all fields
        let isFormValid = true;
        fields.forEach(field => {
            if (!validateField(field)) {
                isFormValid = false;
            }
        });

        if (!isFormValid) {
            // Focus first invalid field
            const firstInvalid = waitlistForm.querySelector('[aria-invalid="true"]');
            if (firstInvalid) {
                firstInvalid.focus();
            }
            return;
        }

        // Show loading state
        if (submitButton) {
            submitButton.classList.add('loading');
            submitButton.disabled = true;
        }

        // Prepare form data
        const formData = {
            name: document.getElementById('waitlist-name').value.trim(),
            email: document.getElementById('waitlist-email').value.trim(),
            notes: document.getElementById('waitlist-notes').value.trim()
        };

        // Send email using configured backend server
        const apiUrl = window.siteConfig.api.baseUrl + window.siteConfig.api.waitlistEndpoint;
        fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(formData)
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Show success message
                    if (feedback) {
                        feedback.innerHTML = '';
                        const successMessage = document.createElement('div');
                        successMessage.className = 'form-success';
                        successMessage.innerHTML = `
                        <p><strong>Thank you for joining the Yarn waitlist!</strong></p>
                        <p>We've received your request and will be in touch soon with updates about Yarn's availability.</p>
                        <p style="margin-top: 0.5rem; font-size: 0.9rem; color: var(--color-text-muted);">
                            You should receive a confirmation email shortly.
                        </p>
                    `;
                        feedback.appendChild(successMessage);
                    }

                    // Clear form
                    waitlistForm.reset();

                    // Remove validation states
                    fields.forEach(field => {
                        field.removeAttribute('aria-invalid');
                        const errorElement = document.getElementById(field.id + '-error');
                        if (errorElement) {
                            errorElement.textContent = '';
                        }
                    });
                } else {
                    throw new Error(data.error || 'Failed to submit form');
                }
            })
            .catch(error => {
                console.error('Waitlist submission error:', error);

                // Show error message with fallback option
                if (feedback) {
                    feedback.innerHTML = '';
                    const errorMessage = document.createElement('div');
                    errorMessage.className = 'form-error';

                    const subject = encodeURIComponent('Yarn Waitlist Request - ' + formData.name);
                    const body = encodeURIComponent(
                        `New waitlist request:\n\n` +
                        `Name: ${formData.name}\n` +
                        `Email: ${formData.email}\n` +
                        (formData.notes ? `Notes: ${formData.notes}\n` : '') +
                        `\nTimestamp: ${new Date().toLocaleString()}\n` +
                        `Source: Website waitlist form`
                    );
                    const mailtoLink = `mailto:${waitlistRecipient}?subject=${subject}&body=${body}`;

                    errorMessage.innerHTML = `
                    <p><strong>Sorry, there was an issue submitting your request.</strong></p>
                    <p>Please try sending us an email directly:</p>
                    <p style="margin-top: 1rem;">
                        <a href="${mailtoLink}" class="button primary" style="display: inline-block; text-decoration: none;">
                            Send Email to ${waitlistRecipient}
                        </a>
                    </p>
                `;
                    feedback.appendChild(errorMessage);
                }
            })
            .finally(() => {
                // Reset button state
                if (submitButton) {
                    submitButton.classList.remove('loading');
                    submitButton.disabled = false;
                }
            });
    });
});

