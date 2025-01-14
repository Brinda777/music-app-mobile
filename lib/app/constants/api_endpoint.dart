class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://192.168.1.8:8484/api/";
  //static const String baseUrl = "http://10.0.0.2:3000/api/";

  // ====================== Auth Routes ======================
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String imageUrl = "http://192.168.1.8:8484";

  // ====================== Genre Routes ======================
  static const String getGenres = 'genre';

  // ====================== User Routes ======================
  static const String currentUser = "user/me";
  static const String uploadImage = "user/me";
  static const String changePassword = "user/change-password";
  static const String editUser = "user/me";

  // ====================== Artist Routes ======================
  static const String getArtists = 'artist';
  static const String getArtistById = 'artist';

  // ====================== Song Routes ======================
  static const String getSongs = 'song';
  static const String getTrendingSongs = 'song/trending/get-all';
  static const String getPopularSongs = 'song/popular/get-all/songs';
  static const String getSongsByArtist = 'song/get-all/songs/artist/12';
  static const String getSongsByGenre =
      'song/get-all/songs/genre/genre-name/12';

  // ====================== Favorite Routes ======================
  static const String getFavorites = 'user/favorite';

  // ====================== Playlist Routes ======================
  static const String getPlaylists = 'user/playlist';

  // ====================== Extras ======================
  static const limitPage = 10;
}
