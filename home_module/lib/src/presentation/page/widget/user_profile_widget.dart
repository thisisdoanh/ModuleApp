import 'package:flutter/material.dart';
import 'package:common_ui/common_ui.dart';
import 'package:dependency/dependency.dart';

import '../../../data/model/user_profile.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _avatar,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.username, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 2),
              Text(
                profile.email,
                style: AppTextStyles.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _avatar {
    if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(profile.avatarUrl!),
      );
    }
    final initials = _initials;
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.primary,
      child: Text(
        initials,
        style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
      ),
    );
  }

  String get _initials {
    final parts = profile.username.trim().split(' ');
    if (parts.isEmpty || profile.username.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
