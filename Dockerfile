FROM node:20-slim

WORKDIR /app

# Install base tools
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy package files first (for Docker layer caching)
COPY package*.json ./

# Install Node.js dependencies
RUN npm ci --only=production

# Install Playwright browser and dependencies
RUN npx playwright install chromium && \
    npx playwright install-deps chromium

# Copy application code
COPY . .

# Build the website
RUN cd website && npm ci && npm run build && cd ..

EXPOSE 10000

CMD ["npm", "start"]
