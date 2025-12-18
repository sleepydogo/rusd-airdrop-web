#!/bin/bash

echo "🚀 Starting rUSD Airdrop Server"
echo "================================"
echo ""

# Check if requirements are installed
if ! python -c "import fastapi" 2>/dev/null; then
    echo "📦 Installing Python dependencies..."
    pip install -r requirements.txt
fi

# Check Solana config
echo "🔍 Checking Solana configuration..."
solana config get

echo ""
echo "💰 Starting airdrop server on http://localhost:8002"
echo "🌐 Open http://localhost:8002/static/index.html in your browser"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start the server
python server.py
