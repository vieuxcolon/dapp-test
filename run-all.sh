#!/bin/bash
set -e

# Compile contracts
npx hardhat clean
npx hardhat compile

echo "✅ Contracts compiled successfully!"
ls -R artifacts/contracts/
