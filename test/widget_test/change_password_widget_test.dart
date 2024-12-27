import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sangeet/app/navigator_key/navigator_key.dart';
import 'package:sangeet/app/themes/app_theme.dart';
import 'package:sangeet/features/profile/domain/usecases/user_usecase.dart';
import 'package:sangeet/features/profile/presentation/view/change_password_view.dart';
import 'package:sangeet/features/profile/presentation/viewmodel/user_view_model.dart';

import 'change_password_widget_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserUseCase>(),
])
void main() {
  late UserUseCase mockUserUsecase;

  setUp(() {
    mockUserUsecase = MockUserUseCase();
  });

  testWidgets('Change Password and check snackbar message', (tester) async {
    // Arrange
    when(mockUserUsecase.changePassword('oldPassword', 'newPassword'))
        .thenAnswer((_) async => const Right(true));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userViewModelProvider.overrideWith(
            (ref) => UserViewModel(userUseCase: mockUserUsecase),
          ),
        ],
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Sangeet',
          theme: AppTheme.getApplicationTheme(false),
          home: const ChangePasswordView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Act
    await tester.enterText(find.byType(TextFormField).at(0), 'oldPassword');
    await tester.enterText(find.byType(TextFormField).at(1), 'newPassword');
    await tester.enterText(find.byType(TextFormField).at(2), 'newPassword');

    await tester.pumpAndSettle();

    final changePasswordButtonFinder =
        find.widgetWithText(ElevatedButton, 'Change Password');
    await tester.tap(changePasswordButtonFinder);

    await tester.pumpAndSettle();

    // Assert
    expect(find.widgetWithText(SnackBar, 'Password has been changed.'),
        findsOneWidget);
  });
}
