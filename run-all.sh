#!/bin/bash
set -e

echo "🚀 Starting Hardhat interactive initialization..."
hardhat --init

echo "🧹 Cleaning previous artifacts..."
npx hardhat clean

echo "🔨 Compiling contracts..."
npx hardhat compile

echo "✅ Contracts compiled successfully!"
ls -R artifacts/contracts/
