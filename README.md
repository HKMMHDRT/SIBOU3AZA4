# 🚀 SIBOU3AZA3 - Ultra-Streamlined Email Marketing

**Ultra-Simple: Create HTML Template → Send Bulk Emails**

## 🎯 Ultra-Streamlined Approach

### **Key Features:**
✅ **Ultra-simple workflow:** Create template.html → Send  
✅ **High-speed bulk sending** (2s optimized delays)  
✅ **Professional DKIM/SPF/DMARC authentication**  
✅ **Automatic sender rotation for bulk campaigns**  
✅ **You control the HTML template completely**  

## 📋 Complete Workflow

### **🔧 Setup (Run Once):**
```bash
# 1. Clone repository
git clone https://github.com/HKMMHDRT/SIBOU3AZA3.git
cd SIBOU3AZA3

# 2. Setup authentication (generates DNS records)
sudo chmod +x setup_mailer.sh
sudo ./setup_mailer.sh

# 3. Add DNS records to your domain (see instructions below)

# 4. Verify DNS records
chmod +x verify_domain.sh
./verify_domain.sh yourdomain.com

# 5. Create mailing list
nano emaillist.txt
```

### **📧 Daily Usage:**
```bash
# 1. Create your HTML email template
nano template.html

# 2. Send to your entire mailing list
chmod +x send_bulk_email.sh
./send_bulk_email.sh template.html
```

**That's it! Ultra-simple 2-step process.**

## 🔑 DNS Setup for Namecheap

### **Step 1: Get Your DNS Records**
After running `sudo ./setup_mailer.sh`, you'll get 3 DNS records to add:

### **Step 2: Add to Namecheap DNS**
1. **Login to Namecheap**
2. **Go to Domain List → Manage → Advanced DNS**
3. **Add these 3 records:**

#### **SPF Record:**
- **Type:** `TXT`
- **Host:** `@`
- **Value:** `v=spf1 ip4:YOUR_IP include:_spf.google.com ~all`

#### **DKIM Record:**
- **Type:** `TXT`
- **Host:** `mail._domainkey`
- **Value:** `v=DKIM1; h=sha256; k=rsa; p=MIGfMA0GCS...` (from setup output)

#### **DMARC Record:**
- **Type:** `TXT`
- **Host:** `_dmarc`
- **Value:** `v=DMARC1; p=none; rua=mailto:dmarc@yourdomain.com`

### **Step 3: Verify DNS**
```bash
./verify_domain.sh yourdomain.com
```

**Should show:** All DNS records verified ✅

## 📧 How It Works

### **Ultra-Streamlined Flow:**
```
Setup DNS → Create template.html → ./send_bulk_email.sh template.html → Done!
```

### **Email Flow:**
```
Your HTML Template → Bulk Sender → 8 Rotating Senders → All Subscribers
```

## 📁 Available Scripts

### **`send_bulk_email.sh`** - High-Volume Bulk Sender
- **Optimized for 200k+ emails**
- 2000 emails per batch (2s intervals - SPEED OPTIMIZED)
- 4 parallel workers for fast processing
- Automatic sender rotation (8 different senders)
- Empty return-path for maximum inbox delivery
- Real-time progress monitoring
- Professional authentication headers

### **`send_html_email.sh`** - Regular HTML Sender
- Send smaller email campaigns
- Individual email processing
- Professional authentication
- Detailed delivery tracking

### **`setup_mailer.sh`** - One-Time Setup
- Configures DKIM, SPF, DMARC authentication
- Generates DNS records for your domain
- Sets up Postfix mail server
- Creates secure email sending environment

### **`workflow.sh`** - System Management
- Check system status
- View available commands
- Guided setup process
- Troubleshooting assistance

## 📊 Example Usage Session

```bash
# After setup, create your email:
nano template.html

# Your HTML content:
<!DOCTYPE html>
<html>
<head>
    <title>Summer Sale - 50% Off Everything!</title>
</head>
<body>
    <h1>🌞 Summer Sale is Here!</h1>
    <p>Get <strong>50% OFF</strong> on all products!</p>
    <p>Limited time offer - Shop now!</p>
    <a href="https://yourstore.com/sale">Shop Now</a>
</body>
</html>

# Send to your entire list:
./send_bulk_email.sh template.html

# Output shows:
📊 Batch Analysis:
Total emails: 50000
Batch size: 2000
Total batches: 25
Workers: 4

🔄 Automatic Sender Rotation Pool:
  News Team <news@yourdomain.com>
  Info Desk <info@yourdomain.com>
  Updates <updates@yourdomain.com>
  Alerts <alerts@yourdomain.com>
  Team <team@yourdomain.com>
  Newsletter <newsletter@yourdomain.com>
  Notifications <notifications@yourdomain.com>
  Support <support@yourdomain.com>

🚀 Launching 4 workers...
⏳ Waiting 2s before next batch group... (OPTIMIZED SPEED)

📊 Campaign Status:
Batches: 25/25 (100%)
✅ Successful: 49,847
❌ Failed: 153
📈 Success Rate: 99%
⚡ Rate: 2,847 emails/second

🎉 ALL BATCHES COMPLETED!
```

## 🎯 Key Benefits

### **Ultra-Simple:**
- **2-step process:** Create HTML → Send
- No complex email editors needed
- You control the HTML completely
- No mailbox management
- No forwarding complexity

### **Lightning Fast:**
- **2-second delays** (not 15 seconds)
- 4 parallel workers processing simultaneously
- Automatic sender rotation for better delivery
- Optimized for 200k+ emails per campaign

### **Professional Delivery:**
- DKIM/SPF/DMARC authentication prevents spam
- Empty return-path for maximum inbox delivery
- 8 different rotating senders
- Professional email headers
- Real-time delivery statistics

### **Complete Control:**
- Create any HTML template you want
- Full control over design and content
- No restrictions on styling or layout
- Mobile-responsive design support

## 🔧 Available Commands

```bash
# Check system status
./workflow.sh status

# View all commands
./workflow.sh commands

# Send bulk emails
./send_bulk_email.sh template.html

# Send regular emails
./send_html_email.sh template.html

# Verify DNS records
./verify_domain.sh yourdomain.com

# Check mail service
sudo service postfix status

# View mail logs
sudo tail -f /var/log/mail.log
```

## 🚨 Troubleshooting

### **Permission Denied Error:**
```bash
# Fix script permissions
sudo chmod +x send_bulk_email.sh send_html_email.sh
sudo chmod +x setup_mailer.sh workflow.sh
```

### **DNS Issues:**
```bash
# Check what DNS records you need
cat /etc/opendkim/keys/yourdomain.com/mail.txt

# Verify DNS propagation
./verify_domain.sh yourdomain.com
```

### **Emails Not Sending:**
```bash
# Check mail logs for errors
sudo tail -f /var/log/mail.log

# Check mailing list format
cat emaillist.txt
# Should be one email per line, no extra spaces
```

### **Slow Sending:**
The system is already optimized with 2-second delays. If you need even faster:
- Reduce `BATCH_DELAY=2` to `BATCH_DELAY=1` in `send_bulk_email.sh`
- Increase `WORKER_COUNT=4` to `WORKER_COUNT=6` for more parallel processing

## 📧 Email List Format

Your `emaillist.txt` should look like this:
```
subscriber1@gmail.com
subscriber2@yahoo.com
subscriber3@hotmail.com
# Lines starting with # are comments
user@domain.com
another@email.com
```

- One email address per line
- No extra spaces
- Lines starting with # are ignored
- Empty lines are ignored

## 📞 Support

- Use `/reportbug` in chat for technical issues
- Check mail logs: `sudo tail -f /var/log/mail.log`
- Verify DNS: `./verify_domain.sh yourdomain.com`

---

**SIBOU3AZA3 - Ultra-Streamlined Professional Email Marketing**

*Create HTML → Send Bulk → Done! That's it!*
