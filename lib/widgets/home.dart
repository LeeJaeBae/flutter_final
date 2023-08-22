import 'dart:convert';

import 'package:final_report/widgets/detail.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _getPopularMovies();
    _getNowMovies();
    _getComingSoon();
  }

  var _popularMovies = [];
  var _nowPlayingMovies = [];
  var _comingSoonMovies = [];

  _getPopularMovies() async {
    var url = Uri.parse('https://movies-api.nomadcoders.workers.dev/popular');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _popularMovies = jsonDecode(response.body)['results'];
      });
      print(_popularMovies);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  _getComingSoon() async {
    var url =
        Uri.parse('https://movies-api.nomadcoders.workers.dev/coming-soon');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _comingSoonMovies = jsonDecode(response.body)['results'];
      });
      print(_comingSoonMovies);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  _getNowMovies() async {
    var url =
        Uri.parse('https://movies-api.nomadcoders.workers.dev/now-playing');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _nowPlayingMovies = jsonDecode(response.body)['results'];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      'Popular Movies',
                      style: titleStyle,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: _buildPopularMoviesList(),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      'Now In Cinemas',
                      style: titleStyle,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: _buildNowPlayingMoviesList(),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      'Coming Soon',
                      style: titleStyle,
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: _buildComingSoon(),
                  )
                ],
              )),
        ));
  }

  ListView _buildNowPlayingMoviesList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _nowPlayingMovies.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return _buildNowMovieItem(index);
      },
    );
  }

  Container _buildNowMovieItem(int index) {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Column(
        children: [
          InkWell(
            child: _buildNowMoviePoster(index),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MovieDetail(
                  movie: _nowPlayingMovies[index],
                );
              }));
            },
          ),
          Text(
            _nowPlayingMovies[index]['title'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }

  Container _buildNowMoviePoster(int index) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(
              'https://image.tmdb.org/t/p/w500${_nowPlayingMovies[index]['poster_path']}'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  ListView _buildComingSoon() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _comingSoonMovies.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return _buildComingSoonItem(index);
      },
    );
  }

  Container _buildComingSoonItem(int index) {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Column(
        children: [
          InkWell(
            child: _buildComingSoonPoster(index),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MovieDetail(
                  movie: _comingSoonMovies[index],
                );
              }));
            },
          ),
          Text(
            _comingSoonMovies[index]['title'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }

  Container _buildComingSoonPoster(int index) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(
              'https://image.tmdb.org/t/p/w500${_comingSoonMovies[index]['poster_path']}'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _buildPopularMovieItem(int index) {
    return Container(
      width: 300,
      height: 200,
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Column(
        children: [
          InkWell(
            child: _buildPopularMoviePoster(index),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MovieDetail(
                  movie: _popularMovies[index],
                );
              }));
            },
          ),
        ],
      ),
    );
  }

  Container _buildPopularMoviePoster(int index) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(
              'https://image.tmdb.org/t/p/w500${_popularMovies[index]['poster_path']}'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  ListView _buildPopularMoviesList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _popularMovies.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return _buildPopularMovieItem(index);
      },
    );
  }
}

TextStyle titleStyle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
