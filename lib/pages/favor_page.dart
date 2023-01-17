import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_toons/models/webtoon_detail_model.dart';
import 'package:flutter_naver_toons/services/api_service.dart';

import 'package:flutter_naver_toons/widgets/webtoon_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favor extends StatefulWidget {
  const Favor({Key? key}) : super(key: key);

  @override
  State<Favor> createState() => _FavorState();
}

class _FavorState extends State<Favor> {
  late SharedPreferences prefs;
  late Future<WebtoonDetailModel> likedWebtoon;

  Future initPref() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');

    return likedToons;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPref();
  }

/*
prefs에서 id가 담긴 list를 받아옴. getToonsById (likedWebtoonDetailModel)를 이용해 title, thumb, id를 likedWebtoon위젯에 넘겨주어 home과 같은 방식으로 리스트를 만든다. 
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          title: Text(
            'Favorite Webtoons',
            style: const TextStyle(fontSize: 22),
          ),
          elevation: 1,
        ),
        body: FutureBuilder(
          future: initPref(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(height: 100),
                  Expanded(child: makeList(snapshot))
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  ListView makeList(AsyncSnapshot<dynamic> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        if (snapshot.hasData) {
          final str = snapshot.data![index];
          List<String> result = str.split(',');
          return Webtoon(title: result[0], thumb: result[1], id: result[2]);
        } else
          throw Error();
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 40);
      },
    );
  }
}
