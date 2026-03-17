import 'package:common_ui/common_ui.dart';
import 'package:dependency/dependency.dart';

import 'app_state.dart';

class AppCubit extends BaseCubit<AppState> {
  AppCubit(this._prefs) : super(_loadInitialState(_prefs));

  final SharedPreferences _prefs;

  static const _themeKey = 'app_theme';
  static const _localeKey = 'app_locale';

  @override
  Future<void> load() async {}

  static AppState _loadInitialState(SharedPreferences prefs) {
    final savedTheme = prefs.getString(_themeKey);
    final themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == savedTheme,
      orElse: () => ThemeMode.system,
    );
    final savedLocale = prefs.getString(_localeKey);
    final locale = savedLocale != null ? Locale(savedLocale) : const Locale('vi');
    return AppState(themeMode: themeMode, locale: locale);
  }

  Future<void> setTheme(ThemeMode mode) async {
    safeEmit(state.copyWith(themeMode: mode));
    await _prefs.setString(_themeKey, mode.name);
  }

  Future<void> toggleTheme() async {
    final next = state.isDark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(next);
  }

  Future<void> setLocale(Locale locale) async {
    safeEmit(state.copyWith(locale: locale));
    await _prefs.setString(_localeKey, locale.languageCode);
  }
}
