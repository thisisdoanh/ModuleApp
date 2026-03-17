# 🗂️ 03 - Project Structure

Complete project folder organization and file purposes.

## 📁 Root Directory Structure

```
ModuleApp/
│
├── 📦 Core Packages
│   ├── app_host/              ← Main Flutter application
│   ├── dependency/            ← Production dependencies (re-export)
│   └── dev_dependency/        ← Dev/test dependencies (re-export)
│
├── 🔌 Feature Modules
│   └── login/                 ← Sample feature module
│
├── 🔧 Scripts & Config
│   ├── script/                ← Helper bash scripts
│   ├── run_app.sh             ← Main command runner
│   └── pubspec.yaml           ← Root workspace config
│
├── 📖 Documentation
│   ├── app_docs/              ← Complete docs (numbered)
│   ├── SETUP.md               ← Setup guide
│   ├── QUICK_START.md         ← Quick reference
│   ├── MONOREPO_GUIDE.md      ← Architecture guide
│   └── SCRIPTS_CONFIG.md      ← Scripts configuration
│
└── 🔐 Configuration
    ├── .gitignore             ← Git ignore rules
    ├── analysis_options.yaml  ← Linting rules
    └── .env.example           ← Environment variables
```

## 🏢 Core Packages Explained

### app_host/ (Main App)

```
app_host/
├── lib/
│   ├── main.dart              ← App entry point
│   ├── app.dart               ← MaterialApp setup
│   ├── di/                    ← Dependency injection
│   │   └── injection.dart     ← GetIt setup
│   ├── router/                ← Navigation routes
│   │   └── app_router.dart    ← AutoRouter config
│   ├── l10n/                  ← Localizations (generated)
│   │   ├── app_localizations.dart
│   │   ├── app_localizations_en.dart
│   │   ├── app_localizations_vi.dart
│   │   └── arb/               ← Translation files (source)
│   │       ├── app_en.arb
│   │       └── app_vi.arb
│   └── gen/                   ← Flutter Gen assets (generated)
│       └── assets.dart        ← Type-safe asset access
│
├── pubspec.yaml               ← Dependencies & config
├── analysis_options.yaml      ← Lint rules
└── ios/ / android/            ← Platform-specific code
```

**Purpose:** Entry point of the application

**Key Files:**
- `main.dart` - Initializes app and GetIt
- `app.dart` - Material app with theme and routing
- `di/injection.dart` - DI container setup
- `router/app_router.dart` - Route definitions

### dependency/ (Production Packages)

```
dependency/
├── lib/
│   └── dependency.dart        ← Re-exports all packages
├── pubspec.yaml               ← All production packages
└── analysis_options.yaml
```

**Purpose:** Centralized production dependency management

**Key Files:**
- `dependency.dart` - Re-exports Dio, BLoC, GetIt, Freezed, etc.

**Example usage in modules:**
```dart
// ✅ DO THIS
import 'package:dependency/dependency.dart';

// ❌ DON'T DO THIS
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
```

### dev_dependency/ (Test Packages)

```
dev_dependency/
├── lib/
│   └── dev_dependency.dart    ← Re-exports test packages
└── pubspec.yaml               ← Test packages (bloc_test, mocktail, etc)
```

**Purpose:** Centralized test dependency management

## 🔌 Feature Module Structure (login/)

### Complete Module Layout

```
login/
│
├── lib/
│   ├── login.dart             ← Public API (exports)
│   │
│   └── src/                   ← Private implementation
│       │
│       ├── data/              ← Data layer
│       │   ├── model/
│       │   │   ├── login_request.dart          (freezed)
│       │   │   └── login_response.dart         (freezed)
│       │   ├── datasource/
│       │   │   └── login_remote_datasource.dart
│       │   └── repository/
│       │       ├── auth_repository.dart        (abstract)
│       │       └── auth_repository_impl.dart   (implementation)
│       │
│       ├── di/                ← Dependency injection
│       │   └── login_module.dart               (@injectable)
│       │
│       ├── presentation/      ← UI layer
│       │   ├── bloc/
│       │   │   ├── login_bloc.dart
│       │   │   ├── login_event.dart            (freezed)
│       │   │   └── login_state.dart            (freezed)
│       │   └── page/
│       │       ├── login_page.dart             (@RoutePage)
│       │       └── widget/
│       │           └── login_form_widget.dart
│       │
│       └── router/
│           └── login_router.dart               (AutoRoute)
│
├── test/
│   └── presentation/bloc/
│       └── login_bloc_test.dart                (BLoC tests)
│
├── pubspec.yaml               ← Module config
└── analysis_options.yaml      ← Lint rules
```

### Layer Responsibilities

| Layer | Files | Purpose |
|-------|-------|---------|
| **Data** | model/, datasource/, repository/ | API calls, local storage, models |
| **Presentation** | bloc/, page/, widget/ | UI, state management, events |
| **DI** | di/ | Dependency injection setup |
| **Router** | router/ | Navigation routes |
| **Test** | test/ | Unit and widget tests |

## 🔧 Scripts Directory

```
script/
├── README.md              ← Scripts documentation
├── get.sh                 ← Get dependencies
├── clean.sh               ← Clean packages
├── build_runner.sh        ← Generate code
└── clean_setup.sh         ← Complete setup (all-in-one)
```

## 📚 Configuration Files

### pubspec.yaml (Root)

```yaml
name: module_app
environment:
  sdk: ^3.11.0
```

Root workspace configuration.

### analysis_options.yaml

Dart/Flutter linting rules (consistent across packages).

## 🎯 Key File Locations

### Main App
- Entry point: `app_host/lib/main.dart`
- Routes: `app_host/lib/router/app_router.dart`
- DI setup: `app_host/lib/di/injection.dart`
- Localizations: `app_host/lib/l10n/arb/`

### Dependencies
- Production: `dependency/lib/dependency.dart`
- Dev/Test: `dev_dependency/lib/dev_dependency.dart`

### Sample Module
- Public API: `login/lib/login.dart`
- Models: `login/lib/src/data/model/`
- BLoC: `login/lib/src/presentation/bloc/`
- UI Pages: `login/lib/src/presentation/page/`

## 🔄 Dependency Flow

```
app_host/
  ├── imports: dependency/
  ├── imports: dev_dependency/ (dev only)
  └── imports: login/

login/
  ├── imports: dependency/
  └── dev imports: dev_dependency/

dependency/
  ├── imports: 40+ pub.dev packages
  └── re-exports them all

dev_dependency/
  ├── imports: test packages (bloc_test, mocktail)
  └── re-exports them
```

## 📋 Generated Files

After running `./script/clean_setup.sh`, these are generated:

```
app_host/lib/
├── gen/                           ← flutter_gen assets
│   └── assets.dart
├── l10n/                          ← localizations
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   └── app_localizations_vi.dart

login/lib/src/
├── data/model/
│   ├── login_request.freezed.dart
│   ├── login_request.g.dart
│   ├── login_response.freezed.dart
│   └── login_response.g.dart
├── di/
│   └── login_module.config.dart   ← injectable config
├── presentation/bloc/
│   ├── login_event.freezed.dart
│   └── login_state.freezed.dart
└── router/
    └── login_router.gr.dart       ← AutoRoute generated

Root:
└── app_host/lib/router/
    └── app_router.gr.dart        ← AutoRoute generated
```

> ⚠️ Don't edit generated files! They're regenerated on build.

## 🚫 Ignored Files

Files ignored by git (see .gitignore):

```
build/                    ← Build artifacts
.dart_tool/              ← Dart cache
pubspec.lock             ← Dependency lock
.env                     ← Local environment
.idea/                   ← IDE settings
.vscode/                 ← VS Code settings
```

## 📊 File Count Summary

```
Total Packages:    4 (app_host, dependency, dev_dependency, login)
Total .dart files: ~30 (excluding generated)
Total Docs:        8 numbered docs
Total Scripts:     5 (3 utility + 1 main + 1 complete setup)
```

## 🔗 Navigation Guide

- **Setup?** → [02-setup.md](02-setup.md)
- **Scripts?** → [04-scripts.md](04-scripts.md)
- **Architecture?** → [05-architecture.md](05-architecture.md)
- **New module?** → [06-modules.md](06-modules.md)
- **Issues?** → [08-troubleshooting.md](08-troubleshooting.md)

---

Continue reading: [04-scripts.md](04-scripts.md) ⬇️
