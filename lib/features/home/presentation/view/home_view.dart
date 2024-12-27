import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/app/navigator/navigator.dart';
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';
import 'package:sangeet/features/artist/presentation/view/artist_view.dart';
import 'package:sangeet/features/artist/presentation/viewmodel/artist_view_model.dart';
import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';
import 'package:sangeet/features/genre/presentation/view/genre_view.dart';
import 'package:sangeet/features/genre/presentation/viewmodel/genre_view_model.dart';
import 'package:sangeet/features/player/presentation/view/song_player_view.dart';
import 'package:sangeet/features/search/presentation/view/search_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';
import 'package:sangeet/features/song/presentation/state/song_state.dart';
import 'package:sangeet/features/song/presentation/viewmodel/popular_song_view_model.dart';
import 'package:sangeet/features/song/presentation/viewmodel/song_view_model.dart';
import 'package:sangeet/features/song/presentation/viewmodel/trending_song_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  // Form Key
  final _formKey = GlobalKey<FormState>();
  String? keyword;

  final ScrollController _recommendedScrollController = ScrollController();
  final ScrollController _trendingScrollController = ScrollController();
  final ScrollController _mostLikedScrollController = ScrollController();
  final ScrollController _recentlyAddedScrollController = ScrollController();

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _recommendedScrollController.addListener(_onScroll);
    _trendingScrollController.addListener(_onScroll);
    _mostLikedScrollController.addListener(_onScroll);
    _recentlyAddedScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _recommendedScrollController.dispose();
    _trendingScrollController.dispose();
    _mostLikedScrollController.dispose();
    _recentlyAddedScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_recommendedScrollController.position.pixels ==
        _recommendedScrollController.position.maxScrollExtent) {
      ref.read(songViewmodelProvider.notifier).getAllSongs();
    }
    if (_trendingScrollController.position.pixels ==
        _trendingScrollController.position.maxScrollExtent) {
      ref.read(trendingSongViewmodelProvider.notifier).getTrendingSongs();
    }
    if (_mostLikedScrollController.position.pixels ==
        _mostLikedScrollController.position.maxScrollExtent) {
      ref.read(popularSongViewmodelProvider.notifier).getPopularSongs();
    }
    if (_recentlyAddedScrollController.position.pixels ==
        _recentlyAddedScrollController.position.maxScrollExtent) {
      // Implement fetch for recently added songs
    }
  }

  Future<void> _refresh() async {
    ref.read(songViewmodelProvider.notifier).resetState();
    ref.read(trendingSongViewmodelProvider.notifier).resetState();
    ref.read(popularSongViewmodelProvider.notifier).resetState();
    ref.read(artistViewmodelProvider.notifier).resetState();
    ref.read(genreViewmodelProvider.notifier).resetState();
    setState(() {});
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void _submitSearch(value) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Implement search functionality using keyword
      NavigateRoute.pushRoute(SearchView(query: value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final songState = ref.watch(songViewmodelProvider);
    final lstSongs = songState.lstSongs;
    final trendingSongState = ref.watch(trendingSongViewmodelProvider);
    final trendingSongs = trendingSongState.lstSongs;
    final popularSongState = ref.watch(popularSongViewmodelProvider);
    final popularSongs = popularSongState.lstSongs;
    final artistState = ref.watch(artistViewmodelProvider);
    final artists = artistState.lstArtists;
    final genreState = ref.watch(genreViewmodelProvider);
    final genres = genreState.lstGenres;

    final screenWidth = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh: _refresh,
      color: ThemeConstant.neutralColor,
      backgroundColor: Colors.black,
      child: SizedBox.expand(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 60),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          '${_getGreeting()}, Bijaya',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ThemeConstant.neutralColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onChanged: (value) {
                          keyword = value;
                        },
                        onFieldSubmitted: (value) {
                          _submitSearch(value);
                        },
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          labelText: 'Search your favorite song, artist..',
                          hintText: "What do you want to listen?",
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTopArtistSlider(artists, screenWidth),
                  const SizedBox(height: 20),
                  _buildGenreButtons(genres),
                  const SizedBox(height: 20),
                  _buildSongSection('Recommended For You', lstSongs,
                      _recommendedScrollController, songState),
                  _buildSongSection('Trending Now', trendingSongs,
                      _trendingScrollController, trendingSongState),
                  _buildSongSection('Most Liked', popularSongs,
                      _mostLikedScrollController, popularSongState),
                  // _buildSongSection('Recently Added', lstSongs,
                  //     _recentlyAddedScrollController, songState),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopArtistSlider(List<ArtistEntity> artists, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: screenWidth * 0.6,
          child: PageView.builder(
            controller: _pageController,
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final artist = artists[index];
              return
                GestureDetector(
                  onTap: () {
                    NavigateRoute.pushRoute(ArtistView(artist: artist));
                  },
                  child:Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        ApiEndpoints.imageUrl + artist.imageUrl!,
                        width: double.infinity,
                        height: screenWidth * 0.4,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: screenWidth * 0.4,
                            height: screenWidth * 0.4,
                            color: Colors.white,
                            child: Image.asset('assets/images/default_image.png'),
                          );
                        },
                      ),
                    ),
                  ) ,
                )
                ;
            },
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: artists.length,
            effect: const WormEffect(
              dotHeight: 8.0,
              dotWidth: 8.0,
              activeDotColor: ThemeConstant.neutralColor,
              dotColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenreButtons(List<GenreEntity> genres) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: genres.map((genre) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GenreSongsView(genreName: genre.name!),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConstant.neutralColor,
                foregroundColor: Colors.white,
              ),
              child: Text(
                genre.name!,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSongSection(String title, List<SongEntity> songs,
      ScrollController scrollController, SongState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 170,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: songs.length +
                1, // Add one extra item for the progress indicator
            itemBuilder: (context, index) {
              if (index == songs.length) {
                return Padding(
                  padding: const EdgeInsets.all(68.0),
                  child: state.isLoading
                      ? const CircularProgressIndicator(
                      color: ThemeConstant.neutralColor)
                      : const SizedBox.shrink(),
                );
              }
              final song = songs[index];

              return GestureDetector(
                  onTap: () {
                    NavigateRoute.pushRoute(SongPlayerView(song: song));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            ApiEndpoints.imageUrl + song.imageUrl!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 120,
                                height: 120,
                                color: Colors.white,
                                child: Image.asset(
                                    'assets/images/default_image.png'),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: ThemeConstant.neutralColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                            ),
                            child: Text(
                              song.artist ??
                                  '', // Replace with your artist name field
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            // color: Colors.black.withOpacity(0.5), // Adjust opacity and color as needed
                            child: Text(
                              song.title ??
                                  '', // Replace with your song title field
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}