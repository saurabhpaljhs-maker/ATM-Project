# Stage 1: Build Phase
FROM node:20-alpine AS builder
WORKDIR /usr/src/app

# Dependencies install karna
COPY package*.json ./
RUN npm install

# Source code copy karna
COPY . .

# Stage 2: Runtime Phase (Light & Secure)
FROM node:20-alpine
WORKDIR /usr/app

# Sirf production files ko copy karna (Security best practice)
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/server.js ./
COPY --from=builder /usr/src/app/node_modules ./node_modules

# Security Hardening: Non-root user create karna
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Application Port
EXPOSE 8081

# App start command
CMD ["node", "server.js"]
