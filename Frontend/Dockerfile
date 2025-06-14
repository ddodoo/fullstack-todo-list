### Stage 1: Build the React App

FROM node:20 AS builder

# Set working directory
WORKDIR /app

# Copy dependency files and install
COPY package.json .
RUN yarn install

# Copy all source files
COPY . .

# Build the Vite app
RUN yarn build


#### Stage 2: Serve with Nginx

FROM nginx:stable-alpine

# Remove default Nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom Nginx config (optional)
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]