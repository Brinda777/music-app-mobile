import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/features/favorite/presentation/view/favorite_view.dart';
import 'package:sangeet/features/favorite/presentation/view_model/favorite_view_model.dart';
import 'package:sangeet/features/playlist/presentation/view/playlist_view.dart';
import 'package:sangeet/features/playlist/presentation/view_model/playlist_view_model.dart';
import 'package:sangeet/features/song/presentation/viewmodel/song_view_model.dart'; // Ensure to import your theme constant

class LibraryView extends ConsumerStatefulWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Length is 2 for two tabs (Favorite Songs and Playlists)
    _tabController.addListener(_handleTabSelection); // Default to the first tab (Favorite Songs)
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteState = ref.watch(favoriteViewmodelProvider);
    final favorites = favoriteState.lstFavorites;

    final playlistState = ref.watch(playlistViewmodelProvider);
    final playlists = playlistState.lstPlaylists;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: TabBar(
            controller: _tabController,
            indicatorColor: ThemeConstant.neutralColor,
            labelColor: ThemeConstant.neutralColor,
            unselectedLabelColor: Colors.white,
            tabs: const [
              Tab(text: 'Favorites',
                icon: Icon(Icons.favorite,),),
              Tab(text: 'Playlists',
                icon: Icon(Icons.playlist_add,),),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // First tab view (Favorite Songs)
              Consumer(
                builder: (context, watch, _) {
                  final favoriteSongs = favorites.map((e) => e.song!).toList();
                  return FavoriteSongsView(songs: favoriteSongs);
                },
              ),

              // Second tab view (Playlists)
              Consumer(
                builder: (context, watch, _) {
                  return PlaylistsView(playlists: playlists);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
