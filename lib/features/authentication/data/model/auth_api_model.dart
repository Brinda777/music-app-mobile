import 'package:json_annotation/json_annotation.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel {
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

  AuthApiModel({
    this.id,
    this.firstName,
    this.lastName,
    this.imageUrl,
    this.email,
    this.password,
    this.dob,
    this.gender,
    this.genres
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      imageUrl: imageUrl,
      email: email,
      password: password ?? '',
      dob: dob,
      gender: gender,
      genres: genres
    );
  }
}
