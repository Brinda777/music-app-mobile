import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/core/networking/remote/http_service.dart';
import 'package:sangeet/core/shared_prefs/auth_shared_prefs.dart';
import 'package:sangeet/features/artist/data/model/artist_api_model.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';

final artistRemoteDataSourceProvider = Provider(
      (ref) => ArtistRemoteDataSource(
      dio: ref.read(httpServiceProvider),
      artistApiModel: ref.read(artistApiModelProvider),
      authSharedPrefs: ref.read(authSharedPrefsProvider)
  ),
);

class ArtistRemoteDataSource {
  final Dio dio;
  final ArtistApiModel artistApiModel;
  final AuthSharedPrefs authSharedPrefs;

  ArtistRemoteDataSource({
    required this.dio,
    required this.artistApiModel,
    required this.authSharedPrefs
  });

  Future<Either<Failure, List<ArtistEntity>>> getAllArtists(int page) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get(ApiEndpoints.getArtists,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          'page': page,
          'limit': ApiEndpoints.limitPage,
        },
      );
      if (response.statusCode == 200) {
        // 1st way
        return Right(
          (response.data['data']['artist'] as List)
              .map((artist) => ArtistApiModel.fromJson(artist).toEntity())
              .toList(),
        );
        // OR
        // 2nd way
        // GetAllBatchDTO batchAddDTO = GetAllBatchDTO.fromJson(response.data);
        // return Right(batchApiModel.toEntityList(batchAddDTO.data));
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, ArtistEntity>> getArtist(String id) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get('${ApiEndpoints.getArtistById}/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        })
      );
      if (response.statusCode == 200) {
        final artist = ArtistApiModel.fromJson(response.data['data']['artist']).toEntity();
        return Right(artist);
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }
}
