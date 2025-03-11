
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

# Define folder name for the instance
INSTANCE_FOLDER="gaianet_instance_${INSTANCE_NUM}"


# Kill any existing screen session named "gaianet_script"
echo "Checking for existing folders with 'gaianet_chat_by_dp'..."
find . -type d -name "*gaianet_chat_by_dp*" -exec rm -rf {} + 2>/dev/null
echo "All matching folders deleted."

# Stop all screen sessions that contain "gaianet_script"
echo "Stopping all running 'gaianet_script' screen sessions..."
screen -ls | grep "gaianet_script" | awk '{print $1}' | while read session; do
    screen -X -S "$session" quit
done
echo "All matching screen sessions stopped."
# Create the instance directory if it doesn't exist
mkdir -p "$INSTANCE_FOLDER"

# Define paths inside the instance folder
ACCOUNT_FILE="$INSTANCE_FOLDER/account.txt"
MESSAGE_FILE="$INSTANCE_FOLDER/message.txt"
BOT_FILE="$INSTANCE_FOLDER/bot.py"
VENV_DIR="$INSTANCE_FOLDER/venv"
SCREEN_NAME="gaianet_chat_${INSTANCE_NUM}"

# Installing dependencies
sudo apt install screen -y
sudo apt install python3-venv -y 
sudo apt install git -y
sleep 3

# Kill the specific screen session if it exists
screen -X -S $SCREEN_NAME quit 2>/dev/null

# Create a virtual environment inside the instance folder
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

# Create message file
if [ ! -f "$MESSAGE_FILE" ]; then
  echo "Creating message file..."
  cat > "$MESSAGE_FILE" <<EOF
What is artificial intelligence?
How does machine learning work?
What is the difference between AI and machine learning?
What is deep learning?
How do neural networks function?
What is natural language processing?
How does computer vision work?
What are some real-world applications of AI?
What is the Turing test?
Who is Alan Turing and why is he important?
What is the history of artificial intelligence?
How do self-driving cars work?
What are the ethical concerns of AI?
How does AI impact job markets?
What is the singularity in AI?
What are chatbots and how do they work?
What is reinforcement learning?
How does AI generate images and videos?
What are large language models?
How does AI detect fraud?
What is blockchain technology?
How does Bitcoin work?
What is Ethereum?
How do smart contracts work?
What is a decentralized application (dApp)?
What is a cryptocurrency wallet?
How does mining work in cryptocurrency?
What is proof of work?
What is proof of stake?
What is the difference between a coin and a token?
How does a blockchain ensure security?
What are NFTs?
How are NFTs created?
What are the use cases of blockchain beyond crypto?
What is DeFi (Decentralized Finance)?
What is a DAO (Decentralized Autonomous Organization)?
How does Web3 differ from Web2?
What is quantum computing?
How does a quantum computer work?
What are qubits?
What is superposition in quantum computing?
What is quantum entanglement?
How can quantum computing revolutionize cryptography?
What are the challenges of quantum computing?
Who are the leaders in quantum computing development?
What is cloud computing?
What are the benefits of cloud computing?
What is SaaS (Software as a Service)?
What is IaaS (Infrastructure as a Service)?
What is PaaS (Platform as a Service)?
What is serverless computing?
What is edge computing?
What is a data center?
What is the difference between public and private clouds?
How do cloud storage services work?
What are APIs and how are they used?
What is REST API?
What is GraphQL?
What is an SDK?
What is microservices architecture?
How does containerization work?
What is Docker?
What is Kubernetes?
How does virtualization work?
What is a hypervisor?
What is 5G technology?
How is 5G different from 4G?
What are the benefits of 5G?
How does 5G impact IoT?
What are the security concerns with 5G?
What is Wi-Fi 6?
How do fiber-optic networks work?
What is a VPN and how does it work?
What is cybersecurity?
What are common types of cyber threats?
What is phishing?
What is ransomware?
How does encryption work?
What is two-factor authentication (2FA)?
What is a firewall?
How do antivirus programs work?
What is ethical hacking?
What is penetration testing?
How do password managers work?
What is zero-trust security?
What is the dark web?
How do Tor networks work?
What is biometric security?
What is facial recognition technology?
What are the risks of facial recognition?
How does fingerprint authentication work?
What is iris scanning technology?
What is AI-based fraud detection?
What is social engineering in cybersecurity?
How do digital signatures work?
What is a CAPTCHA?
How does end-to-end encryption work?
What is homomorphic encryption?
What is an IP address?
What is IPv6 and why is it important?
What is the Internet of Things (IoT)?
How do smart homes work?
What are some IoT security concerns?
What is an industrial IoT?
What is edge AI?
What is embedded computing?
How do smartwatches work?
What is augmented reality (AR)?
What is virtual reality (VR)?
What is mixed reality (MR)?
How does AR differ from VR?
What is the metaverse?
Who are the key players in the metaverse?
What is a digital twin?
How does 3D printing work?
What is additive manufacturing?
How does LiDAR technology work?
What is computer-aided design (CAD)?
What is robotic process automation (RPA)?
How do drones work?
What are the applications of drones?
What are self-replicating robots?
What is exoskeleton technology?
What are humanoid robots?
What is swarm robotics?
How do space robots work?
What is the history of robotics?
What are neural implants?
What is brain-computer interface (BCI)?
What is synthetic biology?
What is gene editing technology?
What is CRISPR?
What are biochips?
What are AI-driven prosthetics?
How does nanotechnology work?
What is a quantum internet?
What is the future of AI-generated content?
What is a hologram?
What is photonic computing?
What is DNA computing?
What is neuromorphic computing?
How does AI power autonomous robots?
What is 6G technology?
What is drone swarm technology?
What is self-healing software?
What is self-healing concrete?
What is decentralized cloud computing?
What is confidential computing?
What are AI-powered personal assistants?
What is edge AI computing?
What is predictive analytics?
What is a digital wallet?
How do mobile payments work?
What is a central bank digital currency (CBDC)?
How does AI detect deepfakes?
What is AI-generated music?
What is an AI-powered chatbot?
What is an AI-powered recommendation system?
What is an AI-powered translation service?
What are the dangers of AI bias?
What is explainable AI?
How does AI improve healthcare?
What is AI-driven drug discovery?
What is the role of AI in education?
What is the future of AI in creative industries?
What is AI-driven video editing?
What is AI-powered image recognition?
What is real-time AI translation?
What is the role of AI in agriculture?
How does AI help in climate research?
What is AI-generated storytelling?
What is an AI-powered writing assistant?
How does AI impact journalism?
What are digital humans?
How do autonomous ships work?
What is the Hyperloop?
How do maglev trains work?
What is AI-powered code generation?
What is the future of smart cities?
What is AI-based medical diagnosis?
How does AI power gaming NPCs?
What is AI-generated synthetic data?
How does AI predict earthquakes?
What are digital twins in manufacturing?
What are AI-driven surveillance systems?
What is the impact of AI on the film industry?
What is an AI-powered legal assistant?
What is AI-driven customer service?
What is AI-powered facial animation?
How does AI power financial trading algorithms?
What is the impact of AI on the music industry?
How does AI generate 3D models?
What is an AI-powered social media algorithm?
What is AI-powered stock market prediction?
How does AI detect plagiarism?
What is AI-powered fraud detection?
How does AI create deepfake videos?
What is AI-driven autonomous farming?
How does AI optimize logistics and supply chains?
How does AI impact space exploration?
What is the capital of France?
How does photosynthesis work?
Can you explain the theory of relativity in simple terms?
What is your favorite book and why?
If you could travel anywhere in the world, where would you go?
What are the benefits of regular exercise?
Who invented the telephone?
How does quantum computing differ from classical computing?
Why is the sky blue?
What exactly is artificial intelligence?
What are the main causes of climate change?
What is the meaning of life?
How do you solve a Rubik’s cube?
Can you explain the process of human digestion?
How many continents are there on Earth?
What is the best way to learn a new language?
Can you tell me a funny joke?
What is the smallest prime number?
Which is the largest planet in our solar system?
How does a computer process information?
What is the history of the Internet?
Can you describe the water cycle?
What is blockchain technology and how is it used?
What is the fastest land animal?
How do magnets work?
Why is the Mona Lisa so famous?
Who wrote "Romeo and Juliet"?
How do airplanes manage to stay in the air?
What causes earthquakes?
How do vaccines help protect our bodies?
What is the difference between a comet and an asteroid?
Why is renewable energy important for the future?
Can you explain the concept of gravity?
What are some key ingredients in a healthy salad?
How do you make the perfect cup of coffee?
What is your favorite programming language and why?
What is machine learning in simple terms?
How does an ecosystem maintain balance?
What exactly are black holes?
Can you recommend a good movie for a rainy day?
What is the difference between a virus and bacteria?
How does meditation benefit mental health?
What role does art play in society?
How does a smartphone function?
What is the Pythagorean theorem?
Can you explain how the stock market works?
What are the main stages of human life?
How do you cook pasta to achieve the perfect al dente texture?
What is the significance of dreams?
What is your opinion on space exploration?
How do the seasons change throughout the year?
What is the history behind the Olympic Games?
Can you explain the concept of supply and demand?
How does evolution shape the diversity of life?
What is the formula to calculate the area of a circle?
What are the benefits of reading regularly?
How is blockchain technology transforming industries?
Can you suggest a good book for self-improvement?
What are the main differences between Eastern and Western philosophies?
Why is mental health as important as physical health?
How does social media influence modern society?
What are the major world religions?
What function does the heart serve in the human body?
How do plants grow from seeds?
What is the history behind the Eiffel Tower?
Can you explain the concept of time dilation?
What are the advantages of electric cars over traditional vehicles?
How does the immune system defend the body?
What role does music play in different cultures?
How do you solve a quadratic equation?
Why is education important for personal growth?
Can you explain the fundamentals of democracy?
What are the differences between classical and jazz music?
How do satellites maintain orbit around the Earth?
What is significant about the Renaissance period?
Can you explain what virtual reality is?
What are common causes of stress and how can they be managed?
How do you play a game of chess?
What is the history of the space race between nations?
What are the characteristics of a balanced, healthy diet?
Can you tell me a little about your creators?
How does the human brain process information?
What distinguishes a smartphone from a tablet?
What is the historical development of the automobile?
How are weather forecasts generated?
What benefits does yoga offer for physical and mental well-being?
What is natural selection and how does it work?
Can you explain the basics of coding to a beginner?
What is the difference between fiction and non-fiction?
How is the speed of light measured?
Why is biodiversity important to our planet?
Can you recount a famous historical event?
What are the main components that make up a computer?
How do you start a conversation with someone new?
What is the history of human civilization?
Can you explain the theory of evolution?
What are some effective strategies for time management?
How does the Internet connect people around the world?
What ethical concerns arise with the development of AI?
Can you describe what an algorithm is in simple terms?
How do AI chatbots learn from conversations?
What is transfer learning in AI?
How does AI-powered speech recognition work?
What are some common AI programming languages?
How does AI generate realistic human faces?
What is an adversarial attack on AI models?
How does AI help in medical image analysis?
What is a GAN (Generative Adversarial Network)?
How do recommendation systems work on platforms like Netflix?
How does AI detect fraudulent transactions?
What is federated learning?
How does reinforcement learning apply to gaming AI?
What are transformer models in AI?
What is the role of AI in space exploration?
How does AI analyze satellite imagery?
What are self-supervised learning models?
What are AI-powered humanoid robots?
How does AI handle unstructured data?
How does AI predict disease outbreaks?
How does AI analyze financial markets?
What is AI-generated fashion design?
How does AI automate music composition?
How does AI generate human-like speech?
What are AI-powered self-healing systems?
How does AI help in legal case analysis?
What are quantum gates?
How does a quantum processor work?
What are superconducting qubits?
What is quantum cryptography?
How does quantum computing impact cybersecurity?
What is quantum supremacy?
What is quantum key distribution?
What is the difference between classical and quantum encryption?
How does quantum computing speed up simulations?
What are the potential applications of quantum computing in AI?
How do quantum circuits work?
What is the current state of quantum computing development?
What is the relationship between quantum mechanics and computing?
What industries will benefit the most from quantum computing?
What is Shor’s algorithm?
How does Grover’s algorithm work?
What challenges must be overcome to make quantum computing practical?
What is the role of IBM, Google, and other tech companies in quantum computing?
What is quantum teleportation?
What are the limitations of today’s quantum computers?
What is end-to-end encryption?
How does multi-factor authentication (MFA) work?
What are common cyber attack techniques?
What is social engineering in cybersecurity?
How does ransomware work?
What is a zero-day exploit?
How do hackers use botnets?
What is the difference between symmetric and asymmetric encryption?
What are the best practices for creating strong passwords?
What is a man-in-the-middle attack?
What is the role of AI in cybersecurity?
How do phishing scams work?
What is the impact of GDPR on data privacy?
What are security tokens in cybersecurity?
What is a brute-force attack?
What are honeypots in cybersecurity?
What is cybersecurity hygiene?
How do companies prevent data breaches?
What is a DDoS (Distributed Denial of Service) attack?
What is cyber forensics?
What are Layer 1 and Layer 2 blockchain solutions?
How do zero-knowledge proofs work?
What is a private blockchain?
What is the difference between Bitcoin and Ethereum?
How does staking work in blockchain networks?
What is a blockchain oracle?
How does tokenization work in finance?
What is the Lightning Network?
What are gas fees in Ethereum?
What are rollups in blockchain scaling?
How does blockchain support supply chain transparency?
What is the role of decentralized exchanges (DEXs)?
What is the difference between a soft fork and a hard fork in blockchain?
How does DeFi lending work?
What is an automated market maker (AMM)?
How do blockchain-based identity systems work?
What is a consensus mechanism in blockchain?
How does sharding improve blockchain scalability?
What are blockchain-based stablecoins?
What are wrapped tokens in crypto?
What is the difference between AR, VR, and MR?
How does AR enhance retail shopping?
How do VR headsets track movement?
What is eye-tracking technology in VR?
How does AR improve industrial training?
What is volumetric video in VR?
How does haptic feedback enhance VR experiences?
How does AR assist in medical surgeries?
What are the uses of AR in education?
What are the ethical concerns of VR addiction?
How does AR integrate with wearable devices?
What is spatial computing?
How do AR glasses work?
What is photogrammetry in AR?
How do full-body VR suits work?
What is the impact of VR on remote work?
How is VR used in real estate?
What are digital humans in AR?
How do AR filters work on social media?
What is the Metaverse, and how is it evolving?
How do reusable rockets work?
What is the significance of the James Webb Space Telescope?
How do satellites communicate with Earth?
What is nuclear fusion, and why is it important?
How do space elevators work?
What is asteroid mining?
How does AI assist in space exploration?
How do CubeSats contribute to space research?
What is interplanetary internet?
How does radiation affect astronauts in space?
What is the role of 3D printing in space missions?
What are the benefits of colonizing Mars?
How does AI help in analyzing astronomical data?
What is the importance of the Hubble Space Telescope?
How does solar sail technology work?
What is the future of interstellar travel?
What is cryogenic sleep for space travel?
What are exoplanets, and how do we detect them?
How does space weather impact Earth’s technology?
What is the role of private space companies in space exploration?
EOF
fi

# Create bot script inside the instance folder
if [ ! -f "$BOT_FILE" ]; then
  echo "Creating bot script..."
  cat > "$BOT_FILE" <<EOF
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

sleep 5
chmod +x "$BOT_FILE"
screen -dmS "$SCREEN_NAME" bash -c "cd $INSTANCE_FOLDER && source venv/bin/activate && python3 bot.py $THREADS_AMOUNT"
