import 'package:app_localizations/app_localizations.dart';
import 'package:common_ui/common_ui.dart';
import 'package:dependency/dependency.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'widget/user_profile_widget.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(l10n.home),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<HomeCubit>().refresh(),
              ),
            ],
          ),
          body: switch (state) {
            HomeLoading() => const Center(child: AppLoading()),
            HomeLoaded(:final profile) => RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refresh(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.welcomeBackToDashboard,
                                style: AppTextStyles.bodySmall),
                            const SizedBox(height: 4),
                            UserProfileWidget(profile: profile),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.dashboard,
                                style: AppTextStyles.headlineSmall),
                            const SizedBox(height: 8),
                            Text(
                              'Your content goes here.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            HomeError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.error),
                      const SizedBox(height: 8),
                      Text(message, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Retry',
                        fullWidth: false,
                        onPressed: () => context.read<HomeCubit>().refresh(),
                      ),
                    ],
                  ),
                ),
              ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}
