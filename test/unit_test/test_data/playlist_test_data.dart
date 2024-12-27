import 'package:sangeet/features/playlist/domain/entity/playlist_entity.dart';
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

class PlaylistTestData {
  PlaylistTestData._();

  static List<PlaylistEntity> getPlaylistTestData() {
    List<PlaylistEntity> lstPlaylists = [
      const PlaylistEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          name: 'my playlist',
          userId: "668cc58dcb6bbfd08a688ba8",
          songs: [
            SongEntity(
                id: "668cc58dcb6bbfd08a688ba9",
                title: "Rap God",
                artist: "Eminem",
                genre: "Hip Hop",
                imageUrl:
                    "/api/public/uploads/songs/1720501727402__b9f2fbea5ec2be5d4eb1d3fa04dca87f.jpg",
                audioUrl:
                    "/api/public/uploads/songs/1720501645714__x2mate.com---Sushant-KC---Behos-(128-kbps).mp3",
                favoriteCount: 0,
                playCount: 0)
          ]),
      const PlaylistEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          name: 'my playlist',
          userId: "668cc58dcb6bbfd08a688ba8",
          songs: [
            SongEntity(
                id: "668cc58dcb6bbfd08a688ba9",
                title: "Rap God",
                artist: "Eminem",
                genre: "Hip Hop",
                imageUrl:
                    "/api/public/uploads/songs/1720501727402__b9f2fbea5ec2be5d4eb1d3fa04dca87f.jpg",
                audioUrl:
                    "/api/public/uploads/songs/1720501645714__x2mate.com---Sushant-KC---Behos-(128-kbps).mp3",
                favoriteCount: 0,
                playCount: 0)
          ]),
      const PlaylistEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          name: 'my playlist',
          userId: "668cc58dcb6bbfd08a688ba8",
          songs: [
            SongEntity(
                id: "668cc58dcb6bbfd08a688ba9",
                title: "Rap God",
                artist: "Eminem",
                genre: "Hip Hop",
                imageUrl:
                    "/api/public/uploads/songs/1720501727402__b9f2fbea5ec2be5d4eb1d3fa04dca87f.jpg",
                audioUrl:
                    "/api/public/uploads/songs/1720501645714__x2mate.com---Sushant-KC---Behos-(128-kbps).mp3",
                favoriteCount: 0,
                playCount: 0)
          ]),
      const PlaylistEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          name: 'my playlist',
          userId: "668cc58dcb6bbfd08a688ba8",
          songs: [
            SongEntity(
                id: "668cc58dcb6bbfd08a688ba9",
                title: "Rap God",
                artist: "Eminem",
                genre: "Hip Hop",
                imageUrl:
                    "/api/public/uploads/songs/1720501727402__b9f2fbea5ec2be5d4eb1d3fa04dca87f.jpg",
                audioUrl:
                    "/api/public/uploads/songs/1720501645714__x2mate.com---Sushant-KC---Behos-(128-kbps).mp3",
                favoriteCount: 0,
                playCount: 0)
          ]),
      const PlaylistEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          name: 'my playlist',
          userId: "668cc58dcb6bbfd08a688ba8",
          songs: [
            SongEntity(
                id: "668cc58dcb6bbfd08a688ba9",
                title: "Rap God",
                artist: "Eminem",
                genre: "Hip Hop",
                imageUrl:
                    "/api/public/uploads/songs/1720501727402__b9f2fbea5ec2be5d4eb1d3fa04dca87f.jpg",
                audioUrl:
                    "/api/public/uploads/songs/1720501645714__x2mate.com---Sushant-KC---Behos-(128-kbps).mp3",
                favoriteCount: 0,
                playCount: 0)
          ]),
    ];

    return lstPlaylists;
  }
}
