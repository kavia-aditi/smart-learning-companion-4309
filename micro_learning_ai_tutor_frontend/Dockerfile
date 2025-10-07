# syntax=docker/dockerfile:1

# Build Flutter web app
FROM ghcr.io/cirruslabs/flutter:3.24.3 AS builder
WORKDIR /app

# Copy pubspec files and fetch deps first for caching
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the source and build for web
COPY . .
# Use a configurable API URL injected at build/run time
# The app reads BACKEND_BASE_URL via --dart-define (see lib/config/env.dart).
ARG BACKEND_BASE_URL=http://backend:8080
RUN flutter build web --release --dart-define=BACKEND_BASE_URL=${BACKEND_BASE_URL}

# Runtime image with a tiny static server
FROM node:20-alpine AS runtime
WORKDIR /srv/app

# Install a tiny HTTP server
RUN npm i -g dhttpd@^1.4.1

# Copy built web assets
COPY --from=builder /app/build/web ./build

# Serve on 3000 by default
ENV PORT=3000
EXPOSE 3000

# Start static server
CMD ["dhttpd", "--path", "/srv/app/build", "--port", "3000", "--host", "0.0.0.0"]
