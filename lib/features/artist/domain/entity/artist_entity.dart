import 'package:equatable/equatable.dart';

class ArtistEntity extends Equatable {
  final String? id;
  final String? displayName;
  final String? imageUrl;

  const ArtistEntity({
    this.id,
    this.displayName,
    this.imageUrl
  });

  @override
  List<Object?> get props =>
      [id, displayName, imageUrl];
}
