import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/core/networking/remote/http_service.dart';
import 'package:sangeet/core/shared_prefs/auth_shared_prefs.dart';
import 'package:sangeet/features/song/data/model/song_api_model.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

final songRemoteDataSourceProvider = Provider(
      (ref) => SongRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    songApiModel: ref.read(songApiModelProvider),
        authSharedPrefs: ref.read(authSharedPrefsProvider)
  ),
);

class SongRemoteDataSource {
  final Dio dio;
  final SongApiModel songApiModel;
  final AuthSharedPrefs authSharedPrefs;

  SongRemoteDataSource({
    required this.dio,
    required this.songApiModel,
    required this.authSharedPrefs
  });

  Future<Either<Failure, List<SongEntity>>> getAllSongs(int page) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get(ApiEndpoints.getSongs,
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
          (response.data['data']['song'] as List)
              .map((song) => SongApiModel.fromJson(song).toEntity())
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

  Future<Either<Failure, List<SongEntity>>> getTrendingSongs(int page) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get(ApiEndpoints.getTrendingSongs,
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
          (response.data['data']['song'] as List)
              .map((song) => SongApiModel.fromJson(song).toEntity())
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

  Future<Either<Failure, List<SongEntity>>> getPopularSongs(int page) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get(ApiEndpoints.getPopularSongs,
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
          (response.data['data']['song'] as List)
              .map((song) => SongApiModel.fromJson(song).toEntity())
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

  Future<Either<Failure, List<SongEntity>>> searchAllSongs(int page, String keyword) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get(ApiEndpoints.getSongs,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          'page': page,
          'limit': ApiEndpoints.limitPage,
          'keyword': keyword
        },
      );
      if (response.statusCode == 200) {
        // 1st way
        return Right(
          (response.data['data']['song'] as List)
              .map((song) => SongApiModel.fromJson(song).toEntity())
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


  Future<Either<Failure, List<SongEntity>>> getSongsByArtist(int page, String keyword) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get(ApiEndpoints.getSongsByArtist,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          'page': page,
          'limit': ApiEndpoints.limitPage,
          'keyword': keyword
        },
      );
      if (response.statusCode == 200) {
        // 1st way
        return Right(
          (response.data['data']['song'] as List)
              .map((song) => SongApiModel.fromJson(song).toEntity())
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

  Future<Either<Failure, List<SongEntity>>> getSongsByGenre(int page, String keyword) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get(ApiEndpoints.getSongsByGenre,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          'page': page,
          'limit': ApiEndpoints.limitPage,
          'keyword': keyword
        },
      );
      if (response.statusCode == 200) {
        // 1st way
        return Right(
          (response.data['data']['song'] as List)
              .map((song) => SongApiModel.fromJson(song).toEntity())
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
