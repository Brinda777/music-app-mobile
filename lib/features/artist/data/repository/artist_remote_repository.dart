import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/features/artist/data/data_source/remote/artist_remote_data_source.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';
import 'package:sangeet/features/artist/domain/repository/artist_repository.dart';

final artistRemoteRepositoryProvider = Provider<IArtistRepository>(
      (ref) => ArtistRemoteRepository(
    artistRemoteDataSource: ref.read(artistRemoteDataSourceProvider),
  ),
);

class ArtistRemoteRepository implements IArtistRepository {
  final ArtistRemoteDataSource artistRemoteDataSource;

  ArtistRemoteRepository({required this.artistRemoteDataSource});

  @override
  Future<Either<Failure, List<ArtistEntity>>> getAllArtists(int page) {
    return artistRemoteDataSource.getAllArtists(page);
  }

  @override
  Future<Either<Failure, ArtistEntity>> getArtist(String id) {
    return artistRemoteDataSource.getArtist(id);
  }
}
