import 'package:json_annotation/json_annotation.dart';
import 'package:sangeet/features/authentication/domain/entity/auth_entity.dart';

part 'get_current_user_dto.g.dart';

@JsonSerializable()
class GetCurrentUserDto {
  @JsonKey(name:"_id")
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? dob;
  final String? gender;
  final List<Object?>? genres;

  GetCurrentUserDto({
     this.id,
     this.firstName,
     this.lastName,
     this.email,
     this.dob,
     this.gender,
     this.genres,
  });

  AuthEntity toEntity() {
    return AuthEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        dob: dob,
        gender: gender,
        genres:  []
        );
  }

  factory GetCurrentUserDto.fromJson(Map<String, dynamic> json) =>
      _$GetCurrentUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetCurrentUserDtoToJson(this);
}
