import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sangeet/features/favorite/domain/entity/favorite_entity.dart';
import 'package:sangeet/features/favorite/domain/usecases/favorite_usecase.dart';
import 'package:sangeet/features/favorite/presentation/view_model/favorite_view_model.dart';

import 'favorite_unit_test.mocks.dart';
import 'test_data/favorite_test_data.dart';

@GenerateNiceMocks([
  MockSpec<FavoriteUseCase>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FavoriteUseCase mockFavoriteUseCase;
  late ProviderContainer container;
  late List<FavoriteEntity> lstFavorites;

  setUp(() {
    mockFavoriteUseCase = MockFavoriteUseCase();
    lstFavorites = FavoriteTestData.getFavoriteTestData();
    container = ProviderContainer(
      overrides: [
        favoriteViewmodelProvider.overrideWith(
              (ref) => FavoriteViewModel(mockFavoriteUseCase),
        )
      ],
    );
  });

  test('check favorite initial state', () async {
    // Arrange
    when(mockFavoriteUseCase.getAllFavorites(1))
        .thenAnswer((_) => Future.value(Right(lstFavorites)));

    // Act
    await container.read(favoriteViewmodelProvider.notifier).getAllFavorites();

    // Assert
    final favoriteState = container.read(favoriteViewmodelProvider);
    expect(favoriteState.isLoading, false);
    expect(favoriteState.error, isNull);
    expect(favoriteState.lstFavorites, isNotEmpty);
  });

  test('check add song to favorite', () async {
    const songId = '668cc58dcb6bbfd08a688ba9';
    when(mockFavoriteUseCase.addSongToFavorite(songId))
        .thenAnswer((_) => Future.value(const Right(true)));

    await container.read(favoriteViewmodelProvider.notifier).addSongToFavorite(songId);

    final favoriteState = container.read(favoriteViewmodelProvider);

    expect(favoriteState.isLoading, false);
    expect(favoriteState.error, isNull);
    expect(favoriteState.lstFavorites, isNotEmpty);
  });



  tearDown(() {
    container.dispose();
  });
}
