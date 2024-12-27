import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';
import 'package:sangeet/features/playlist/presentation/view/create_playlist_dialog_view.dart';
import 'package:sangeet/features/playlist/presentation/view/edit_playlist_dialog_view.dart';
import 'package:sangeet/features/playlist/presentation/view/playlist_detail_view.dart';
import 'package:sangeet/features/playlist/presentation/view_model/playlist_view_model.dart';

class PlaylistsView extends ConsumerStatefulWidget {
  final List<PlaylistEntity> playlists;

  PlaylistsView({Key? key, required this.playlists}) : super(key: key);

  @override
  ConsumerState<PlaylistsView> createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends ConsumerState<PlaylistsView> {
  void _removePlaylist(PlaylistEntity playlist) {
    ref.read(playlistViewmodelProvider.notifier).deletePlaylist(playlist.id!);
  }

  void _editPlaylist(PlaylistEntity playlist) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPlaylistDialog(
          currentName: playlist.name ?? '',
          onSave: (name) {
            ref.read(playlistViewmodelProvider.notifier).updatePlaylist(playlist.id!, name);
          },
        );
      },
    );
  }

  void _createPlaylist(String name) {
    ref.read(playlistViewmodelProvider.notifier).addPlaylist(name);
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreatePlaylistDialog(
          onCreate: (name) {
            _createPlaylist(name);
          },
        );
      },
    );
  }

  final List<Color> lightColors = [
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.pinkAccent,
    Colors.purple[200]!,
    Colors.orange[200]!,
    Colors.tealAccent,
    Colors.amber[200]!,
    Colors.cyan[200]!,
    Colors.lime[200]!,
    Colors.indigo[200]!,
    Colors.red[200]!,
    Colors.deepPurple[200]!,
    Colors.yellow[200]!,
    Colors.blueGrey[200]!,
    Colors.brown[200]!,
  ];

  Color getRandomLightColor() {
    Random random = Random();
    return lightColors[random.nextInt(lightColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        itemCount: widget.playlists.length,
        itemBuilder: (context, index) {
          final playlist = widget.playlists[index];
          final songCount = playlist.songs?.length ?? 0; // Get the number of songs

          return Card(
            shadowColor: Colors.blueAccent,
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12.0),
              title: Text(playlist.name ?? '', style: Theme.of(context).textTheme.headlineSmall),
              subtitle: Row(
                children: [
                  Icon(Icons.music_note, color: Colors.grey[600]), // Icon for the number of songs
                  const SizedBox(width: 8),
                  Text('$songCount songs', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  playlist.songs?.isNotEmpty == true
                      ? ApiEndpoints.imageUrl + (playlist.songs!.first.imageUrl ?? '')
                      : '', // Placeholder image URL or asset
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      color: getRandomLightColor(),
                      child: const Icon(Icons.queue_music, color: Colors.black),
                    );
                  },
                ),
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'removePlaylist') {
                    _removePlaylist(playlist);
                  } else if (value == 'editPlaylist') {
                    _editPlaylist(playlist);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'editPlaylist',
                    child: ListTile(
                      leading: Icon(Icons.edit, color: Colors.white),
                      title: Text('Edit Playlist'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'removePlaylist',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.white),
                      title: Text('Remove Playlist'),
                    ),
                  ),
                ],
                color: Theme.of(context).primaryColor, // Change background color if needed
              ),
              onTap: () {
                NavigateRoute.pushRoute(PlaylistDetailView(playlist: playlist,));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePlaylistDialog,
        tooltip: 'Create Playlist',
        backgroundColor: ThemeConstant.neutralColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
