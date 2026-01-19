FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# System deps
RUN apt-get update && apt-get install -y \
  curl git build-essential ca-certificates expect \
  && rm -rf /var/lib/apt/lists/*

# Node 22 + npm
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g npm@10.9.4

# Hardhat
RUN npm install -g hardhat@3.1.4

# Copy repo (only InvestmentDAO.sol is required)
COPY . /app

# Hardhat init (automated)
RUN expect <<'EOF'
set timeout -1
spawn hardhat --init

expect -re "Which version of Hardhat"
send "\r"

expect -re "relative or an absolute path"
send "\r"

expect -re "What type of project would you like to initialize"
expect -re "A minimal Hardhat project"
send "\x1b[B"
send "\x1b[B"
send "\r"

expect {
  -re "overwrite" {
    send "\r"
    exp_continue
  }
  -re "run it now" {
    send "\r"
  }
}

expect eof
EOF

# First compile (downloads solc, seals project)
RUN npx hardhat compile

CMD ["bash"]
