#!/bin/bash

# What the Fish - iOS Build Script
# This script builds the iOS app for the fish identification app

echo "🐟 Building What the Fish iOS App..."
echo "===================================="

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

# Build iOS (requires Xcode)
echo "🔨 Building iOS app..."
if command -v xcodebuild &> /dev/null; then
    flutter build ios --release --no-codesign
    
    # Check if build was successful
    if [ -d "build/ios/Release-iphoneos/Runner.app" ]; then
        echo "✅ iOS app built successfully!"
        echo "📍 Location: build/ios/Release-iphoneos/Runner.app"
        
        # Get build size
        IOS_SIZE=$(du -sh build/ios/Release-iphoneos/Runner.app | cut -f1)
        echo "📊 iOS App Size: $IOS_SIZE"
        
        echo ""
        echo "📋 Next steps for iOS deployment:"
        echo "1. Open ios/Runner.xcworkspace in Xcode"
        echo "2. Select your development team"
        echo "3. Configure code signing"
        echo "4. Build and archive for distribution"
        echo "5. Upload to App Store Connect"
    else
        echo "❌ iOS build failed!"
        exit 1
    fi
else
    echo "⚠️ Xcode not found. iOS build requires Xcode on macOS."
    echo "📋 To build for iOS:"
    echo "1. Run this on macOS with Xcode installed"
    echo "2. Or use: flutter build ios --release --no-codesign"
    echo "3. Then open ios/Runner.xcworkspace in Xcode"
fi

echo ""
echo "🎉 iOS build process completed!"

