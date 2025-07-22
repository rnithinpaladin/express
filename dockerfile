# Stage 1: Build stage
FROM node:18-alpine AS build

# Set working directory
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the application source code
COPY . .

# Stage 2: Runtime stage
FROM node:18-alpine

# Create a non-root user (optional but recommended for security)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /usr/src/app

# Copy only the necessary files from the build stage
COPY --from=build /usr/src/app ./

# Use non-root user
USER appuser

# Expose the port your app listens on
EXPOSE 3000

# Start the application
CMD ["node", "examples/hello-world/index.js"]
