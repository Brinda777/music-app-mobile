import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';
import 'package:sangeet/features/song/domain/usecases/song_usecase.dart';
import 'package:sangeet/features/song/presentation/viewmodel/song_view_model.dart';

import 'song_unit_test.mocks.dart';
import 'test_data/song_test_data.dart';

@GenerateNiceMocks([
  MockSpec<SongUseCase>(),
])

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SongUseCase mockSongUseCase;
  late ProviderContainer container;
  late List<SongEntity> lstSongs;

  setUp(
        () {
      mockSongUseCase = MockSongUseCase();
      lstSongs = SongTestData.getSongTestData();
      container = ProviderContainer(
        overrides: [
          songViewmodelProvider.overrideWith(
                (ref) => SongViewmodel(mockSongUseCase),
          )
        ],
      );
    },
  );

  test('check song initial state', () async {
    //Arrange
    when(mockSongUseCase.getAllSongs(1))
        .thenAnswer((_) => Future.value(Right(lstSongs)));

    // Get all songs
    await container.read(songViewmodelProvider.notifier).getAllSongs();

    // Act
    // Store the state
    final songState = container.read(songViewmodelProvider);

    // Assert
    // Check the state
    expect(songState.isLoading, false);
    expect(songState.error, isNull);
    expect(songState.lstSongs, isNotEmpty);
  });

  tearDown(() {
    container.dispose();
  });
}
