import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/core/failure/failure.dart';
import 'package:sangeet/core/networking/remote/http_service.dart';
import 'package:sangeet/core/shared_prefs/auth_shared_prefs.dart';
import 'package:sangeet/features/authentication/data/data_source/dto/get_current_user_dto.dart';
import 'package:sangeet/features/authentication/data/model/auth_api_model.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    authSharedPrefs: ref.read(authSharedPrefsProvider),
  ),
);

class AuthRemoteDataSource {
  final Dio dio;
  final AuthSharedPrefs authSharedPrefs;

  AuthRemoteDataSource({required this.dio, required this.authSharedPrefs});

  Future<Either<Failure, bool>> register(AuthEntity user) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.register,
        data: {
          "firstName": user.firstName,
          "lastName": user.lastName,
          "email": user.email,
          "password": user.password,
        },
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["data"],
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

  // Upload image using multipart
  Future<Either<Failure, String>> uploadProfilePicture(
      File image,
      ) async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );
      // Extract name from path
      // c:/user/username/pictures/image.png
      String fileName = image.path.split('/').last;

      FormData formData = FormData.fromMap(
        {
          'image': await MultipartFile.fromFile(
            image.path,
            filename: fileName,
          ),
        },
      );

      Response response = await dio.patch(
        ApiEndpoints.uploadImage,
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      return Right(response.data["data"]["message"]);
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> login(
    String email,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.login,
        data: {
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        // retrieve token
        // print({response.data["data"]["accessToken"]});
        String token = response.data["data"]["accessToken"];
        await authSharedPrefs.setAuthToken(token);
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
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

  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await authSharedPrefs.getAuthToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );

      var response = await dio.get(
        ApiEndpoints.currentUser,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        AuthApiModel user =
            AuthApiModel.fromJson(response.data['data']['userObject']);
        // User Properties on shared prefs
        // String? storedUser;
        // var data = await authSharedPrefs.getUser();
        // data.fold(
        //       (l) => storedUser = null,
        //       (r) => storedUser = r!,
        // );
        // if(storedUser == null) {
        //   AuthEntity user = response.data["data"]["userObject"];
        //   await authSharedPrefs.setUser(user);
        // }
        return Right(user.toEntity());
      } else {
        return Left(
          Failure(
            error: response.data["message"],
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

  Future<Either<Failure, bool>> logout() async {
    try {
      await authSharedPrefs.getAuthToken();
      return const Right(true);
    } catch(e) {
      return Left(
        Failure(
          error: 'Unable to logout',
          statusCode: 400.toString(),
        ),
      );
    }
  }
}
