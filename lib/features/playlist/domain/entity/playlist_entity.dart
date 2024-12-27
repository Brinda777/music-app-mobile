import 'package:equatable/equatable.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

class PlaylistEntity extends Equatable {
  final String? id;
  final String? name;
  final String? userId;
  final List<SongEntity>? songs;
  final String? createdAt;

  const PlaylistEntity({this.id, this.name, this.userId, this.songs, this.createdAt});

  @override
  List<Object?> get props => [id, name, userId, songs, createdAt];
}
