import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';
import 'package:sangeet/features/playlist/domain/usecases/playlist_usecase.dart';
import 'package:sangeet/features/playlist/presentation/view_model/playlist_view_model.dart';

import 'playlist_unit_test.mocks.dart';
import 'test_data/playlist_test_data.dart';

@GenerateNiceMocks([
  MockSpec<PlaylistUseCase>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PlaylistUseCase mockPlaylistUseCase;
  late ProviderContainer container;
  late List<PlaylistEntity> lstPlaylists;

  setUp(() {
    mockPlaylistUseCase = MockPlaylistUseCase();
    lstPlaylists = PlaylistTestData.getPlaylistTestData();
    container = ProviderContainer(
      overrides: [
        playlistViewmodelProvider.overrideWith(
          (ref) => PlaylistViewModel(mockPlaylistUseCase),
        )
      ],
    );
  });

  test('check playlist initial state', () async {
    // Arrange
    when(mockPlaylistUseCase.getAllPlaylists(1))
        .thenAnswer((_) => Future.value(Right(lstPlaylists)));

    // Act
    await container.read(playlistViewmodelProvider.notifier).getAllPlaylists();

    // Assert
    final playlistState = container.read(playlistViewmodelProvider);
    expect(playlistState.isLoading, false);
    expect(playlistState.error, isNull);
    expect(playlistState.lstPlaylists, isNotEmpty);
  });

  test('create playlist', () async {
    const name = 'my playlist';

    // Arrange: Mock the addPlaylist method
    when(mockPlaylistUseCase.addPlaylist(name))
        .thenAnswer((_) => Future.value(const Right(true)));

    // Arrange: Mock the getAllPlaylists method to return a non-empty list
    when(mockPlaylistUseCase.getAllPlaylists(1))
        .thenAnswer((_) => Future.value(const Right([]))); // Return an empty list or a list with playlists

    // Act: Trigger the addPlaylist method
    await container.read(playlistViewmodelProvider.notifier).addPlaylist(name);

    // Assert: Check the state after the operation
    final playlistState = container.read(playlistViewmodelProvider);

    // Assert that the state has the expected values
    expect(playlistState.isLoading, true);
    expect(playlistState.error, isNull);
    expect(playlistState.lstPlaylists, isEmpty); // Assuming it reloads the playlists
  });

  tearDown(() {
    container.dispose();
  });
}
