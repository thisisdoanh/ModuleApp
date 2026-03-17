# 📖 01 - Project Overview

Welcome to Flutter Monorepo! This is a complete, production-ready Flutter monorepo setup based on clean architecture principles.

## 🎯 What is This Project?

A **Flutter monorepo** that demonstrates:
- ✅ Monorepo organization
- ✅ Clean Architecture (Data, Presentation, DI layers)
- ✅ BLoC pattern for state management
- ✅ Dependency injection with Injectable
- ✅ Code generation (Freezed, AutoRoute, JSON serialization)
- ✅ Feature-based modular architecture
- ✅ Comprehensive documentation and scripts

## 📦 Project Structure

```
ModuleApp/
├── 📦 Core Packages
│   ├── app_host/          ← Main Flutter app
│   ├── dependency/        ← Production dependencies
│   └── dev_dependency/    ← Dev/test dependencies
├── 🔌 Feature Modules
│   └── login/            ← Sample module (copy pattern)
├── 🔧 Scripts
│   └── script/           ← Helper bash scripts
└── 📖 Documentation
    └── app_docs/         ← You are here
```

## 🏗️ Architecture Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Routing** | AutoRoute | Type-safe navigation |
| **State** | BLoC | State management |
| **DI** | Injectable/GetIt | Dependency injection |
| **Models** | Freezed | Immutable data classes |
| **Networking** | Dio | HTTP client |
| **Storage** | SharedPreferences, Hive | Local data |
| **UI** | Flutter | UI framework |

## 🎓 Documentation Flow

This documentation is numbered for easy progression:

1. **01-overview.md** (You are here) - Overview
2. **02-setup.md** - Initial setup & first run
3. **03-project-structure.md** - Detailed structure
4. **04-scripts.md** - Scripts configuration
5. **05-architecture.md** - Architecture patterns
6. **06-modules.md** - Creating new modules
7. **07-testing.md** - Testing strategy
8. **08-troubleshooting.md** - Problem solving

## 🚀 Quick Start

```bash
# Setup (5 minutes)
./script/clean_setup.sh

# Run app
./run_app.sh run

# Explore code
# → See 03-project-structure.md for file organization
```

## 🎯 Key Features

### ✨ **Well-Organized**
- Clear folder structure
- Named scripts for common tasks
- Numbered documentation

### 🔧 **Production-Ready**
- Error handling
- Logging capabilities
- Testing infrastructure

### 📚 **Well-Documented**
- Step-by-step guides
- Configuration examples
- Troubleshooting tips

### 🚀 **Scalable**
- Easy to add modules
- Consistent patterns
- DRY principles

## 📋 What's Included

### Core Packages
- **app_host/** - Main Flutter app (entry point)
- **dependency/** - All production packages (re-exported)
- **dev_dependency/** - All test packages (re-exported)

### Sample Module
- **login/** - Complete example module with:
  - Data layer (models, datasource, repository)
  - Presentation layer (BLoC, pages, widgets)
  - DI setup
  - Routes
  - Tests

### Helper Scripts
- **script/get.sh** - Get dependencies
- **script/clean.sh** - Clean packages
- **script/build_runner.sh** - Generate code
- **script/clean_setup.sh** - Complete setup
- **run_app.sh** - Run common commands

## 🎓 Architecture Overview

### Clean Architecture (3-Layer)
```
┌─────────────────────────────────┐
│     Presentation Layer          │
│  (BLoC, Pages, Widgets)         │
└─────────────────────────────────┘
         ↑          ↓
┌─────────────────────────────────┐
│      Domain Layer (optional)    │
│     (Use cases, Entities)       │
└─────────────────────────────────┘
         ↑          ↓
┌─────────────────────────────────┐
│       Data Layer                │
│ (Models, Datasource, Repository)│
└─────────────────────────────────┘
         ↑          ↓
┌─────────────────────────────────┐
│   External APIs & Databases     │
└─────────────────────────────────┘
```

### Dependency Flow
```
app_host (main app)
  ├── Depends on: login module
  ├── Depends on: dependency package
  └── Depends on: dev_dependency package

login module
  ├── Depends on: dependency package
  └── Dev depends on: dev_dependency package

dependency package
  └── Re-exports all pub.dev packages

dev_dependency package
  └── Re-exports all test packages
```

## 🔄 Development Workflow

### Daily Workflow
```
Terminal 1: Watch for code changes
./run_app.sh watch

Terminal 2: Run the app
./run_app.sh run

Terminal 3: Run tests
./run_app.sh test
```

### Before Commit
```bash
./run_app.sh format   # Format code
./run_app.sh analyze  # Check errors
./run_app.sh test     # Run tests
```

## 📚 Next Steps

1. **Read 02-setup.md** - Set up the project
2. **Read 03-project-structure.md** - Understand folder structure
3. **Read 04-scripts.md** - Learn about scripts
4. **Read 05-architecture.md** - Deep dive into patterns
5. **Read 06-modules.md** - Create your own module

## 🆘 Getting Help

**Lost?** → Read **08-troubleshooting.md**

**Want to add a module?** → Read **06-modules.md**

**Understanding patterns?** → Read **05-architecture.md**

**Scripts not working?** → Read **04-scripts.md** and **08-troubleshooting.md**

---

## 📞 Quick Links

- **Setup Guide** → [02-setup.md](02-setup.md)
- **Project Structure** → [03-project-structure.md](03-project-structure.md)
- **Scripts Guide** → [04-scripts.md](04-scripts.md)
- **Architecture** → [05-architecture.md](05-architecture.md)
- **Create Modules** → [06-modules.md](06-modules.md)
- **Testing** → [07-testing.md](07-testing.md)
- **Troubleshooting** → [08-troubleshooting.md](08-troubleshooting.md)

---

**Ready?** Let's get started! → [02-setup.md](02-setup.md) ⬇️
