import 'package:app_route/app_route.dart';
import 'package:dependency/dependency.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'widget/login_form_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AuthCubit>()..checkAuthStatus(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            AppNavigator.toDashboard();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: const LoginFormWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
