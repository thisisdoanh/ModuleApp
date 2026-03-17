# 📜 Script Directory

Helper shell scripts for Flutter monorepo development.

## 📋 Available Scripts

### `get.sh` - Get Dependencies
```bash
./script/get.sh
```
Install Flutter/Dart dependencies for all packages.

**What it does:**
- Runs `flutter pub get` for each package
- Updates `pubspec.lock` files
- Installs all transitive dependencies

**When to use:**
- First time setup
- After modifying `pubspec.yaml`
- After pulling new changes from git

---

### `clean.sh` - Clean All Packages
```bash
./script/clean.sh
```
Remove build artifacts and generated files.

**What it removes:**
- `build/` directories
- `.dart_tool/` directories
- `pubspec.lock` files
- Generated files

**When to use:**
- Troubleshooting build issues
- After major changes
- When starting fresh

**Safety:** Asks for confirmation before deleting.

---

### `build_runner.sh` - Generate Code
```bash
./script/build_runner.sh
```
Run code generation for all packages.

**What it generates:**
- Freezed models (`.freezed.dart`, `.g.dart`)
- AutoRoute routes (`.gr.dart`)
- Injectable DI (`.config.dart`)
- JSON serialization (`.g.dart`)

**When to use:**
- After `./script/get.sh`
- After adding new freezed models
- After adding new routes
- After adding new DI modules

---

### `clean_setup.sh` - Complete Setup
```bash
./script/clean_setup.sh
```
Full setup pipeline in one command:
1. **Clean** - Remove old artifacts
2. **Get** - Install dependencies
3. **Build Runner** - Generate code
4. **Gen Assets** - Generate Flutter assets
5. **Gen L10n** - Generate localizations

**When to use:**
- First time project setup
- After major git changes
- When troubleshooting
- To reset to clean state

**What it outputs:**
```
✓ Clean
✓ Get dependencies
✓ Build runner (code generation)
✓ Generate assets
✓ Generate localizations
```

---

## 🚀 Quick Start

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

---

## 📦 Script Locations

```
script/
├── get.sh              ← Get dependencies
├── clean.sh            ← Clean packages
├── build_runner.sh     ← Run build_runner
├── clean_setup.sh      ← Complete setup (clean → get → build → assets → l10n)
└── README.md           ← This file
```

---

## 🔄 Common Workflows

### Scenario 1: First Time Setup
```bash
./script/clean_setup.sh
./run_app.sh run
```

### Scenario 2: After Pulling New Code
```bash
./script/clean.sh       # Clean old artifacts
./script/get.sh         # Get new dependencies
./script/build_runner.sh # Regenerate code
./run_app.sh run
```

### Scenario 3: After Modifying Models
```bash
./script/build_runner.sh
./run_app.sh run
```

### Scenario 4: Troubleshooting Build
```bash
./script/clean_setup.sh
./run_app.sh analyze
./run_app.sh run
```

---

## 🛠️ Dependencies Between Scripts

```
clean_setup.sh
├── calls clean.sh
├── calls get.sh
├── calls build_runner.sh
└── generates l10n

(Independent scripts)
- clean.sh              (can run alone)
- get.sh               (can run alone)
- build_runner.sh      (requires dependencies already installed)
```

---

## ✅ Verification After Scripts

After running scripts, verify:

```bash
# Check for errors
./run_app.sh analyze

# Run tests
./run_app.sh test

# Run the app
./run_app.sh run
```

---

## 📝 Notes

- All scripts ask for confirmation before destructive operations
- Scripts use color-coded output for easy reading
- Scripts automatically determine correct working directory
- Scripts handle errors gracefully
- Most scripts are idempotent (safe to run multiple times)

---

## 🔗 Related Commands

See also:
- `./run_app.sh` - Main command runner
- `./gen_asset.sh` - Generate assets (deprecated, use scripts/)
- `./get.sh` - Get deps (deprecated, use scripts/get.sh)
- `./clean.sh` - Clean (deprecated, use scripts/clean.sh)

---

**Last Updated:** 2026-03-16
