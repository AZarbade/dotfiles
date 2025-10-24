#!/bin/bash

# yt_down.sh — Download YouTube video in 4K with audio using yt-dlp
# Usage: ./yt_down.sh <YouTube_URL>

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
    echo "Error: yt-dlp is not installed. Install it with:"
    echo "  sudo apt install yt-dlp"
    exit 1
fi

# Check if a URL was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <YouTube_URL>"
    exit 1
fi

URL="$1"

# Optional: create a downloads directory
DOWNLOAD_DIR="$HOME/Videos/yt-downloads"
mkdir -p "$DOWNLOAD_DIR"

# Download the best 4K video with audio
yt-dlp \
    -f "bestvideo[height<=2160]+bestaudio/best[height<=2160]" \
    --merge-output-format mp4 \
    --embed-metadata \
    --embed-thumbnail \
    -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" \
    "$URL"

# Confirm completion
if [ $? -eq 0 ]; then
    echo "✅ Download complete! Saved to: $DOWNLOAD_DIR"
else
    echo "❌ Download failed."
fi
