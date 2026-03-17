import 'package:dependency/dependency.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this._prefs) : super(_loadInitialState(_prefs));

  final SharedPreferences _prefs;

  static const _themeKey = 'app_theme';
  static const _localeKey = 'app_locale';

  static AppState _loadInitialState(SharedPreferences prefs) {
    final savedTheme = prefs.getString(_themeKey);
    final themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == savedTheme,
      orElse: () => ThemeMode.system,
    );

    final savedLocale = prefs.getString(_localeKey);
    final locale =
        savedLocale != null ? Locale(savedLocale) : const Locale('vi');

    return AppState(themeMode: themeMode, locale: locale);
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _prefs.setString(_themeKey, mode.name);
  }

  Future<void> toggleTheme() async {
    final next = state.isDark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(next);
  }

  Future<void> setLocale(Locale locale) async {
    emit(state.copyWith(locale: locale));
    await _prefs.setString(_localeKey, locale.languageCode);
  }
}
