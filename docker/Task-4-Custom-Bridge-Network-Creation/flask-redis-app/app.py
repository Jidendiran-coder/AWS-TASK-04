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