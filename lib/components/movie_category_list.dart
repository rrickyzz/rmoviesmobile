import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libremovies/models/response/imdb_details.dart';
import 'package:libremovies/models/response/tmdb_result.dart';
import 'package:libremovies/providers/movie.dart';
import 'package:libremovies/screens/movie_info.dart';
import 'package:libremovies/utils/movie.dart';

class MovieCategoryList extends StatefulWidget {
  final String tag;
  final TmdbMovieResult? movies;
  const MovieCategoryList({super.key, required this.movies, required this.tag});

  @override
  State<MovieCategoryList> createState() => _MovieCategoryListState();
}

class _MovieCategoryListState extends State<MovieCategoryList> {
  TmdbMovieResult? _movies;
  ImdbDetails? imdbDetails;

  final MovieProvider movieProvider = Get.find();

  @override
  void initState() {
    _movies = widget.movies;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant MovieCategoryList oldWidget) {
    if (widget.movies != oldWidget.movies) {
      _movies = widget.movies;
      log('Movies:  ${widget.tag} ${_movies?.results?.length}');
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.size.width,
      height: 250,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _movies?.results?.length ?? 0,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                movieProvider
                    .getMovieImdb(_movies?.results?[index].id.toString() ?? '')
                    .then((value) {
                  Get.to(() => MovieInfoSreen(
                        tag: widget.tag,
                        movie: value,
                      ));
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : 12),
                    child: SizedBox(
                      width: 185,
                      height: 185,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: MovieUtils.getPosterLink(
                              size: 185,
                              posterPath:
                                  _movies?.results?[index].posterPath ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 12, left: index == 0 ? 0 : 12),
                    child: SizedBox(
                      width: 180,
                      child: Text(
                        '${_movies?.results?[index].title}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
