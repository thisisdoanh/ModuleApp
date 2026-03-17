# 🚀 02 - Setup Guide

Complete setup instructions to get the project running in 5 minutes.

## ✅ Prerequisites

Before starting, ensure you have:

- **Flutter** 3.11.0+ ([Install](https://flutter.dev/docs/get-started/install))
- **Dart** 3.11.0+ (comes with Flutter)
- **Git** (for version control)
- **Android SDK** (for Android development)
- **Xcode** (for iOS development - macOS only)

## 📋 Step-by-Step Setup

### Step 1: Clone or Download Project
```bash
cd /path/to/ModuleApp
ls -la
# You should see: app_host/, dependency/, dev_dependency/, login/, script/
```

### Step 2: Run Complete Setup
```bash
./script/clean_setup.sh
```

This single command runs:
1. ✅ **Clean** - Remove old artifacts
2. ✅ **Get** - Install all dependencies
3. ✅ **Build Runner** - Generate code (models, routes, DI)
4. ✅ **Assets** - Generate Flutter assets
5. ✅ **L10n** - Generate localizations

**Output should show:**
```
✓ Clean
✓ Get dependencies
✓ Build runner (code generation)
✓ Generate assets
✓ Generate localizations
```

### Step 3: Verify Setup
```bash
./run_app.sh analyze
```

Should show no errors. If there are errors, see [08-troubleshooting.md](08-troubleshooting.md).

### Step 4: Run the App
```bash
./run_app.sh run
```

Select device and app should launch!

## 🎯 Verify Installation

✅ All of these should work:

```bash
# Show available packages
./run_app.sh list

# Output should show:
# ▶ Packages in monorepo:
#   • app_host (1.0.0+1)
#   • dependency (0.0.1)
#   • dev_dependency (0.0.1)
#   • login (1.0.0)
```

```bash
# Analyze code
./run_app.sh analyze

# Should complete with no errors
```

```bash
# Run tests
./run_app.sh test

# Should run tests in login module
```

## 🔄 Daily Setup

After the first setup, you only need:

```bash
# Get latest dependencies
./script/get.sh

# Run the app
./run_app.sh run
```

## 🔧 If Something Goes Wrong

### Clean Everything and Restart
```bash
./script/clean_setup.sh
```

### Check Specific Package
```bash
cd app_host
flutter pub get
flutter analyze
cd ..
```

### View All Script Options
```bash
./run_app.sh help
```

## 📱 Device Selection

When running `./run_app.sh run`, you'll be prompted:

```
Connected devices:
1 • iPhone 15 Pro Simulator (mobile) • com.apple.CoreSimulator.CoreSimulator.iPhone15ProSimulator • ios
2 • Android Emulator (mobile) • emulator-5554 • android • Android 14 (API 34)

Please choose one (or 'q' to quit):
```

Enter `1` or `2` to select device.

## 💾 Project Structure After Setup

After successful setup, you should have:

```
ModuleApp/
├── build/                ← Generated (can delete)
├── .dart_tool/           ← Generated (can delete)
├── app_host/
│   ├── build/            ← Generated
│   ├── lib/
│   │   ├── gen/          ← Generated Flutter Gen assets
│   │   └── l10n/         ← Generated localizations
│   └── pubspec.lock      ← Generated
├── dependency/
│   ├── build/            ← Generated
│   └── pubspec.lock      ← Generated
├── dev_dependency/
│   ├── build/            ← Generated
│   └── pubspec.lock      ← Generated
└── login/
    ├── build/            ← Generated
    └── pubspec.lock      ← Generated
```

> Generated files can be safely deleted and regenerated with `./script/clean_setup.sh`

## 🌍 Platform-Specific Setup

### macOS/iOS
```bash
# Install pods
cd app_host/ios
pod install
cd ../..

# Run on iOS Simulator
./run_app.sh run
# or
cd app_host
flutter run -d <iOS-Device-ID>
```

### Windows/Android
```bash
# Make sure Android Emulator is running
emulator -avd Pixel_5_API_34

# Run on Android Emulator
./run_app.sh run
# or
cd app_host
flutter run -d <Android-Device-ID>
```

### Linux
```bash
# Run on Linux Desktop (if configured)
./run_app.sh run
```

## 📊 Versions Check

Verify you have correct versions:

```bash
flutter --version
# Flutter 3.11.0+
# Dart 3.11.0+

dart --version
# Dart SDK version: 3.11.0+

git --version
# git version 2.x+
```

## ⚡ Quick Commands Reference

```bash
# Complete setup
./script/clean_setup.sh

# Just get dependencies
./script/get.sh

# Just clean
./script/clean.sh

# Just run code generation
./script/build_runner.sh

# Run the app
./run_app.sh run

# Analyze code
./run_app.sh analyze

# Format code
./run_app.sh format

# Run tests
./run_app.sh test

# List packages
./run_app.sh list

# Show help
./run_app.sh help
```

## ✨ What's Next?

After successful setup:

1. **Read [03-project-structure.md](03-project-structure.md)** - Understand the folder layout
2. **Read [04-scripts.md](04-scripts.md)** - Learn about scripts
3. **Read [05-architecture.md](05-architecture.md)** - Understand architecture
4. **Read [06-modules.md](06-modules.md)** - Create your own module

## 🆘 Troubleshooting

### Build fails?
```bash
./script/clean_setup.sh
./run_app.sh run
```

### "flutter command not found"?
Add Flutter to your PATH:
```bash
export PATH="$PATH:$(flutter bin)"
```

### Port already in use?
```bash
./run_app.sh run -v  # Verbose mode to see details
```

More help → [08-troubleshooting.md](08-troubleshooting.md)

---

**Setup complete!** 🎉

Continue reading: [03-project-structure.md](03-project-structure.md) ⬇️
