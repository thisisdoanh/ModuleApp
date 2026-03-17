import 'package:auth_module/auth_module.dart';
import 'package:dev_dependency/dev_dependency.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthCubit', () {
    late AuthCubit authCubit;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      authCubit = AuthCubit(mockRepository);
    });

    tearDown(() => authCubit.close());

    test('initial state is AuthInitial', () {
      expect(authCubit.state, equals(const AuthState.initial()));
    });

    group('login', () {
      final testToken = AuthToken(
        accessToken: 'access_token_123',
        refreshToken: 'refresh_token_456',
        userId: 'user_001',
        username: 'testuser',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, authenticated] when login succeeds',
        setUp: () {
          when(() => mockRepository.login('testuser', 'password123'))
              .thenAnswer((_) async => testToken);
        },
        build: () => authCubit,
        act: (cubit) => cubit.login('testuser', 'password123'),
        expect: () => [
          const AuthState.loading(),
          AuthState.authenticated(
            userId: testToken.userId,
            username: testToken.username,
            accessToken: testToken.accessToken,
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, failure] when login fails',
        setUp: () {
          when(() => mockRepository.login(any(), any()))
              .thenThrow(Exception('Invalid credentials'));
        },
        build: () => authCubit,
        act: (cubit) => cubit.login('testuser', 'wrongpass'),
        expect: () => [
          const AuthState.loading(),
          isA<AuthFailure>(),
        ],
      );
    });

    group('logout', () {
      blocTest<AuthCubit, AuthState>(
        'emits [loading, unauthenticated] when logout',
        setUp: () {
          when(() => mockRepository.logout()).thenAnswer((_) async {});
        },
        build: () => authCubit,
        act: (cubit) => cubit.logout(),
        expect: () => [
          const AuthState.loading(),
          const AuthState.unauthenticated(),
        ],
      );
    });

    group('checkAuthStatus', () {
      blocTest<AuthCubit, AuthState>(
        'emits [loading, unauthenticated] when not logged in',
        setUp: () {
          when(() => mockRepository.isLoggedIn()).thenAnswer((_) async => false);
        },
        build: () => authCubit,
        act: (cubit) => cubit.checkAuthStatus(),
        expect: () => [
          const AuthState.loading(),
          const AuthState.unauthenticated(),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, authenticated] when already logged in with valid token',
        setUp: () {
          when(() => mockRepository.isLoggedIn()).thenAnswer((_) async => true);
          when(() => mockRepository.isTokenExpired())
              .thenAnswer((_) async => false);
          when(() => mockRepository.getAccessToken())
              .thenAnswer((_) async => 'access_token');
          when(() => mockRepository.getUserId())
              .thenAnswer((_) async => 'user_001');
        },
        build: () => authCubit,
        act: (cubit) => cubit.checkAuthStatus(),
        expect: () => [
          const AuthState.loading(),
          isA<AuthAuthenticated>(),
        ],
      );
    });
  });
}
