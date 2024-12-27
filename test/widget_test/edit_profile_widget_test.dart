import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sangeet/app/navigator_key/navigator_key.dart';
import 'package:sangeet/app/themes/app_theme.dart';
import 'package:sangeet/features/profile/domain/entity/user_entity.dart';
import 'package:sangeet/features/profile/domain/usecases/user_usecase.dart';
import 'package:sangeet/features/profile/presentation/view/edit_profile_view.dart';
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

  testWidgets('Edit User Personal Details and check snackbar message',
      (tester) async {
    const user = UserEntity(
        firstName: 'Bijaya',
        lastName: 'Majhi',
        gender: 'Male',
        dob: '1999/11/09');
    // Arrange
    when(mockUserUsecase.editUser(user))
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
          home: const EditProfileView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Act
    await tester.enterText(find.byType(TextFormField).at(0), 'Bijaya');
    await tester.enterText(find.byType(TextFormField).at(1), 'Majhi');
    await tester.enterText(
        find.byType(InputDatePickerFormField).at(0), '1999-11-09');
    await tester.enterText(find.byType(DropdownButtonFormField).at(0), 'male');

    await tester.pumpAndSettle();

    final editProfileButtonFinder = find.widgetWithText(ElevatedButton, 'Save');
    await tester.tap(editProfileButtonFinder);

    await tester.pumpAndSettle();

    // Assert
    expect(find.widgetWithText(SnackBar, 'User has been updated.'),
        findsOneWidget);
  });
}
