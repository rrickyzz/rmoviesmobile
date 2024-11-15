// To parse this JSON data, do
//
//     final movieList = movieListFromJson(jsonString);

import 'dart:convert';

MovieList movieListFromJson(String str) => MovieList.fromJson(json.decode(str));

String movieListToJson(MovieList data) => json.encode(data.toJson());

class MovieList {
  List<MovieResult>? result;
  int? pages;

  MovieList({
    this.result,
    this.pages,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) => MovieList(
        result: json["result"] == null
            ? []
            : List<MovieResult>.from(
                json["result"]!.map((x) => MovieResult.fromJson(x))),
        pages: json["pages"],
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "pages": pages,
      };
}

class MovieResult {
  String? imdbId;
  String? tmdbId;
  String? title;
  String? embedUrl;
  String? embedUrlTmdb;
  String? quality;

  MovieResult({
    this.imdbId,
    this.tmdbId,
    this.title,
    this.embedUrl,
    this.embedUrlTmdb,
    this.quality,
  });

  factory MovieResult.fromJson(Map<String, dynamic> json) => MovieResult(
        imdbId: json["imdb_id"],
        tmdbId: json["tmdb_id"],
        title: json["title"],
        embedUrl: json["embed_url"],
        embedUrlTmdb: json["embed_url_tmdb"],
        quality: json["quality"],
      );

  Map<String, dynamic> toJson() => {
        "imdb_id": imdbId,
        "tmdb_id": tmdbId,
        "title": title,
        "embed_url": embedUrl,
        "embed_url_tmdb": embedUrlTmdb,
        "quality": quality,
      };
}
