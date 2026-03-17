import 'package:dependency/dependency.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({required ThemeMode themeMode, required Locale locale}) = _AppState;
  const AppState._();

  bool get isDark => themeMode == ThemeMode.dark;
}
