import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/artist/data/repository/artist_remote_repository.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';

final artistRepositoryProvider = Provider<IArtistRepository>((ref) {
  return ref.read(artistRemoteRepositoryProvider);
});

abstract class IArtistRepository {
  Future<Either<Failure, List<ArtistEntity>>> getAllArtists(int page);
  Future<Either<Failure, ArtistEntity>> getArtist(String id);
}
