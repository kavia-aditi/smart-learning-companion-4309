# syntax=docker/dockerfile:1

# -----------------------------
# Base image and common args
# -----------------------------
ARG NODE_VERSION=18-alpine

# -----------------------------
# Builder stage
# -----------------------------
FROM node:${NODE_VERSION} AS builder

ENV NODE_ENV=development

WORKDIR /app

# Install deps first for better caching
COPY package.json package-lock.json* ./
RUN npm ci

# Copy source and build
COPY tsconfig.json ./tsconfig.json
COPY src ./src

# Build TypeScript -> dist
RUN npm run build

# Prune dev dependencies to get production-only node_modules
RUN npm prune --production

# -----------------------------
# Runtime stage
# -----------------------------
FROM node:${NODE_VERSION} AS runtime

ENV NODE_ENV=production
WORKDIR /app

# Copy production node_modules and build output from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY package.json ./

# Expose port 8080
EXPOSE 8080

# Set default envs (can be overridden at runtime)
ENV PORT=8080

# Start the server
CMD ["node", "dist/server.js"]
