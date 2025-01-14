import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/authentication/presentation/view/login_view.dart';
import 'package:sangeet/features/profile/presentation/view/change_password_view.dart';
import 'package:sangeet/features/profile/presentation/view/edit_profile_view.dart';
import 'package:sangeet/features/profile/presentation/viewmodel/profile_view_model.dart';

import '../../../../app/constants/api_endpoint.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(profileViewModelProvider);
    final authEntity = currentUser.authEntity;

    if (authEntity == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: ThemeConstant.neutralColor,
        ),
      );
    }

    return SizedBox.expand(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white24, width: 1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 80,
                                      backgroundColor: Colors.grey[900],
                                      backgroundImage: authEntity.imageUrl !=
                                              null
                                          ? NetworkImage(ApiEndpoints.imageUrl +
                                              authEntity.imageUrl!)
                                          : const AssetImage(
                                                  'assets/images/default_image.png')
                                              as ImageProvider,
                                    ),
                                    if (authEntity.imageUrl == null)
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Name: ${authEntity.firstName ?? 'Brinda'} ${authEntity.lastName ?? 'Bhattarai'}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Email: ${authEntity.email ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Date of Birth: ${authEntity.dob ?? '1999/11/09'}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Gender: ${authEntity.gender ?? 'Male'}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildActionTile(
                        icon: Icons.edit,
                        color: ThemeConstant.neutralColor,
                        title: 'Edit Profile',
                        borderColor: ThemeConstant.neutralColor,
                        onTap: () {
                          NavigateRoute.pushRoute(const EditProfileView());
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildActionTile(
                        icon: Icons.lock,
                        color: Colors.redAccent,
                        title: 'Change Password',
                        borderColor: Colors.redAccent,
                        onTap: () {
                          NavigateRoute.pushRoute(const ChangePasswordView());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  // Handle logout logic here
                  NavigateRoute.popAndPushRoute(const LoginView());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color color,
    required String title,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        ),
      ),
    );
  }
}
