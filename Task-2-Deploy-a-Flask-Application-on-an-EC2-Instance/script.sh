#!/bin/bash
# Update and install necessary packages
sudo apt update -y
sudo apt install -y python3-pip python3-venv git python3-flask

# Install Flask within a virtual environment (optional, you can skip if using system-wide Flask)
cd /home/ubuntu

# Create a new directory for the Flask app
mkdir flask_app
cd flask_app

# (Optional) Create a virtual environment for isolating the Flask installation
python3 -m venv flask_env

# (Optional) Activate the virtual environment
source flask_env/bin/activate

# Install Flask inside the virtual environment if you are using one
# pip install flask

# If using system-wide Flask via apt, you can skip this step

# Create the app.py file with a simple Flask application
cat <<EOF > app.py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return 'Your name'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOF

# Start the Flask app in the background
sudo nohup python3 app.py
