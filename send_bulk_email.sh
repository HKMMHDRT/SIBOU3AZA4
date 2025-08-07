#!/bin/bash

# SIBOU3AZA4 - Ultra High-Volume Bulk Email Sender
# Optimized for millions of emails with advanced batch processing and workers
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE}================================${NC}"
echo -e "${PURPLE}   SIBOU3AZA4 BULK EMAIL SENDER${NC}"
echo -e "${PURPLE}   Ultra High-Volume Optimized${NC}"
echo -e "${PURPLE}================================${NC}"
echo ""

# Function to prompt for domain and configuration
setup_session_config() {
    echo -e "${YELLOW}=== CLOUD SHELL SESSION SETUP ===${NC}"
    echo ""
    
    # Prompt for domain
    read -p "Enter your domain name (e.g., yourdomain.com): " domain_input
    if [ -z "$domain_input" ]; then
        echo -e "${RED}Domain name is required!${NC}"
        exit 1
    fi
    
    # Verify DNS records first
    echo -e "${BLUE}Verifying DNS records for: $domain_input${NC}"
    if ! ./verify_domain.sh "$domain_input"; then
        echo -e "${RED}DNS verification failed. Please configure DNS records first.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}DNS records verified successfully!${NC}"
    echo ""
    
    # Get current IP
    CURRENT_IP=$(curl -s ifconfig.me 2>/dev/null || echo "unknown")
    
    # Prompt for sender email
    read -p "Enter sender email (default: noreply@$domain_input): " sender_input
    sender_input=${sender_input:-"noreply@$domain_input"}
    
    # Update configuration
    DOMAIN="$domain_input"
    SENDER_EMAIL="$sender_input"
    SENDER_NAME="Newsletter Team"
    EMAIL_SUBJECT="Newsletter Update"
    EMAIL_LIST="emaillist.txt"
    MYHOSTNAME="$domain_input"
    
    # Update config file for this session
    cat > sibou3aza.conf <<CONF
# SIBOU3AZA4 Session Configuration
DOMAIN="$DOMAIN"
SENDER_EMAIL="$SENDER_EMAIL"
SENDER_NAME="$SENDER_NAME"
EMAIL_SUBJECT="$EMAIL_SUBJECT"
EMAIL_LIST="$EMAIL_LIST"
CURRENT_IP="$CURRENT_IP"
MYHOSTNAME="$MYHOSTNAME"
BATCH_SIZE=2000
BATCH_DELAY=1
WORKER_COUNT=6
MAX_RETRIES=3
PROGRESS_CHECKPOINT=5000
CONF
    
    echo -e "${GREEN}Session configuration created successfully!${NC}"
    echo ""
}

# Check if configuration exists and is valid
if [ ! -f "sibou3aza.conf" ] || [ ! -s "sibou3aza.conf" ] || ! grep -q "DOMAIN=" sibou3aza.conf || [ "$(grep "DOMAIN=" sibou3aza.conf | cut -d'"' -f2)" = "" ]; then
    setup_session_config
fi

# Load configuration
source sibou3aza.conf

# Verify configuration is loaded
if [ -z "$DOMAIN" ] || [ -z "$SENDER_EMAIL" ]; then
    echo -e "${RED}Configuration incomplete. Setting up session...${NC}"
    setup_session_config
    source sibou3aza.conf
fi

# Configuration for ultra high-volume sending
BATCH_SIZE=2000           # Emails per batch
BATCH_DELAY=1            # Seconds between batches (ultra-optimized for speed)
WORKER_COUNT=6           # Parallel workers (increased for better performance)
MAX_RETRIES=3            # Retry failed emails
PROGRESS_CHECKPOINT=5000 # Progress update every N emails

# Auto-rotating sender pool for better deliverability
SENDER_POOL=(
    "news@$DOMAIN"
    "info@$DOMAIN" 
    "updates@$DOMAIN"
    "alerts@$DOMAIN"
    "team@$DOMAIN"
    "newsletter@$DOMAIN"
    "notifications@$DOMAIN"
    "support@$DOMAIN"
)
SENDER_NAMES=(
    "News Team"
    "Info Desk"
    "Updates"
    "Alerts"
    "Team"
    "Newsletter"
    "Notifications"
    "Support"
)

# Create working directories
mkdir -p bulk_temp
mkdir -p bulk_logs
mkdir -p bulk_progress

# Function to create batch template with rotating sender
create_batch_template() {
    local html_file="$1"
    local output_file="$2"
    local batch_num="$3"
    
    # Extract subject from HTML
    local subject=$(grep -i "<title>" "$html_file" | sed 's/<[^>]*>//g' | tr -d '\n' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    if [ -z "$subject" ]; then
        subject="Newsletter"
    fi
    
    # Auto-rotate sender based on batch number
    local sender_count=${#SENDER_POOL[@]}
    local sender_index=$(( (batch_num - 1) % sender_count ))
    local rotating_sender="${SENDER_POOL[$sender_index]}"
    local rotating_name="${SENDER_NAMES[$sender_index]}"
    
    # Create optimized email template with rotating sender and empty return-path
    cat > "$output_file" <<EOF
Return-Path: <>
From: $rotating_name <$rotating_sender>
Subject: $subject
MIME-Version: 1.0
Content-Type: text/html; charset=UTF-8
X-SIBOU3AZA4-Bulk: bulk-campaign-$(date +%Y%m%d_%H%M%S)
X-Mailer: SIBOU3AZA4-Bulk
X-Sender-Pool: $sender_index
Date: $(date -R)
List-Unsubscribe: <mailto:unsubscribe@$DOMAIN>

EOF
    
    # Add HTML content
    cat "$html_file" >> "$output_file"
    
    echo "Batch $batch_num using sender: $rotating_name <$rotating_sender>"
}

# Function to send batch via worker
send_batch_worker() {
    local batch_file="$1"
    local worker_id="$2"
    local html_file="$3"
    local batch_num="$4"
    
    local worker_log="bulk_logs/worker_${worker_id}_batch_${batch_num}.log"
    local success_count=0
    local failure_count=0
    
    echo "[$(date)] Worker $worker_id starting batch $batch_num" >> "$worker_log"
    
    # Auto-rotate sender based on batch number
    local sender_count=${#SENDER_POOL[@]}
    local sender_index=$(( (batch_num - 1) % sender_count ))
    local rotating_sender="${SENDER_POOL[$sender_index]}"
    local rotating_name="${SENDER_NAMES[$sender_index]}"
    
    echo "[$(date)] Worker $worker_id using sender: $rotating_name <$rotating_sender>" >> "$worker_log"
    
    # Read batch emails
    local emails=()
    while IFS= read -r email; do
        email=$(echo "$email" | tr -d '\r' | xargs)
        [[ ! -z "$email" && ! "$email" =~ ^#.* ]] && emails+=("$email")
    done < "$batch_file"
    
    local batch_size=${#emails[@]}
    echo "[$(date)] Worker $worker_id processing $batch_size emails" >> "$worker_log"
    
    # Create batch template with rotating sender
    local batch_template="bulk_temp/template_${worker_id}_${batch_num}.eml"
    create_batch_template "$html_file" "$batch_template" "$batch_num"
    
    # Add BCC header with all emails in this batch
    local bcc_list=""
    for email in "${emails[@]}"; do
        if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            if [ -z "$bcc_list" ]; then
                bcc_list="$email"
            else
                bcc_list="$bcc_list, $email"
            fi
            ((success_count++))
        else
            echo "[$(date)] Invalid email: $email" >> "$worker_log"
            ((failure_count++))
        fi
    done
    
    # Add BCC header to batch template
    sed -i "1i Bcc: $bcc_list" "$batch_template"
    
    # Send the batch
    if /usr/sbin/sendmail -t < "$batch_template" 2>>"$worker_log"; then
        echo "[$(date)] Worker $worker_id successfully sent batch $batch_num ($success_count emails) via $rotating_sender" >> "$worker_log"
        echo "$success_count" > "bulk_progress/worker_${worker_id}_batch_${batch_num}_success.txt"
        echo "$failure_count" > "bulk_progress/worker_${worker_id}_batch_${batch_num}_failure.txt"
    else
        echo "[$(date)] Worker $worker_id FAILED to send batch $batch_num via $rotating_sender" >> "$worker_log"
        echo "0" > "bulk_progress/worker_${worker_id}_batch_${batch_num}_success.txt"
        echo "$batch_size" > "bulk_progress/worker_${worker_id}_batch_${batch_num}_failure.txt"
    fi
    
    # Cleanup
    rm -f "$batch_template" "$batch_file"
}

# Function to split emails into batches
create_batches() {
    local email_list="$1"
    local batch_prefix="$2"
    
    # Clean email list
    local clean_emails="bulk_temp/clean_emails.txt"
    grep -v "^#" "$email_list" | grep -v "^$" | sed 's/\r//g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//' > "$clean_emails"
    
    local total_emails=$(wc -l < "$clean_emails")
    local total_batches=$(( (total_emails + BATCH_SIZE - 1) / BATCH_SIZE ))
    
    echo -e "${CYAN}📊 Batch Analysis:${NC}"
    echo -e "${BLUE}Total emails: $total_emails${NC}"
    echo -e "${BLUE}Batch size: $BATCH_SIZE${NC}"
    echo -e "${BLUE}Total batches: $total_batches${NC}"
    echo -e "${BLUE}Workers: $WORKER_COUNT${NC}"
    echo ""
    
    # Split into batches
    split -l "$BATCH_SIZE" "$clean_emails" "${batch_prefix}"
    
    echo "$total_batches"
}

# Function to monitor progress
monitor_progress() {
    local total_batches="$1"
    local start_time=$(date +%s)
    
    while true; do
        local completed_batches=0
        local total_success=0
        local total_failure=0
        
        # Count completed batches
        for progress_file in bulk_progress/worker_*_success.txt; do
            if [ -f "$progress_file" ]; then
                ((completed_batches++))
                local success=$(cat "$progress_file" 2>/dev/null || echo "0")
                total_success=$((total_success + success))
            fi
        done
        
        for progress_file in bulk_progress/worker_*_failure.txt; do
            if [ -f "$progress_file" ]; then
                local failure=$(cat "$progress_file" 2>/dev/null || echo "0")
                total_failure=$((total_failure + failure))
            fi
        done
        
        # Calculate progress
        local progress_percent=$((completed_batches * 100 / total_batches))
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        local emails_processed=$((total_success + total_failure))
        
        # Clear screen and show progress
        clear
        echo -e "${PURPLE}================================${NC}"
        echo -e "${PURPLE}   SIBOU3AZA4 BULK PROGRESS${NC}"
        echo -e "${PURPLE}================================${NC}"
        echo ""
        echo -e "${CYAN}📊 Campaign Status:${NC}"
        echo -e "${BLUE}Batches: $completed_batches/$total_batches (${progress_percent}%)${NC}"
        echo -e "${GREEN}✅ Successful: $total_success${NC}"
        echo -e "${RED}❌ Failed: $total_failure${NC}"
        echo -e "${YELLOW}⏱️  Elapsed: ${elapsed}s${NC}"
        
        if [ $emails_processed -gt 0 ]; then
            local success_rate=$((total_success * 100 / emails_processed))
            echo -e "${BLUE}📈 Success Rate: ${success_rate}%${NC}"
            
            if [ $elapsed -gt 0 ]; then
                local rate=$((emails_processed / elapsed))
                echo -e "${CYAN}⚡ Rate: ${rate} emails/second${NC}"
            fi
        fi
        
        echo ""
        echo -e "${YELLOW}🔄 Workers processing batches...${NC}"
        
        # Show active workers
        local active_workers=0
        for ((i=1; i<=WORKER_COUNT; i++)); do
            if pgrep -f "send_batch_worker.*worker_$i" >/dev/null; then
                echo -e "${GREEN}Worker $i: Active${NC}"
                ((active_workers++))
            else
                echo -e "${BLUE}Worker $i: Standby${NC}"
            fi
        done
        
        # Check if all batches are completed
        if [ $completed_batches -ge $total_batches ]; then
            echo ""
            echo -e "${GREEN}🎉 ALL BATCHES COMPLETED!${NC}"
            break
        fi
        
        sleep 2
    done
}

# Function to send bulk email campaign
send_bulk_campaign() {
    local html_file="$1"
    
    if [ ! -f "$html_file" ]; then
        echo -e "${RED}Error: HTML file not found: $html_file${NC}"
        exit 1
    fi
    
    if [ ! -f "$EMAIL_LIST" ]; then
        echo -e "${RED}Error: Mailing list file not found: $EMAIL_LIST${NC}"
        exit 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    echo -e "${CYAN}🚀 Starting BULK email campaign${NC}"
    echo -e "${BLUE}HTML file: $html_file${NC}"
    echo -e "${BLUE}Email list: $EMAIL_LIST${NC}"
    echo -e "${BLUE}Campaign ID: $timestamp${NC}"
    echo ""
    
    # Show automatic sender rotation info
    echo -e "${PURPLE}🔄 Automatic Sender Rotation Pool:${NC}"
    local sender_count=${#SENDER_POOL[@]}
    for ((i=0; i<sender_count; i++)); do
        echo -e "${CYAN}  ${SENDER_NAMES[$i]} <${SENDER_POOL[$i]}>${NC}"
    done
    echo -e "${BLUE}Total senders in pool: $sender_count${NC}"
    echo ""
    
    # Create batches
    echo -e "${YELLOW}📦 Creating batches...${NC}"
    local batch_prefix="bulk_temp/batch_${timestamp}_"
    local total_batches=$(create_batches "$EMAIL_LIST" "$batch_prefix")
    
    echo -e "${YELLOW}Send $total_batches batches with up to $BATCH_SIZE emails each? (y/n):${NC}"
    read -r confirmation
    
    if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Campaign cancelled.${NC}"
        exit 0
    fi
    
    # Start progress monitor in background
    monitor_progress "$total_batches" &
    local monitor_pid=$!
    
    # Launch workers to process batches
    echo -e "${GREEN}🚀 Launching $WORKER_COUNT workers...${NC}"
    
    local batch_counter=0
    local worker_id=1
    
    for batch_file in ${batch_prefix}*; do
        if [ -f "$batch_file" ]; then
            ((batch_counter++))
            
            # Launch worker in background
            (send_batch_worker "$batch_file" "$worker_id" "$html_file" "$batch_counter") &
            
            # Cycle through workers
            worker_id=$(( (worker_id % WORKER_COUNT) + 1 ))
            
            # Wait between batches
            if (( batch_counter % WORKER_COUNT == 0 )); then
                echo -e "${BLUE}⏳ Waiting ${BATCH_DELAY}s before next batch group...${NC}"
                sleep "$BATCH_DELAY"
            fi
        fi
    done
    
    # Wait for all background jobs to complete
    wait
    
    # Stop progress monitor
    kill $monitor_pid 2>/dev/null
    
    # Final statistics
    echo ""
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}   BULK CAMPAIGN COMPLETED${NC}"
    echo -e "${GREEN}================================${NC}"
    
    # Calculate final stats
    local final_success=0
    local final_failure=0
    
    for success_file in bulk_progress/worker_*_success.txt; do
        if [ -f "$success_file" ]; then
            local success=$(cat "$success_file")
            final_success=$((final_success + success))
        fi
    done
    
    for failure_file in bulk_progress/worker_*_failure.txt; do
        if [ -f "$failure_file" ]; then
            local failure=$(cat "$failure_file")
            final_failure=$((final_failure + failure))
        fi
    done
    
    local total_processed=$((final_success + final_failure))
    local final_success_rate=$((final_success * 100 / total_processed))
    
    echo -e "${BLUE}Total Processed: $total_processed${NC}"
    echo -e "${GREEN}Successful: $final_success${NC}"
    echo -e "${RED}Failed: $final_failure${NC}"
    echo -e "${CYAN}Success Rate: ${final_success_rate}%${NC}"
    echo ""
    
    # Create summary
    local summary_file="bulk_campaign_${timestamp}_summary.txt"
    cat > "$summary_file" <<SUMMARY
SIBOU3AZA4 Bulk Email Campaign Summary
=====================================
Campaign ID: $timestamp
HTML File: $html_file
Email List: $EMAIL_LIST
Start Time: $(date)

Configuration:
- Batch Size: $BATCH_SIZE
- Batch Delay: ${BATCH_DELAY}s
- Workers: $WORKER_COUNT
- Return-Path: Empty (optimized for inbox delivery)

Results:
- Total Processed: $total_processed
- Successful: $final_success
- Failed: $final_failure
- Success Rate: ${final_success_rate}%
- Batches: $total_batches

Log Files: bulk_logs/
Progress Files: bulk_progress/
SUMMARY
    
    echo -e "${YELLOW}📊 Summary saved: $summary_file${NC}"
    echo -e "${YELLOW}📁 Logs available in: bulk_logs/${NC}"
}

# Main execution
html_file=${1:-""}

if [ -z "$html_file" ]; then
    echo -e "${RED}Usage: ./send_bulk_email.sh <html_file>${NC}"
    echo ""
    echo -e "${YELLOW}Optimized for ultra high-volume sending:${NC}"
    echo -e "${GREEN}• Batch processing: $BATCH_SIZE emails per batch${NC}"
    echo -e "${GREEN}• Worker threads: $WORKER_COUNT parallel workers${NC}"
    echo -e "${GREEN}• Rate limiting: ${BATCH_DELAY}s between batches (ultra-fast)${NC}"
    echo -e "${GREEN}• Empty return-path for better deliverability${NC}"
    echo -e "${GREEN}• Automatic sender rotation (8 senders)${NC}"
    echo -e "${GREEN}• Single template (no personalization)${NC}"
    echo -e "${GREEN}• Perfect for millions of emails per session${NC}"
    echo ""
    echo -e "${CYAN}Examples:${NC}"
    echo -e "${BLUE}  ./send_bulk_email.sh newsletter.html${NC}"
    echo -e "${BLUE}  ./send_bulk_email.sh marketing.html${NC}"
    exit 1
fi

echo -e "${BLUE}Domain: $DOMAIN${NC}"
echo -e "${BLUE}Sender: $SENDER_EMAIL${NC}"
echo -e "${BLUE}HTML file: $html_file${NC}"
echo -e "${CYAN}Mode: ULTRA HIGH-VOLUME BULK SENDING${NC}"
echo ""

send_bulk_campaign "$html_file"

echo ""
echo -e "${YELLOW}Commands:${NC}"
echo -e "${GREEN}• Bulk sending: ./send_bulk_email.sh [html_file]${NC}"
echo -e "${GREEN}• Regular sending: ./send_html_email.sh [html_file]${NC}"
echo -e "${GREEN}• Compose email: ./compose_email.sh${NC}"
