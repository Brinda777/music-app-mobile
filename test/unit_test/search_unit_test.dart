import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sangeet/features/search/presentation/view_model/search_view_model.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';
import 'package:sangeet/features/song/domain/usecases/song_usecase.dart';

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

  setUp(() {
    mockSongUseCase = MockSongUseCase();
    lstSongs = SongTestData.getSongTestData();
    container = ProviderContainer(
      overrides: [
        searchViewmodelProvider.overrideWith(
              (ref, keyword) => SearchViewmodel(mockSongUseCase, keyword),
        ),
      ],
    );
  });

  test('check search initial state', () async {
    const keyword = 'ab';

    // Arrange
    when(mockSongUseCase.searchAllSongs(1, keyword))
        .thenAnswer((_) => Future.value(Right(lstSongs)));

    // Act
    final searchViewmodel = container.read(searchViewmodelProvider(keyword).notifier);
    await searchViewmodel.searchAllSongs(keyword); // Trigger the search

    // Assert
    final songState = container.read(searchViewmodelProvider(keyword)); // Read the updated state

    expect(songState.isLoading, false);
    expect(songState.error, isNull);
    expect(songState.lstSongs, isNotEmpty);
  });

  tearDown(() {
    container.dispose();
  });
}
