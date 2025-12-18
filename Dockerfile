# Multi-stage Dockerfile for rUSD Airdrop
FROM node:18 AS node-base

# Install Solana CLI
RUN sh -c "$(curl -sSfL https://release.solana.com/stable/install)" && \
    export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"

# Install ts-node globally
RUN npm install -g ts-node typescript

# Python stage
FROM python:3.11-slim

# Copy Solana CLI from node stage
COPY --from=node-base /root/.local/share/solana /root/.local/share/solana
ENV PATH="/root/.local/share/solana/install/active_release/bin:$PATH"

# Install Node.js and npm
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g ts-node typescript yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy solana-engine (needed for minting)
COPY ./solana-engine /app/solana-engine
WORKDIR /app/solana-engine
RUN yarn install

# Copy airdrop-web
WORKDIR /app/airdrop-web
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Expose port
EXPOSE 8002

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8002/ || exit 1

# Start server
CMD ["python", "server.py"]
