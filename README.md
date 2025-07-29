# what_the_fish

A new Flutter project.

## Getting Started

# What the Fish - Flutter Mobile App

![Flutter](https://img.shields.io/badge/Flutter-3.32.8-blue)
![Dart](https://img.shields.io/badge/Dart-3.8.1-blue)
![Android](https://img.shields.io/badge/Android-API%2023+-green)
![iOS](https://img.shields.io/badge/iOS-12+-green)

An AI-powered mobile application built with Flutter for identifying fish and aquatic animals using Google Gemini AI.

## 🐟 Features

### Core Functionality
- **AI Fish Identification**: Real-time fish identification using Google Gemini AI
- **Camera Integration**: In-app camera with autofocus for optimal aquatic photography
- **Gallery Upload**: Support for JPG, PNG, HEIC image formats
- **Offline Storage**: Local storage using Hive for identification history
- **Cross-Platform**: Native Android and iOS support

### User Experience
- **Animated Splash Screen**: Underwater-themed splash with Lottie animations
- **Ocean Theme**: Beautiful blue/teal color palette with gradient backgrounds
- **Bottom Navigation**: Intuitive tab-based navigation
- **Dark Mode Support**: Automatic system theme adaptation
- **Responsive Design**: Optimized for different screen sizes

### App Sections
1. **Camera Tab**: Capture or upload fish photos
2. **History Tab**: View past identifications with filtering options
3. **Explore Tab**: Marine life facts and photography tips
4. **Profile Tab**: User statistics and app settings

## 🛠 Technical Architecture

### Framework & Language
- **Flutter 3.32.8**: Cross-platform mobile development
- **Dart 3.8.1**: Programming language
- **Material Design 3**: Modern UI components

### State Management
- **Provider**: Reactive state management
- **Hive**: NoSQL local database for offline storage

### AI Integration
- **Google Gemini AI**: Fish identification and species information
- **Camera Plugin**: Native camera access
- **Image Processing**: Optimized image handling for AI analysis

### Key Dependencies
```yaml
dependencies:
  camera: ^0.11.0+2          # Camera functionality
  image_picker: ^1.1.2       # Gallery access
  hive: ^2.2.3               # Local storage
  lottie: ^3.2.0             # Animations
  provider: ^6.1.2           # State management
  google_generative_ai: ^0.4.6  # Gemini AI integration
  share_plus: ^10.1.2        # Social sharing
  permission_handler: ^11.3.1   # Device permissions
```

## 📱 App Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── fish_identification.dart # Data models
│   └── fish_identification.g.dart # Hive adapters
├── providers/
│   └── fish_provider.dart       # State management
├── screens/
│   ├── splash_screen.dart       # Animated splash
│   ├── main_navigation.dart     # Bottom navigation
│   ├── camera_screen.dart       # Camera interface
│   ├── history_screen.dart      # History with filters
│   ├── result_screen.dart       # Identification results
│   ├── explore_screen.dart      # Marine life facts
│   └── profile_screen.dart      # User profile
├── services/
│   └── gemini_service.dart      # AI integration
├── utils/
│   └── theme.dart               # App theming
└── widgets/                     # Reusable components
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.32.8+
- Dart SDK 3.8.1+
- Android Studio / VS Code
- Android SDK (API 23+) for Android builds
- Xcode (for iOS builds)


### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd what_the_fish
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code (Hive adapters)**
```bash
flutter packages pub run build_runner build
```

4. **Run the app**
```bash
flutter run
```

### Configuration

1. **Gemini AI API Key**: The app uses Google Gemini AI for fish identification. The API key is already configured.

2. **Permissions**: The app automatically requests camera and storage permissions on first use.

## 🐠 How It Works

### Fish Identification Process
1. **Image Capture**: User takes photo or selects from gallery
2. **AI Analysis**: Image sent to Google Gemini AI for identification
3. **Species Recognition**: AI returns species name, scientific name, and confidence score
4. **Result Display**: Show identification with detailed information
5. **Storage**: Save result to local Hive database for offline access

### Data Model
```dart
class FishIdentification {
  String id;                    // Unique identifier
  String speciesName;           // Common name
  String scientificName;        // Scientific name
  double confidence;            // AI confidence (0-1)
  String imagePath;             // Local image path
  DateTime identifiedAt;        // Timestamp
  String? habitat;              // Habitat information
  String? size;                 // Size information
  String? facts;                // Interesting facts
  List<AlternativeFish> alternatives;  // Alternative suggestions
}
```

## 📊 Features in Detail

### Camera Screen
- **Real-time camera preview** with optimized settings for aquatic photography
- **Flash control** for low-light conditions
- **Gallery picker** with image validation
- **Loading states** with beautiful UI feedback

### History Screen
- **Sortable list** by date, confidence, or name
- **Filter options** by confidence threshold
- **Swipe actions** for quick delete
- **Offline access** to all saved identifications

### Result Screen
- **High-quality image display** with proper scaling
- **Confidence indicators** with color coding
- **Detailed species information** including habitat and facts
- **Social sharing** capabilities
- **Alternative suggestions** for ambiguous identifications

### Explore Screen
- **Marine life categories** with visual icons
- **Fish facts** and educational content
- **Photography tips** for better identification results
- **Interactive cards** with engaging content

## 🎨 Design System

### Color Palette
```dart
// Ocean-inspired colors
static const Color primaryBlue = Color(0xFF006994);
static const Color lightBlue = Color(0xFF4FC3F7);
static const Color darkBlue = Color(0xFF003B57);
static const Color teal = Color(0xFF26A69A);
static const Color aqua = Color(0xFF00BCD4);
```

### Typography
- **Primary Font**: Poppins (clean, modern sans-serif)
- **Weight Variants**: Regular (400), Medium (500), Bold (700)
- **Responsive Sizing**: Scales based on device size

### UI Components
- **Ocean gradients** for immersive underwater feel
- **Rounded corners** (15-20px radius) for modern look
- **Subtle shadows** for depth and hierarchy
- **Consistent spacing** using 8dp grid system

## 🧪 Testing

The app includes comprehensive error handling and graceful fallbacks:

- **Network failures**: Shows helpful error messages
- **Camera issues**: Provides alternative gallery access
- **AI failures**: Returns fallback identification with low confidence
- **Permission denials**: Guides users to enable required permissions

## 📈 Performance Optimizations

- **Image compression** before AI analysis
- **Lazy loading** for history items
- **Efficient state management** with Provider
- **Local caching** with Hive database
- **Memory management** for camera resources

## 🔐 Privacy & Security

- **Local storage**: All data stored locally on device
- **No user accounts**: No personal data collection
- **Image privacy**: Images processed securely via Google Gemini
- **Minimal permissions**: Only requests necessary camera/storage access

## 🚀 Future Enhancements

- **Offline AI models** using TensorFlow Lite
- **GPS location tracking** for identification context
- **Social features** for sharing discoveries
- **Advanced filters** by habitat, region, etc.
- **Bulk identification** for multiple images
- **Export functionality** for research purposes

## 📄 License

This project is built for educational and demonstration purposes. The Google Gemini AI integration requires proper API usage according to Google's terms of service.

## 🤝 Contributing

This is a demonstration project showcasing Flutter development with AI integration. The code serves as a reference for building similar applications.

---

**Built with ❤️ using Flutter and Google Gemini AI**




