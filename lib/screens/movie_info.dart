import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libremovies/components/player/player.dart';
import 'package:libremovies/models/response/imdb_details.dart';
import 'package:libremovies/models/response/movie.dart';
import 'package:libremovies/models/response/tmdb_result.dart';
import 'package:libremovies/providers/movie.dart';
import 'package:libremovies/utils/movie.dart';

class MovieInfoSreen extends StatefulWidget {
  final String tag;
  final ImdbDetails movie;
  const MovieInfoSreen({super.key, required this.movie, required this.tag});

  @override
  State<MovieInfoSreen> createState() => _MovieInfoSreenState();
}

class _MovieInfoSreenState extends State<MovieInfoSreen> {
  ImdbDetails? imdbDetails;
  TmdbMovieResult? similarMovies;
  ImdbDetails? _movie;
  String? posterPath;
  Color primaryColor = Get.theme.primaryColor;

  final MovieProvider movieProvider = Get.find();

  Future<void> init(id) async {
    movieProvider.getMovieImdb(id).then((value) {
      setState(() {
        imdbDetails = value;
      });
    });
    movieProvider.getTMDBMovieSimilar(id).then((value) {
      setState(() {
        similarMovies = value;
      });
    });
  }

  @override
  void initState() {
    _movie = widget.movie;
    init(_movie?.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF17181B),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leadingWidth: 80,
              backgroundColor: const Color(0xFF17181B),
              leading: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF17181B).withOpacity(.2),
                    shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: primaryColor,
                    size: 32,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
              pinned: true,
              floating: true,
              expandedHeight: Get.height * .5,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    SizedBox(
                      width: Get.size.width,
                      height: Get.size.height * .5,
                      child: CachedNetworkImage(
                        imageUrl: MovieUtils.getPosterLink(
                            size: 500,
                            posterPath: imdbDetails?.backdropPath ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xFF17181B), // Solid color at the bottom
                            Color(0x0017181B), // Transparent color at the top
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 20,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: MovieUtils.getPosterLink(
                                    size: 185,
                                    posterPath: imdbDetails?.posterPath ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            SliverList.builder(
                itemCount: 1,
                itemBuilder: (_, index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: primaryColor),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                widget.tag,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  imdbDetails?.title ?? '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: Image.asset(
                                            'assets/images/imdb_logo.png')),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        '${imdbDetails?.voteAverage ?? '0'} / 10',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    AnotherTag(
                                        hasHorizontalPadding: false,
                                        tag:
                                            '• ${imdbDetails?.releaseDate?.year}'),
                                    Row(
                                        children: imdbDetails?.genres
                                                ?.map((genre) => AnotherTag(
                                                    tag: genre.name ?? ''))
                                                .toList() ??
                                            [])
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                                style: ButtonStyle(
                                  padding: const WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(vertical: 12)),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                                  overlayColor: WidgetStatePropertyAll(
                                      Colors.white.withOpacity(.2)),
                                  splashFactory: InkRipple.splashFactory,
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith(
                                          ((states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return primaryColor.withOpacity(.5);
                                    }
                                    return primaryColor;
                                  })),
                                ),
                                onPressed: () {
                                  Get.dialog(Player(
                                      id: imdbDetails?.id.toString() ?? ''));
                                },
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_arrow,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Play Now',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),
                                      )
                                    ])),
                            const SizedBox(height: 18),
                            Text(
                              imdbDetails?.overview ?? '',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'You might also like',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: List.generate(
                                        similarMovies?.results?.length ?? 0,
                                        (index) => InkWell(
                                              onTap: () async {
                                                init(similarMovies
                                                    ?.results?[index].id
                                                    .toString());
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: index == 0
                                                            ? 0
                                                            : 12),
                                                    child: SizedBox(
                                                      width: 185,
                                                      height: 185,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: MovieUtils.getPosterLink(
                                                              size: 185,
                                                              posterPath: similarMovies
                                                                      ?.results?[
                                                                          index]
                                                                      .posterPath ??
                                                                  ''),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 12),
                                                    child: SizedBox(
                                                      width: 180,
                                                      child: Text(
                                                        '${similarMovies?.results?[index].title}',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )).toList()))
                          ]));
                })
          ],
        ));
  }
}

class AnotherTag extends StatelessWidget {
  final bool hasHorizontalPadding;
  final String tag;
  const AnotherTag(
      {super.key, required this.tag, this.hasHorizontalPadding = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: hasHorizontalPadding ? 8 : 0, vertical: 4),
      decoration: const BoxDecoration(color: Color(0XFF18181B)),
      child: Text(
        tag,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
