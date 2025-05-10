# Multi-Container Flask Application with Redis

This project demonstrates how to create a multi-container application using Docker Compose. The application consists of a Flask web server that increments a counter value stored in Redis each time the page is refreshed.

## Project Structure

```
flask-redis-app/
├── app.py                 # Flask application code
├── requirements.txt       # Python dependencies
├── Dockerfile             # Instructions to build the Flask app container
└── docker-compose.yml     # Service definitions for both containers
```

## Prerequisites

- [Docker](https://www.docker.com/get-started) installed on your machine
- [Docker Compose](https://docs.docker.com/compose/install/) installed on your machine (included with Docker Desktop for Windows/Mac)

## Application Components

### Flask Application (app.py)

The Flask application provides a simple web interface that:
- Connects to the Redis service
- Increments a visit counter each time the page is loaded
- Displays the current count to the user

### Redis Database

Redis is used as an in-memory data store to persist the counter value between requests and across application restarts.

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd flask-redis-app
```

### 2. Examine the Code

The application consists of:

**app.py**
```python
from flask import Flask, jsonify
import redis
import socket
import os

app = Flask(__name__)

# Connect to Redis using container name from docker-compose
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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**requirements.txt**
```
flask==1.1.4
redis==4.0.2
werkzeug==1.0.1
```

**Dockerfile**
```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

**docker-compose.yml**
```yaml
version: '3'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - REDIS_HOST=redis
    depends_on:
      - redis
    networks:
      - app-network

  redis:
    image: redis:latest
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

### 3. Build and Run the Application

Use Docker Compose to build and run both containers:

```bash
docker-compose up
```

For detached mode (run in background):

```bash
docker-compose up -d
```

### 4. Test the Application

Visit [http://localhost:5000](http://localhost:5000) in your browser. You should see a JSON response with:
- A greeting message
- The container ID
- The visit counter (increments on refresh)
- Redis connection status

Refresh the page multiple times to see the counter increment.

### 5. Shut Down the Application

When you're finished testing, stop the containers:

```bash
# If running in foreground (with Ctrl+C)
# OR if running in detached mode:
docker-compose down
```

## How It Works

1. **Docker Compose Networking:**
   - Both containers are connected to a custom bridge network named `app-network`
   - Within this network, containers can communicate using service names as hostnames

2. **Service Dependencies:**
   - The Flask application depends on the Redis service
   - Docker Compose ensures Redis starts before the Flask app

3. **Data Persistence:**
   - The visit counter persists as long as the Redis container is running
   - If you stop and restart with `docker-compose up`, the counter will continue from its previous value
   - If you use `docker-compose down` and then restart, the counter will reset to zero

## Additional Commands

```bash
# View logs
docker-compose logs

# View logs for a specific service
docker-compose logs web

# Scale the web service (create multiple instances)
docker-compose up -d --scale web=3

# Enter a running container
docker-compose exec web bash
docker-compose exec redis redis-cli
```

## Troubleshooting

If you encounter any issues:

1. Ensure both Docker and Docker Compose are properly installed and up to date
2. Check the Docker Compose logs for error messages
3. Verify that port 5000 is not in use by another application
4. Test the Redis connection manually from inside the Flask container:
   ```bash
   docker-compose exec web bash
   python -c "import redis; r = redis.Redis(host='redis'); print(r.ping())"
   ```

## License

[Specify license information here]