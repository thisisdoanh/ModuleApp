import 'package:dependency/dependency.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.createdAt,
  });

  final String userId;
  final String username;
  final String email;
  final String? avatarUrl;
  final DateTime? createdAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  factory UserProfile.empty() => const UserProfile(
        userId: '',
        username: '',
        email: '',
      );

  UserProfile copyWith({
    String? userId,
    String? username,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
  }) =>
      UserProfile(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [userId, username, email, avatarUrl, createdAt];
}
