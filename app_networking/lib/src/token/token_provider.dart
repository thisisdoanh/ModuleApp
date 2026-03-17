import 'dart:convert';

import 'package:app_networking/app_networking.dart';
import 'package:dependency/dependency.dart';

const String _tokenKey = 'token';

class TokenProvider {
  TokenProvider(this._preferences);
  final SharedPreferences _preferences;

  TokenResponseModel get token {
    final String? data = _preferences.getString(_tokenKey);
    return data.isNotNullOrEmpty
        ? TokenResponseModel.fromJson(jsonDecode(data!))
        : const TokenResponseModel();
  }

  Future<void> setToken(TokenResponseModel? token) async {
    await _preferences.setString(_tokenKey, token != null ? jsonEncode(token) : '');
  }

  Future<void> clearToken() async {
    await _preferences.remove(_tokenKey);
  }
}
