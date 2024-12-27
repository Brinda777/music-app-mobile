import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/favorite/presentation/view_model/favorite_view_model.dart';
import 'package:sangeet/features/player/presentation/view/song_player_view.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

class FavoriteSongsView extends ConsumerStatefulWidget {
  final List<SongEntity> songs;

  const FavoriteSongsView({Key? key, required this.songs}) : super(key: key);

  @override
  ConsumerState<FavoriteSongsView> createState() => _FavoriteSongsViewState();
}

class _FavoriteSongsViewState extends ConsumerState<FavoriteSongsView> {
  void _removeFromFavorite(SongEntity song) {
    ref.read(favoriteViewmodelProvider.notifier).removeSongFromFavorite(song.id!);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.songs.length,
      itemBuilder: (context, index) {
        final song = widget.songs[index];
        return Card(
          shadowColor: Colors.blueAccent,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
          child: InkWell(
            onTap: () {
              // Handle tapping on the song tile
              NavigateRoute.pushRoute(SongPlayerView(song: song));
            },
            borderRadius: BorderRadius.circular(12.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  ApiEndpoints.imageUrl + (song.imageUrl ?? ''),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.music_note, color: Colors.black),
                    );
                  },
                ),
              ),
              title: Text(
                song.title ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(song.artist ?? ''),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'favorite') {
                    _removeFromFavorite(song);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'favorite',
                    child: ListTile(
                      leading: Icon(Icons.favorite_border, color: Colors.white),
                      title: Text('Remove from favorite'),
                    ),
                  ),
                ],
                color: Theme.of(context).primaryColor, // Change background color
              ),
            ),
          ),
        );
      },
    );
  }
}
