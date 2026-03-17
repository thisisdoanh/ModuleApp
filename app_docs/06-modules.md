# 🧩 06 - Creating New Modules

Step-by-step guide to create a new feature module following the `login/` module pattern.

## 📋 Overview

Each feature module is a **Flutter package** with:
- Its own `pubspec.yaml` with path dependencies on `dependency/`
- Clean Architecture layers (data, presentation, di, router)
- Public API through a single export file
- BLoC for state management
- Tests in `test/` directory

## 🚀 Quick Reference

```bash
# After creating the module:
1. Create folder structure
2. Add to app_host/pubspec.yaml
4. Add routes to app_router.dart
5. Run ./script/clean_setup.sh
```

## 📁 Step 1: Create Module Structure

Replace `profile` with your module name:

```bash
# Create directories
mkdir -p profile/lib/src/data/model
mkdir -p profile/lib/src/data/datasource
mkdir -p profile/lib/src/data/repository
mkdir -p profile/lib/src/presentation/bloc
mkdir -p profile/lib/src/presentation/page/widget
mkdir -p profile/lib/src/router
mkdir -p profile/lib/src/di
mkdir -p profile/test/presentation/bloc
```

## 📄 Step 2: Create pubspec.yaml

`profile/pubspec.yaml`:
```yaml
name: profile
description: Profile module - feature package
publish_to: none
version: 1.0.0

environment:
  sdk: ^3.11.0
  flutter: ">=3.11.0"

dependencies:
  flutter:
    sdk: flutter

  # Local dependencies - always use dependency package
  dependency:
    path: ../dependency

dev_dependencies:
  flutter_test:
    sdk: flutter
  dev_dependency:
    path: ../dev_dependency

  # Code generation
  build_runner: ^2.12.2
  auto_route_generator: ^10.5.0
  injectable_generator: ^2.12.1
  freezed: ^3.2.5

flutter:
  uses-material-design: true
```

## 📄 Step 3: Create analysis_options.yaml

`profile/analysis_options.yaml`:
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
```

## 📦 Step 4: Create Data Models

`profile/lib/src/data/model/profile_model.dart`:
```dart
import 'package:dependency/dependency.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    String? phone,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
```

## 🌐 Step 5: Create DataSource

`profile/lib/src/data/datasource/profile_remote_datasource.dart`:
```dart
import 'package:dependency/dependency.dart';
import '../model/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<ProfileModel> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<ProfileModel> getProfile(String userId) async {
    final response = await _dio.get('/api/users/$userId');
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final response = await _dio.put(
      '/api/users/${profile.id}',
      data: profile.toJson(),
    );
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }
}
```

## 🗄️ Step 6: Create Repository

`profile/lib/src/data/repository/profile_repository.dart`:
```dart
import '../model/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile(String userId);
  Future<ProfileModel> updateProfile(ProfileModel profile);
}
```

`profile/lib/src/data/repository/profile_repository_impl.dart`:
```dart
import 'package:dependency/dependency.dart';
import '../datasource/profile_remote_datasource.dart';
import '../model/profile_model.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final SharedPreferences _prefs;

  ProfileRepositoryImpl(this._remoteDataSource, this._prefs);

  static const String _profileKey = 'cached_profile';

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final profile = await _remoteDataSource.getProfile(userId);
      // Cache profile locally
      await _prefs.setString(_profileKey, profile.toJson().toString());
      return profile;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    return await _remoteDataSource.updateProfile(profile);
  }
}
```

## 🔄 Step 7: Create BLoC

`profile/lib/src/presentation/bloc/profile_event.dart`:
```dart
import 'package:dependency/dependency.dart';

part 'profile_event.freezed.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.loadProfile({required String userId}) =
      LoadProfileEvent;

  const factory ProfileEvent.updateProfile({
    required String name,
    String? phone,
    String? avatarUrl,
  }) = UpdateProfileEvent;
}
```

`profile/lib/src/presentation/bloc/profile_state.dart`:
```dart
import 'package:dependency/dependency.dart';
import '../../data/model/profile_model.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = ProfileInitial;

  const factory ProfileState.loading() = ProfileLoading;

  const factory ProfileState.loaded({required ProfileModel profile}) =
      ProfileLoaded;

  const factory ProfileState.failure({required String message}) =
      ProfileFailure;
}
```

`profile/lib/src/presentation/bloc/profile_bloc.dart`:
```dart
import 'package:dependency/dependency.dart';
import '../../data/repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(const ProfileState.initial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.loading());
    try {
      final profile = await _repository.getProfile(event.userId);
      emit(ProfileState.loaded(profile: profile));
    } catch (e) {
      emit(ProfileState.failure(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // TODO: Implement update
  }
}
```

## 📱 Step 8: Create Page

`profile/lib/src/presentation/page/profile_page.dart`:
```dart
import 'package:dependency/dependency.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({super.key, @PathParam('userId') required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ProfileBloc>()
        ..add(ProfileEvent.loadProfile(userId: userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (profile) => Center(
                child: Text('Hello, ${profile.name}!'),
              ),
              failure: (message) => Center(
                child: Text('Error: $message'),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## 🔌 Step 9: Create DI Module

`profile/lib/src/di/profile_module.dart`:
```dart
import 'package:dependency/dependency.dart';
import '../data/datasource/profile_remote_datasource.dart';
import '../data/repository/profile_repository.dart';
import '../data/repository/profile_repository_impl.dart';
import '../presentation/bloc/profile_bloc.dart';

@module
abstract class ProfileModule {
  @lazySingleton
  ProfileRemoteDataSource profileRemoteDataSource(Dio dio) =>
      ProfileRemoteDataSourceImpl(dio);

  @lazySingleton
  ProfileRepository profileRepository(
    ProfileRemoteDataSource remoteDataSource,
    SharedPreferences prefs,
  ) =>
      ProfileRepositoryImpl(remoteDataSource, prefs);

  @factory
  ProfileBloc profileBloc(ProfileRepository repository) =>
      ProfileBloc(repository);
}
```

## 🧭 Step 10: Create Router

`profile/lib/src/router/profile_router.dart`:
```dart
import 'package:dependency/dependency.dart';
import '../presentation/page/profile_page.dart';

part 'profile_router.gr.dart';

List<AutoRoute> getProfileRoutes() {
  return [
    AutoRoute(
      path: '/profile/:userId',
      page: ProfileRoute.page,
    ),
  ];
}
```

## 📢 Step 11: Create Public API

`profile/lib/profile.dart`:
```dart
/// Profile module
library profile;

// Models
export 'src/data/model/profile_model.dart';

// Repository
export 'src/data/repository/profile_repository.dart';

// BLoC
export 'src/presentation/bloc/profile_bloc.dart';
export 'src/presentation/bloc/profile_event.dart';
export 'src/presentation/bloc/profile_state.dart';

// Pages
export 'src/presentation/page/profile_page.dart';

// Router
export 'src/router/profile_router.dart';

// DI
export 'src/di/profile_module.dart';
```

## 🔧 Step 12: Register in Monorepo

### 12a. Update `app_host/pubspec.yaml`:
```yaml
dependencies:
  dependency:
    path: ../dependency
  login:
    path: ../login
  profile:          # ← Add this
    path: ../profile
```

### 12c. Update `app_host/lib/router/app_router.dart`:
```dart
import 'package:login/login.dart';
import 'package:profile/profile.dart';   // ← Add this

import '../pages/home_page.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: ProfileRoute.page, path: '/profile/:userId'), // ← Add
      ];
}
```

### 12d. Update scripts (if needed):
```bash
# script/get.sh, script/clean.sh, script/build_runner.sh
PACKAGES=("dependency" "dev_dependency" "login" "profile" "app_host")

# run_app.sh
PACKAGES=("app_host" "dependency" "dev_dependency" "login" "profile")
```

## 🧪 Step 13: Write Tests

`profile/test/presentation/bloc/profile_bloc_test.dart`:
```dart
import 'package:dev_dependency/dev_dependency.dart';
import 'package:profile/profile.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  group('ProfileBloc', () {
    late ProfileBloc bloc;
    late MockProfileRepository mockRepository;

    setUp(() {
      mockRepository = MockProfileRepository();
      bloc = ProfileBloc(mockRepository);
    });

    tearDown(() => bloc.close());

    test('initial state is ProfileInitial', () {
      expect(bloc.state, equals(const ProfileState.initial()));
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, loaded] when profile loads successfully',
      setUp: () {
        when(() => mockRepository.getProfile('user_123')).thenAnswer(
          (_) async => ProfileModel(
            id: 'user_123',
            name: 'John Doe',
            email: 'john@example.com',
          ),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
        const ProfileEvent.loadProfile(userId: 'user_123'),
      ),
      expect: () => [
        const ProfileState.loading(),
        isA<ProfileLoaded>(),
      ],
    );
  });
}
```

## 🏃 Step 14: Run Setup

```bash
# Run complete setup
./script/clean_setup.sh

# Or step by step
./script/get.sh          # Get new dependencies
./script/build_runner.sh # Generate code
./run_app.sh analyze     # Check for errors
./run_app.sh test        # Run tests
./run_app.sh run         # Test in app
```

## 📊 Module Checklist

```
✅ pubspec.yaml with dependency path
✅ analysis_options.yaml
✅ Data model (Freezed)
✅ Remote DataSource (Dio)
✅ Repository (abstract + impl)
✅ BLoC (event, state, bloc)
✅ Page (@RoutePage)
✅ DI Module (@module)
✅ Router (AutoRoute)
✅ Public API (lib/module.dart)
✅ Tests (bloc_test)
✅ Added to app_host/pubspec.yaml
✅ Added to app_router.dart
✅ Added to scripts PACKAGES[]
```

## 🔗 Navigation to New Module

```dart
// Navigate to profile page
context.router.push(ProfileRoute(userId: currentUserId));

// Or by name
context.router.pushNamed('/profile/$userId');

// Replace current route
context.router.replace(ProfileRoute(userId: userId));
```

---

Continue reading: [07-testing.md](07-testing.md) ⬇️
