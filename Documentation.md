# Todo App

A full-stack Todo application built with React (Frontend), Node.js (Backend), and MongoDB (Database), containerized with Docker for easy deployment and development.

![Todo App](Frontend/src/assets/home-snapshot.png)

## 🚀 Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd todo-app

# Start the application
docker compose down -v
docker compose build --no-cache
docker compose up
```

**Access the application:**
- Frontend: http://localhost:3001
- Backend API: http://localhost:3000
- Database: localhost:27017

## 📋 Features

- ✅ Create, read, update, and delete todos
- 🎨 Modern React frontend with responsive design
- 🔗 RESTful API backend
- 🗄️ MongoDB database with persistent storage
- 🐳 Fully containerized with Docker
- 🔒 Secure database authentication
- 🌐 Isolated Docker network

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │    Backend      │    │   Database      │
│   (React)       │◄──►│   (Node.js)     │◄──►│   (MongoDB)     │
│   Port: 3001    │    │   Port: 3000    │    │   Port: 27017   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📦 Project Structure

```
todo-app/
├── Backend/
│   ├── DB/
│   │   ├── connection.js
│   │   └── models/
│   │       └── Todo.model.js
│   ├── src/
│   │   └── modules/
│   │       ├── index.router.js
│   │       └── todos/
│   │           ├── todo.controller.js
│   │           └── todo.router.js
│   ├── Dockerfile
│   ├── index.js
│   └── package.json
├── Frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── hooks/
│   │   └── utils/
│   ├── nginx/
│   │   └── nginx.conf
│   ├── Dockerfile
│   └── package.json
└── docker-compose.yaml
```

## 🛠️ Installation & Setup

## 🔧 Configuration

### Environment Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `MONGO_INITDB_ROOT_USERNAME` | MongoDB root username | `admin` |
| `MONGO_INITDB_ROOT_PASSWORD` | MongoDB root password | `9$9i&ZNw0e>4` |
| `MONGO_INITDB_DATABASE` | Default database name | `todoapp` |

### Port Configuration
| Service | Internal Port | External Port | Description |
|---------|---------------|---------------|-------------|
| Frontend | 80 | 3001 | React application |
| Backend | 3000 | 3000 | Node.js API server |
| Database | 27017 | 27017 | MongoDB instance |

## 🔒 Security
**⚠️ Security Recommendations:**
1. **Change default credentials** before production deployment
2. **Use environment files** for sensitive data:
   ```bash
   echo "MONGO_ROOT_PASSWORD=your-secure-password" > .env
   ```
3. **Network isolation** via custom Docker network
4. **Data persistence** with named Docker volumes

## 🚀 Development

### Prerequisites
- Docker (v20.10+)
- Docker Compose (v2.0+)
- Git
- 2GB+ available RAM

### Local Development
```bash
# Start development environment
docker compose up

# Run in background
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down

# Reset everything (including data)
docker compose down -v
```

### API Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/todos` | Get all todos |
| POST | `/todos` | Create new todo |
| PUT | `/todos/:id` | Update todo |
| DELETE | `/todos/:id` | Delete todo |

## 🧪 Testing

### Automated Testing
Run the comprehensive test suite:

```bash
# Make the test script executable
chmod +x test-containers.sh

# Run all tests
./test-containers.sh
```

### Manual Testing
```bash
# Test API endpoints
curl http://localhost:3000/todos
curl -X POST http://localhost:3000/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Todo","completed":false}'

# Test database connection
docker compose exec database mongosh \
  -u admin -p '9$9i&ZNw0e>4' \
  --authenticationDatabase admin

# Check container status
docker compose ps
```

## 🔍 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Check what's using the port
sudo lsof -i :3000
sudo lsof -i :3001
sudo lsof -i :27017

# Kill the process or change ports in docker-compose.yaml
```

#### Build Failures
```bash
# Clear Docker cache
docker system prune -a

# Rebuild without cache
docker compose build --no-cache
```

#### Database Connection Issues
```bash
# Check container status
docker compose ps

# View database logs
docker compose logs database

# Test network connectivity
docker compose exec backend ping todo-database
```

#### Frontend Not Loading
```bash
# Check frontend logs
docker compose logs frontend

# Verify backend connectivity
curl http://localhost:3000
```

### Debug Commands
```bash
# View all logs
docker compose logs

# View specific service logs
docker compose logs backend

# Execute commands in containers
docker compose exec backend bash
docker compose exec database mongosh

# Monitor resource usage
docker stats
```

## 📊 Monitoring

### Health Checks
```bash
# Quick health check
docker compose ps && curl -s http://localhost:3001 > /dev/null && echo "✅ All services healthy"

# Detailed health check
./test-containers.sh
```

### Backup Database
```bash
# Create backup
docker compose exec database mongodump \
  --uri="mongodb://admin:9\$9i&ZNw0e>4@localhost:27017/todoapp?authSource=admin" \
  --out=/tmp/backup

# Copy to host
docker cp todo-database:/tmp/backup ./backup
```

## 🚀 Production Deployment

### Environment Setup
1. Change default database credentials
2. Use Docker secrets for sensitive data
3. Implement proper logging
4. Add health checks to services
5. Configure backup strategies
6. Set up monitoring and alerting

### Scaling
```bash
# Scale backend instances
docker compose up --scale backend=3
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Test with: `./test-containers.sh`
5. Commit: `git commit -am 'Add feature'`
6. Push: `git push origin feature-name`
7. Submit a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter any issues:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Run the test script: `./test-containers.sh`
3. Check container logs: `docker compose logs`
4. Open an issue on GitHub

---

**Made with ❤️ using React, Node.js, MongoDB, and Docker**

---

## 🧪 Automated Testing Script

Save this as `test-containers.sh` and make it executable with `chmod +x test-containers.sh`:

```bash
#!/bin/bash

echo "🧪 Todo App Container Testing Script"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print test results
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        return 1
    fi
}

# Function to test HTTP endpoint
test_endpoint() {
    local url=$1
    local description=$2
    local expected_status=${3:-200}
    
    echo -n "Testing $description... "
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✅ ($response)${NC}"
        return 0
    else
        echo -e "${RED}❌ ($response)${NC}"
        return 1
    fi
}

echo ""
echo "1. Testing Container Status..."
echo "------------------------------"

# Check if containers are running
containers=("todo-database" "todo-backend" "todo-frontend")
for container in "${containers[@]}"; do
    if docker ps --format "table {{.Names}}" | grep -q "^$container$"; then
        print_result 0 "$container is running"
    else
        print_result 1 "$container is not running"
    fi
done

echo ""
echo "2. Testing Network Connectivity..."
echo "--------------------------------"

# Test if backend can reach database
if docker compose exec -T backend ping -c 1 todo-database > /dev/null 2>&1; then
    print_result 0 "Backend can reach database"
else
    print_result 1 "Backend cannot reach database"
fi

echo ""
echo "3. Testing Database Connection..."
echo "-------------------------------"

# Test MongoDB connection
if docker compose exec -T database mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    print_result 0 "MongoDB is responding"
else
    print_result 1 "MongoDB is not responding"
fi

# Test authentication
if docker compose exec -T database mongosh -u admin -p "9\$9i&ZNw0e>4" --authenticationDatabase admin --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    print_result 0 "MongoDB authentication working"
else
    print_result 1 "MongoDB authentication failed"
fi

echo ""
echo "4. Testing HTTP Endpoints..."
echo "---------------------------"

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 5

# Test backend health
test_endpoint "http://localhost:3000" "Backend API"

# Test backend todos endpoint
test_endpoint "http://localhost:3000/todos" "Backend /todos endpoint"

# Test frontend
test_endpoint "http://localhost:3001" "Frontend application"

echo ""
echo "5. Testing API Functionality..."
echo "-----------------------------"

# Test POST request (create todo)
echo -n "Testing POST /todos... "
post_response=$(curl -s -X POST http://localhost:3000/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Todo","completed":false}' \
  -w "%{http_code}" -o /tmp/post_response.json 2>/dev/null)

if [[ "$post_response" =~ ^(200|201)$ ]]; then
    echo -e "${GREEN}✅ ($post_response)${NC}"
    # Extract ID for cleanup
    TODO_ID=$(cat /tmp/post_response.json | grep -o '"_id":"[^"]*' | cut -d'"' -f4 2>/dev/null)
else
    echo -e "${RED}❌ ($post_response)${NC}"
fi

# Test GET request (fetch todos)
echo -n "Testing GET /todos... "
get_response=$(curl -s -w "%{http_code}" http://localhost:3000/todos -o /tmp/get_response.json 2>/dev/null)

if [ "$get_response" = "200" ]; then
    echo -e "${GREEN}✅ ($get_response)${NC}"
else
    echo -e "${RED}❌ ($get_response)${NC}"
fi

# Cleanup test todo if created successfully
if [ ! -z "$TODO_ID" ]; then
    echo -n "Cleaning up test todo... "
    delete_response=$(curl -s -X DELETE "http://localhost:3000/todos/$TODO_ID" -w "%{http_code}" -o /dev/null 2>/dev/null)
    if [[ "$delete_response" =~ ^(200|204)$ ]]; then
        echo -e "${GREEN}✅${NC}"
    else
        echo -e "${YELLOW}⚠️ (manual cleanup may be needed)${NC}"
    fi
fi

echo ""
echo "6. Container Resource Usage..."
echo "----------------------------"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"

echo ""
echo "7. Volume Information..."
echo "----------------------"
echo "Database volume info:"
docker volume inspect todo-app_mongodb_data --format "{{.Mountpoint}}" 2>/dev/null || echo "Volume not found"

echo ""
echo "🏁 Testing Complete!"
echo "==================="
echo ""
echo "Quick Commands:"
echo "- View logs: docker compose logs"
echo "- Restart services: docker compose restart"
echo "- Stop services: docker compose down"
echo "- View container status: docker compose ps"
echo ""
echo "Access URLs:"
echo "- Frontend: http://localhost:3001"
echo "- Backend API: http://localhost:3000"
echo "- Backend API docs: http://localhost:3000/todos"

# Cleanup temp files
rm -f /tmp/post_response.json /tmp/get_response.json
```

### Manual Testing Commands

```bash
# Test individual containers
docker compose exec backend curl http://localhost:3000
docker compose exec frontend curl http://localhost:80
docker compose exec database mongosh -u admin -p '9$9i&ZNw0e>4' --authenticationDatabase admin

# Test API endpoints
curl http://localhost:3000/todos
curl -X POST http://localhost:3000/todos -H "Content-Type: application/json" -d '{"title":"Test","completed":false}'

# Test database directly
docker compose exec database mongosh -u admin -p '9$9i&ZNw0e>4' --authenticationDatabase admin todoapp --eval "db.todos.find()"

# Monitor containers
watch docker compose ps
docker compose logs -f --tail=50
```

### Health Check Commands

```bash
# Quick health check
docker compose ps && curl -s http://localhost:3001 > /dev/null && echo "✅ All services healthy" || echo "❌ Some services down"

# Detailed health check
docker compose exec backend curl -f http://localhost:3000 > /dev/null 2>&1 && echo "Backend: ✅" || echo "Backend: ❌"
docker compose exec frontend curl -f http://localhost:80 > /dev/null 2>&1 && echo "Frontend: ✅" || echo "Frontend: ❌"
docker compose exec database mongosh --quiet --eval "db.adminCommand('ping').ok" > /dev/null 2>&1 && echo "Database: ✅" || echo "Database: ❌"
```

---

## Additional Notes

### Development vs Production
- Current setup is for development. For production:
  - Use environment variables for secrets
  - Implement proper logging
  - Add health checks to docker-compose.yaml
  - Use Docker secrets for sensitive data
  - Configure proper backup strategies

### Scaling
To scale services:
```bash
# Scale backend to 3 instances
docker compose up --scale backend=3

# Note: You'll need a load balancer for multiple backend instances
```

### Backup Database
```bash
# Create backup
docker compose exec database mongodump --uri="mongodb://admin:9\$9i&ZNw0e>4@localhost:27017/todoapp?authSource=admin" --out=/tmp/backup

# Copy backup to host
docker cp todo-database:/tmp/backup ./backup
```