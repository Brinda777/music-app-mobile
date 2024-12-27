import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';

final artistApiModelProvider = Provider<ArtistApiModel>(
      (ref) => ArtistApiModel.empty(),
);

@JsonSerializable()
class ArtistApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? displayName;
  final String? imageUrl;

  const ArtistApiModel({
    this.id,
    this.displayName,
    this.imageUrl
  });

  const ArtistApiModel.empty()
      : id = '',
        displayName = '',
        imageUrl = '';

  // From Json , write full code without generator
  factory ArtistApiModel.fromJson(Map<String, dynamic> json) {
    return ArtistApiModel(
        id: json['_id'],
        displayName: json['displayName'],
        imageUrl: json['imageUrl'],
    );
  }

  // To Json , write full code without generator
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'imageUrl': imageUrl,
    };
  }

  // Convert API Object to Entity
  ArtistEntity toEntity() => ArtistEntity(
      id: id,
      displayName: displayName,
      imageUrl: imageUrl,
  );

  // Convert Entity to API Object
  ArtistApiModel fromEntity(ArtistEntity entity) => ArtistApiModel(
      id: entity.id ?? '',
      displayName: entity.displayName,
      imageUrl: entity.imageUrl,
  );

  // Convert API List to Entity List
  List<ArtistEntity> toEntityList(List<ArtistApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [id, displayName, imageUrl];
}
