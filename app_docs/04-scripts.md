# 📜 04 - Scripts Guide

All shell scripts with configuration and usage.

## 🎯 Scripts Overview

```
script/               ← Organized scripts directory
├── get.sh           ← Get dependencies
├── clean.sh         ← Clean packages
├── build_runner.sh  ← Generate code
└── clean_setup.sh   ← Complete setup

run_app.sh            ← Main command runner (root)
```

## 🔧 Configuration

All scripts have a **CONFIGURATION** section at the top:

```bash
# ═══════════════════════════════════════════════════════════
# 📋 CONFIGURATION - Modify these values
# ═══════════════════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES=("dependency" "dev_dependency" "login" "app_host")
CONFIRM_BEFORE_CLEAN=true  # Example setting
# ═══════════════════════════════════════════════════════════
```

**Modifiable variables:**
- `PACKAGES` - Array of packages to process
- `CONFIRM_BEFORE_CLEAN` - Ask before deleting
- `DELETE_CONFLICTING` - Handle conflicting files
- `APP_HOST_DIR` - Main app directory
- `ENABLE_L10N` - Generate localizations

## 📝 Script Details

### 1. `script/get.sh` - Get Dependencies

```bash
./script/get.sh
```

**Does:**
- Runs `flutter pub get` for each package
- Updates `pubspec.lock` files
- Installs dependencies

**Use when:**
- First time setup
- After modifying pubspec.yaml
- After pulling from git

**Config:**
```bash
PACKAGES=("dependency" "dev_dependency" "login" "app_host")
```

### 2. `script/clean.sh` - Clean Packages

```bash
./script/clean.sh
```

**Removes:**
- `build/` directories
- `.dart_tool/` directories
- `pubspec.lock` files

**Use when:**
- Troubleshooting build issues
- After major changes
- Starting fresh

**Config:**
```bash
PACKAGES=("dependency" "dev_dependency" "login" "app_host")
CONFIRM_BEFORE_CLEAN=true  # Ask before deleting
```

### 3. `script/build_runner.sh` - Generate Code

```bash
./script/build_runner.sh
```

**Generates:**
- Freezed models (`.freezed.dart`, `.g.dart`)
- AutoRoute routes (`.gr.dart`)
- Injectable DI (`.config.dart`)
- JSON serialization (`.g.dart`)

**Use when:**
- After `./script/get.sh`
- After adding freezed models
- After adding new routes
- After adding DI modules

**Config:**
```bash
PACKAGES=("dependency" "dev_dependency" "login" "app_host")
DELETE_CONFLICTING=true  # Delete old generated files
```

### 4. `script/clean_setup.sh` - Complete Setup

```bash
./script/clean_setup.sh
```

**Runs 5 steps:**
1. Clean (remove artifacts)
2. Get (install dependencies)
3. Build Runner (generate code)
4. Assets (flutter_gen)
5. L10n (localizations)

**Use:** First time setup or reset

**Config:**
```bash
PACKAGES=("dependency" "dev_dependency" "login" "app_host")
APP_HOST_DIR="app_host"
ENABLE_L10N=true
```

### 5. `run_app.sh` - Main Command Runner

```bash
./run_app.sh [command]
```

**Available commands:**

```bash
./run_app.sh get        # Get dependencies
./run_app.sh analyze    # Analyze code
./run_app.sh test       # Run tests
./run_app.sh format     # Format code
./run_app.sh clean      # Clean packages
./run_app.sh build      # Run build_runner
./run_app.sh watch      # Watch for changes
./run_app.sh run        # Run app
./run_app.sh run:dev    # Run with dev flavor
./run_app.sh lint       # Strict lint check
./run_app.sh list       # List packages
./run_app.sh help       # Show help
```

**Config:**
```bash
PACKAGES=("app_host" "dependency" "dev_dependency" "login")
APP_HOST_DIR="app_host"
APP_HOST_MAIN="lib/main.dart"
```

## 🚀 Workflow Examples

### First Time Setup
```bash
./script/clean_setup.sh
./run_app.sh run
```

### Daily Development
```bash
# Terminal 1: Watch for changes
./run_app.sh watch

# Terminal 2: Run app
./run_app.sh run

# Terminal 3: Run tests
./run_app.sh test
```

### Before Commit
```bash
./run_app.sh format
./run_app.sh analyze
./run_app.sh test
```

### After Pulling Code
```bash
./script/clean.sh
./script/get.sh
./script/build_runner.sh
./run_app.sh run
```

## 🔧 Customization

### Add New Package

1. Update `PACKAGES` in each script:

```bash
# script/get.sh, script/clean.sh, script/build_runner.sh
PACKAGES=("dependency" "dev_dependency" "login" "app_host" "new_package")
```

2. Update `run_app.sh`:

```bash
PACKAGES=("app_host" "dependency" "dev_dependency" "login" "new_package")
```

### Change Main App

```bash
# run_app.sh and script/clean_setup.sh
APP_HOST_DIR="custom_app"
APP_HOST_MAIN="lib/custom_main.dart"
```

### Disable Confirmations

```bash
# script/clean.sh
CONFIRM_BEFORE_CLEAN=false
```

### Disable L10n

```bash
# script/clean_setup.sh
ENABLE_L10N=false
```

## 📊 Script Dependencies

```
clean_setup.sh
├── calls clean.sh
├── calls get.sh
├── calls build_runner.sh
└── generates l10n

(Independent)
- clean.sh              (standalone)
- get.sh               (standalone)
- build_runner.sh      (requires deps)
- run_app.sh           (multipurpose)
```

## ✅ Verification Checklist

After running scripts:

- [ ] No error messages
- [ ] Generated files exist (lib/gen/, lib/l10n/)
- [ ] `./run_app.sh list` shows packages
- [ ] `./run_app.sh analyze` has no errors
- [ ] `./run_app.sh test` passes
- [ ] `./run_app.sh run` launches app

## 🆘 Troubleshooting Scripts

**Script not found:**
```bash
chmod +x script/*.sh
chmod +x run_app.sh
```

**"Permission denied":**
```bash
chmod +x script/*.sh run_app.sh
```

**Build fails:**
```bash
./script/clean_setup.sh
```

More help → [08-troubleshooting.md](08-troubleshooting.md)

---

Continue reading: [05-architecture.md](05-architecture.md) ⬇️
