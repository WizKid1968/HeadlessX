FROM node:20-slim

# Install Playwright dependencies
RUN apt-get update && apt-get install -y \
    libgtk-3-0t64 libatk1.0-0t64 libatk-bridge2.0-0t64 \
    libcups2t64 libatspi2.0-0t64 libasound2t64 \
    libxcomposite1 libnss3 libdrm2 libxss1 libxrandr2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build website
RUN cd website && npm ci && npm run build && cd ..

# Install Playwright browsers
RUN npx playwright install chromium

EXPOSE 3000

CMD ["npm", "start"]
