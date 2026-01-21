
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
# 4. Copy repo
# ----------------------------
COPY . /app

# ----------------------------
# 5. Default command
# ----------------------------
CMD ["bash"]
