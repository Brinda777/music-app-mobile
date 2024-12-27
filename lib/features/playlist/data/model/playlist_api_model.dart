import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';
import 'package:sangeet/features/song/data/model/song_api_model.dart';

final playlistApiModelProvider = Provider<PlaylistApiModel>(
  (ref) => PlaylistApiModel.empty(),
);

@JsonSerializable()
class PlaylistApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? userId;
  final List<SongApiModel>? songs;
  final String? createdAt;

  const PlaylistApiModel(
      {this.id, this.userId, this.songs, this.name, this.createdAt});

  const PlaylistApiModel.empty()
      : id = '',
        userId = '',
        name = '',
        songs = const [],
        createdAt = '';

  // From Json
  factory PlaylistApiModel.fromJson(Map<String, dynamic> json) {
    return PlaylistApiModel(
        id: json['_id'] as String?,
        userId: json['userId'] as String?,
        name: json['name'] as String?,
        songs: (json['songs'] as List<dynamic>?)
            ?.map((e) => SongApiModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: json['createdAt'] as String?);
  }

  // To Json
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'userId': userId,
      'songs': songs?.map((song) => song.toJson()).toList(),
      'createdAt': createdAt
    };
  }

  // Convert API Object to Entity
  PlaylistEntity toEntity() => PlaylistEntity(
      id: id,
      name: name,
      userId: userId,
      songs: SongApiModel.toEntityList(songs ?? []),
      createdAt: createdAt);

  // Convert Entity to API Object
  factory PlaylistApiModel.fromEntity(PlaylistEntity entity) =>
      PlaylistApiModel(
          id: entity.id,
          name: entity.name,
          userId: entity.userId,
          songs: entity.songs
                  ?.map((song) => SongApiModel.fromEntity(song))
                  .toList() ??
              [],
          createdAt: entity.createdAt);

  // Convert API List to Entity List
  static List<PlaylistEntity> toEntityList(List<PlaylistApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [id, name, userId, songs, createdAt];
}
