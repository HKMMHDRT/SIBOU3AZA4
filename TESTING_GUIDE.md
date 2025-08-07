# 🧪 SIBOU3AZA Testing Guide

**Complete Step-by-Step Testing: From Single Email to Mass Sending**

This guide walks you through testing SIBOU3AZA from a simple test email to full mass email campaigns.

## 📋 PREREQUISITES

Before starting, ensure you have:
- ✅ Google Cloud Shell access
- ✅ Domain name with DNS access
- ✅ Email template (email.eml) from legitimate sender
- ✅ Test email addresses (your own emails recommended)

---

## 🚀 PHASE 1: INITIAL SETUP

### Step 1: Get Your Files Ready
```bash
# Open Google Cloud Shell
# Go to: https://console.cloud.google.com
# Click the Cloud Shell icon (>_)

# Clone the repository
git clone https://github.com/HKMMHDRT/SIBOU3AZA.git
cd SIBOU3AZA

# Upload your email.eml file using Cloud Shell upload feature
# Click the three dots (...) → Upload file → Select your .eml file

# Verify the file is there
ls -la email.eml
```

### Step 2: Run Initial Setup
```bash
# Make setup script executable
chmod +x setup_mailer.sh

# Run the enhanced setup
sudo ./setup_mailer.sh
```

**During setup, provide:**
- Domain: `yourdomain.com`
- Hostname: `mail.yourdomain.com` (or press Enter)
- Sender email: `test@yourdomain.com`
- Sender name: `Test Sender`
- Subject: `SIBOU3AZA Test Email`
- Email list: `emaillist.txt`

### Step 3: Configure DNS Records
**Copy the DNS records shown and add them to your domain:**

```
SPF Record:
Type: TXT, Name: @, Value: v=spf1 ip4:YOUR_IP include:_spf.google.com ~all

DKIM Record:
Type: TXT, Name: mail._domainkey, Value: [Generated DKIM key]

DMARC Record:
Type: TXT, Name: _dmarc, Value: v=DMARC1; p=none; rua=mailto:dmarc@yourdomain.com
```

**Wait 10-15 minutes for DNS propagation**

---

## 🔍 PHASE 2: VERIFICATION TESTING

### Step 4: Verify Domain Setup
```bash
# Make verification script executable
chmod +x verify_domain.sh

# Verify your domain
./verify_domain.sh yourdomain.com
```

**Expected output:**
```
✓ SPF Record Found
✓ DKIM Record Found
✓ DMARC Record Found
All DNS records are properly configured!
```

### Step 5: Test Mail System
```bash
# Check if Postfix is running
sudo systemctl status postfix

# Check if OpenDKIM is running
sudo systemctl status opendkim

# Test basic mail functionality
echo "Test from SIBOU3AZA" | mail -s "System Test" test@yourdomain.com
```

---

## 📧 PHASE 3: SINGLE EMAIL TESTING

### Step 6: Create Test Email List
```bash
# Create a small test list with your own emails
nano test-emails.txt
```

**Add only your own email addresses:**
```
your-email@gmail.com
your-backup@yahoo.com
your-work@company.com
```

### Step 7: Test with Single Email
```bash
# Create a single-email test list
echo "your-test@gmail.com" > single-test.txt

# Edit the send script temporarily for single email
cp send.sh test-single.sh
```

**Edit test-single.sh to use single-test.txt:**
```bash
nano test-single.sh
# Change EMAIL_LIST="emaillist.txt" to EMAIL_LIST="single-test.txt"
```

### Step 8: Send Single Test Email
```bash
# Make test script executable
chmod +x test-single.sh

# Send single test email
sudo ./test-single.sh
```

**Monitor the output:**
```
Verifying DNS records before sending...
✓ DNS records verified successfully!

Starting email campaign...
Total emails to send: 1

[1/1] Processing: your-test@gmail.com
✓ Sent to: your-test@gmail.com

CAMPAIGN COMPLETED
Total Processed: 1
Successful: 1
Failed: 0
```

### Step 9: Verify Email Reception
**Check your email inbox:**
- ✅ Email should arrive in inbox (not spam)
- ✅ Check email headers for DKIM signature
- ✅ Verify sender information is correct
- ✅ Content should match your template

---

## 📊 PHASE 4: SMALL BATCH TESTING

### Step 10: Test with 5-10 Emails
```bash
# Create small batch test list
nano small-batch.txt
```

**Add 5-10 of your own email addresses:**
```
test1@yourdomain.com
test2@gmail.com
test3@yahoo.com
test4@outlook.com
test5@protonmail.com
```

### Step 11: Send Small Batch
```bash
# Update send.sh to use small batch
cp send.sh test-batch.sh
nano test-batch.sh
# Change EMAIL_LIST to "small-batch.txt"

chmod +x test-batch.sh
sudo ./test-batch.sh
```

### Step 12: Monitor Delivery Results
```bash
# Watch success deliveries in real-time
tail -f successdelivery.txt

# Check for any failures
cat faileddelivery.txt

# View statistics
cat deliverystats.txt
```

---

## 📈 PHASE 5: MEDIUM BATCH TESTING

### Step 13: Test with 50-100 Emails
**Only proceed if small batch was 100% successful**

```bash
# Create medium batch list (mix of your emails + test domains)
nano medium-batch.txt
```

**Include mix of providers:**
```
# Your real emails for monitoring
your-email@gmail.com
your-backup@yahoo.com

# Test emails (use temporary/disposable if available)
test01@gmail.com
test02@yahoo.com
test03@outlook.com
# ... continue up to 50-100 emails
```

### Step 14: Send Medium Batch
```bash
cp send.sh test-medium.sh
nano test-medium.sh
# Change EMAIL_LIST to "medium-batch.txt"

chmod +x test-medium.sh
sudo ./test-medium.sh
```

### Step 15: Analyze Delivery Rates
```bash
# Check success rate
echo "Success rate analysis:"
TOTAL=$(wc -l < medium-batch.txt)
SUCCESS=$(wc -l < successdelivery.txt)
echo "Total sent: $TOTAL"
echo "Successful: $SUCCESS"
echo "Success rate: $((SUCCESS * 100 / TOTAL))%"

# Check for patterns in failures
echo "Failed deliveries:"
cat faileddelivery.txt
```

---

## 🚨 PHASE 6: TROUBLESHOOTING TESTS

### Step 16: Test IP Change Scenario
```bash
# Simulate new Cloud Shell session
# Get current IP
OLD_IP=$(curl -s ifconfig.me)
echo "Current IP: $OLD_IP"

# Run IP update helper
chmod +x update_ip.sh
./update_ip.sh
```

### Step 17: Test DNS Re-verification
```bash
# After updating DNS (if IP changed)
./verify_domain.sh yourdomain.com

# Test sending after IP change
sudo ./test-single.sh
```

### Step 18: Test Error Scenarios
```bash
# Test with invalid email addresses
echo "invalid-email" > error-test.txt
cp send.sh test-errors.sh
nano test-errors.sh
# Change EMAIL_LIST to "error-test.txt"

chmod +x test-errors.sh
sudo ./test-errors.sh

# Check error handling
cat faileddelivery.txt
```

---

## 🎯 PHASE 7: MASS SENDING PREPARATION

### Step 19: Reputation Building Test
**Before mass sending, build reputation:**

```bash
# Day 1: Send 50 emails
# Day 2: Send 100 emails  
# Day 3: Send 200 emails
# Day 4: Send 500 emails
# Day 5+: Full mass sending

# Create daily batch files
echo "Day 1 batch - 50 emails"
head -50 your-full-list.txt > day1-batch.txt

echo "Day 2 batch - 100 emails"
head -100 your-full-list.txt > day2-batch.txt
```

### Step 20: Final Mass Sending Test
```bash
# Only proceed if all previous tests successful
# Update your main email list
nano emaillist.txt
# Add your full subscriber list

# Run final mass campaign
sudo ./send.sh
```

---

## 📊 MONITORING COMMANDS

### Real-time Monitoring
```bash
# Watch live progress
tail -f successdelivery.txt

# Monitor mail logs
sudo tail -f /var/log/mail.log

# Check system resources
top
df -h
```

### Post-Campaign Analysis
```bash
# Final statistics
cat deliverystats.txt

# Success/failure breakdown
echo "=== CAMPAIGN SUMMARY ==="
echo "Successful deliveries: $(wc -l < successdelivery.txt)"
echo "Failed deliveries: $(wc -l < faileddelivery.txt)"

# Check for bounce patterns
grep -i "bounce\|reject\|fail" faileddelivery.txt
```

---

## ⚠️ TESTING SAFETY RULES

### 🔴 STOP TESTING IF:
- Success rate drops below 90%
- Multiple failures from same domain
- DNS verification fails
- Authentication errors appear

### 🟡 INVESTIGATE IF:
- Success rate below 95%
- Slow delivery times
- Inconsistent results

### 🟢 PROCEED IF:
- Success rate above 95%
- No authentication errors
- Consistent delivery times

---

## 🛠️ TROUBLESHOOTING COMMANDS

### Fix Common Issues
```bash
# Restart services
sudo systemctl restart postfix opendkim

# Check configurations
sudo postconf -n
sudo cat /etc/opendkim.conf

# Test DKIM signing
sudo opendkim-testkey -d yourdomain.com -s mail

# Check permissions
ls -la /etc/opendkim/keys/yourdomain.com/
```

### Emergency Recovery
```bash
# If system becomes unstable
sudo systemctl stop postfix opendkim
sudo ./setup_mailer.sh  # Re-run setup
```

---

## 📋 TESTING CHECKLIST

**Before Mass Sending:**
- [ ] Single email test: 100% success
- [ ] Small batch (10): >95% success  
- [ ] Medium batch (50): >95% success
- [ ] DNS records verified
- [ ] Authentication working
- [ ] No spam folder deliveries
- [ ] IP reputation check passed
- [ ] Legal compliance verified

**Ready for Mass Sending:**
- [ ] All tests passed
- [ ] Subscriber list cleaned
- [ ] Content approved
- [ ] Unsubscribe mechanism ready
- [ ] Monitoring tools active

---

**Remember: Test responsibly with your own email addresses first!**
