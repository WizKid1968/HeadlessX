FROM node:20-slim

WORKDIR /app

# Install base tools
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including dev)
RUN npm ci

# Install Playwright browser and dependencies
RUN npx playwright install chromium && \
    npx playwright install-deps chromium

# Copy rest of app
COPY . .

# Build website
RUN cd website && npm ci && npm run build && cd ..

EXPOSE 10000

CMD ["npm", "start"]
