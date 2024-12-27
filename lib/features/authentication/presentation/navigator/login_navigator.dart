import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/authentication/presentation/navigator/register_navigator.dart';
import 'package:sangeet/features/authentication/presentation/view/login_view.dart';
import 'package:sangeet/features/dashboard/presentation/navigator/dashboard_navigator.dart';

final loginViewNavigatorProvider = Provider((ref) => LoginViewNavigator());

class LoginViewNavigator with RegisterViewRoute, DashboardViewRoute, LoginViewRoute {}

mixin LoginViewRoute {
  openLoginView() {
    NavigateRoute.popAndPushRoute(const LoginView());
  }
}
