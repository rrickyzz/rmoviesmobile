import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libremovies/models/response/imdb_details.dart';
import 'package:libremovies/models/response/tmdb_result.dart';
import 'package:libremovies/providers/movie.dart';
import 'package:libremovies/screens/movie_info.dart';
import 'package:libremovies/utils/movie.dart';

class OverlappedCarouselItem extends StatefulWidget {
  final String tag;
  final TMDBMovie movie;
  const OverlappedCarouselItem(
      {super.key, required this.movie, required this.tag});

  @override
  State<OverlappedCarouselItem> createState() => _OverlappedCarouselItemState();
}

class _OverlappedCarouselItemState extends State<OverlappedCarouselItem> {
  ImdbDetails? imdbDetails;
  String? posterPath;
  final MovieProvider movieProvider = Get.find();
  

  @override
  void initState() {
    movieProvider.getMovieImdb(widget.movie.id.toString()).then((value) {
      setState(() {
        imdbDetails = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() =>
          MovieInfoSreen(tag: widget.tag, movie: imdbDetails ?? ImdbDetails())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        width: Get.size.width,
        height: Get.size.height,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                errorWidget: (context, url, error) {
                  return Center(
                    child: SizedBox(
                        width: 72,
                        height: 72,
                        child: Image.asset('assets/images/photo-gallery.png')),
                  );
                },
                imageUrl: MovieUtils.getPosterLink(
                    posterPath: imdbDetails?.posterPath ?? ''),
                fit: BoxFit.cover,
                width: Get.size.width,
                height: Get.size.height,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
