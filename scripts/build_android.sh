#!/bin/bash

# What the Fish - Android Build Script
# This script builds the Android APK for the fish identification app

echo "🐟 Building What the Fish Android App..."
echo "========================================"

# Set Flutter path
export PATH="/app/flutter/bin:$PATH"

# Navigate to project directory
cd /app/what_the_fish

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate code (Hive adapters)
echo "⚙️ Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build Android APK
echo "🔨 Building Android APK..."
flutter build apk --release

# Build Android App Bundle (for Play Store)
echo "📱 Building Android App Bundle..."
flutter build appbundle --release

# Check if builds were successful
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ Android APK built successfully!"
    echo "📍 Location: build/app/outputs/flutter-apk/app-release.apk"
    
    # Get file size
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    echo "📊 APK Size: $APK_SIZE"
else
    echo "❌ Android APK build failed!"
    exit 1
fi

if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    echo "✅ Android App Bundle built successfully!"
    echo "📍 Location: build/app/outputs/bundle/release/app-release.aab"
    
    # Get file size
    AAB_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
    echo "📊 AAB Size: $AAB_SIZE"
else
    echo "❌ Android App Bundle build failed!"
fi

echo ""
echo "🎉 Android build completed!"
echo "📱 Install APK on device: adb install build/app/outputs/flutter-apk/app-release.apk"
echo "🏪 Upload AAB to Google Play Store: build/app/outputs/bundle/release/app-release.aab"
