import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/player/presentation/view/song_player_view.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';
import 'package:sangeet/features/song/presentation/viewmodel/genre_song_view_model.dart';

class GenreSongsView extends ConsumerStatefulWidget {
  final String genreName;

  const GenreSongsView({Key? key, required this.genreName}) : super(key: key);

  @override
  _GenreSongsViewState createState() => _GenreSongsViewState();
}

class _GenreSongsViewState extends ConsumerState<GenreSongsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(genreSongViewmodelProvider(widget.genreName).notifier);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(genreSongViewmodelProvider(widget.genreName).notifier);
    }
  }

  Future<void> _refresh() async {
    ref.read(genreSongViewmodelProvider(widget.genreName).notifier).resetState();
  }

  void _addToFavorite(SongEntity song) {
    print('Added ${song.title} to favorites');
  }

  void _addToPlaylist(SongEntity song) {
    print('Added ${song.title} to playlist');
  }

  @override
  Widget build(BuildContext context) {
    final songState = ref.watch(genreSongViewmodelProvider(widget.genreName));
    final songs = songState.lstSongs;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genreName),
        backgroundColor: ThemeConstant.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: songs.isEmpty
          ? const Center(
        child: Text('No songs available for this genre',
            style: TextStyle(color: Colors.white70)),
      )
          : RefreshIndicator(
        onRefresh: _refresh,
        color: ThemeConstant.primaryColor,
        backgroundColor: Colors.black,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: songs.length + (songState.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == songs.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: ThemeConstant.primaryColor,
                  ),
                ),
              );
            }
            final song = songs[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 4,
              shadowColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    ApiEndpoints.imageUrl + song.imageUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[800],
                        child: const Icon(Icons.error, color: Colors.white),
                      );
                    },
                  ),
                ),
                title: Text(
                  song.title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        song.artist ?? '',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.play_arrow, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${song.playCount}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.favorite, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${song.favoriteCount}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                // trailing: PopupMenuButton<String>(
                //   icon: const Icon(Icons.more_vert, color: Colors.white),
                //   onSelected: (value) {
                //     if (value == 'favorite') {
                //       _addToFavorite(song);
                //     } else if (value == 'playlist') {
                //       _addToPlaylist(song);
                //     }
                //   },
                //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                //     const PopupMenuItem<String>(
                //       value: 'favorite',
                //       child: ListTile(
                //         leading: Icon(Icons.favorite, color: Colors.white),
                //         title: Text('Add to favorite', style: TextStyle(color: Colors.white)),
                //       ),
                //     ),
                //     const PopupMenuItem<String>(
                //       value: 'playlist',
                //       child: ListTile(
                //         leading: Icon(Icons.playlist_add, color: Colors.white),
                //         title: Text('Add to playlist', style: TextStyle(color: Colors.white)),
                //       ),
                //     ),
                //   ],
                //   color: Theme.of(context).cardColor,
                // ),
                onTap: () {
                  NavigateRoute.pushRoute(SongPlayerView(song: song));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
