import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/features/authentication/presentation/viewmodel/auth_view_model.dart';
import 'package:sangeet/features/home/presentation/view/home_view.dart';
import 'package:sangeet/features/library/presentation/view/library_view.dart';
import 'package:sangeet/features/profile/presentation/view/profile_view.dart';
import 'package:sangeet/features/sensors/domain/usecases/double_shake_use_case.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  int _selectedIndex = 0;

  final List<Widget> bottomScreens = [
    const HomeView(),
    const LibraryView(),
    const ProfileView(),
  ];

  late DoubleShakeDetectorService _doubleShakeDetectorService;

  @override
  void initState() {
    super.initState();
    // Initialize shake detection service
    _doubleShakeDetectorService = DoubleShakeDetectorService(onShake: _handleShake);
    _doubleShakeDetectorService.startListening();
  }

  @override
  void dispose() {
    // Clean up when the widget is disposed
    _doubleShakeDetectorService.stopListening();
    super.dispose();
  }

  void _handleShake() {
    // Handle shake event (e.g., logout)
    _doubleShakeDetectorService.stopListening();
    _logout();
  }

  void _logout() {
    // Perform logout action
    // ref.read(authViewModelProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.library_add), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
