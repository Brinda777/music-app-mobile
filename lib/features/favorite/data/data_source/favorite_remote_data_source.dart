import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/core/networking/remote/http_service.dart';
import 'package:sangeet/core/shared_prefs/auth_shared_prefs.dart';
import 'package:sangeet/features/favorite/data/model/favorite_api_model.dart';
import 'package:sangeet/features/favorite/domain/entity/favorite_entity.dart';

final favoriteRemoteDataSourceProvider = Provider(
  (ref) => FavoriteRemoteDataSource(
      dio: ref.read(httpServiceProvider),
      favoriteApiModel: ref.read(favoriteApiModelProvider),
      authSharedPrefs: ref.read(authSharedPrefsProvider)),
);

class FavoriteRemoteDataSource {
  final Dio dio;
  final FavoriteApiModel favoriteApiModel;
  final AuthSharedPrefs authSharedPrefs;

  FavoriteRemoteDataSource(
      {required this.dio,
      required this.favoriteApiModel,
      required this.authSharedPrefs});

  Future<Either<Failure, List<FavoriteEntity>>> getAllFavorites(
      int page) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.get(
        ApiEndpoints.getFavorites,
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
          (response.data['data']['favorite'] as List)
              .map((favorite) => FavoriteApiModel.fromJson(favorite).toEntity())
              .toList(),
        );
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

  Future<Either<Failure, bool>> addSongToFavorite(String songId) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.post(ApiEndpoints.getFavorites,
          data: {"songId": songId},
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        return const Right(true);
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

  Future<Either<Failure, bool>> removeSongFromFavorite(String songId) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.delete('${ApiEndpoints.getFavorites}/$songId',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        return const Right(true);
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

  Future<Either<Failure, FavoriteEntity>> getFavorite(String songId) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.get('${ApiEndpoints.getFavorites}/$songId',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        final res = response.data['data']['favorite'];
        return Right(FavoriteApiModel.fromJson(res).toEntity());
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
