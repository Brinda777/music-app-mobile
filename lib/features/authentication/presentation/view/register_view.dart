import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/core/common/my_snackbar.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';
import 'package:sangeet/features/authentication/presentation/view/login_view.dart';
import 'package:sangeet/features/authentication/presentation/viewmodel/auth_view_model.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController(text: '');
  final _lastNameController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  bool _isObscure = true;

  final _gap = const SizedBox(height: 10);
  final _highGap = const SizedBox(height: 20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping anywhere outside the text fields
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 60),
                height: 250,
                width: 250,
                alignment: Alignment.center,
                child: Image.asset('assets/images/sangeet.png'),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: const Text(
                  'Create Your Account',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ThemeConstant.neutralColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          hintText: "Type in your first name",
                        ),
                      ),
                      _gap,
                      TextFormField(
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          hintText: "Type in your last name",
                        ),
                      ),
                      _gap,
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: "Type in your email",
                        ),
                      ),
                      _gap,
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: _isObscure,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: "Type in your password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      _highGap,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Perform login action
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => const DashboardScreen()));
                              final user = AuthEntity(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              await ref
                                  .read(authViewModelProvider.notifier)
                                  .register(user);
                            }
                            // showMySnackBar(message: "Successfully registered");
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      _highGap,
                      const SizedBox(
                          child: Text(
                        'OR REGISTER WITH',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                      SizedBox(
                        child: Image.asset(
                          'assets/images/google_login.png',
                          height: 90,
                          width: 90,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              NavigateRoute.pushRoute(const LoginView());
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF1DB954),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
