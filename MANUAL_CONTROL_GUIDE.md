# 📧 SIBOU3AZA2 Manual Control Guide

**Complete Manual Control Over Email Processing**

## 🎯 Overview

This guide shows you how to use SIBOU3AZA2 with full manual control:
1. **Setup** authentication and mailbox properly
2. **Receive** emails manually 
3. **Read** emails when you want
4. **Send** to mailing list when you decide

## 🚀 Setup Process

### **Step 1: Initial Setup**
```bash
sudo apt-get update
git clone https://github.com/HKMMHDRT/SIBOU3AZA2.git
cd SIBOU3AZA2
sudo chmod +x setup_mailer.sh
sudo ./setup_mailer.sh
```

### **Step 2: Add DNS Records**
Add the DNS records shown during setup to your domain.

### **Step 3: Verify DNS**
```bash
./verify_domain.sh yourdomain.com
```
**Make sure you see all ✓ green checkmarks!**

### **Step 4: Setup Mailbox (AFTER DNS verification)**
```bash
sudo chmod +x setup_mailbox.sh
sudo ./setup_mailbox.sh
```

This will:
- Verify DNS records first
- Create proper mailbox structure
- Test mail reception
- Confirm everything works

## 📧 Manual Email Processing

### **1. Check for New Emails**
```bash
./check_inbox.sh
```

This shows:
- Mailbox locations
- Number of emails
- Postfix status
- Recent mail logs

### **2. List Available Emails**
```bash
./read_email.sh
```

Shows all emails with:
- Email number
- From address
- Subject
- Date

### **3. Read Specific Email**
```bash
./read_email.sh 1
```

Shows complete email:
- Headers (From, Subject, Date)
- Full body content
- File path for sending

### **4. Send Email to Mailing List**
```bash
./send_to_list.sh "/path/to/email/file"
```

This will:
- Show email preview
- Ask for confirmation
- Send to your mailing list
- Create tracking files

## 📋 Complete Workflow Example

### **Setup Phase:**
```bash
# 1. Setup authentication
sudo ./setup_mailer.sh

# 2. Add DNS records (from setup output)

# 3. Verify DNS
./verify_domain.sh yourdomain.com

# 4. Create mailbox
sudo ./setup_mailbox.sh

# 5. Create mailing list
nano emaillist.txt
```

### **Daily Usage:**
```bash
# 1. Check for new emails
./check_inbox.sh

# 2. List emails
./read_email.sh

# 3. Read specific email
./read_email.sh 1

# 4. Send to mailing list
./send_to_list.sh "/home/forward/Maildir/new/1234567890.eml"
```

## 🎯 Key Benefits

### **Full Control:**
- You decide when to send emails
- Preview before sending
- Manual confirmation required
- No automatic processing

### **Proper Order:**
- DNS verification BEFORE mailbox creation
- Mailbox tested before use
- Step-by-step validation

### **Clear Process:**
- Simple commands
- Clear output
- Easy troubleshooting
- Manual at every step

## 📁 Script Functions

### **`check_inbox.sh`**
- Finds mailbox locations
- Counts emails
- Shows Postfix status
- Displays recent logs

### **`read_email.sh`**
- Lists all emails (no parameter)
- Reads specific email (with number)
- Shows headers and body
- Provides file path for sending

### **`send_to_list.sh`**
- Validates email file
- Shows preview
- Asks confirmation
- Sends to mailing list
- Creates tracking files

### **`setup_mailbox.sh`**
- Verifies DNS first
- Creates proper mailbox
- Tests mail reception
- Confirms everything works

## 🔧 Commands Summary

### **Setup Commands:**
```bash
sudo ./setup_mailer.sh          # Initial setup
./verify_domain.sh domain.com   # Verify DNS
sudo ./setup_mailbox.sh         # Create mailbox
```

### **Daily Commands:**
```bash
./check_inbox.sh                # Check for emails
./read_email.sh                 # List all emails
./read_email.sh 1               # Read email #1
./send_to_list.sh [email_file]  # Send to list
```

### **Troubleshooting:**
```bash
sudo tail -f /var/log/mail.log  # Check mail logs
sudo service postfix status     # Check Postfix
sudo service postfix start      # Start Postfix
```

## 📊 Email List Format

Create `emaillist.txt`:
```
subscriber1@gmail.com
customer@company.com
user@yahoo.com
# Lines starting with # are comments
```

## 🚨 Troubleshooting

### **No Emails Received:**
1. Check Postfix: `sudo service postfix status`
2. Check logs: `sudo tail -f /var/log/mail.log`
3. Verify DNS: `./verify_domain.sh yourdomain.com`
4. Test manually: `echo "test" | mail -s "test" forward@yourdomain.com`

### **Send Fails:**
1. Verify DNS authentication
2. Check mailing list file exists
3. Ensure proper email file format
4. Monitor mail logs during sending

### **Permission Issues:**
1. Run setup scripts with `sudo`
2. Check file permissions: `ls -la`
3. Verify user ownership: `ls -la /home/forward/`

## 🎯 Best Practices

1. **Always verify DNS before creating mailbox**
2. **Test with small mailing lists first**
3. **Read emails before sending to list**
4. **Monitor tracking files for results**
5. **Keep mailing lists clean and updated**

---

**With SIBOU3AZA2 Manual Control, you have complete power over your email marketing campaigns!**
