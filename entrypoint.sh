#!/bin/bash
set -e

if [ ! -f hardhat.config.ts ] && [ ! -f hardhat.config.js ]; then
  echo "🚀 Initializing Hardhat project (one-time)..."

  expect <<'EOF'
  set timeout -1
  spawn hardhat --init

  expect -re "Which version of Hardhat"
  send "\r"

  expect -re "initialize the project"
  send "\r"

  expect -re "What type of project"
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
fi

echo "📦 First compile (downloads solc)"
npx hardhat compile

exec bash
