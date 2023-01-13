import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_naver_toons/models/webtoon_detail_model.dart';
import 'package:flutter_naver_toons/models/webtoon_episode_model.dart';
import 'package:flutter_naver_toons/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    //get은 항상 Future 형태를 필요로 한다. 정보를 얻어오는데 시간이 필요하고 그 시간을 기다렸다가 함수를 실행해야하기 때문이다.
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      //response.body는 stringㅈㄷ이므로 json(List<dynamic>)으로 변환.
      //json에 있는 모든 item에 대해 webtoon model instance를 만든다.
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));

        //각각 title, thumb, id를 활용할 수 있는 형태로 가져온다.
        /*나열되어 있는 항목들을 List(배열)안에 저장하기 위해 미리 List<WebtoonModel> 형태의 리스트를
        생성해둔 후 for문 안에서 각각 add를 이용해 배열에 데이터를 채워넣음. */
      }
      return webtoonInstances;

      /*webtoonInstances의 데이터 타입이 List<WebtoonModel> 이고 async-await 구문을 이용하므로 
      getTodaysToons 함수는 Future<List<WebtoonModel>> 타입으로 반환된다. */
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonsById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      //String 타입인 resonse.body를 받아와서 json으로 변환시켜 webtoon에 저장.
      return WebtoonDetailModel.fromJson(webtoon);
      //json타입 webtoon을 인자로 넘겨 Constructor of WebtoonDetailModel로 부터 값 받음.
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodeById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      //String 타입인 resonse.body를 받아와서 json으로 변환시켜 episodes에 저장.
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;

      //json타입 webtoon을 인자로 넘겨 Constructor of WebtoonDetailModel로 부터 값 받음.
    }
    throw Error();
  }
}
