import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';

final genreApiModelProvider = Provider<GenreApiModel>(
      (ref) => GenreApiModel.empty(),
);

@JsonSerializable()
class GenreApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;

  const GenreApiModel({
    this.id,
    this.name
  });

  const GenreApiModel.empty()
      : id = '',
        name = '';

  // From Json , write full code without generator
  factory GenreApiModel.fromJson(Map<String, dynamic> json) {
    return GenreApiModel(
      id: json['_id'],
      name: json['name']
    );
  }

  // To Json , write full code without generator
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  // Convert API Object to Entity
  GenreEntity toEntity() => GenreEntity(
    id: id,
    name: name,
  );

  // Convert Entity to API Object
  GenreApiModel fromEntity(GenreEntity entity) => GenreApiModel(
    id: entity.id ?? '',
    name: entity.name
  );

  // Convert API List to Entity List
  List<GenreEntity> toEntityList(List<GenreApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [id, name];
}
