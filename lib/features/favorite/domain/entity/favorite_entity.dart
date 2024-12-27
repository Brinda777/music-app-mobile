import 'package:equatable/equatable.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

class FavoriteEntity extends Equatable {
  final String? id;
  final String? userId;
  final SongEntity? song;

  const FavoriteEntity({this.id, this.userId, this.song});

  @override
  List<Object?> get props => [id, userId, song];
}
