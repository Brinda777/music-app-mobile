import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/core/networking/remote/http_service.dart';
import 'package:sangeet/core/shared_prefs/auth_shared_prefs.dart';
import 'package:sangeet/features/genre/data/model/genre_model.dart';
import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';

final genreRemoteDataSourceProvider = Provider(
      (ref) => GenreRemoteDataSource(
      dio: ref.read(httpServiceProvider),
      genreApiModel: ref.read(genreApiModelProvider),
      authSharedPrefs: ref.read(authSharedPrefsProvider)
  ),
);

class GenreRemoteDataSource {
  final Dio dio;
  final GenreApiModel genreApiModel;
  final AuthSharedPrefs authSharedPrefs;

  GenreRemoteDataSource({
    required this.dio,
    required this.genreApiModel,
    required this.authSharedPrefs
  });

  Future<Either<Failure, List<GenreEntity>>> getAllGenres(int page) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get(ApiEndpoints.getGenres,
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
          (response.data['data']['genre'] as List)
              .map((genre) => GenreApiModel.fromJson(genre).toEntity())
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
}
