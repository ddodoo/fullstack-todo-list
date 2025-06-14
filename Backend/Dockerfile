# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json .
RUN npm install
COPY . .

# Stage 2: Runtime
FROM node:18-alpine

WORKDIR /app
COPY --from=builder /app .

ENV NODE_ENV=production
ENV PORT=3000


EXPOSE 3000
CMD ["npm", "start"]