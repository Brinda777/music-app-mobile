import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/core/networking/remote/http_service.dart';
import 'package:sangeet/core/shared_prefs/auth_shared_prefs.dart';
import 'package:sangeet/features/playlist/data/model/playlist_api_model.dart';
import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';

final playlistRemoteDataSourceProvider = Provider(
  (ref) => PlaylistRemoteDataSource(
      dio: ref.read(httpServiceProvider),
      playlistApiModel: ref.read(playlistApiModelProvider),
      authSharedPrefs: ref.read(authSharedPrefsProvider)),
);

class PlaylistRemoteDataSource {
  final Dio dio;
  final PlaylistApiModel playlistApiModel;
  final AuthSharedPrefs authSharedPrefs;

  PlaylistRemoteDataSource(
      {required this.dio,
      required this.playlistApiModel,
      required this.authSharedPrefs});

  Future<Either<Failure, List<PlaylistEntity>>> getAllPlaylists(
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
        ApiEndpoints.getPlaylists,
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
          (response.data['data']['userPlaylists'] as List)
              .map((playlist) => PlaylistApiModel.fromJson(playlist).toEntity())
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

  Future<Either<Failure, bool>> addSongToPlaylist(
      String playlistId, String songId) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.patch(
          '${ApiEndpoints.getPlaylists}/$playlistId/song/$songId',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 201) {
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

  Future<Either<Failure, bool>> addPlaylist(String name) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.post(ApiEndpoints.getPlaylists,
          data: {'name': name},
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 201) {
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

  Future<Either<Failure, bool>> updatePlaylist(
      String playlistId, String name) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.patch('${ApiEndpoints.getPlaylists}/$playlistId',
          data: {'name': name},
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

  Future<Either<Failure, bool>> deletePlaylist(String playlistId) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response =
          await dio.delete('${ApiEndpoints.getPlaylists}/$playlistId',
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

  Future<Either<Failure, PlaylistEntity>> getPlaylist(String playlistId) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.get('${ApiEndpoints.getPlaylists}/$playlistId',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        final res = response.data['data']['playlist'];
        return Right(PlaylistApiModel.fromJson(res).toEntity());
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
