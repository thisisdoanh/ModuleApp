# 🏗️ 05 - Architecture Guide

Deep dive into the architecture patterns, design decisions, and best practices used in this monorepo.

## 📐 Clean Architecture Overview

The project follows **Clean Architecture** with 3 main layers:

```
┌─────────────────────────────────────────────────────────┐
│                 Presentation Layer                      │
│        (BLoC, Pages, Widgets, Navigation)               │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│                   Domain Layer (Optional)               │
│              (Use Cases, Entities, Contracts)           │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│                    Data Layer                           │
│         (Models, DataSources, Repositories)             │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│            External APIs & Databases                    │
│               (REST API, SQLite, etc.)                  │
└─────────────────────────────────────────────────────────┘
```

### Key Principles

- **Dependency Rule**: Inner layers cannot depend on outer layers
- **Independence**: Each layer can be tested independently
- **Testability**: Business logic is separate from UI
- **Flexibility**: Easy to swap implementations

## 🔄 Layer Responsibilities

### Presentation Layer (UI)
**Location**: `lib/src/presentation/`

**Responsibilities:**
- Display data to user
- Handle user interactions
- Manage navigation
- Show loading/error states

**Components:**
- **BLoC** - Handles business logic and state
- **Pages** - Full-screen widgets marked with `@RoutePage`
- **Widgets** - Reusable UI components

**Example Structure:**
```
presentation/
├── bloc/
│   ├── login_event.dart      ← User actions
│   ├── login_state.dart      ← UI states
│   └── login_bloc.dart       ← Logic
├── page/
│   ├── login_page.dart       ← Full screen
│   └── widget/
│       └── login_form_widget.dart
└── router/
    └── login_router.dart     ← Navigation
```

### Domain Layer (Optional)

**Location**: `lib/src/domain/` (if used)

**Responsibilities:**
- Define business rules
- Abstract interfaces
- Define entities and use cases

**When to use:**
- Complex business logic
- Multiple implementations needed
- Sharing logic across modules

**When to skip:**
- Simple data-driven apps
- Direct data-to-UI mapping

### Data Layer

**Location**: `lib/src/data/`

**Responsibilities:**
- Fetch data from APIs
- Handle local storage
- Transform responses to models
- Implement repositories

**Components:**
- **Models** - Data classes (Freezed)
- **DataSources** - API/DB access
- **Repositories** - Implement abstract contracts

**Example Structure:**
```
data/
├── model/
│   ├── login_request.dart    ← API request
│   └── login_response.dart   ← API response
├── datasource/
│   └── login_remote_datasource.dart  ← Dio HTTP
└── repository/
    ├── auth_repository.dart         ← abstract
    └── auth_repository_impl.dart    ← implements
```

## 🧩 Core Technologies

### 1. BLoC Pattern (State Management)

**Location**: `lib/src/presentation/bloc/`

**Structure:**
```dart
// Event - User action
abstract class LoginEvent extends Equatable {}

class LoginPressedEvent extends LoginEvent {
  final String email;
  final String password;
  LoginPressedEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// State - UI state
abstract class LoginState extends Equatable {}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final String message;
  LoginSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC - Business logic
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginPressedEvent>(_onLoginPressed);
  }

  FutureOr<void> _onLoginPressed(
    LoginPressedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      await authRepository.login(event.email, event.password);
      emit(LoginSuccess(message: 'Login successful'));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
```

**Benefits:**
- Testable business logic
- Separation of concerns
- Easy state management
- Time-travel debugging

### 2. Freezed Models (Immutable Data Classes)

**Location**: `lib/src/data/model/`

**Purpose**: Create immutable, copyable, equatable data classes with JSON serialization

**Example:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String token,
    required String userId,
    required String email,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, Object?> json) =>
      _$LoginResponseFromJson(json);
}
```

**Auto-generated methods:**
- `copyWith()` - Create modified copies
- `==` and `hashCode` - Value equality
- `toString()` - Debugging
- `fromJson()` / `toJson()` - Serialization

### 3. AutoRoute (Type-Safe Navigation)

**Location**: `lib/router/app_router.dart`

**Structure:**
```dart
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: LoginRoute.page,
      initial: true,
    ),
    AutoRoute(
      page: HomeRoute.page,
    ),
  ];
}

// In login module
@RoutePage()
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
    );
  }
}
```

**Benefits:**
- Type-safe navigation
- Deep linking support
- Nested routing
- Route guards

### 4. Injectable + GetIt (Dependency Injection)

**Location**: `lib/di/injection.dart`

**Structure:**
```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

// In a module
@Module()
abstract class LoginModule {
  @lazySingleton
  AuthRepository authRepository(AuthRepositoryImpl impl) => impl;

  @lazySingleton
  LoginRemoteDataSource loginRemoteDataSource(Dio dio) =>
      LoginRemoteDataSource(dio);
}
```

**Annotations:**
- `@singleton` - One instance for app lifetime
- `@lazySingleton` - Lazy singleton (created on first access)
- `@factory` - New instance each time
- `@lazySingleton` - Combine with Module for features

**Usage:**
```dart
// Get instance
final authRepo = getIt<AuthRepository>();

// Provide in BLoC
BlocProvider<LoginBloc>(
  create: (_) => getIt<LoginBloc>(),
  child: LoginPage(),
)
```

## 📦 Module Architecture

Each feature module follows the same structure:

```
module_name/
├── lib/
│   ├── module_name.dart          ← Public API (exports)
│   └── src/
│       ├── data/
│       │   ├── model/            ← Freezed models
│       │   ├── datasource/       ← Remote/local data
│       │   └── repository/       ← Data contracts & impl
│       ├── presentation/
│       │   ├── bloc/             ← State management
│       │   ├── page/             ← Full screens
│       │   └── widget/           ← Reusable UI
│       ├── router/               ← Navigation
│       └── di/                   ← Dependency injection
└── test/
    └── presentation/bloc/        ← BLoC tests
```

### Public API Pattern

Each module exports only what's needed:

```dart
// module_name/lib/module_name.dart
export 'src/presentation/page/module_page.dart';
export 'src/router/module_router.dart';

// ❌ DON'T export:
// - Internal data models
// - Repository implementations
// - BLoC (use parent's version)
```

## 🔌 Dependency Management

### Centralized Dependencies

```
app_host/
  ├── imports: dependency/
  ├── imports: login/
  └── imports: other modules

login/ (and all modules)
  ├── imports: dependency/ (for packages)
  └── dev imports: dev_dependency/ (for tests)

dependency/
  └── re-exports all pub.dev packages

dev_dependency/
  └── re-exports test packages
```

### Import Best Practices

**✅ DO THIS:**
```dart
// In any module
import 'package:dependency/dependency.dart';  // Only this
```

**❌ DON'T DO THIS:**
```dart
import 'package:dio/dio.dart';                // Direct imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
```

**Why?**
- Single source of truth
- Easy to upgrade packages
- Consistent versions
- Easy to find what's available

## 🔗 Data Flow Example

```
User taps Login Button
        ↓
LoginEvent (LoginPressedEvent)
        ↓
LoginBloc processes event
        ↓
BLoC emits LoginLoading
        ↓
UI shows loading spinner
        ↓
BLoC calls AuthRepository.login()
        ↓
AuthRepository calls LoginRemoteDataSource
        ↓
LoginRemoteDataSource makes Dio HTTP request
        ↓
Response is mapped to LoginResponse (Freezed)
        ↓
Repository caches token in SharedPreferences
        ↓
AuthRepository returns result
        ↓
BLoC emits LoginSuccess
        ↓
UI navigates to Home screen
```

## 🎯 Dependency Flow in Code

```dart
// main.dart
void main() async {
  // 1. Setup DI
  configureDependencies();

  // 2. Initialize shared services
  await SharedPreferences.getInstance();

  // Run app with router
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginBloc>()),
      ],
      child: MyApp(appRouter: getIt<AppRouter>()),
    ),
  );
}

// app.dart
class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      theme: ThemeData.light(),
    );
  }
}

// Login page gets BLoC from context
@RoutePage()
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginLoading) {
          return CircularProgressIndicator();
        }
        if (state is LoginSuccess) {
          return Text('Login successful!');
        }
        return LoginForm();
      },
    );
  }
}
```

## 📊 Error Handling Pattern

```dart
// Repository handles both errors and responses
abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(
    String email,
    String password,
  );
}

// BLoC emits Failure state
class LoginFailure extends LoginState {
  final String error;
  LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// UI shows error message
BlocBuilder<LoginBloc, LoginState>(
  builder: (context, state) {
    if (state is LoginFailure) {
      return Text('Error: ${state.error}');
    }
    return Container();
  },
)
```

## 🔐 Best Practices

### DO ✅

1. **Keep layers separate**
   - Data layer knows nothing about BLoC
   - UI layer doesn't know about HTTP

2. **Use dependency injection**
   - All dependencies provided through GetIt
   - Easy to swap implementations in tests

3. **Keep BLoC methods focused**
   - One BLoC method per event type
   - Event handlers should be async-safe

4. **Use Freezed models**
   - Never write equals/hashCode manually
   - Use copyWith() for modifications

5. **Test each layer independently**
   - Unit test repositories
   - Unit test BLoCs
   - Widget test UI

### DON'T ❌

1. **Mix layers**
   - Don't import data models in UI
   - Don't access HTTP in BLoC directly

2. **Create god objects**
   - Keep BLoCs focused
   - One responsibility per class

3. **Use context for state**
   - Use BLoC/Provider instead
   - Context is for theme/navigation only

4. **Hardcode values**
   - Use constants file
   - Externalise API endpoints

5. **Ignore errors**
   - Always handle exceptions
   - Emit appropriate failure states

## 🚀 Scaling the Architecture

### Adding a New Module

1. Create folder: `new_module/`
2. Follow the structure in [06-modules.md](06-modules.md)
3. Register in `app_host/pubspec.yaml`
5. Create routes in new module
6. Include in `app_router.dart`

### Using Shared Components

```
shared_ui/  (new module)
├── lib/
│   ├── shared_ui.dart
│   └── src/
│       ├── widgets/
│       │   ├── custom_button.dart
│       │   ├── custom_text_field.dart
│       │   └── custom_app_bar.dart
│       └── theme/
│           ├── colors.dart
│           └── text_styles.dart
```

Import in any module:
```dart
import 'package:shared_ui/shared_ui.dart';

// Use shared components
CustomButton(onPressed: () {})
CustomTextField(hint: 'Email')
```

## 📚 Reference Files

- **login module**: `login/lib/src/` - Complete example of all layers
- **DI setup**: `app_host/lib/di/injection.dart` - GetIt configuration
- **Router**: `app_host/lib/router/app_router.dart` - Navigation setup
- **BLoC example**: `login/lib/src/presentation/bloc/login_bloc.dart`
- **Repository pattern**: `login/lib/src/data/repository/auth_repository.dart`

---

Continue reading: [06-modules.md](06-modules.md) ⬇️
