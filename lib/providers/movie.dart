import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:libremovies/models/response/imdb_details.dart';
import 'package:libremovies/models/response/movie.dart';
import 'package:libremovies/models/response/tmdb_result.dart';
import 'package:libremovies/utils/movie.dart';

class MovieProvider extends GetConnect {
  // Get request
  Future<MovieList> getLatestMovies(int? pageNumber) async {
    final response =
        await get('https://vidsrc.xyz/movies/latest/page-$pageNumber.json');
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching movies');
    } else {
      var moviesJson = response.body;
      return movieListFromJson(moviesJson);
    }
  }

  Future<ImdbDetails> getMovieImdb(String movieId) async {
    final response = await get(
        'https://api.themoviedb.org/3/movie/$movieId?language=en-US',
        query: {'api_key': '1865f43a0549ca50d341dd9ab8b29f49'});
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching movies');
    } else {
      var moviesJson = response.body;
      return imdbDetailsFromJson(jsonEncode(moviesJson));
    }
  }

  Future<TmdbMovieResult> getTMDBMovieNowPlaying(String page1) async {
    final response = await get(
        'https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=$page1',
        query: {'api_key': '1865f43a0549ca50d341dd9ab8b29f49'});
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching movies');
    } else {
      var moviesJson = response.body;
      return tmdbMovieResultFromJson(jsonEncode(moviesJson));
    }
  }

  Future<TmdbMovieResult> getTMDBTopRated(String page1) async {
    final response = await get(
        'https://api.themoviedb.org/3/movie/top_rated?language=en-US&=$page1',
        query: {'api_key': '1865f43a0549ca50d341dd9ab8b29f49'});

    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching movies');
    } else {
      var moviesJson = response.body;
      return tmdbMovieResultFromJson(jsonEncode(moviesJson));
    }
  }

  Future<TmdbMovieResult> getTMDBMoviePopularMovies(String page1) async {
    final response = await get(
        'https://api.themoviedb.org/3/movie/popular?language=en-US&page=$page1',
        query: {'api_key': '1865f43a0549ca50d341dd9ab8b29f49'});
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching movies');
    } else {
      var moviesJson = response.body;
      return tmdbMovieResultFromJson(jsonEncode(moviesJson));
    }
  }

  Future<TmdbMovieResult> getTMDBMovieOnTheAirSeries(String page1) async {
    final response = await get(
        'https://api.themoviedb.org/3/tv/on_the_air?language=en-US&page=$page1',
        query: {'api_key': '1865f43a0549ca50d341dd9ab8b29f49'});
    log('series: ${response.body}');
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching movies');
    } else {
      var moviesJson = response.body;
      return tmdbMovieResultFromJson(jsonEncode(moviesJson));
    }
  }

  Future<TmdbMovieResult> getTMDBMovieSimilar(String movieId) async {
    final response = await get(
        'https://api.themoviedb.org/3/movie/$movieId/similar?language=en-US&page=1',
        query: {'api_key': '1865f43a0549ca50d341dd9ab8b29f49'});
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching movies');
    } else {
      var moviesJson = response.body;
      return tmdbMovieResultFromJson(jsonEncode(moviesJson));
    }
  }

  Future<Response> getMoviePoster(String posterPath) async {
    final response = await get(MovieUtils.getPosterLink(posterPath: posterPath),
        query: {'api_key': '1865f43a0549ca50d341dd9ab8b29f49'});
    log('path: ${MovieUtils.getPosterLink(posterPath: posterPath)}');
    return response;
  }

  Future<Response> getMovieImages(String movieId) async {
    final response = await get(
        'https://api.themoviedb.org/3/movie/$movieId/images',
        query: {'api_key': '1865f43a0549ca50d341dd9ab8b29f49'});
    return response;
  }

  // Post request

  GetSocket userMessages() {
    return socket('https://yourapi/users/socket');
  }
}
