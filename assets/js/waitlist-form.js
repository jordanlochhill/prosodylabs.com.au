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

        // Simulate processing delay for better UX
        setTimeout(() => {
            const name = document.getElementById('waitlist-name').value.trim();
            const email = document.getElementById('waitlist-email').value.trim();
            const notes = document.getElementById('waitlist-notes').value.trim();

            const subject = encodeURIComponent('Yarn waitlist enquiry');
            const details = [
                name ? `Name: ${name}` : null,
                email ? `Email: ${email}` : null,
                notes ? `Context: ${notes}` : null
            ].filter(Boolean).join('\n');
            const body = encodeURIComponent(details);

            const mailtoLink = `mailto:${waitlistRecipient}?subject=${subject}&body=${body}`;

            // Try to open email client
            window.open(mailtoLink, '_self');

            if (feedback) {
                feedback.innerHTML = '';

                const message = document.createElement('p');
                message.textContent = `We've drafted an email to ${waitlistRecipient}. Please send it from your email client to complete your waitlist request.`;
                feedback.appendChild(message);

                const prompt = document.createElement('p');
                prompt.textContent = 'If your email client did not open automatically, you can click here:';
                feedback.appendChild(prompt);

                const manualLink = document.createElement('a');
                manualLink.href = mailtoLink;
                manualLink.textContent = waitlistRecipient;
                manualLink.classList.add('waitlist-feedback-link');
                feedback.appendChild(manualLink);
            }

            // Reset form state
            if (submitButton) {
                submitButton.classList.remove('loading');
                submitButton.disabled = false;
            }
        }, 500);
    });
});

