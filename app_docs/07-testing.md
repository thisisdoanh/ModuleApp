# 🧪 07 - Testing Guide

Testing strategy, patterns, and examples for the monorepo.

## 🎯 Testing Philosophy

```
┌─────────────────────────────────────────┐
│          E2E / Integration Tests         │  (Few, Slow, High confidence)
├─────────────────────────────────────────┤
│           Widget Tests                   │  (Some, Medium speed)
├─────────────────────────────────────────┤
│             Unit Tests                   │  (Many, Fast, Low cost)
└─────────────────────────────────────────┘
```

**Focus:** Unit tests for BLoC and Repository (most bang for buck).

## 📦 Test Setup

### dev_dependency package

All test utilities are centralized in `dev_dependency/`:

```dart
// Import all test utilities from one place
import 'package:dev_dependency/dev_dependency.dart';

// Provides:
// - flutter_test (expect, test, group, setUp, etc.)
// - bloc_test (blocTest, emitsInOrder)
// - mocktail (Mock, when, verify)
// - mockito (Mock fallback)
```

### Package test structure

```
module_name/
└── test/
    ├── presentation/
    │   └── bloc/
    │       └── module_bloc_test.dart   ← BLoC tests
    ├── data/
    │   └── repository/
    │       └── module_repo_test.dart   ← Repository tests
    └── data/
        └── datasource/
            └── module_datasource_test.dart
```

## 🧩 BLoC Testing Pattern

The primary test pattern follows `login_bloc_test.dart`:

```dart
import 'package:dev_dependency/dev_dependency.dart';
import 'package:login/login.dart';

// 1. Create Mock
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginBloc', () {
    late LoginBloc loginBloc;
    late MockAuthRepository mockRepository;

    // 2. Setup before each test
    setUp(() {
      mockRepository = MockAuthRepository();
      loginBloc = LoginBloc(mockRepository);
    });

    // 3. Cleanup after each test
    tearDown(() {
      loginBloc.close();
    });

    // 4. Test initial state
    test('initial state is LoginInitial', () {
      expect(loginBloc.state, equals(const LoginState.initial()));
    });

    // 5. Test success flow
    group('LoginPressedEvent', () {
      blocTest<LoginBloc, LoginState>(
        'emits [loading, success] when login succeeds',
        setUp: () {
          when(mockRepository.login('user', 'pass'))
              .thenAnswer((_) async => LoginResponse(
                    token: 'test_token',
                    userId: 'user_123',
                    username: 'testuser',
                  ));
        },
        build: () => loginBloc,
        act: (bloc) => bloc.add(
          const LoginEvent.loginPressed(
            username: 'user',
            password: 'pass',
          ),
        ),
        expect: () => [
          const LoginState.loading(),
          LoginState.success(token: 'test_token', userId: 'user_123'),
        ],
      );

      // 6. Test failure flow
      blocTest<LoginBloc, LoginState>(
        'emits [loading, failure] when login fails',
        setUp: () {
          when(mockRepository.login(any, any))
              .thenThrow(Exception('Network error'));
        },
        build: () => loginBloc,
        act: (bloc) => bloc.add(
          const LoginEvent.loginPressed(
            username: 'user',
            password: 'wrongpass',
          ),
        ),
        expect: () => [
          const LoginState.loading(),
          isA<LoginFailure>(),
        ],
      );
    });
  });
}
```

## 🗄️ Repository Testing Pattern

```dart
import 'package:dev_dependency/dev_dependency.dart';
import 'package:login/login.dart';

class MockLoginRemoteDataSource extends Mock
    implements LoginRemoteDataSource {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockLoginRemoteDataSource mockDataSource;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockDataSource = MockLoginRemoteDataSource();
      mockPrefs = MockSharedPreferences();
      repository = AuthRepositoryImpl(mockDataSource, mockPrefs);
    });

    test('login saves token to SharedPreferences', () async {
      // Arrange
      final response = LoginResponse(
        token: 'auth_token',
        userId: 'user_1',
        username: 'testuser',
      );
      when(() => mockDataSource.login(any())).thenAnswer((_) async => response);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      // Act
      await repository.login('testuser', 'password');

      // Assert
      verify(() => mockPrefs.setString('auth_token', 'auth_token')).called(1);
    });

    test('isLoggedIn returns true when token exists', () async {
      // Arrange
      when(() => mockPrefs.getString('auth_token')).thenReturn('some_token');

      // Act
      final isLoggedIn = await repository.isLoggedIn();

      // Assert
      expect(isLoggedIn, isTrue);
    });

    test('isLoggedIn returns false when no token', () async {
      // Arrange
      when(() => mockPrefs.getString('auth_token')).thenReturn(null);

      // Act
      final isLoggedIn = await repository.isLoggedIn();

      // Assert
      expect(isLoggedIn, isFalse);
    });
  });
}
```

## 🔬 Mocktail vs Mockito

The project uses both, but **mocktail is preferred** (no code generation needed):

### Mocktail (preferred)
```dart
import 'package:dev_dependency/dev_dependency.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

// Setup mock
when(() => mockRepo.login('user', 'pass'))
    .thenAnswer((_) async => testResponse);

// Any argument matcher
when(() => mockRepo.login(any(), any()))
    .thenThrow(Exception('error'));

// Verify calls
verify(() => mockRepo.login('user', 'pass')).called(1);
verifyNever(() => mockRepo.logout());
```

### Mockito (requires code gen)
```dart
// Requires:
// @GenerateMocks([AuthRepository])
// in the test file, plus running build_runner

class MockAuthRepository extends Mock implements AuthRepository {}

// Setup
when(mockRepo.login('user', 'pass')).thenAnswer((_) async => response);
```

## 🎨 Widget Testing Pattern

```dart
import 'package:dependency/dependency.dart';
import 'package:dev_dependency/dev_dependency.dart';
import 'package:login/login.dart';

void main() {
  group('LoginFormWidget', () {
    testWidgets('shows error when fields are empty', (tester) async {
      // Arrange - create a bloc with mock
      final mockBloc = MockLoginBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<LoginBloc>.value(
            value: mockBloc,
            child: const Scaffold(
              body: LoginFormWidget(),
            ),
          ),
        ),
      );

      // Act - tap login button without filling fields
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert - should show error snackbar
      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('dispatches LoginPressed event when form is filled', (tester) async {
      final mockBloc = MockLoginBloc();

      await tester.pumpWidget(
        ScreenUtilInit(
          builder: (context, child) => MaterialApp(
            home: BlocProvider<LoginBloc>.value(
              value: mockBloc,
              child: const Scaffold(body: LoginFormWidget()),
            ),
          ),
        ),
      );

      // Act - fill in form
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert - bloc received the event
      verify(
        () => mockBloc.add(
          const LoginEvent.loginPressed(
            username: 'testuser',
            password: 'password123',
          ),
        ),
      ).called(1);
    });
  });
}
```

## 🏃 Running Tests

```bash
# Run all tests
./run_app.sh test

# Run tests in a specific package
cd login
flutter test

# Run specific test file
flutter test test/presentation/bloc/login_bloc_test.dart

# Run with coverage
flutter test --coverage

# Run tests verbose
flutter test -v
```

## 📊 Test Coverage

```bash
# Generate coverage report
cd login
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## ✅ Test Checklist

For each feature module, cover:

```
BLoC Tests:
□ Initial state is correct
□ Each event emits expected states (success path)
□ Each event emits failure state on error
□ State transitions are correct
□ Async loading states work

Repository Tests:
□ Successful API call returns correct model
□ API error throws proper exception
□ Local caching works (SharedPreferences)
□ Cache hit returns cached data

Widget Tests (optional):
□ Widget renders correctly with each state
□ User interactions dispatch correct events
□ Error states display error messages
□ Loading states show loading indicator
```

## 🔧 Test Helpers

Create reusable helpers in your test directory:

```dart
// login/test/helpers/login_bloc_helpers.dart
import 'package:dev_dependency/dev_dependency.dart';
import 'package:login/login.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

LoginBloc createLoginBloc({AuthRepository? repository}) {
  return LoginBloc(repository ?? MockAuthRepository());
}

LoginResponse get testLoginResponse => LoginResponse(
  token: 'test_token',
  userId: 'user_123',
  username: 'testuser',
);
```

Use in tests:
```dart
import 'helpers/login_bloc_helpers.dart';

void main() {
  test('login success', () async {
    final bloc = createLoginBloc();
    // ...
  });
}
```

## 📚 References

- **BLoC Testing**: `login/test/presentation/bloc/login_bloc_test.dart`
- **bloc_test docs**: https://pub.dev/packages/bloc_test
- **mocktail docs**: https://pub.dev/packages/mocktail
- **flutter_test docs**: https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html

---

Continue reading: [08-troubleshooting.md](08-troubleshooting.md) ⬇️
