# Task 1: Build and Run a Dockerized Flask Application

This guide walks you through creating a simple Flask application, containerizing it with Docker, and running it on your local machine.

## Step 1: Write the Flask Application

First, create a project directory and navigate into it:

```bash
mkdir flask-docker-app
cd flask-docker-app
```

Create a new Python file called `app.py` with the following content:

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return {
        "message": "Welcome to my Flask Docker application!",
        "status": "success"
    }

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

Create a `requirements.txt` file to list the dependencies:

```
flask==2.0.1
```

## Step 2: Create a Dockerfile

In the same directory, create a file named `Dockerfile` (with no file extension):

```dockerfile
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container
COPY . .

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable
ENV FLASK_APP=app.py

# Run app.py when the container launches
CMD ["python", "app.py"]
```

## Step 3: Build the Docker Image

Build the Docker image using the following command:

```bash
docker build -t flask-app .
```

This command:
- `-t flask-app` assigns the tag "flask-app" to your image
- `.` tells Docker to look for the Dockerfile in the current directory

You can verify that your image was created by running:

```bash
docker images
```

You should see your "flask-app" image in the list.

## Step 4: Run the Container

Run the Docker container and map port 5000 of the container to port 5000 on your host:

```bash
docker run -p 5000:5000 flask-app
```

If you want to run the container in the background (detached mode):

```bash
docker run -d -p 5000:5000 --name my-flask-container flask-app
```

## Step 5: Test the Application

Open your web browser and navigate to:

```
http://localhost:5000
```

You should see the JSON response:

```json
{
  "message": "Welcome to my Flask Docker application!",
  "status": "success"
}
```

Alternatively, you can use curl from the terminal:

```bash
curl http://localhost:5000
```

## Additional Commands

### Check running containers:
```bash
docker ps
```

### Stop the container:
```bash
docker stop my-flask-container
```

### Remove the container:
```bash
docker rm my-flask-container
```

### Enter the running container:
```bash
docker exec -it my-flask-container bash
```

## Troubleshooting

1. **Port already in use**: If port 5000 is already being used, change the port mapping:
   ```bash
   docker run -p 8080:5000 flask-app
   ```
   Then access the application at `http://localhost:8080`

2. **Permission denied**: If you encounter permission issues, try running the Docker commands with `sudo`

3. **Container exits immediately**: Check the logs to see what went wrong:
   ```bash
   docker logs my-flask-container
   ```

## Next Steps

- Add more routes to your Flask application
- Connect to a database
- Set up a development environment with auto-reloading
- Learn about Docker Compose for multi-container applications