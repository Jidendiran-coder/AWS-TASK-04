I'll help you create a complete implementation of Task 4 from scratch, including creating a Flask application image that communicates with Redis, all using a custom network named "app-network".

## Task 4: Custom Bridge Network Creation (Complete Implementation)

### 1. Create a Custom Bridge Network

```bash
# Create the custom bridge network named app-network
docker network create app-network

# Verify the network was created
docker network ls
```

### 2. Create a Simple Flask Application

First, let's create a directory for our Flask application:

```bash
mkdir flask-redis-app
cd flask-redis-app
```

Now, create the following files:

**app.py**:
```python
from flask import Flask, jsonify
import redis
import os
import socket

app = Flask(__name__)

# Connect to Redis using container name
redis_host = os.environ.get('REDIS_HOST', 'redis')
redis_client = redis.Redis(host=redis_host, port=6379)

@app.route('/')
def index():
    try:
        # Increment a counter in Redis
        visit_count = redis_client.incr('visits')
        
        # Get hostname for demonstration
        hostname = socket.gethostname()
        
        return jsonify({
            'message': 'Hello from Flask!',
            'container': hostname,
            'visit_count': visit_count,
            'redis_connection': 'successful'
        })
    except Exception as e:
        return jsonify({
            'message': 'Hello from Flask!',
            'container': socket.gethostname(),
            'redis_connection': 'failed',
            'error': str(e)
        }), 500

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**requirements.txt**:
```
flask==2.0.1
redis==4.0.2
werkzeug==2.0.1
```

**Dockerfile**:
```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

### 3. Build the Flask Application Image

```bash
# Build the Flask application image
docker build -t flask-redis-app .
```

### 4. Deploy Containers in the Custom Network

Now, deploy both Redis and your Flask application in the custom network:

```bash
# Run Redis container
docker run -d --name redis --network app-network redis:latest

# Run Flask container connected to Redis
docker run -d --name flask-app --network app-network -p 5000:5000 \
  -e REDIS_HOST=redis \
  flask-redis-app
```

### 5. Configure Communication Between Containers

The Flask application is already configured to communicate with Redis using the container name as the hostname. The connection is established in the app.py file with:

```python
redis_host = os.environ.get('REDIS_HOST', 'redis')
redis_client = redis.Redis(host=redis_host, port=6379)
```

This works because Docker's built-in DNS resolver allows containers in the same custom network to find each other by container name.

### 6. Test Network Communication

Test that the containers can communicate by accessing the Flask app:

```bash
# Check if containers are running
docker ps

# Check logs
docker logs flask-app

# Test the application with curl
curl http://localhost:5000
```

The response should look like:
```json
{
  "container": "container_id",
  "message": "Hello from Flask!",
  "redis_connection": "successful",
  "visit_count": 1
}
```

Each time you refresh or call the API, the visit count should increment, proving that Redis and Flask are communicating.

### 7. Additional Testing Commands

To further verify communication between containers:

```bash
# Enter the Flask container
docker exec -it flask-app bash

# Inside the container, install ping tools
apt-get update && apt-get install -y iputils-ping

# Ping Redis by container name
ping redis

# Check Redis connection directly
python -c "import redis; r = redis.Redis(host='redis'); print(r.ping())"
```

This implementation demonstrates creating a custom network, building a Flask application that uses Redis, and deploying both containers to communicate with each other over the custom network.