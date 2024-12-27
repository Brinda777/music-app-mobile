import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';
import 'package:sangeet/features/artist/domain/usecases/artist_usecase.dart';
import 'package:sangeet/features/artist/presentation/viewmodel/artist_view_model.dart';

import 'artist_unit_test.mocks.dart';
import 'test_data/artist_test_data.dart';

@GenerateNiceMocks([
  MockSpec<ArtistUseCase>(),
])

void main () {
  TestWidgetsFlutterBinding.ensureInitialized();

  TestWidgetsFlutterBinding.ensureInitialized();

  late ArtistUseCase mockArtistUseCase;
  late ProviderContainer container;
  late List<ArtistEntity> lstArtists;

  setUp(
        () {
          mockArtistUseCase = MockArtistUseCase();
      lstArtists = ArtistTestData.getArtistTestData();
      container = ProviderContainer(
        overrides: [
          artistViewmodelProvider.overrideWith(
                (ref) => ArtistViewModel(mockArtistUseCase),
          )
        ],
      );
    },
  );

  test('check artist initial state', () async {
    //Arrange
    when(mockArtistUseCase.getAllArtists(1))
        .thenAnswer((_) => Future.value(Right(lstArtists)));

    // Get all artists
    await container.read(artistViewmodelProvider.notifier).getAllArtists();

    // Act
    // Store the state
    final artistState = container.read(artistViewmodelProvider);

    // Assert
    // Check the state
    expect(artistState.isLoading, false);
    expect(artistState.error, isNull);
    expect(artistState.lstArtists, isNotEmpty);
  });

  tearDown(() {
    container.dispose();
  });
}