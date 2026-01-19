# Use Ubuntu 22.04 LTS
FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Install essentials
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22.x
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@10.9.4

# Install Hardhat globally
RUN npm install -g hardhat@3.1.4

# Copy repo contents (including contracts/InvestmentDAO.sol)
COPY . /app

# Automatically initialize Hardhat minimal project
RUN npx hardhat init --yes-minimal

# Install dependencies suggested by hardhat init
RUN npm install --save-dev "hardhat@^3.1.4" "@types/node@^22.8.5" "typescript@~5.8.0"

# Compile Solidity contracts
RUN npx hardhat compile

# Set default command
CMD [ "bash" ]
