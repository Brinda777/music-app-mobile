import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';
import 'package:sangeet/features/genre/domain/usecases/genre_usecase.dart';
import 'package:sangeet/features/genre/presentation/viewmodel/genre_view_model.dart';

import 'genre_unit_test.mocks.dart';
import 'test_data/genre_test_data.dart';

@GenerateNiceMocks([
  MockSpec<GenreUsecase>(),
])

void main () {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GenreUsecase mockGenreUseCase;
  late ProviderContainer container;
  late List<GenreEntity> lstGenres;

  setUp(
        () {
          mockGenreUseCase = MockGenreUsecase();
          lstGenres = GenreTestData.getGenreTestData();
      container = ProviderContainer(
        overrides: [
          genreViewmodelProvider.overrideWith(
                (ref) => GenreViewModel(mockGenreUseCase),
          )
        ],
      );
    },
  );

  test('check genre initial state', () async {
    //Arrange
    when(mockGenreUseCase.getAllGenres(1))
        .thenAnswer((_) => Future.value(Right(lstGenres)));

    // Get all genres
    await container.read(genreViewmodelProvider.notifier).getAllGenres();

    // Act
    // Store the state
    final genreState = container.read(genreViewmodelProvider);

    // Assert
    // Check the state
    expect(genreState.isLoading, false);
    expect(genreState.error, isNull);
    expect(genreState.lstGenres, isNotEmpty);
  });

  tearDown(() {
    container.dispose();
  });
}