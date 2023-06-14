import 'package:flutter/material.dart';
import 'package:flutter_application_kobis2/kobis_api.dart';

class MovieDetail extends StatelessWidget {
  final String movieCd;
  MovieDetail({super.key, required this.movieCd});
  var kobisApi = KobisApi(apikey: 'd14ac539587c46a3421ee909edbf9a45');

  @override
  Widget build(BuildContext context) {
    kobisApi.getMoieDetail(movieCd: movieCd);

    return Scaffold(
      body: Text(movieCd),
    );
  }
}
