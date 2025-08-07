# 🚀 SIBOU3AZA2 - Revolutionary Email Forwarding - Quick Start Guide

Follow these steps to set up the revolutionary email forwarding system in Google Cloud Shell.

## ⚡ STEP-BY-STEP SETUP

### 1. **Open Google Cloud Shell**
- Go to [Google Cloud Console](https://console.cloud.google.com)
- Click the Cloud Shell icon (>_) in the top right
- Wait for the shell to initialize

### 2. **Download SIBOU3AZA2**
```bash
git clone https://github.com/HKMMHDRT/SIBOU3AZA2.git
cd SIBOU3AZA2
```

### 3. **Run the Enhanced Setup** 
**No EML files needed for the forwarding system!**
```bash
sudo chmod +x setup_mailer.sh
sudo ./setup_mailer.sh
```

**You'll be prompted for:**
- Domain name (e.g., `yourdomain.com`)
- Hostname (press Enter to use your domain)
- Sender email (e.g., `noreply@yourdomain.com`)
- Sender name (e.g., `Your Company Name`)
- Email subject (e.g., `Special Offer - 50% Off!`)
- Email list file path (use `emaillist.txt`)

### 5. **Configure DNS Records**
The setup will display DNS records like this:

```
1. SPF Record:
Type: TXT
Name: @ (or your domain)
Value: v=spf1 ip4:34.123.45.67 include:_spf.google.com ~all

2. DKIM Record:
Type: TXT
Name: mail._domainkey
Value: v=DKIM1; h=sha256; k=rsa; p=MIGfMA0GCSqGSIb3...

3. DMARC Record:
Type: TXT
Name: _dmarc
Value: v=DMARC1; p=none; rua=mailto:dmarc@yourdomain.com
```

**Add these to your domain DNS:**
- Go to your domain registrar (GoDaddy, Namecheap, Cloudflare, etc.)
- Access DNS settings
- Add each TXT record exactly as shown
- Save changes

### 6. **Wait for DNS Propagation**
Wait 5-10 minutes for DNS records to propagate worldwide.

### 7. **Verify Your Domain**
```bash
./verify_domain.sh yourdomain.com
```

You should see:
```
✓ SPF Record Found
✓ DKIM Record Found  
✓ DMARC Record Found
All DNS records are properly configured!
```

### 8. **Prepare Your Email List**
Edit the email list file:
```bash
nano emaillist.txt
```

Add your subscriber emails (one per line):
```
subscriber1@gmail.com
customer@company.com
user@yahoo.com
```

Save and exit: `Ctrl+X`, then `Y`, then `Enter`

### 9. **Choose Your Sending Method**

## 🚀 **METHOD 1: REVOLUTIONARY EMAIL FORWARDING (RECOMMENDED)**

**Start the forwarding system:**
```bash
./start_forwarding.sh
```

**Now you can send mass emails by simply forwarding from Gmail!**

### **How to Use:**
1. **Compose email** in Gmail/Outlook as usual
2. **Add all your content**: Text, images, links, formatting
3. **Send to**: `forward@yourdomain.com` (your forwarding address)
4. **SIBOU3AZA2 automatically** forwards to your entire mailing list!

### **Example:**
**In Gmail:**
```
To: forward@yourdomain.com
Subject: 🔥 Amazing Summer Sale - 70% Off!

Hi there!

We're excited to announce our biggest sale ever...
[Add all your content, images, links here]

Best regards,
Your Company Team
```

**Result:** This email automatically goes to all subscribers in your `emaillist.txt`!

## 📄 **METHOD 2: Traditional EML Sending**

```bash
sudo ./send.sh
```

You'll see real-time progress:
```
Verifying DNS records before sending...
✓ All DNS records verified successfully!

Starting email campaign...
Total emails to send: 150

[1/150] Processing: subscriber1@gmail.com
✓ Sent to: subscriber1@gmail.com
[2/150] Processing: customer@company.com
✓ Sent to: customer@company.com
```

### 10. **Monitor Results**
**View successful deliveries:**
```bash
tail -f successdelivery.txt
```

**Check failed deliveries:**
```bash
tail -f faileddelivery.txt
```

**View campaign statistics:**
```bash
cat deliverystats.txt
```

## 📊 MONITORING YOUR CAMPAIGN

### Real-time Tracking
```bash
# Watch success deliveries in real-time
tail -f successdelivery.txt

# Monitor the sending process
tail -f /var/log/mail.log
```

### Campaign Statistics
After completion, check:
- **successdelivery.txt** - All successful sends with timestamps
- **faileddelivery.txt** - Failed attempts with reasons
- **deliverystats.txt** - Overall campaign metrics

## 🔄 RUNNING ADDITIONAL CAMPAIGNS

### For New Cloud Shell Sessions:
1. Your IP will change, so update DNS records:
```bash
curl ifconfig.me  # Get new IP
```
2. Update your SPF record with the new IP
3. Re-verify domain:
```bash
./verify_domain.sh yourdomain.com
```
4. Run new campaign:
```bash
sudo ./send.sh
```

## ⚠️ TROUBLESHOOTING

### DNS Records Not Found
```bash
# Check if records exist
dig TXT yourdomain.com
dig TXT mail._domainkey.yourdomain.com
dig TXT _dmarc.yourdomain.com

# If missing, double-check your DNS provider settings
```

### Emails Going to Spam
- Verify all DNS records are correct
- Use professional email content
- Start with small batches (10-50 emails)
- Check your domain reputation

### DKIM Signature Issues
```bash
# Restart services
sudo systemctl restart opendkim
sudo systemctl restart postfix

# Check service status
sudo systemctl status opendkim
```

### Permission Errors
```bash
# Fix permissions
sudo chown opendkim:opendkim /etc/opendkim/keys/yourdomain.com/mail.private
sudo chmod 600 /etc/opendkim/keys/yourdomain.com/mail.private
```

## 🎯 BEST PRACTICES

1. **Start Small**: Test with 10-20 emails first
2. **Quality Lists**: Use engaged, opted-in subscribers
3. **Professional Content**: Use templates from reputable senders
4. **Monitor Metrics**: Watch success rates and adjust
5. **Gradual Growth**: Increase volume slowly over time

## 📞 NEED HELP?

- Check the main README.md for detailed information
- Use `/reportbug` in chat for technical issues
- Join Telegram support channel

---

**Remember**: This tool is for legitimate email marketing with proper consent only!
