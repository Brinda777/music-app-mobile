
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/home/presentation/view/home_view.dart';

class HomeViewNavigator {}

mixin HomeViewRoute {
  openHomeView() {
    NavigateRoute.pushRoute(const HomeView());
  }
}
