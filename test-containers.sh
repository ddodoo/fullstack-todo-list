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