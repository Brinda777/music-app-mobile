import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/core/networking/remote/http_service.dart';
import 'package:sangeet/core/shared_prefs/auth_shared_prefs.dart';
import 'package:sangeet/features/profile/domain/entity/user_entity.dart';

final userRemoteDataSourceProvider = Provider(
  (ref) => UserRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    authSharedPrefs: ref.read(authSharedPrefsProvider),
  ),
);

class UserRemoteDataSource {
  final Dio dio;
  final AuthSharedPrefs authSharedPrefs;

  UserRemoteDataSource({required this.dio, required this.authSharedPrefs});

  Future<Either<Failure, bool>> editUser(UserEntity user) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );
      Response response = await dio.patch(
        ApiEndpoints.editUser,
        data: {
          "firstName": user.firstName,
          "lastName": user.lastName,
          "gender": user.gender,
          "dob": user.dob,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        // Check response data type before accessing
        final responseData = response.data as Map<String, dynamic>?;
        final errorMessage = responseData?["data"]?['message'] ?? 'Unknown error';
        return Left(
          Failure(
            error: errorMessage,
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }


  Future<Either<Failure, bool>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      Response response = await dio.patch(
        ApiEndpoints.changePassword,
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["data"]['message'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
