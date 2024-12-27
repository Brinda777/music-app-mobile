
import 'package:sangeet/features/artist/domain/entity/artist_entity.dart';

class ArtistTestData {
  ArtistTestData._();

  static List<ArtistEntity> getArtistTestData() {
    List<ArtistEntity> lstArtists = [
      const ArtistEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          displayName: "Weeknd"
      ),
      const ArtistEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          displayName: "Rihanna"
      ),
      const ArtistEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          displayName: "Justin Beiber"
      ),
      const ArtistEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          displayName: "Kanye West"
      ),
    ];

    return lstArtists;
  }
}