import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sangeet/features/favorite/domain/entity/favorite_entity.dart';
import 'package:sangeet/features/song/data/model/song_api_model.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

final favoriteApiModelProvider = Provider<FavoriteApiModel>(
      (ref) => FavoriteApiModel.empty(),
);

@JsonSerializable()
class FavoriteApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? userId;
  final SongApiModel? song;

  const FavoriteApiModel({this.id, this.userId, this.song});

  const FavoriteApiModel.empty()
      : id = '',
        userId = '',
        song = const SongApiModel(
            title: '',
            artist: '',
            audioUrl: '',
            favoriteCount: 0,
            genre: '',
            imageUrl: '',
            playCount: 0);

  // From Json
  factory FavoriteApiModel.fromJson(Map<String, dynamic> json) {
    return FavoriteApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      song: json['song'] != null
          ? SongApiModel.fromJson(json['song'] as Map<String, dynamic>)
          : null,
    );
  }

  // To Json
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'song': song?.toJson(),
    };
  }

  // Convert API Object to Entity
  FavoriteEntity toEntity() => FavoriteEntity(
    id: id,
    userId: userId,
    song: song?.toEntity(),
  );

  // Convert Entity to API Object
  factory FavoriteApiModel.fromEntity(FavoriteEntity entity) => FavoriteApiModel(
    id: entity.id,
    userId: entity.userId,
    song: SongApiModel.fromEntity(entity.song!),
  );

  // Convert API List to Entity List
  static List<FavoriteEntity> toEntityList(List<FavoriteApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [id, userId, song];
}
