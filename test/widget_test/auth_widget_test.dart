import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sangeet/app/navigator_key/navigator_key.dart';
import 'package:sangeet/app/themes/app_theme.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';
import 'package:sangeet/features/authentication/domain/usecases/auth_usecase.dart';
import 'package:sangeet/features/authentication/presentation/navigator/login_navigator.dart';
import 'package:sangeet/features/authentication/presentation/view/login_view.dart';
import 'package:sangeet/features/authentication/presentation/view/register_view.dart';
import 'package:sangeet/features/authentication/presentation/viewmodel/auth_view_model.dart';

import '../unit_test/auth_unit_test.mocks.dart';

void main() {
  late AuthUseCase mockAuthUsecase;

  setUp(() {
    mockAuthUsecase = MockAuthUseCase();
  });

  testWidgets(
      'Login with email and password and check weather dashboard opens or not',
      (tester) async {
    // Arrange
    const correctEmail = 'a@gmail.com';
    const correctPassword = 'password';

    when(mockAuthUsecase.login(any, any)).thenAnswer((invocation) {
      final email = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;
      return Future.value(email == correctEmail && password == correctPassword
          ? const Right(true)
          : Left(Failure(error: 'Invalid Credentails')));
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(
              ref.read(loginViewNavigatorProvider),
              mockAuthUsecase,
            ),
          )
        ],
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Sangeet',
          theme: AppTheme.getApplicationTheme(false),
          home: const LoginView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'a@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');

    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Login'),
    );

    await tester.pumpAndSettle();

    expect(find.text('Good'), findsOneWidget);
  });

  // Invalid username and password
  testWidgets(
      'Login with invalid email and password and check weather snackbar appears or not!',
      (tester) async {
    // Arrange
    const correctEmail = 'a@gmail.com';
    const correctPassword = 'password';

    when(mockAuthUsecase.login(any, any)).thenAnswer((invocation) {
      final email = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;
      return Future.value(email == correctEmail && password == correctPassword
          ? const Right(true)
          : Left(Failure(error: 'Invalid Credentails')));
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(
              ref.read(loginViewNavigatorProvider),
              mockAuthUsecase,
            ),
          )
        ],
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Sangeet',
          theme: AppTheme.getApplicationTheme(false),
          home: const LoginView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Type in first textformfield/TextField
    await tester.enterText(find.byType(TextField).at(0), 'a@gmail.com');
    // Type in second textformfield
    await tester.enterText(find.byType(TextField).at(1), 'wrong password');

    // expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Login'),
    );

    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  // User Registration
  testWidgets('Register user', (tester) async {
    // Arrange
    const user = AuthEntity(
      firstName: 'Bijaya',
      lastName: 'Majhi',
      email: 'a@gmail.com',
      password: 'password',
    );
    when(mockAuthUsecase.register(user))
        .thenAnswer((_) async => const Right(true));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(
              ref.read(loginViewNavigatorProvider),
              mockAuthUsecase,
            ),
          ),
        ],
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Sangeet',
          theme: AppTheme.getApplicationTheme(false),
          home: const RegisterView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Act
    await tester.enterText(find.byType(TextFormField).at(0), 'Bijaya');
    await tester.enterText(find.byType(TextFormField).at(1), 'Majhi');
    await tester.enterText(find.byType(TextFormField).at(2), 'a@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(3), 'password');

    await tester.pumpAndSettle();

    final registerButtonFinder =
        find.widgetWithText(ElevatedButton, 'Register');
    await tester.tap(registerButtonFinder);

    await tester.pumpAndSettle();

    // Assert
    expect(find.widgetWithText(SnackBar, 'Successfully registered'),
        findsOneWidget);
  });
}
