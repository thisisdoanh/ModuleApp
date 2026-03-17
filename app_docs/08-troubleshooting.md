# 🆘 08 - Troubleshooting Guide

Solutions for common issues in the monorepo.

## 🚨 Most Common Issues

### 1. Build fails with "Target of URI doesn't exist"

**Error:**
```
Target of URI doesn't exist: 'injection.config.dart'
Target of URI doesn't exist: 'app_router.gr.dart'
Target of URI doesn't exist: 'login_router.gr.dart'
```

**Cause:** Generated files haven't been created yet.

**Fix:**
```bash
./script/clean_setup.sh
# OR
./script/build_runner.sh
```

---

### 2. "flutter pub get" fails with dependency conflicts

**Error:**
```
Because X depends on Y >=2.0.0 and Z depends on Y <2.0.0, version solving failed.
```

**Fix:**
```bash
# Clean and reinstall
./script/clean.sh
./script/get.sh

# Or check specific package
cd login
flutter pub deps
flutter pub upgrade
```

---

### 3. Injectable: GetIt not finding registered type

**Error:**
```
StateError: GetIt: Object/factory with type LoginBloc is not registered
```

**Causes & Fixes:**

**a) Missing @injectable annotation:**
```dart
// ✅ Add @injectable or module registration
@module
abstract class LoginModule {
  @factory
  LoginBloc loginBloc(AuthRepository repository) => LoginBloc(repository);
}
```

**b) build_runner not run:**
```bash
./script/build_runner.sh
```

**c) configureDependencies() not called:**
```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(); // ← Must be called!
  runApp(App(appRouter: appRouter));
}
```

---

### 4. AutoRoute: Route not found

**Error:**
```
RouteNotFoundException: No route found for name '/home'
```

**Fix:** Add route to `app_router.dart`:
```dart
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
    AutoRoute(page: HomeRoute.page, path: '/home'),  // ← Add missing route
  ];
}
```

Then regenerate:
```bash
cd app_host
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### 5. Freezed: "Part not found" error

**Error:**
```
A part file 'login_state.freezed.dart' must exist
```

**Fix:**
```bash
cd login
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### 6. BLoC not receiving events

**Error:** Events added to BLoC have no effect.

**Causes & Fixes:**

**a) BLoC not in context:**
```dart
// ✅ Wrap page with BlocProvider
BlocProvider(
  create: (context) => GetIt.I<LoginBloc>(),
  child: LoginPage(),
)
```

**b) Wrong BLoC type in BlocBuilder:**
```dart
// ✅ Check generic types match
BlocBuilder<LoginBloc, LoginState>(  // ← Must match
  builder: (context, state) { ... }
)
```

**c) BLoC already closed:**
```dart
// ✅ Don't close BLoC that's still in use
// Avoid loginBloc.close() while still navigated to LoginPage
```

---

### 7. ScreenUtil: "FlutterError: ScreenUtil has not been initialized"

**Error:**
```
FlutterError: ScreenUtil has not been initialized
```

**Fix:** Wrap app in `ScreenUtilInit`:
```dart
// app.dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp.router(...),
    );
  }
}
```

---

### 8. Flavor error on app launch

**Error:**
```
FlutterError: F.appFlavor not initialized
```

**Fix:** Run with flavor defined:
```bash
# Option 1: dart-define
flutter run --dart-define=FLAVOR=dev

# Option 2: Using run_app.sh (already configured)
./run_app.sh run

# Option 3: IDE - check run_config/Dev.run.xml has:
# <option name="additionalArgs" value="--dart-define=FLAVOR=dev" />
```

---

### 9. "dart format" fails in scripts

**Error:**
```
dart: Could not find an option named "set-exit-if-changed"
```

**Fix:** Use correct format command:
```bash
# Correct
dart format lib/
dart format .

# For CI (fail on unformatted)
dart format --output=none --set-exit-if-changed lib/
```

---

## 🔧 General Troubleshooting Steps

### Full Reset (Nuclear Option)

When nothing else works:

```bash
# 1. Complete clean
./script/clean_setup.sh

# 2. If still failing, manual clean
find . -type d -name "build" -exec rm -rf {} + 2>/dev/null
find . -type d -name ".dart_tool" -exec rm -rf {} + 2>/dev/null
find . -name "pubspec.lock" -delete 2>/dev/null

# 3. Re-setup
./script/get.sh
./script/build_runner.sh
./run_app.sh analyze
```

### Check Each Package Individually

```bash
# Test specific package
cd login
flutter pub get
flutter analyze
flutter test
cd ..

# Test app_host
cd app_host
flutter pub get
flutter analyze
cd ..
```

### Verify Generated Files Exist

After running build_runner, verify these files exist:
```bash
# app_host generated files
ls app_host/lib/router/app_router.gr.dart
ls app_host/lib/di/injection.config.dart

# login generated files
ls login/lib/src/router/login_router.gr.dart
ls login/lib/src/data/model/login_request.freezed.dart
ls login/lib/src/data/model/login_request.g.dart
ls login/lib/src/presentation/bloc/login_event.freezed.dart
ls login/lib/src/presentation/bloc/login_state.freezed.dart
```

---

## 📊 Diagnostic Commands

```bash
# Check Flutter version
flutter --version

# Check dart version
dart --version

# Check outdated packages
cd app_host && flutter pub outdated
cd login && flutter pub outdated

# Check dependency graph
cd login && flutter pub deps

# Verbose pub get
cd app_host && flutter pub get --verbose

# Check analyzer details
cd app_host && flutter analyze --verbose

# Show all registered packages in GetIt (debug build)
# Add to main.dart temporarily:
# getIt.allReady().then((_) => print(getIt.toString()));
```

---

## 🐛 Common Code Mistakes

### Wrong import path

```dart
// ❌ WRONG - direct package import
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ✅ CORRECT - use dependency re-export
import 'package:dependency/dependency.dart';
```

### Missing @RoutePage annotation

```dart
// ❌ WRONG - LoginRoute not generated
class LoginPage extends StatelessWidget { ... }

// ✅ CORRECT - @RoutePage triggers code generation
@RoutePage()
class LoginPage extends StatelessWidget { ... }
```

### Singleton BLoC causes stale state

```dart
// ❌ WRONG - same bloc instance shared
@lazySingleton
LoginBloc loginBloc(...) => LoginBloc(...);

// ✅ CORRECT - new instance per page
@factory
LoginBloc loginBloc(...) => LoginBloc(...);
```

### Missing WidgetsFlutterBinding

```dart
// ❌ WRONG - async main without binding
void main() async {
  await configureDependencies(); // Will crash!
  runApp(App());
}

// ✅ CORRECT
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ← Required before any async!
  await configureDependencies();
  runApp(App());
}
```

---

## 🌐 Network Issues

### Dio BaseUrl not configured

```dart
// In AppModule or where Dio is created:
Dio get dio => Dio()
  ..options = BaseOptions(
    baseUrl: 'https://api.example.com',  // ← Add base_component URL!
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );
```

### SSL Certificate Issues (Dev only)

```dart
// For dev environment only:
Dio get dio {
  final dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };
  return dio;
}
```

---

## 📱 iOS Specific

### Pods not installed

```bash
cd app_host/ios
pod install --repo-update
cd ../..
```

### iOS build fails after package update

```bash
cd app_host/ios
pod deintegrate
pod install
cd ../..
```

---

## 🤖 Android Specific

### Minimum SDK version error

In `app_host/android/app/build.gradle`:
```gradle
android {
  defaultConfig {
    minSdkVersion 21  // ← May need to increase
    targetSdkVersion 34
  }
}
```

### Gradle build failure

```bash
cd app_host/android
./gradlew clean
cd ../..
flutter build apk --debug
```

---

## 🆘 Getting More Help

1. **Check error message carefully** - Dart errors are usually descriptive
2. **Run `./run_app.sh analyze`** - Shows all type errors
3. **Check generated files exist** - Most issues are from missing generated code
4. **Run `./script/clean_setup.sh`** - Resets everything
5. **Check Flutter docs**: https://flutter.dev/docs
6. **Check package docs on pub.dev**

---

**Still stuck?** Check other docs:
- [02-setup.md](02-setup.md) - Setup steps
- [04-scripts.md](04-scripts.md) - Script usage
- [05-architecture.md](05-architecture.md) - Architecture patterns
