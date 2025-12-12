# Assets Directory

This directory contains all static assets used by the Expense Tracker app.

## Directory Structure

### `/fonts`
Place the required font files here:
- **Poppins Font Family**: 
  - Poppins-Regular.ttf
  - Poppins-Medium.ttf (weight: 500)
  - Poppins-SemiBold.ttf (weight: 600)
  - Poppins-Bold.ttf (weight: 700)
- **Inter Font Family**:
  - Inter-Regular.ttf
  - Inter-Bold.ttf (weight: 700)

**Download Links:**
- Poppins: https://fonts.google.com/specimen/Poppins
- Inter: https://fonts.google.com/specimen/Inter

### `/images`
Store app images and illustrations:
- Logo images
- Onboarding illustrations
- Empty state graphics
- Background images

### `/icons`
Custom icon files (SVG or PNG):
- Category icons
- Badge/achievement icons
- Navigation icons
- Action button icons

### `/animations`
Animation files (Lottie JSON or similar):
- Loading animations
- Success/error animations
- Celebration animations for achievements

## Usage in Code

These assets are referenced in `pubspec.yaml` and can be accessed in code using:

```dart
// Images
Image.asset('assets/images/logo.png')

// Icons (SVG)
SvgPicture.asset('assets/icons/food_icon.svg')

// Fonts are automatically available via Theme
```

## Notes

- Keep file sizes optimized for mobile
- Use SVG for icons when possible
- Compress images before adding
- Follow naming convention: lowercase_with_underscores.ext
