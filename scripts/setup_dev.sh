#!/bin/bash

# What the Fish - Development Setup Script
# This script sets up the development environment

echo "🐟 What the Fish - Development Setup"
echo "===================================="

# Set Flutter path
export PATH="/app/flutter/bin:$PATH"

# Navigate to project directory
cd /app/what_the_fish

echo "🔧 Setting up development environment..."

# Check Flutter installation
echo "✅ Checking Flutter installation..."
flutter --version

# Check connected devices
echo "📱 Checking connected devices..."
flutter devices

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Generate code
echo "⚙️ Generating code (Hive adapters)..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run Flutter doctor
echo "🩺 Running Flutter doctor..."
flutter doctor

echo ""
echo "🎉 Development setup completed!"
echo ""
echo "🚀 Available commands:"
echo "  flutter run                    # Run in debug mode"
echo "  flutter run --release          # Run in release mode"
echo "  flutter run -d chrome          # Run in web browser"
echo "  ./scripts/build_android.sh     # Build Android APK"
echo "  ./scripts/build_ios.sh         # Build iOS app"
echo ""
echo "📱 Connect a device or start an emulator, then run:"
echo "  flutter run"
