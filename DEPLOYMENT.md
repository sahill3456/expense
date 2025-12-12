# Deployment Guide

This guide covers deploying the Expense Tracker app to production environments.

## Pre-Deployment Checklist

Before deploying to production, ensure you have:

- [ ] Completed all features and testing
- [ ] Updated version number in `pubspec.yaml`
- [ ] Updated `CHANGELOG.md` with release notes
- [ ] Configured production Firebase project
- [ ] Added all required font files to `assets/fonts/`
- [ ] Added app icons for all platforms
- [ ] Configured app signing (Android) or certificates (iOS)
- [ ] Tested on physical devices (both Android and iOS)
- [ ] Run `flutter analyze` with no errors
- [ ] Run all tests: `flutter test`
- [ ] Optimized images and assets
- [ ] Reviewed and updated privacy policy
- [ ] Prepared app store listings (screenshots, descriptions)

## Version Management

Update version in `pubspec.yaml`:

```yaml
version: 1.0.0+1
# Format: MAJOR.MINOR.PATCH+BUILD_NUMBER
```

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes
- **BUILD_NUMBER**: Incremental build number

## Android Deployment

### 1. Generate App Signing Key

Create a keystore for signing your app:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### 2. Configure Key Properties

Create `android/key.properties`:

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-upload-keystore.jks>
```

**Important**: Add `android/key.properties` to `.gitignore`!

### 3. Configure Signing in Gradle

Update `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... other config

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### 4. Build Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### 5. Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 6. Upload to Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Create a new app
3. Fill in app details, content rating, pricing
4. Upload the `.aab` file to Production/Beta/Alpha track
5. Complete store listing (screenshots, descriptions)
6. Submit for review

### App Bundle Advantages
- Smaller download size (Google generates optimized APKs)
- Required for new apps on Play Store
- Supports dynamic feature modules

## iOS Deployment

### 1. Configure App in Xcode

Open `ios/Runner.xcworkspace` in Xcode (not `.xcodeproj`):

1. Select Runner in Project Navigator
2. Update **Bundle Identifier** (e.g., `com.yourcompany.expensetracker`)
3. Select **Team** (your Apple Developer account)
4. Update **Display Name**
5. Set **Deployment Target** (minimum iOS version)

### 2. Update Info.plist

Add required permissions and configurations in `ios/Runner/Info.plist`:

```xml
<key>CFBundleDisplayName</key>
<string>Expense Tracker</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library to upload receipts.</string>
<!-- Add other permissions as needed -->
```

### 3. Configure App Icons

Add app icons to `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Use a tool like [App Icon Generator](https://appicon.co/) to generate all required sizes.

### 4. Build for Release

```bash
flutter build ios --release
```

### 5. Create Archive in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Any iOS Device (arm64)" as build target
3. Product > Archive
4. Wait for archive to complete
5. Window > Organizer > Archives
6. Select your archive
7. Click "Distribute App"
8. Choose "App Store Connect"
9. Follow the wizard to upload

### 6. Submit to App Store

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Create a new app
3. Fill in app information
4. Add screenshots (6.5", 5.5" displays)
5. Add app description, keywords, support URL
6. Select the uploaded build
7. Submit for review

### iOS Submission Requirements
- Privacy Policy URL
- App screenshots for required device sizes
- App description (max 4000 characters)
- Keywords (max 100 characters)
- Support URL and contact information
- Age rating questionnaire

## Firebase Production Setup

### 1. Create Production Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project for production
3. Add Android and iOS apps
4. Download configuration files

### 2. Configure Firebase for Production

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure for production
flutterfire configure --project=your-production-project-id
```

### 3. Update Environment Configuration

Consider using flavor-based configuration for dev/staging/production:

- Development: Use test Firebase project
- Staging: Use staging Firebase project
- Production: Use production Firebase project

### 4. Enable Firebase Services

In Firebase Console, enable:
- **Authentication**: Email/Password, Google Sign-In
- **Cloud Firestore**: Set up security rules (if using)
- **Analytics**: For user tracking
- **Crashlytics**: For crash reporting

## Continuous Integration/Deployment (CI/CD)

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter test
      - run: flutter build appbundle --release
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.SERVICE_ACCOUNT_JSON }}
          packageName: com.example.expense_tracker
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production

  deploy-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter test
      - run: flutter build ios --release --no-codesign
      # Add Fastlane or similar for iOS deployment
```

## Testing Before Release

### 1. Internal Testing

**Android**: Use Internal Testing track in Play Console
**iOS**: Use TestFlight

Invite team members and early testers.

### 2. Beta Testing

**Android**: Open Beta or Closed Beta in Play Console
**iOS**: External Testing in TestFlight

Collect feedback and fix issues.

### 3. Production Release

Gradually roll out to users:
- Start with 10% of users
- Monitor crashes and ratings
- Increase to 25%, 50%, 100%

## Monitoring and Analytics

### 1. Firebase Analytics

Track user behavior and app performance:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics.instance.logEvent(
  name: 'expense_added',
  parameters: {'category': 'food', 'amount': 25.50},
);
```

### 2. Crashlytics

Monitor crashes:

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// In main.dart
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
```

### 3. Performance Monitoring

Track app performance:

```dart
import 'package:firebase_performance/firebase_performance.dart';

final trace = FirebasePerformance.instance.newTrace('load_expenses');
await trace.start();
// ... load expenses
await trace.stop();
```

## Post-Release

### 1. Monitor Metrics

- Crash-free rate
- User ratings and reviews
- Active users (DAU, MAU)
- Retention rate
- Session duration

### 2. Respond to Reviews

- Monitor app store reviews
- Respond to user feedback
- Address critical issues quickly

### 3. Plan Updates

- Schedule regular updates (bug fixes, features)
- Keep dependencies up to date
- Follow platform guidelines and policies

## Rollback Strategy

If critical issues are found:

### Android
1. Halt rollout in Play Console
2. Upload fixed version
3. Resume rollout

### iOS
1. Remove app from sale (if critical)
2. Upload fixed version
3. Request expedited review if needed

## Security Considerations

- [ ] Use ProGuard/R8 for code obfuscation (Android)
- [ ] Enable bitcode (iOS)
- [ ] Store secrets securely (use Firebase Remote Config or similar)
- [ ] Implement certificate pinning for API calls
- [ ] Use HTTPS for all network requests
- [ ] Validate all user inputs
- [ ] Keep dependencies updated
- [ ] Follow OWASP Mobile Security guidelines

## Compliance

- [ ] **GDPR**: Data protection for EU users
- [ ] **CCPA**: Privacy rights for California users
- [ ] **COPPA**: Child safety (if applicable)
- [ ] **Privacy Policy**: Required for app stores
- [ ] **Terms of Service**: User agreement

## Resources

- [Flutter Deployment Docs](https://docs.flutter.dev/deployment)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Firebase Console](https://console.firebase.google.com/)
- [Fastlane for iOS](https://fastlane.tools/)

---

**Good luck with your deployment!** 🚀

For questions, contact: support@expensetracker.com
