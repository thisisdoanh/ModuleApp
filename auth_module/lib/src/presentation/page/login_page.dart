import 'package:app_route/app_route.dart';
import 'package:common_ui/common_ui.dart';
import 'package:dependency/dependency.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'widget/login_form_widget.dart';

class LoginPage extends BaseViewStateless<AuthCubit, AuthState> {
  const LoginPage({super.key});

  @override
  AuthCubit createCubit(BuildContext context) =>
      GetIt.I<AuthCubit>()..checkAuthStatus();

  @override
  void onStateChange(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) AppNavigator.toDashboard();
  }

  @override
  Widget buildView(BuildContext context, AuthState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: const LoginFormWidget(),
          ),
        ),
      ),
    );
  }
}
