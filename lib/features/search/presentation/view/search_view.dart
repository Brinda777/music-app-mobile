import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/player/presentation/view/song_player_view.dart';
import 'package:sangeet/features/search/presentation/view_model/search_view_model.dart';

class SearchView extends ConsumerWidget {
  final String query;

  SearchView({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songState = ref.watch(searchViewmodelProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results', style: TextStyle()),
        backgroundColor: Colors.black,
        elevation: 0, // Subtle shadow for a modern look
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter action
            },
          ),
        ],
      ),
      body: songState.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: ThemeConstant.neutralColor,
        ),
      )
          : songState.error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const Icon(
              Icons.error,
              size: 60,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              'An error occurred: ${songState.error}',
              style: const TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : songState.lstSongs.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        itemCount: songState.lstSongs.length,
        itemBuilder: (context, index) {
          final song = songState.lstSongs[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4, // Slightly elevated card for a modern look
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: song.imageUrl != null
                    ? NetworkImage(ApiEndpoints.imageUrl + song.imageUrl!)
                    : const AssetImage('assets/images/default_image.png') as ImageProvider,
                backgroundColor: Colors.grey.shade200,
              ),
              title: Text(
                song.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                song.artist!,
                style: const TextStyle(),
              ),
              // trailing: Icon(Icons.more_vert, color: Colors.grey[600]),
              onTap: () {
                // Handle song tap
                NavigateRoute.pushRoute(SongPlayerView(song: song));
              },
            ),
          );
        },
      ),
    );
  }
}
