import 'dart:convert';

import 'package:http/http.dart' as http;

class KobisApi {
  final String apikey;
  final String _site = 'http://www.kobis.or.kr/kobisopenapi/webservice/rest';
  KobisApi({required this.apikey});

  Future<List<dynamic>> getDailyBoxOffice({required String targetDt}) async {
    var uri = '$_site/boxoffice/searchDailyBoxOfficeList.json';
    uri = '$uri?key=$apikey';
    uri = '$uri&targetDt=$targetDt';
    var response = await http.get(Uri.parse(uri));
    //get 주소창으로 정보를 넘기는것 => 주소창에 정보가 다 보임
    //post 헤더에 정보를 넘김 => 주소창에 안보임 ex) id, pw

    if (response.statusCode == 200) {
      //정상 boxOfficeResult.dailyBoxOfficeList
      try {
        var movies = jsonDecode(response.body)['boxOfficeResult']
            ['dailyBoxOfficeList'] as List<dynamic>;
        return movies;
      } catch (e) {
        return [];
      }
    } else {
      //에러
      return [];
    }
  }

  getMoieDetail({required String movieCd}) async {
    var uri = '$_site/movie/searchMovieInfo.json';
    uri = '$uri?key=$apikey';
    uri = '$uri&movieCd=$movieCd';

    var response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      var movie =
          jsonDecode(response.body)['movieInfoResult']['movieInfo'] as dynamic;
      print(movie['movieNm']);
    } else {
      return [];
    }
  }
}
