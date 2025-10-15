# Prosody Labs Waitlist Backend

A flexible Node.js backend server that handles waitlist form submissions. Choose between file storage only or automatic email sending - no configuration required for basic usage!

## Setup Instructions

### Option 1: Docker Deployment (Recommended)

#### Quick Start with Docker Compose

1. **Configure Environment Variables**
   ```bash
   cp env.example .env
   # Edit .env and add your SendGrid API key (optional)
   ```

2. **Start with Docker Compose**
   ```bash
   docker-compose up -d
   ```

3. **Check Status**
   ```bash
   docker-compose ps
   docker-compose logs -f waitlist-api
   ```

4. **Test the Setup**
   Visit `http://localhost:3001/api/health` to verify the server is running.

#### Manual Docker Build

```bash
# Build the image
docker build -t prosodylabs-waitlist-api .

# Run the container
docker run -d \
  --name waitlist-api \
  -p 3001:3001 \
  -v $(pwd)/data:/app/data \
  -e SENDGRID_API_KEY=your_api_key_here \
  -e EMAIL_TO=info@prosodylabs.com.au \
  -e EMAIL_FROM=noreply@prosodylabs.com.au \
  prosodylabs-waitlist-api
```

### Option 2: Local Development

#### 1. Install Dependencies

```bash
cd backend
npm install
```

#### 2. Configure Email (Optional)

If you want automatic email sending, copy and configure the environment file:

```bash
cp env.example .env
```

Edit `.env` and add your SendGrid settings (see Email Configuration section below).

#### 3. Start the Server

```bash
# Development mode (with auto-restart)
npm run dev

# Or production mode
npm start
```

The server will start on `http://localhost:3001`

#### 4. Test the Setup

Visit `http://localhost:3001/api/health` to verify the server is running.

## How It Works

When someone submits the waitlist form:

1. **Data is stored** in `backend/data/waitlist-submissions.json`
2. **Console notification** shows the submission details immediately
3. **Individual email files** are created in `backend/data/` for easy copying
4. **Email is sent automatically** (if SMTP is configured) OR saved to files only

## API Endpoints

- `POST /api/waitlist` - Submit waitlist form
- `GET /api/submissions` - View all submissions
- `GET /api/health` - Health check

## File Structure

```
backend/
├── data/
│   ├── waitlist-submissions.json    # All submissions in JSON format
│   ├── waitlist-1234567890.txt      # Individual email files
│   └── waitlist-1234567891.txt      # Ready to copy/paste
├── server.js
└── package.json
```

## Managing Submissions

### View All Submissions
Visit `http://localhost:3001/api/submissions` to see all submissions in JSON format.

### Individual Email Files
Each submission creates a text file like `waitlist-1234567890.txt` with the email content ready to copy/paste into your email client.

### Console Output
When someone submits the form, you'll see:
```
🎉 NEW WAITLIST SUBMISSION:
Name: Jane Smith
Email: jane@company.com
Notes: Looking to integrate Yarn for our AI workloads
Time: 2025-01-15T10:30:00.000Z
---
```

## Email Configuration

### Option 1: File Storage Only (Default)
If you don't configure SendGrid settings, submissions are saved to files only. Perfect for manual email management.

### Option 2: Automatic Email Sending with SendGrid
Configure SendGrid settings in your `.env` file:

```env
# SendGrid Configuration
SENDGRID_API_KEY=your_sendgrid_api_key_here

# Email settings
EMAIL_TO=info@prosodylabs.com.au
EMAIL_FROM=noreply@prosodylabs.com.au
```

**Note:** You'll need a SendGrid account and API key. SendGrid offers a free tier with 100 emails per day.

## Benefits

- ✅ **Flexible configuration** - works with or without email setup
- ✅ **Automatic fallback** - if email fails, saves to files
- ✅ **Data persistence** - submissions always saved to files
- ✅ **Professional emails** - HTML formatted emails with your branding
- ✅ **Console notifications** - see submissions immediately
- ✅ **JSON API** - easy to integrate with other tools
- ✅ **No authentication required** - simple and secure
- ✅ **Better deliverability** - SendGrid handles reputation and compliance
- ✅ **Email analytics** - track opens, clicks, bounces in SendGrid dashboard

## Docker Deployment

### Features

- **Multi-stage build** for optimized image size
- **Non-root user** for security
- **Health checks** for monitoring
- **Volume persistence** for data storage
- **Environment variable** configuration
- **Automatic restart** on failure

### Docker Commands

```bash
# Build and start with docker-compose
docker-compose up -d

# View logs
docker-compose logs -f waitlist-api

# Stop services
docker-compose down

# Rebuild and restart
docker-compose up -d --build

# Check container status
docker-compose ps
```

### Production Deployment

For production deployment, consider:

1. **Use a reverse proxy** (nginx) for SSL termination
2. **Set up proper logging** with log aggregation
3. **Configure monitoring** and alerting
4. **Use secrets management** for API keys
5. **Set up backup** for the data volume

Example production docker-compose.yml additions:
```yaml
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - waitlist-api
```

## Production Deployment with TLS

### Prerequisites

1. **DNS Configuration**
   - Add A record: `api.prosodylabs.com.au` → your server's public IP
   - Verify DNS propagation: `dig api.prosodylabs.com.au`

2. **Server Requirements**
   - Ubuntu/Debian server with root access
   - Ports 80 and 443 open in firewall
   - Node.js 18+ installed
   - Git installed

### Quick Deployment

1. **Clone and Deploy**
   ```bash
   git clone ssh://github-personal/prosodylabs/prosodylabs.com.au.git
   cd prosodylabs/prosodylabs.com.au/backend
   ./deploy.sh
   ```

2. **Configure Environment**
   ```bash
   sudo nano /opt/prosodylabs/backend/.env
   # Add your SendGrid API key and email settings
   ```

3. **Setup SSL Certificates**
   ```bash
   ./setup-ssl.sh
   ```

4. **Verify Deployment**
   ```bash
   # Check service status
   sudo systemctl status waitlist-api
   
   # Test API endpoint
   curl -I https://api.prosodylabs.com.au/api/health
   
   # Test from frontend
   # Visit https://prosodylabs.com.au and submit waitlist form
   ```

### Manual Setup Steps

#### 1. Install Dependencies
```bash
sudo apt-get update
sudo apt-get install -y nginx certbot python3-certbot-nginx nodejs npm git
```

#### 2. Deploy Application
```bash
sudo mkdir -p /opt/prosodylabs/backend
sudo chown $USER:$USER /opt/prosodylabs/backend
cd /opt/prosodylabs/backend
git clone ssh://github-personal/prosodylabs/prosodylabs.com.au.git .
cd prosodylabs.com.au/backend
npm ci --only=production
```

#### 3. Configure Environment
```bash
cp env.example .env
nano .env  # Add your SendGrid API key
```

#### 4. Setup Systemd Service
```bash
sudo cp waitlist-api.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable waitlist-api
sudo systemctl start waitlist-api
```

#### 5. Configure Nginx and SSL
```bash
# Copy initial nginx config
sudo cp nginx/nginx-initial.conf /etc/nginx/sites-available/api.prosodylabs.com.au
sudo ln -sf /etc/nginx/sites-available/api.prosodylabs.com.au /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Obtain SSL certificate and auto-configure nginx
sudo certbot --nginx \
    -d api.prosodylabs.com.au \
    --email info@prosodylabs.com.au \
    --agree-tos \
    --no-eff-email \
    --redirect

# Setup auto-renewal
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

### SSL Certificate Management

#### Check Certificate Status
```bash
sudo certbot certificates
```

#### Test Auto-Renewal
```bash
sudo certbot renew --dry-run
```

#### Manual Renewal
```bash
sudo certbot renew
sudo systemctl reload nginx
```

### Monitoring and Logs

#### Service Logs
```bash
sudo journalctl -u waitlist-api -f
```

#### Nginx Logs
```bash
sudo tail -f /var/log/nginx/api.prosodylabs.com.au.access.log
sudo tail -f /var/log/nginx/api.prosodylabs.com.au.error.log
```

#### Application Logs
```bash
sudo tail -f /opt/prosodylabs/backend/data/waitlist-submissions.json
```

### Troubleshooting

#### Common Issues

1. **Certificate Not Obtained**
   - Verify DNS points to your server
   - Check firewall allows ports 80/443
   - Ensure nginx is running before certbot

2. **API Not Responding**
   - Check service status: `sudo systemctl status waitlist-api`
   - Verify environment variables in `.env`
   - Check nginx config: `sudo nginx -t`

3. **CORS Errors**
   - Verify frontend domain in CORS config
   - Check nginx CORS headers
   - Ensure HTTPS is used for both frontend and backend

4. **Email Not Sending**
   - Verify SendGrid API key in `.env`
   - Check SendGrid dashboard for delivery status
   - Review application logs for errors

#### Health Checks
```bash
# API health
curl https://api.prosodylabs.com.au/api/health

# SSL certificate
openssl s_client -connect api.prosodylabs.com.au:443 -servername api.prosodylabs.com.au

# DNS resolution
dig api.prosodylabs.com.au
```

### Security Considerations

- Certificates auto-renew via systemd timer
- HSTS header enforces HTTPS for 1 year
- TLS 1.2+ only, strong cipher suites
- CORS restricted to prosodylabs.com.au domain
- Backend runs as www-data user (non-root)
- Rate limiting should be added to Nginx config for production

## Security Notes

- Input validation is included for email format and required fields
- All submissions are logged with timestamps and IP addresses
- No sensitive data is stored - just the form submissions
- SendGrid API key is stored in environment variables (never commit .env to git)
- Docker container runs as non-root user for security
- Health checks ensure service availability
