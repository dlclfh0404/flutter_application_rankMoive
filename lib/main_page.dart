import 'package:flutter/material.dart';
import 'package:flutter_application_kobis2/movie_detail.dart';
import 'kobis_api.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final kobisApi = KobisApi(apikey: 'd14ac539587c46a3421ee909edbf9a45');
  dynamic body = const Center(
    child: Text(
      '영화 🎦',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    ),
  );
  void showCal() async {
    var dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(const Duration(days: 1)),
        firstDate: DateTime(2023),
        lastDate: DateTime.now().subtract(const Duration(days: 1)));
    if (dt != null) {
      //2022-02-02 00:00:00
      var targetDt = dt.toString().split(' ')[0].replaceAll('-', '');
      var movies = kobisApi.getDailyBoxOffice(targetDt: targetDt);
      showList(movies);
    }
  }

  void showList(Future<List<dynamic>> movies) {
    setState(() {
      body = FutureBuilder(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //데이터가 넘어옴
            var movies = snapshot.data;
            return ListView.separated(
                itemBuilder: (context, index) {
                  var rankColor = Colors.white; //기본 컬러
                  if (index == 0) {
                    rankColor = Colors.red; //1등 컬러
                  } else if (index == 1) {
                    rankColor = Colors.blue; //2등 컬러
                  } else if (index == 2) {
                    rankColor = Colors.green; //3등 컬러
                  }
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: rankColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        movies[index]['rank'],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(movies[index]['movieNm']),
                    subtitle: Text('${movies[index]['audiAcc']}'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetail(
                            movieCd: movies[index]['movieCd'],
                          ),
                        )),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: movies!.length);
          } else {
            // 로딩중...
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 달력 보여주기
    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: showCal,
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}
