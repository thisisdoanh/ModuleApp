import 'package:dependency/dependency.dart';

part 'auth_token.g.dart';

@JsonSerializable()
class AuthToken extends Equatable {
  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.username,
    required this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final String userId;
  final String username;
  final DateTime expiresAt;

  /// Returns true if access token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Returns true if token expires within [minutes] minutes
  bool expiresWithin(int minutes) =>
      DateTime.now().isAfter(expiresAt.subtract(Duration(minutes: minutes)));

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);

  @override
  List<Object?> get props =>
      [accessToken, refreshToken, userId, username, expiresAt];
}
