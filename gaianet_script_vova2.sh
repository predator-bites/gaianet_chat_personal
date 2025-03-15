#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <DOMAIN> <API_KEY> <THREADS_AMOUNT> <INSTANCE_NUM>"
    exit 1
fi

# Assign command-line arguments to variables
DOMAIN=$1
API_KEY=$2
THREADS_AMOUNT=$3
INSTANCE_NUM=$4

# Define folder name and screen name for the instance
INSTANCE_FOLDER="gaianet_instance_${INSTANCE_NUM}"
SCREEN_NAME="gaianet_chat_${INSTANCE_NUM}"

# Cleanup function for gaianet_instance folders
cleanup_gaianet_folders() {
    echo "Checking for folders matching 'gaianet_instance_*'..."
    if ls gaianet_instance_* >/dev/null 2>&1; then
        echo "Found gaianet_instance folders. Deleting..."
        find . -maxdepth 1 -type d -name "gaianet_instance_*" -exec rm -rf {} + 2>/dev/null
        [ $? -eq 0 ] && echo "Successfully deleted all gaianet_instance folders." || echo "Warning: Some folders may not have been deleted."
    else
        echo "No gaianet_instance folders found."
    fi
}

# Cleanup function for graceful shutdown
cleanup() {
    echo "Performing cleanup before exit..."
    # Terminate the specific screen session
    if screen -list | grep -q "$SCREEN_NAME"; then
        echo "Terminating screen session: $SCREEN_NAME"
        screen -X -S "$SCREEN_NAME" quit
        sleep 1  # Give time for screen to terminate
    fi
    # Optional: Uncomment to remove instance folder on exit
    # if [ -d "$INSTANCE_FOLDER" ]; then
    #     echo "Removing instance folder: $INSTANCE_FOLDER"
    #     rm -rf "$INSTANCE_FOLDER"
    # fi
    echo "Cleanup complete."
}

# Trap signals for cleanup on exit or interruption
trap cleanup EXIT INT TERM

# Install initial dependency
sudo apt install apt-utils -y

# Initial cleanup
cleanup_gaianet_folders
echo "Checking for existing folders with 'gaianet_chat_by_dp'..."
find . -type d -name "*gaianet_chat_by_dp*" -exec rm -rf {} + 2>/dev/null
pkill screen  # Kill all screen sessions
echo "All pre-existing screen sessions terminated."
sleep 2  # Reduced sleep time

# Create the instance directory
mkdir -p "$INSTANCE_FOLDER"

# Define paths inside the instance folder
ACCOUNT_FILE="$INSTANCE_FOLDER/account.txt"
MESSAGE_FILE="$INSTANCE_FOLDER/message.txt"
BOT_FILE="$INSTANCE_FOLDER/bot.py"
VENV_DIR="$INSTANCE_FOLDER/venv"

# Installing dependencies
sudo apt install screen python3-venv git -y
sleep 2

# Create virtual environment and install Python package
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"
pip install cloudscraper

# Create API key file
if [ ! -f "$ACCOUNT_FILE" ]; then
    echo "Creating account file..."
    cat > "$ACCOUNT_FILE" <<EOF
$API_KEY|https://$DOMAIN.gaia.domains/v1/chat/completions
EOF
fi

# Create message file (abbreviated for brevity; use your full list)
if [ ! -f "$MESSAGE_FILE" ]; then
    echo "Creating message file..."
    cat > "$MESSAGE_FILE" <<EOF
What is artificial intelligence?
How does machine learning work?
# ... (your full list here)
EOF
fi

# Create bot script
if [ ! -f "$BOT_FILE" ]; then
    echo "Creating bot script..."
    cat > "$BOT_FILE" <<'EOF'
import cloudscraper
import json
import random
import time
import threading
import sys

# Read thread count from command-line
try:
    num_threads = int(sys.argv[1])
    if num_threads < 1:
        print("Please enter a number greater than 0.")
        exit()
except (IndexError, ValueError):
    print("Invalid input. Please enter an integer.")
    exit()

# Read API Keys from account file
api_accounts = []
with open('account.txt', 'r') as file:
    for line in file:
        parts = line.strip().split('|')
        if len(parts) == 2:
            api_accounts.append((parts[0], parts[1]))

if not api_accounts:
    print("Error: No valid API keys found in account.txt!")
    exit()

# Read user messages from message file
with open('message.txt', 'r') as file:
    user_messages = [msg.strip() for msg in file.readlines() if msg.strip()]

if not user_messages:
    print("Error: No messages found in message.txt!")
    exit()

# Initialize Cloudscraper
scraper = cloudscraper.create_scraper()

# Function to send API request
def send_request(message):
    while True:
        api_key, api_url = random.choice(api_accounts)
        headers = {
            'Authorization': f'Bearer {api_key}',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        }
        data = {
            "messages": [
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": message}
            ]
        }
        try:
            response = scraper.post(api_url, headers=headers, json=data)
            if response.status_code == 200:
                try:
                    response_json = response.json()
                    print(f"✅ [SUCCESS] API: {api_url} | Message: '{message}'")
                    print(response_json)
                    break
                except json.JSONDecodeError:
                    print(f"⚠️ [ERROR] Invalid JSON response! API: {api_url}")
            else:
                print(f"⚠️ [ERROR] API: {api_url} | Status: {response.status_code} | Retrying in 2s...")
                time.sleep(2)
        except Exception as e:
            print(f"❌ [REQUEST FAILED] API: {api_url} | Error: {e} | Retrying in 5s...")
            time.sleep(5)

# Start multiple threads
def start_thread():
    while True:
        random_message = random.choice(user_messages)
        send_request(random_message)

threads = []
for _ in range(num_threads):
    thread = threading.Thread(target=start_thread, daemon=True)
    threads.append(thread)
    thread.start()

for thread in threads:
    thread.join()
EOF
fi

# Make bot script executable and start screen session
chmod +x "$BOT_FILE"
echo "Starting screen session: $SCREEN_NAME"
screen -dmS "$SCREEN_NAME" bash -c "cd $INSTANCE_FOLDER && source venv/bin/activate && python3 bot.py $THREADS_AMOUNT"

# Verify screen session started
sleep 2
if screen -list | grep -q "$SCREEN_NAME"; then
    echo "Screen session $SCREEN_NAME started successfully."
    echo "Script completed successfully on $(date)."
    exit 0
else
    echo "Failed to start screen session $SCREEN_NAME."
    exit 1
fi
