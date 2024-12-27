import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/dashboard/presentation/view/dashboard_view.dart';

class DashboardViewNavigator {}

mixin DashboardViewRoute {
  openDashboardView() {
    NavigateRoute.pushRoute(const DashboardView());
  }
}
