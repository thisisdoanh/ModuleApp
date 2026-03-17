import 'package:dependency/dependency.dart';

part 'token_response_model.g.dart';

@JsonSerializable()
class TokenResponseModel {
  const TokenResponseModel({
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  @JsonKey(name: 'access_token')
  final String? accessToken;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseModelToJson(this);

  static const TokenResponseModel empty = TokenResponseModel();
}
