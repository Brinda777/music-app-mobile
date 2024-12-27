import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/features/favorite/presentation/view_model/favorite_view_model.dart';
import 'package:sangeet/features/playlist/presentation/view/playlist_dialog_view.dart';
import 'package:sangeet/features/playlist/presentation/view_model/playlist_view_model.dart';
import 'package:sangeet/features/sensors/domain/usecases/double_shake_use_case.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

class SongPlayerView extends ConsumerStatefulWidget {
  final SongEntity song;

  const SongPlayerView({Key? key, required this.song}) : super(key: key);

  @override
  _SongPlayerViewState createState() => _SongPlayerViewState();
}

class _SongPlayerViewState extends ConsumerState<SongPlayerView> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Color _scaffoldColor = Colors.black;
  late DoubleShakeDetectorService _doubleShakeDetectorService;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _extractScaffoldColor();
    _doubleShakeDetectorService =
        DoubleShakeDetectorService(onShake: _handleShake);
    _doubleShakeDetectorService.startListening();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    try {
      await _audioPlayer
          .setUrl(ApiEndpoints.imageUrl + (widget.song.audioUrl ?? ''));
      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      });
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position ?? Duration.zero;
        });
      });

      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          setState(() {
            _audioPlayer.seek(Duration.zero); // Reset position to beginning
            _audioPlayer.pause();
            _isPlaying = false; // Update play/pause button state
          });
        }
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  Future<void> _extractScaffoldColor() async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(ApiEndpoints.imageUrl + (widget.song.imageUrl ?? '')),
    );

    setState(() {
      _scaffoldColor = paletteGenerator.dominantColor?.color ?? Colors.black;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _doubleShakeDetectorService.stopListening();
    super.dispose();
  }

  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleFavorite() {
    ref
        .read(favoriteViewmodelProvider.notifier)
        .addSongToFavorite(widget.song.id!);
  }

  void _addToPlaylist() {
    final playlistState = ref.watch(playlistViewmodelProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlaylistDialog(
          playlists: playlistState.lstPlaylists,
          onPlaylistSelected: (playlist) {
            ref
                .read(playlistViewmodelProvider.notifier)
                .addSongToPlaylist(playlist.id!, widget.song.id!);
          },
        );
      },
    );
  }

  void _handleShake() {
    _playPause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _scaffoldColor,
        title: Text(
          widget.song.title ?? 'Song Player',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: _scaffoldColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use min to prevent overflow
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        ApiEndpoints.imageUrl + (widget.song.imageUrl ?? '')),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.song.title ?? 'Unknown Title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.song.artist ?? 'Unknown Artist',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow, color: Colors.white70, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.song.playCount ?? 0}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.song.favoriteCount ?? 0}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(_position.toString().split('.').first,
                        style: const TextStyle(color: Colors.white)),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbColor: Colors.white,
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white70,
                        ),
                        child: Slider(
                          value: _position.inSeconds.toDouble(),
                          min: 0.0,
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (double value) {
                            setState(() {
                              _audioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                            });
                          },
                        ),
                      ),
                    ),
                    Text(_duration.toString().split('.').first,
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite,
                        color: Colors.white, size: 36),
                    onPressed: _toggleFavorite,
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                      size: 64,
                    ),
                    onPressed: _playPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.playlist_add,
                        color: Colors.white, size: 36),
                    onPressed: _addToPlaylist,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
