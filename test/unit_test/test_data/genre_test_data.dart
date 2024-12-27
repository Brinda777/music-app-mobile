import 'package:sangeet/features/genre/domain/entity/genre_entity.dart';

class GenreTestData {
  GenreTestData._();

  static List<GenreEntity> getGenreTestData() {
    List<GenreEntity> lstGenres = [
      const GenreEntity(
        id: "668cc58dcb6bbfd08a688ba9",
        name: "Hip Pop"
      ),
      const GenreEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          name: "Pop"
      ),
      const GenreEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          name: "Metal"
      ),
      const GenreEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          name: "Jazz"
      ),
      const GenreEntity(
          id: "668cc58dcb6bbfd08a688ba9",
          name: "Electronic"
      ),
    ];

    return lstGenres;
  }
}