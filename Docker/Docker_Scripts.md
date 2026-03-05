Sure! Below are the **15 Docker interview-related tasks** with detailed implementation. Each task focuses on a different Docker concept such as creating containers, optimizing Dockerfiles, managing networking, using Docker Compose, and more.

---

### **1. Basic Docker Container Creation**

**Task**: Create a basic Nginx container with a custom HTML page.

**Dockerfile**:
```Dockerfile
# Use official Nginx image
FROM nginx:latest

# Copy custom HTML file to the Nginx default directory
COPY index.html /usr/share/nginx/html/index.html

# Expose the default Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
```

**index.html**:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome to Docker Nginx</title>
</head>
<body>
    <h1>Hello from Dockerized Nginx!</h1>
</body>
</html>
```

**Build and Run**:
```bash
docker build -t nginx-custom .
docker run -d -p 8080:80 nginx-custom
```

---

### **2. Dockerizing a Python Flask Application**

**Task**: Containerize a simple Flask application.

**Dockerfile**:
```Dockerfile
# Use official Python image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . /app/

# Expose the Flask default port
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
```

**requirements.txt**:
```
Flask==2.0.1
```

**app.py**:
```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Dockerized Flask!'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
```

**Build and Run**:
```bash
docker build -t flask-app .
docker run -d -p 5000:5000 flask-app
```

---

### **3. Docker Compose for Multi-Container Setup**

**Task**: Set up a multi-container application using Docker Compose with Flask and PostgreSQL.

**docker-compose.yml**:
```yaml
version: '3.7'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - DATABASE_URI=postgresql://user:password@db:5432/mydatabase
    depends_on:
      - db

  db:
    image: postgres:13
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydatabase
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

**Dockerfile** (same as above for Flask app)

**Build and Run**:
```bash
docker-compose up --build
```

---

### **4. Volume Mounting**

**Task**: Demonstrate how to use volumes for persisting MySQL data.

**Docker Compose for MySQL**:
```yaml
version: '3.7'
services:
  mysql:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: example
    volumes:
      - mysql-data:/var/lib/mysql
    ports:
      - "3306:3306"

volumes:
  mysql-data:
```

**Build and Run**:
```bash
docker-compose up
```

---

### **5. Docker Networking**

**Task**: Set up a custom bridge network and connect two containers.

**Docker Compose for Networking**:
```yaml
version: '3.7'
services:
  app:
    image: alpine
    command: ping -c 4 db
    networks:
      - custom-network

  db:
    image: postgres:13
    networks:
      - custom-network

networks:
  custom-network:
    driver: bridge
```

**Build and Run**:
```bash
docker-compose up
```

---

### **6. Docker Image Optimization (Node.js Example)**

**Task**: Optimize a Node.js Dockerfile using multi-stage builds.

**Dockerfile**:
```Dockerfile
# Stage 1: Build stage
FROM node:14 AS build

WORKDIR /app
COPY package.json package-lock.json /app/
RUN npm install

COPY . /app/

# Stage 2: Runtime stage (smaller image)
FROM node:14-slim

WORKDIR /app
COPY --from=build /app /app

RUN npm prune --production

CMD ["node", "server.js"]
```

**Build and Run**:
```bash
docker build -t optimized-node-app .
docker run -d -p 3000:3000 optimized-node-app
```

---

### **7. Docker Environment Variables**

**Task**: Set up a Docker container that uses environment variables.

**Dockerfile**:
```Dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY app.py /app/

# Expose the environment variable
ENV APP_ENV=production

CMD ["python", "app.py"]
```

**app.py**:
```python
import os

app_env = os.getenv('APP_ENV', 'development')
print(f"App is running in {app_env} mode")
```

**Build and Run**:
```bash
docker build -t env-demo .
docker run -e APP_ENV=production env-demo
```

---

### **8. Docker Health Check**

**Task**: Add a health check to a Docker container running a simple web application.

**Dockerfile**:
```Dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY app.py /app/

EXPOSE 5000

CMD ["python", "app.py"]

# Add a health check
HEALTHCHECK CMD curl --fail http://localhost:5000/health || exit 1
```

**app.py**:
```python
from flask import Flask
import time

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, Dockerized Flask!'

@app.route('/health')
def health():
    return 'Healthy'

if __name__ == "__main__":
    time.sleep(5)  # Simulate app startup delay
    app.run(host='0.0.0.0', port=5000)
```

**Build and Run**:
```bash
docker build -t flask-healthcheck .
docker run -d -p 5000:5000 flask-healthcheck
```

---

### **9. Viewing Docker Logs**

**Task**: Show how to view logs from a running Docker container.

```bash
docker logs <container_id>
```

**Example**:
```bash
docker logs flask-healthcheck
```

---

### **10. Docker Swarm Setup**

**Task**: Set up a Docker Swarm cluster with one manager node and two worker nodes.

**Steps**:
1. Initialize Docker Swarm on the manager node:
   ```bash
   docker swarm init
   ```
2. Join worker nodes using the token provided by `docker swarm init`.

**Deploy Service**:
```bash
docker service create --name my-service --replicas 3 -p 80:80 nginx
```

---

### **11. Container Lifecycle Management**

**Task**: Manage the lifecycle of a Docker container (start, stop, remove).

```bash
# Start container
docker start <container_id>

# Stop container
docker stop <container_id>

# Restart container
docker restart <container_id>

# Remove container
docker rm <container_id>

# Remove all unused containers
docker container prune
```

---

### **12. Docker Compose for Multi-Tier App (React, Node, MongoDB)**

**docker-compose.yml**:
```yaml
version: '3.7'

services:
  frontend:
    image: node:14
    build: ./frontend
    ports:
      - "3000:3000"
  backend:
    image: node:14
    build: ./backend
    ports:
      - "5000:5000"
    environment:
      - DB_URI=mongodb://db:27017/mydb
    depends_on:
      - db
  db:
    image: mongo:latest
    ports:
      - "27017:27017"
```

**Build and Run**:
```bash
docker-compose up --build
```

---

### **13. Docker Security Best Practices**

**Task**: Harden a Docker image by limiting container capabilities.

**Dockerfile**:
```Dockerfile
FROM node:14

# Add a non-root user to run the app
RUN useradd -ms /bin/bash appuser
USER appuser

# Application code
WORKDIR /app
COPY . /app/

# Expose port and run the app
EXPOSE 3000
CMD ["node", "server.js"]
```

**Run with restricted capabilities**:
```bash
docker run --cap-drop=ALL --security-opt=no-new-privileges -d my-secure-app
```

---

### **14. Docker Image Signing**

**Task**: Sign a Docker image using Docker Content Trust.

1. Set `DOCKER_CONTENT_TRUST` to `1` to enable image signing.
```bash
export DOCKER_CONTENT_TRUST=1
```

2. Build and push an image.
```bash
docker build -t my-signed-image .
docker push my-signed-image
```

---

### **15. Automating Docker Builds with CI/CD (GitHub Actions)**

**GitHub Actions Workflow (`.github/workflows/docker-build.yml`)**:
```yaml
name: Docker Image CI/CD

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1

    - name: Cache Docker layers
      uses: actions/cache@v2
      with:
        path: /tmp/.buildx-cache
        key: ${{ runner.os }}-buildx-${{ github.sha }}
        restore-keys: |
          ${{ runner.os }}-buildx-

    - name: Build and push Docker image
      uses: docker/build-push-action@v2
      with:
        context: .
        file: ./Dockerfile
        push: true
        tags: my-repo/my-image:latest
```

---

These 15 detailed Docker interview tasks cover various aspects of Docker containerization, from basic container creation to Docker Compose, security, and CI/CD integration. They will help the interviewer assess the candidate's knowledge in building, deploying, and managing containerized applications effectively.