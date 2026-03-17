import 'package:auth_module/auth_module.dart';
import 'package:common_ui/common_ui.dart';
import 'package:dependency/dependency.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'widget/user_profile_widget.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Profile')),
          body: switch (state) {
            HomeLoading() => const Center(child: AppLoading()),
            HomeLoaded(:final profile) => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: UserProfileWidget(profile: profile),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Account Info',
                              style: AppTextStyles.headlineSmall),
                          const SizedBox(height: 12),
                          _InfoRow(label: 'User ID', value: profile.userId),
                          const SizedBox(height: 8),
                          _InfoRow(label: 'Username', value: profile.username),
                          const SizedBox(height: 8),
                          _InfoRow(label: 'Email', value: profile.email),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Log Out',
                    variant: AppButtonVariant.outlined,
                    onPressed: () => _confirmLogout(context),
                  ),
                ],
              ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    AppDialog.show(
      context,
      title: 'Log Out',
      message: 'Are you sure you want to log out?',
      primaryLabel: 'Log Out',
      onPrimary: () {
        Navigator.of(context).pop();
        context.read<AuthCubit>().logout();
      },
      secondaryLabel: 'Cancel',
      onSecondary: () => Navigator.of(context).pop(),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}
