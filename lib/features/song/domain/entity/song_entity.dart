import 'package:equatable/equatable.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';
import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';

class SongEntity extends Equatable {
  final String? id;
  final String? title;
  final String? imageUrl;
  final String? audioUrl;
  final int? favoriteCount;
  final int? playCount;
  final String? artist;
  final String? genre;

  const SongEntity({
    this.id,
    this.title,
    this.imageUrl,
    this.audioUrl,
    this.favoriteCount,
    this.playCount,
    this.artist,
    this.genre
  });

  @override
  List<Object?> get props =>
      [id, title, imageUrl, audioUrl, favoriteCount, playCount, artist, genre];
}
