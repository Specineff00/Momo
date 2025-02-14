# Momo App

A Swift Vapor application containerized with Docker.

## Prerequisites

- Docker Desktop
- Docker Compose
- Docker Hub account

## Setup Instructions

### Development Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/momo-app.git
   ```

2. Create required Docker secrets:
   ```bash
   echo "your_root_password" | docker secret create db_root_password -
   echo "your_user_password" | docker secret create db_password -
   echo "your_username" | docker secret create db_user -
   ```

3. Deploy the stack:
   ```bash
   docker stack deploy -c docker-compose.yml your_stack_name
   ```


### Docker Image Management

  Build the image:
  ```bash
  docker build -t specineff00/momo-app:version .
  ```

  Tag the image with the correct repository name
  ```bash
  docker tag specineff00/momo_app:latest specineff00/momo-app:latest
  ```

  Push to Docker Hub:
  ```bash
  docker push specineff00/momo-app:version
  ```

## Deployment

1. Initialize Docker Swarm:
   ```bash
   docker swarm init
   ```

2. Deploy the stack:
   ```bash
   docker stack deploy -c docker-compose.yml your_stack_name
   ```

3. Verify deployment:
   ```bash
   docker stack services your_stack_name
   ```
