import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/features/profile/domain/entity/user_entity.dart';
import 'package:sangeet/features/profile/presentation/viewmodel/profile_view_model.dart';
import 'package:sangeet/features/profile/presentation/viewmodel/user_view_model.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  File? _img;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(profileViewModelProvider);

    if (currentUser.authEntity != null) {
      _firstNameController.text = currentUser.authEntity!.firstName ?? '';
      _lastNameController.text = currentUser.authEntity!.lastName ?? '';
      _emailController.text = currentUser.authEntity!.email ?? '';
      _genderController.text = currentUser.authEntity!.gender ?? '';
      _dateController.text = currentUser.authEntity!.dob ?? '';
      _selectedValue = currentUser.authEntity!.gender;
    }
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      if (await Permission.camera.shouldShowRequestRationale) {
        // Optionally, show an explanation to the user.
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  Future<void> _browseImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
        });
        ref.read(profileViewModelProvider.notifier).uploadImage(_img!);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image')),
      );
    }
  }

  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: _img != null
                          ? FileImage(_img!)
                          : authEntity.imageUrl != null
                              ? NetworkImage(
                                  ApiEndpoints.imageUrl + authEntity.imageUrl!)
                              : const AssetImage(
                                      'assets/images/default_image.png')
                                  as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 5,
                        ),
                        child:
                            const Icon(Icons.camera_alt, color: Colors.black),
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await _checkCameraPermission();
                                      await _browseImage(ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.camera_alt,
                                        color: Colors.black),
                                    label: const Text('Camera',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await _browseImage(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.image,
                                        color: Colors.black),
                                    label: const Text('Gallery',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(_firstNameController, 'First Name',
                          'Type in your first name'),
                      const SizedBox(height: 16),
                      _buildTextField(_lastNameController, 'Last Name',
                          'Type in your last name'),
                      const SizedBox(height: 16),
                      _buildTextField(_emailController, 'Email', '',
                          readOnly: true),
                      const SizedBox(height: 16),
                      _buildDatePickerField(),
                      const SizedBox(height: 16),
                      _buildDropdownField(),
                      const SizedBox(height: 30),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: _selectDate,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your date of birth';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      value: _selectedValue,
      items: <String>['male', 'female', 'other'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedValue = newValue!;
          _genderController.text = newValue!;
        });
      },
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstant.neutralColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 5,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final user = UserEntity(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              gender: _genderController.text,
              dob: _dateController.text,
            );

            ref.read(userViewModelProvider.notifier).editUser(user);
            ref.read(profileViewModelProvider.notifier).resetState();
          }
        },
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
