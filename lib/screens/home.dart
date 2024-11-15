import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libremovies/components/movie_category_list.dart';
import 'package:libremovies/components/overlapped_carousel_item.dart';
import 'package:libremovies/models/response/movie.dart';
import 'package:libremovies/models/response/tmdb_result.dart';
import 'package:libremovies/providers/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieProvider movieProvider = Get.find();
  Color primaryColor = Get.theme.primaryColor;
  MovieList? movieList;
  TmdbMovieResult? nowPlayingList;
  TmdbMovieResult? popularList;
  TmdbMovieResult? topRatedList;
  TmdbMovieResult? onTheAirSeriesList;

  Future<void> getMovies() async {
    var res = await movieProvider.getLatestMovies(1);

    setState(() {
      movieList = res;
    });
  }

  Future<void> getNowPlayingMovies() async {
    var res = await movieProvider.getTMDBMovieNowPlaying('1');

    setState(() {
      nowPlayingList = res;
    });
  }

  Future<void> getTopRatedMovies() async {
    var res = await movieProvider.getTMDBTopRated('1');

    setState(() {
      topRatedList = res;
    });
  }

  Future<void> getPopularMovies() async {
    var res = await movieProvider.getTMDBMoviePopularMovies('1');

    setState(() {
      popularList = res;
    });
  }

  Future<void> getOnTheAirSeries() async {
    var res = await movieProvider.getTMDBMovieOnTheAirSeries('1');

    setState(() {
      onTheAirSeriesList = res;
    });
  }

  @override
  void initState() {
    getNowPlayingMovies();
    getPopularMovies();
    getTopRatedMovies();
    getOnTheAirSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: const Color(0XFFf2f2f2),
            unselectedLabelStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.transparent,
            selectedItemColor: primaryColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.file_download_outlined),
                label: 'Download',
              ),
            ]),
        backgroundColor: const Color(0xFF17181B),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: CupertinoTextField(
                    prefix: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_list,
                          color: primaryColor,
                        )),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0XFFf2f2f2)),
                    suffix: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: primaryColor,
                        )),
                  )),
              TabBar(
                indicatorColor: primaryColor,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.white,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Now Playing'),
                  Tab(text: 'Series'),
                  Tab(text: 'Top Rated'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: buildCarousel(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Popular Movies',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          MovieCategoryList(
                              tag: 'popular', movies: popularList),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Top Rated Movies',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          MovieCategoryList(
                              tag: 'top rated', movies: topRatedList),
                        ],
                      )),
                    ), // Latest movies
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  height: Get.height * .4,
                                  viewportFraction: .65),
                              items: onTheAirSeriesList?.results?.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return OverlappedCarouselItem(
                                        tag: 'Now Playing', movie: i);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Popular Series',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          MovieCategoryList(
                              tag: 'popular', movies: popularList),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Top Rated Series',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          MovieCategoryList(
                              tag: 'top rated', movies: topRatedList),
                        ],
                      )),
                    ),
                    buildCarousel(), // Trending movies
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the carousel
  Widget buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
          enlargeCenterPage: true,
          height: Get.height * .4,
          viewportFraction: .65),
      items: nowPlayingList?.results?.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return OverlappedCarouselItem(tag: 'Now Playing', movie: i);
          },
        );
      }).toList(),
    );
  }
}
