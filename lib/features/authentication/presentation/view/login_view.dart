import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/features/authentication/presentation/viewmodel/auth_view_model.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  // Form Key
  final _formKey = GlobalKey<FormState>();
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
                child:
                const Text(
                  // 'Welcome to Sangeet\nPlease sign in to continue',
                  'Please Sign In to Continue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ThemeConstant.neutralColor
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          color: Colors.white
                        ),
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
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: "Type in your password",
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off, color: Colors.white,),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      _gap,
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Handle forgot password logic here
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      _highGap,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await ref
                                  .read(authViewModelProvider.notifier)
                                  .login(_emailController.text,
                                      _passwordController.text);
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 25,
                              // color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      _highGap,
                      const SizedBox(
                          child: Text(
                        'OR LOGIN WITH',
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
                            "Don't have an account?",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(authViewModelProvider.notifier)
                                  .openRegisterView();
                            },
                            child: const Text("Register",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF337DC5),
                              ),)
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
