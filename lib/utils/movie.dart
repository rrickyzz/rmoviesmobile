class MovieUtils {
  static String getPosterLink({double size = 185, String posterPath = ''}) =>
      'https://image.tmdb.org/t/p/w${size.toInt()}/$posterPath';
}
