import 'package:common_ui/common_ui.dart';
import 'package:dependency/dependency.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState extends BaseState with _$AppState {
  const AppState._();

  const factory AppState({
    required ThemeMode themeMode,
    required Locale locale,
  }) = _AppState;

  bool get isDark => themeMode == ThemeMode.dark;

  @override
  BaseStatus get status => BaseStatus.success;

  @override
  String? get errorMessage => null;
}
