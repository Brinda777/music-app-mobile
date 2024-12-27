import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';
import 'package:sangeet/features/artist/domain/repository/artist_repository.dart';

final artistUsecaseProvider = Provider<ArtistUseCase>(
      (ref) => ArtistUseCase(
    artistRepository: ref.read(artistRepositoryProvider),
  ),
);

class ArtistUseCase {
  final IArtistRepository artistRepository;

  ArtistUseCase({required this.artistRepository});

  // For getting all songs
  Future<Either<Failure, List<ArtistEntity>>> getAllArtists(int page) {
    return artistRepository.getAllArtists(page);
  }

  Future<Either<Failure, ArtistEntity>> getArtist(String id) {
    return artistRepository.getArtist(id);
  }
}
