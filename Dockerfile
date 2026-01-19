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
# 5. Automate `hardhat --init`
#    (minimal project, no overwrite, install deps)
# ----------------------------
RUN expect <<'EOF'
set timeout -1
spawn hardhat --init

expect "Which version of Hardhat would you like to use?"
send "\r"

expect "Please provide either a relative or an absolute path:"
send "\r"

expect "What type of project would you like to initialize?"
send "\033[B\033[B\r"   ;# scroll down twice → "A minimal Hardhat project"

expect "Do you want to overwrite them?"
send "\r"                ;# false (default)

expect "Do you want to run it now?"
send "\r"                ;# true (default)

expect eof
EOF

# ----------------------------
# 6. FIRST compile (critical!)
#    Downloads solc 0.8.28 and seals project
# ----------------------------
RUN npx hardhat compile

# ----------------------------
# 7. Default command
#    run-all.sh is now safe & deterministic
# ----------------------------
CMD ["bash"]

