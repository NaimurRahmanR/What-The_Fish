#!/bin/bash

# What the Fish - Web Build Script
# This script builds the web version of the fish identification app

echo "🐟 Building What the Fish Web App..."
echo "==================================="

# Set Flutter path
export PATH="/app/flutter/bin:$PATH"

# Navigate to project directory
cd /app/what_the_fish

# Enable web
echo "🌐 Enabling Flutter web..."
flutter config --enable-web

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate code (Hive adapters)
echo "⚙️ Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build web
echo "🔨 Building web app..."
flutter build web --release

# Check if build was successful
if [ -d "build/web" ]; then
    echo "✅ Web app built successfully!"
    echo "📍 Location: build/web/"
    
    # Get build size
    WEB_SIZE=$(du -sh build/web | cut -f1)
    echo "📊 Web Build Size: $WEB_SIZE"
    
    echo ""
    echo "📋 Deployment options:"
    echo "1. Local server: python3 -m http.server 8080 (from build/web/)"
    echo "2. Deploy to Vercel: vercel build/web/"
    echo "3. Deploy to Netlify: drag build/web/ folder"
    echo "4. Deploy to Firebase: firebase deploy"
    echo "5. Deploy to GitHub Pages: copy build/web/ contents"
else
    echo "❌ Web build failed!"
    exit 1
fi

echo ""
echo "🎉 Web build completed!"
