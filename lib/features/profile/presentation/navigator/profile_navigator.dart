
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/profile/presentation/view/profile_view.dart';

class ProfileViewNavigator {}

mixin ProfileViewRoute {
  openProfileView() {
    NavigateRoute.pushRoute(const ProfileView());
  }
}
