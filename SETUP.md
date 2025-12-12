# Setup Guide - Expense Tracker

This guide will help you set up the development environment and get the Expense Tracker app running on your machine.

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from: https://docs.flutter.dev/get-started/install
   - Verify installation: `flutter --version`

2. **Dart SDK** (version 3.0.0 or higher)
   - Comes bundled with Flutter
   - Verify installation: `dart --version`

3. **Git**
   - Download from: https://git-scm.com/downloads
   - Verify installation: `git --version`

4. **Code Editor** (choose one)
   - **VS Code** (Recommended): https://code.visualstudio.com/
     - Install Flutter extension
     - Install Dart extension
   - **Android Studio**: https://developer.android.com/studio
     - Install Flutter plugin
     - Install Dart plugin

### Platform-Specific Requirements

#### For Android Development
- **Android Studio** or **Android SDK Command-line Tools**
- **Java Development Kit (JDK)** 11 or higher
- Android SDK Platform (API level 21 or higher)
- Android Virtual Device (AVD) for emulator

#### For iOS Development (macOS only)
- **Xcode** 12.0 or higher
- **CocoaPods**: `sudo gem install cocoapods`
- iOS Simulator or physical iOS device
- Apple Developer Account (for physical device testing)

## Installation Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd expense_tracker
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

This will download all the packages specified in `pubspec.yaml`.

### 3. Set Up Firebase

#### Option A: Use Existing Configuration (Development)
The project includes a placeholder Firebase configuration. For development, you can use this as-is.

#### Option B: Set Up Your Own Firebase Project (Production)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Add an Android app:
   - Register app with package name: `com.example.expense_tracker`
   - Download `google-services.json`
   - Place it in `android/app/` (once android directory is created)

4. Add an iOS app:
   - Register app with bundle ID: `com.example.expenseTracker`
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/` (once ios directory is created)

5. Enable Authentication:
   - Go to Authentication > Sign-in method
   - Enable Email/Password
   - Enable Google Sign-In

6. Update Firebase Configuration:
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Generate Firebase options
   flutterfire configure
   ```
   This will update `lib/firebase_options.dart` with your project details.

### 4. Add Font Files

Download and place the required font files in the `assets/fonts/` directory:

#### Poppins Font
- Download from: https://fonts.google.com/specimen/Poppins
- Required files:
  - `Poppins-Regular.ttf`
  - `Poppins-Medium.ttf`
  - `Poppins-SemiBold.ttf`
  - `Poppins-Bold.ttf`

#### Inter Font
- Download from: https://fonts.google.com/specimen/Inter
- Required files:
  - `Inter-Regular.ttf`
  - `Inter-Bold.ttf`

### 5. Create Platform Directories (If Missing)

If the `android/` or `ios/` directories don't exist, you can generate them:

```bash
# Create a temporary Flutter project to extract platform files
cd ..
flutter create temp_project
cd temp_project

# Copy platform directories to your project
cp -r android ../expense_tracker/
cp -r ios ../expense_tracker/

# Clean up
cd ..
rm -rf temp_project
cd expense_tracker
```

Alternatively, you can use:
```bash
flutter create --platforms=android,ios .
```

### 6. Generate Code

Generate Hive adapters and other generated files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7. Verify Setup

Check that everything is configured correctly:

```bash
flutter doctor -v
```

Resolve any issues identified by Flutter Doctor.

## Running the App

### On Android Emulator

1. Start Android Emulator from Android Studio or AVD Manager
2. Run the app:
   ```bash
   flutter run
   ```

### On iOS Simulator (macOS only)

1. Open iOS Simulator:
   ```bash
   open -a Simulator
   ```
2. Run the app:
   ```bash
   flutter run
   ```

### On Physical Device

#### Android
1. Enable Developer Options and USB Debugging on your device
2. Connect device via USB
3. Run:
   ```bash
   flutter devices  # Verify device is detected
   flutter run
   ```

#### iOS
1. Connect device via USB
2. Trust the computer on your device
3. Open `ios/Runner.xcworkspace` in Xcode
4. Select your device
5. Run:
   ```bash
   flutter run
   ```

### Hot Reload During Development

While the app is running:
- Press `r` in the terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

## Troubleshooting

### Common Issues

#### 1. "Gradle build failed" (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### 2. "CocoaPods not installed" (iOS)
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

#### 3. "Hive adapter not found"
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4. "Firebase configuration error"
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in the correct locations
- Run `flutterfire configure` to regenerate configuration

#### 5. "Font not found"
- Verify font files are in `assets/fonts/`
- Check that `pubspec.yaml` lists the fonts correctly
- Run `flutter clean` and `flutter pub get`

### Getting Help

If you encounter issues:
1. Check the [Flutter documentation](https://docs.flutter.dev/)
2. Search existing [GitHub issues](https://github.com/yourusername/expense_tracker/issues)
3. Create a new issue with:
   - Flutter doctor output
   - Error messages
   - Steps to reproduce

## Development Workflow

### Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes

3. Run tests:
   ```bash
   flutter test
   ```

4. Check for issues:
   ```bash
   flutter analyze
   ```

5. Format code:
   ```bash
   flutter format .
   ```

6. Commit and push:
   ```bash
   git add .
   git commit -m "feat: your feature description"
   git push origin feature/your-feature-name
   ```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

#### iOS (macOS only)
```bash
flutter build ios --release
```
Then open Xcode and archive for distribution.

## Environment Variables

For sensitive configuration, create a `.env` file (already gitignored):

```env
FIREBASE_API_KEY=your_api_key
GOOGLE_CLIENT_ID=your_client_id
```

## Next Steps

1. Review the [README.md](./README.md) for feature overview
2. Read [CONTRIBUTING.md](./CONTRIBUTING.md) for development guidelines
3. Check [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md) for codebase organization
4. Start developing!

---

**Need help?** Open an issue or reach out to the maintainers.

**Happy coding!** 🚀
