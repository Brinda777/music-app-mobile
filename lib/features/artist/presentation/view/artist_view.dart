import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/features/player/presentation/view/song_player_view.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';
import 'package:sangeet/features/song/presentation/viewmodel/artist_song_view_model.dart';

class ArtistView extends ConsumerStatefulWidget {
  final ArtistEntity artist;

  const ArtistView({required this.artist, super.key});

  @override
  ConsumerState<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends ConsumerState<ArtistView> {
  late Future<void> _artistSongsFuture;

  @override
  void initState() {
    super.initState();
    _artistSongsFuture = _fetchArtistSongs();
  }

  Future<void> _fetchArtistSongs() async {
    await ref
        .read(artistSongViewmodelProvider(widget.artist.displayName!).notifier)
        .getArtistSongs(widget.artist.displayName!);
  }

  @override
  Widget build(BuildContext context) {
    final songState =
        ref.watch(artistSongViewmodelProvider(widget.artist.displayName!));
    final songs = songState.lstSongs;
    final artist = widget.artist;

    return Scaffold(
      appBar: AppBar(
        title: Text(artist.displayName ?? 'Artist Details'),
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Colors.deepPurple, Colors.purpleAccent],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //   ),
        // ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<void>(
        future: _artistSongsFuture,
        builder: (context, snapshot) {
          if (songState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (songState.error != null) {
            return Center(child: Text('Error: ${songState.error}'));
          }

          if (songs.isEmpty) {
            return const Center(child: Text('No songs available.'));
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildArtistImage(artist),
                    const SizedBox(height: 20),
                    Text(
                      artist.displayName ?? 'Unknown Artist',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 10),
                    _buildSongsList(songs),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArtistImage(ArtistEntity artist) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        artist.imageUrl != null
            ? '${ApiEndpoints.imageUrl}${artist.imageUrl!}'
            : 'https://via.placeholder.com/300',
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[800],
            child: const Icon(Icons.error, color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildSongsList(List<SongEntity> songs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Songs',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        ...songs.map((song) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10.0),
            elevation: 6,
            shadowColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  song.imageUrl != null
                      ? '${ApiEndpoints.imageUrl}${song.imageUrl!}'
                      : 'https://via.placeholder.com/50',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.error, color: Colors.white),
                    );
                  },
                ),
              ),
              title: Text(
                song.title ?? 'Unknown Title',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.artist ?? 'Unknown Artist',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.play_arrow, size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        '${song.playCount}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.favorite, size: 16, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Text(
                        '${song.favoriteCount}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongPlayerView(song: song),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ],
    );
  }
}
