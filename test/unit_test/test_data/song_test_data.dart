
import 'package:sangeet/features/song/domain/entity/song_entity.dart';

class SongTestData {
  SongTestData._();

  static List<SongEntity> getSongTestData() {
    List<SongEntity> lstSongs = [
      const SongEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          title: "Rap God",
          artist: "Eminem",
          genre: "Hip Hop",
          imageUrl: "/api/public/uploads/songs/1720501727402__b9f2fbea5ec2be5d4eb1d3fa04dca87f.jpg",
          audioUrl: "/api/public/uploads/songs/1720501645714__x2mate.com---Sushant-KC---Behos-(128-kbps).mp3",
          favoriteCount: 0,
          playCount: 0
      ),
      const SongEntity(
          id: "668cc58dcb6bbfd08a688ba8",
          title: "Slim Shady",
          artist: "Eminem",
          genre: "Hip Hop",
          imageUrl: "/api/public/uploads/songs/1720501727402__b9f2fbea5ec2be5d4eb1d3fa04dca87f.jpg",
          audioUrl: "/api/public/uploads/songs/1720501645714__x2mate.com---Sushant-KC---Behos-(128-kbps).mp3",
          favoriteCount: 0,
          playCount: 0
      ),
      const SongEntity(
          id: "668cc58dcb6bbfd08a688ba2",
          title: "Godzilla",
          artist: "Eminem",
          genre: "Hip Hop",
          imageUrl: "/api/public/uploads/songs/1720501727402__b9f2fbea5ec2be5d4eb1d3fa04dca87f.jpg",
          audioUrl: "/api/public/uploads/songs/1720501645714__x2mate.com---Sushant-KC---Behos-(128-kbps).mp3",
          favoriteCount: 0,
          playCount: 0
      ),
      const SongEntity(
          id: "668cc58dcb6bbfd08a688bb9",
          title: "Wake Up",
          artist: "Eminem",
          genre: "Hip Hop",
          imageUrl: "/api/public/uploads/songs/1720501727402__b9f2fbea5ec2be5d4eb1d3fa04dca87f.jpg",
          audioUrl: "/api/public/uploads/songs/1720501645714__x2mate.com---Sushant-KC---Behos-(128-kbps).mp3",
          favoriteCount: 0,
          playCount: 0
      ),
    ];

    return lstSongs;
  }
}
