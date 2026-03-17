import 'package:test_dependency/test_dependency.dart';
import 'package:home_module/home_module.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late HomeCubit homeCubit;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    homeCubit = HomeCubit(mockRepository);
  });

  tearDown(() => homeCubit.close());

  group('HomeCubit', () {
    const testProfile = UserProfile(
      userId: 'user_123',
      username: 'Test User',
      email: 'test@example.com',
    );

    test('initial state is HomeInitial', () {
      expect(homeCubit.state, const HomeState.initial());
    });

    blocTest<HomeCubit, HomeState>(
      'emits [loading, loaded] on loadProfile success',
      setUp: () {
        when(() => mockRepository.getUserProfile('user_123'))
            .thenAnswer((_) async => testProfile);
      },
      build: () => homeCubit,
      act: (cubit) => cubit.loadProfile('user_123'),
      expect: () => [
        const HomeState.loading(),
        const HomeState.loaded(profile: testProfile, currentTabIndex: 0),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [loading, error] on loadProfile failure',
      setUp: () {
        when(() => mockRepository.getUserProfile('user_123'))
            .thenThrow(Exception('Network error'));
      },
      build: () => homeCubit,
      act: (cubit) => cubit.loadProfile('user_123'),
      expect: () => [
        const HomeState.loading(),
        isA<HomeError>(),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits loaded with updated tabIndex on changeTab',
      seed: () => const HomeState.loaded(
        profile: testProfile,
        currentTabIndex: 0,
      ),
      build: () => homeCubit,
      act: (cubit) => cubit.changeTab(1),
      expect: () => [
        const HomeState.loaded(profile: testProfile, currentTabIndex: 1),
      ],
    );
  });
}
