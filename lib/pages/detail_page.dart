import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_naver_toons/models/webtoon_detail_model.dart';
import 'package:flutter_naver_toons/models/webtoon_episode_model.dart';
import 'package:flutter_naver_toons/services/api_service.dart';
import 'package:flutter_naver_toons/widgets/episode_widget';

class Detail extends StatefulWidget {
  final String title, thumb, id;

  const Detail({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;

  bool isLiked = false;
  /*리스트를 만들고 그 리스트에 좋아요 표시된 웹툰의 id를 모두 저장.
   - Key값 하나에 StringList 활용.*/

  Future initPref() async {
    //앱 시작시에 받아오는 것.
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');

    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        //좋아요 표시된 웹툰
        setState(() {
          isLiked = true;
        });
      }
    } else {
      //List가 null인 경우 새 List를 만들어 디바이스에 저장.
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonsById(widget.id);
    episodes = ApiService.getLatestEpisodeById(widget.id);
    initPref();
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      //initPref에서 이미 List 형태를 만들었기 때문에 null값이 나올 일이 거의 없다.
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }

      await prefs.setStringList('likedToons', likedToons);

      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 22),
          ),
        ),
        actions: [
          IconButton(
              onPressed: onHeartTap,
              icon: Icon(isLiked ? Icons.favorite : Icons.favorite_outline)),
          SizedBox(width: 10)
        ],
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 15,
                              offset: Offset(10, 10),
                              color: Colors.black.withOpacity(0.3))
                        ],
                      ),
                      child: Image.network(
                        widget.thumb,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              FutureBuilder(
                future: webtoon,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return (Column(
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Text(' ${snapshot.data!.genre} / ${snapshot.data!.age}')
                      ],
                    ));
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: episodes,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(webtoonId: widget.id, episode: episode)
                      ],
                    );
                  } else
                    return SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
