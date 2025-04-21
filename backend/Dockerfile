FROM node:18-alpine

WORKDIR /app

# Copy package files first to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Create necessary directories
RUN mkdir -p /app/logs

# Set environment variables
ENV NODE_ENV=development
ENV PORT=5000

# Expose port
EXPOSE 5000

# Add wait script to ensure database is ready
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

# Start the application
CMD /wait && node server.js 