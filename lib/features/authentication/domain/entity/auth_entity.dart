import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? userType;
  final String? dob;
  final String? gender;
  final String? imageUrl;
  final List<Object?>? genres;

  const AuthEntity({
    this.id,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.userType,
    this.dob,
    this.gender,
    this.imageUrl,
    this.genres
  });

  @override
  List<Object?> get props =>
      [id, email, password, firstName, lastName, userType, dob, gender, imageUrl, genres];
}
