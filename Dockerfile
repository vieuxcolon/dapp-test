# ============================
# Hardhat 3.x reproducible env
# ============================

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# ----------------------------
# 1. System dependencies
# ----------------------------
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ca-certificates \
    expect \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------
# 2. Node.js 22.x + npm
# ----------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@10.9.4

# ----------------------------
# 3. Install Hardhat globally
# ----------------------------
RUN npm install -g hardhat@3.1.4

# ----------------------------
# 4. Copy repo (contracts already exist)
# ----------------------------
COPY . /app

# ----------------------------
# 5. NON-INTERACTIVE hardhat --init
#    (Hardhat 3.x Ink-safe Expect)
# ----------------------------
RUN expect <<'EOF'
set timeout -1
log_user 1

spawn hardhat --init

# 1. Hardhat version (default: hardhat-3)
expect "Which version of Hardhat would you like to use?"
send "\r"

# 2. Project path (default: .)
expect "Please provide either a relative or an absolute path:"
send "\r"

# 3. WAIT for menu to fully render (CRITICAL)
expect "A TypeScript Hardhat project using Node Test Runner and Viem"

# Move down twice to select "A minimal Hardhat project"
send "\033[B"
sleep 0.3
send "\033[B"
sleep 0.3
send "\r"

# 4. Overwrite existing files? (default: No)
expect "Do you want to overwrite them?"
send "\r"

# 5. Install dependencies? (default: Yes)
expect "Do you want to run it now?"
send "\r"

expect eof
EOF

# ----------------------------
# 6. FIRST compile (critical)
#    Downloads solc 0.8.28
# ----------------------------
RUN npx hardhat compile

# ----------------------------
# 7. Default command
# ----------------------------
CMD ["bash"]
