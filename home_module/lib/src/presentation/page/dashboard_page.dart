import 'package:app_route/app_route.dart';
import 'package:auth_module/auth_module.dart';
import 'package:dependency/dependency.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'home_tab_page.dart';
import 'profile_tab_page.dart';
import 'widget/bottom_nav_bar_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const List<Widget> _tabs = [
    HomeTabPage(),
    ProfileTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.I<HomeCubit>()),
        BlocProvider.value(value: GetIt.I<AuthCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            AppNavigator.toLogin();
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            if (homeState is HomeInitial) {
              final authState = context.read<AuthCubit>().state;
              if (authState is AuthAuthenticated) {
                context.read<HomeCubit>().loadProfile(authState.userId);
              }
            }

            final currentTab =
                homeState is HomeLoaded ? homeState.currentTabIndex : 0;

            return Scaffold(
              body: IndexedStack(
                index: currentTab,
                children: _tabs,
              ),
              bottomNavigationBar: BottomNavBarWidget(
                currentIndex: currentTab,
                onTabChanged: (index) =>
                    context.read<HomeCubit>().changeTab(index),
              ),
            );
          },
        ),
      ),
    );
  }
}
