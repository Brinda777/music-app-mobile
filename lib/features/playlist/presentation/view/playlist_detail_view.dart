import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sangeet/app/constants/api_endpoint.dart';
import 'package:sangeet/app/constants/theme_constant.dart';
import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';

class PlaylistDetailView extends StatefulWidget {
  final PlaylistEntity playlist;

  const PlaylistDetailView({Key? key, required this.playlist}) : super(key: key);

  @override
  _PlaylistDetailViewState createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends State<PlaylistDetailView> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  int _currentSongIndex = 0;
  bool _isShuffling = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializePlayer();
  }

  void _initializePlayer() async {
    final songUrl = ApiEndpoints.imageUrl + widget.playlist.songs![_currentSongIndex].audioUrl!;
    await _audioPlayer.setUrl(songUrl);

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration ?? Duration.zero;
      });
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void _nextSong() {
    if (widget.playlist.songs != null && widget.playlist.songs!.isNotEmpty) {
      setState(() {
        _currentSongIndex = (_currentSongIndex + 1) % widget.playlist.songs!.length;
        _initializePlayer();
        _playPause();
      });
    }
  }

  void _previousSong() {
    if (widget.playlist.songs != null && widget.playlist.songs!.isNotEmpty) {
      setState(() {
        _currentSongIndex = (_currentSongIndex - 1 + widget.playlist.songs!.length) % widget.playlist.songs!.length;
        _initializePlayer();
        _playPause();
      });
    }
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffling = !_isShuffling;
      if (_isShuffling) {
        _currentSongIndex = (DateTime.now().millisecondsSinceEpoch % widget.playlist.songs!.length);
        _initializePlayer();
        _playPause();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.playlist.name}'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Playlist header
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeConstant.neutralColor, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.playlist.songs?.isNotEmpty == true
                            ? ApiEndpoints.imageUrl + (widget.playlist.songs!.first.imageUrl ?? '')
                            : '', // Placeholder image URL or asset
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[800],
                            child: const Icon(Icons.music_note, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.playlist.name ?? 'No Name',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Created: ${widget.playlist.createdAt ?? 'Unknown'}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '${widget.playlist.songs?.length ?? 0} songs',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Centered player
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.grey[900]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 15.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: widget.playlist.songs?.isNotEmpty == true
                          ? Image.network(
                        ApiEndpoints.imageUrl + (widget.playlist.songs![_currentSongIndex].imageUrl ?? ''),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 200,
                            color: Colors.grey[800],
                            child: const Icon(Icons.music_note, color: Colors.white, size: 100),
                          );
                        },
                      )
                          : Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[800],
                        child: const Icon(Icons.music_note, color: Colors.white, size: 100),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      widget.playlist.songs?.isNotEmpty == true
                          ? widget.playlist.songs![_currentSongIndex].title ?? 'No Song'
                          : 'No Song',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.playlist.songs?.isNotEmpty == true
                          ? widget.playlist.songs![_currentSongIndex].artist ?? 'Unknown Artist'
                          : 'Unknown Artist',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16.0),
                    Slider(
                      value: _currentPosition.inSeconds.toDouble(),
                      min: 0.0,
                      max: _totalDuration.inSeconds.toDouble(),
                      onChanged: (value) {
                        _seek(Duration(seconds: value.toInt()));
                      },
                      activeColor: ThemeConstant.neutralColor,
                      inactiveColor: Colors.white,
                      thumbColor: ThemeConstant.neutralColor,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${_currentPosition.toString().split('.').first} / ${_totalDuration.toString().split('.').first}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.shuffle,
                            color: _isShuffling ? Colors.deepPurpleAccent : Colors.white70,
                            size: 30,
                          ),
                          onPressed: _toggleShuffle,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 30),
                          onPressed: _previousSong,
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            color: ThemeConstant.neutralColor,
                            size: 70,
                          ),
                          onPressed: _playPause,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white, size: 30),
                          onPressed: _nextSong,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 1.0,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ThemeConstant.neutralColor, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 20.0,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: widget.playlist.songs?.length ?? 0,
                            itemBuilder: (context, index) {
                              final song = widget.playlist.songs![index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    song.imageUrl != null
                                        ? ApiEndpoints.imageUrl + song.imageUrl!
                                        : '', // Placeholder image URL or asset
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.music_note, color: Colors.black),
                                      );
                                    },
                                  ),
                                ),
                                title: Text(
                                  song.title ?? 'No Title',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  song.artist ?? 'Unknown Artist',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                onTap: () {
                                  // Handle song tap
                                  setState(() {
                                    _currentSongIndex = index;
                                    _initializePlayer();
                                    _playPause();
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
