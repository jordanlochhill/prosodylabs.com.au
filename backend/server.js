const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const sgMail = require('@sendgrid/mail');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors({
    origin: ['https://prosodylabs.com.au', 'http://localhost:4000'],
    methods: ['GET', 'POST', 'OPTIONS'],
    allowedHeaders: ['Content-Type'],
    credentials: false
}));
app.use(express.json());

// Ensure data directory exists
const dataDir = path.join(__dirname, 'data');
if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir);
}

// Email configuration (optional)
const emailEnabled = !!process.env.SENDGRID_API_KEY && process.env.SENDGRID_API_KEY.trim() !== '';

if (emailEnabled) {
    try {
        sgMail.setApiKey(process.env.SENDGRID_API_KEY);
        console.log('📧 SendGrid email sending enabled');
    } catch (error) {
        console.log('❌ SendGrid configuration error:', error.message);
        console.log('📁 Email sending disabled - submissions will be saved to files only');
    }
} else {
    console.log('📁 Email sending disabled - submissions will be saved to files only');
    console.log('   To enable email sending, configure SENDGRID_API_KEY in .env file');
}

// Waitlist endpoint
app.post('/api/waitlist', async (req, res) => {
    try {
        const { name, email, notes } = req.body;

        // Validate required fields
        if (!name || !email) {
            return res.status(400).json({
                error: 'Name and email are required'
            });
        }

        // Validate email format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            return res.status(400).json({
                error: 'Invalid email format'
            });
        }

        // Create submission data
        const submission = {
            id: Date.now(),
            timestamp: new Date().toISOString(),
            name: name.trim(),
            email: email.trim(),
            notes: notes ? notes.trim() : '',
            ip: req.ip || req.connection.remoteAddress,
            userAgent: req.get('User-Agent')
        };

        // Save to JSON file
        const submissionsFile = path.join(dataDir, 'waitlist-submissions.json');
        let submissions = [];

        // Read existing submissions
        if (fs.existsSync(submissionsFile)) {
            try {
                const data = fs.readFileSync(submissionsFile, 'utf8');
                submissions = JSON.parse(data);
            } catch (err) {
                console.error('Error reading submissions file:', err);
                submissions = [];
            }
        }

        // Add new submission
        submissions.push(submission);

        // Write back to file
        fs.writeFileSync(submissionsFile, JSON.stringify(submissions, null, 2));

        // Also log to console for immediate visibility
        console.log('\n🎉 NEW WAITLIST SUBMISSION:');
        console.log(`Name: ${submission.name}`);
        console.log(`Email: ${submission.email}`);
        console.log(`Notes: ${submission.notes || 'None'}`);
        console.log(`Time: ${submission.timestamp}`);
        console.log('---\n');

        // Create email content
        const emailText = `From: "${submission.name}" <${submission.email}>
To: ${process.env.EMAIL_TO || 'info@prosodylabs.com.au'}
Subject: Yarn Waitlist Request - ${submission.name}

Hello Prosody Labs team,

I would like to join the Yarn waitlist.

${submission.notes ? `Additional information: ${submission.notes}` : ''}

Best regards,
${submission.name}
${submission.email}

---
Submitted: ${submission.timestamp}
IP: ${submission.ip}`;

        const emailHtml = `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <div style="background: #fdf6ec; padding: 30px; border-radius: 8px; border-left: 4px solid #c2721c;">
          <p style="font-size: 16px; margin-bottom: 20px;">Hello Prosody Labs team,</p>
          <p style="font-size: 16px; margin-bottom: 20px;">I would like to join the Yarn waitlist.</p>
          ${submission.notes ? `<div style="background: #fff; padding: 15px; border-radius: 4px; margin: 20px 0;"><strong>Additional information:</strong><br>${submission.notes}</div>` : ''}
          <p style="font-size: 16px; margin-top: 30px;">Best regards,<br><strong>${submission.name}</strong><br>${submission.email}</p>
        </div>
        <div style="margin-top: 20px; font-size: 12px; color: #666; text-align: center;">
          <p>This email was sent from the Prosody Labs website waitlist form.</p>
          <p>Submitted: ${submission.timestamp}</p>
        </div>
      </div>
    `;

        // Save individual email file
        const emailFile = path.join(dataDir, `waitlist-${submission.id}.txt`);
        fs.writeFileSync(emailFile, emailText);

        // Send email if configured (non-blocking)
        if (emailEnabled) {
            // Send email asynchronously without blocking the response
            setImmediate(() => {
                console.log('📧 Attempting to send email via SendGrid...');
                const msg = {
                    to: process.env.EMAIL_TO || 'info@prosodylabs.com.au',
                    from: process.env.EMAIL_FROM || 'noreply@prosodylabs.com.au', // Must be verified in SendGrid
                    replyTo: submission.email,
                    subject: `Yarn Waitlist Request - ${submission.name}`,
                    text: emailText,
                    html: emailHtml
                };

                sgMail
                    .send(msg)
                    .then(() => {
                        console.log('📧 Email sent successfully via SendGrid');
                    })
                    .catch((error) => {
                        console.error('❌ Failed to send email via SendGrid:', error.message);
                        console.log('📁 Email content saved to file instead');
                    });
            });
        } else {
            console.log('📁 Email sending disabled, saving to file only');
        }

        res.json({
            success: true,
            message: 'Thank you for joining the waitlist! We\'ll be in touch soon.'
        });

    } catch (error) {
        console.error('Error processing submission:', error);
        res.status(500).json({
            error: 'Failed to process submission. Please try again or contact us directly.'
        });
    }
});

// View submissions endpoint
app.get('/api/submissions', (req, res) => {
    try {
        const submissionsFile = path.join(dataDir, 'waitlist-submissions.json');

        if (!fs.existsSync(submissionsFile)) {
            return res.json({ submissions: [] });
        }

        const data = fs.readFileSync(submissionsFile, 'utf8');
        const submissions = JSON.parse(data);

        res.json({ submissions });
    } catch (error) {
        console.error('Error reading submissions:', error);
        res.status(500).json({ error: 'Failed to read submissions' });
    }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
    res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Prosody Labs waitlist server running on port ${PORT}`);
    console.log(`📧 Email endpoint: http://localhost:${PORT}/api/waitlist`);
    console.log(`💚 Health check: http://localhost:${PORT}/api/health`);
});

module.exports = app;
