import 'package:dependency/dependency.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    required ThemeMode themeMode,
    required Locale locale,
  }) = _AppState;

  bool get isDark => themeMode == ThemeMode.dark;
}
