import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';
import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

final songApiModelProvider = Provider<SongApiModel>(
      (ref) => SongApiModel.empty(),
);

@JsonSerializable()
class SongApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? title;
  final String? imageUrl;
  final String? audioUrl;
  final int? favoriteCount;
  final int? playCount;
  final String? artist;
  final String? genre;

  const SongApiModel({
    this.id,
    this.title,
    this.imageUrl,
    this.audioUrl,
    this.favoriteCount,
    this.playCount,
    this.artist,
    this.genre,
  });

  const SongApiModel.empty()
      : id = '',
        title = '',
        imageUrl = '',
        audioUrl = '',
        favoriteCount = 0,
        playCount = 0,
        artist = '',
        genre = '';

  // From Json
  factory SongApiModel.fromJson(Map<String, dynamic> json) {
    return SongApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      favoriteCount: json['favoriteCount'] as int?,
      playCount: json['playCount'] as int?,
      artist: json['artist'] as String?,
      genre: json['genre'] as String?,
    );
  }

  // To Json
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'favoriteCount': favoriteCount,
      'playCount': playCount,
      'artist': artist,
      'genre': genre,
    };
  }

  // Convert API Object to Entity
  SongEntity toEntity() => SongEntity(
    id: id,
    title: title,
    imageUrl: imageUrl,
    audioUrl: audioUrl,
    favoriteCount: favoriteCount ?? 0,
    playCount: playCount ?? 0,
    artist: artist,
    genre: genre,
  );

  // Convert Entity to API Object
  factory SongApiModel.fromEntity(SongEntity entity) => SongApiModel(
    id: entity.id,
    title: entity.title,
    imageUrl: entity.imageUrl,
    audioUrl: entity.audioUrl,
    favoriteCount: entity.favoriteCount,
    playCount: entity.playCount,
    artist: entity.artist,
    genre: entity.genre,
  );

  // Convert API List to Entity List
  static List<SongEntity> toEntityList(List<SongApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [id, title, imageUrl, audioUrl, favoriteCount, playCount, artist, genre];
}
