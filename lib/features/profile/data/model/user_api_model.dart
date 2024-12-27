import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sangeet/features/profile/domain/entity/user_entity.dart';

final userApiModelProvider = Provider<UserApiModel>(
  (ref) => UserApiModel.empty(),
);

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;
  final String? email;
  final String? password;
  final String? dob;
  final String? gender;
  final List<Map<String, dynamic>>? genres;
  final String? newPassword;
  final String? confirmNewPassword;

  const UserApiModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.imageUrl,
      this.email,
      this.password,
      this.dob,
      this.gender,
      this.genres,
      this.newPassword,
      this.confirmNewPassword});

  const UserApiModel.empty()
      : id = '',
        firstName = '',
        lastName = '',
        imageUrl = '',
        email = '',
        password = '',
        dob = '',
        gender = '',
        genres = null,
        newPassword = '',
        confirmNewPassword = '';

  // From Json , write full code without generator
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imageUrl: json['imageUrl'],
      email: json['email'],
      password: json['password'],
      dob: json['dob'],
      gender: json['gender'],
      genres: json['genres'],
      newPassword: json['newPassword'],
      confirmNewPassword: json['confirmNewPassword'],
    );
  }

  // To Json , write full code without generator
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'imageUrl': imageUrl,
      'lastName': lastName,
      'email': email,
      'password': password,
      'dob': dob,
      'gender': gender,
      'genres': genres,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    };
  }

  // Convert API Object to Entity
  UserEntity toEntity() => UserEntity(
      id: id,
      firstName: firstName,
      imageUrl: imageUrl,
      lastName: lastName,
      email: email,
      password: password,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
      dob: dob,
      gender: gender);

  // Convert Entity to API Object
  UserApiModel fromEntity(UserEntity entity) => UserApiModel(
      id: entity.id ?? '',
      firstName: entity.firstName,
      imageUrl: entity.imageUrl,
      lastName: entity.lastName,
      email: entity.email,
      dob: entity.dob,
      gender: entity.gender,
      password: entity.password,
      newPassword: entity.newPassword,
      confirmNewPassword: entity.confirmNewPassword);

  // Convert API List to Entity List
  List<UserEntity> toEntityList(List<UserApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        id,
        firstName,
        imageUrl,
        lastName,
        email,
        password,
        dob,
        gender,
        newPassword,
        confirmNewPassword
      ];
}
