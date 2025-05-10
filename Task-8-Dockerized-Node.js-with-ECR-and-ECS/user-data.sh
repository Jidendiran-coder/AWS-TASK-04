#!/bin/bash

set -e

echo "🔧 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "🐋 Installing Docker using official script..."
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | sudo sh
fi

echo "⚙️ Adding user to docker group..."
sudo usermod -aG docker $USER
# Apply group change without reboot
newgrp docker << END
echo "✅ Docker installed:"
docker version
END

echo "⬇️ Installing Node.js v20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v && npm -v

echo "🔐 Installing AWS CLI v2..."
if ! command -v aws &> /dev/null; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
fi
aws --version

echo "📦 Installing Git..."
sudo apt install -y git
git --version

echo "✅ Environment is ready with Docker, Node.js, AWS CLI, and Git!"



'''

previous script for user data dont use but id something doesnt install liek aws or github scroll down to find sudo commands for it in this

#!/bin/bash

set -e

echo "🔧 Updating packages..."
sudo apt update && sudo apt upgrade -y

echo "🐋 Installing Docker (if not already installed)..."
if ! command -v docker &> /dev/null; then
  sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

echo "✅ Docker version:"
docker --version

echo "⚙️ Adding user to docker group (optional)..."
sudo usermod -aG docker $USER
newgrp docker

echo "⬇️ Installing Node.js (v20) and npm..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v && npm -v

echo "🔐 Installing AWS CLI v2 (for ECR auth)..."
if ! command -v aws &> /dev/null; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
fi

echo "✅ AWS CLI version:"
aws --version

echo "🚀 Environment is ready for Dockerized Node.js + Amazon ECR workflow!"

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && sudo ./aws/install && aws --version

sudo curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
newgrp docker

sudo apt install -y git

'''