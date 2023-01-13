import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_naver_toons/models/webtoon_model.dart';
import 'package:flutter_naver_toons/pages/favor_page.dart';
import 'package:flutter_naver_toons/services/api_service.dart';
import 'package:flutter_naver_toons/widgets/webtoon_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final Future<List<WebtoonModel>> webtoons = ApiService().getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              '       Webtoons',
              style: TextStyle(fontSize: 22),
            ),
          ),
          actions: [
            GestureDetector(
                onTap: (() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Favor()));
                }),
                child: Icon(Icons.bookmark_outline)),
            SizedBox(
              width: 10,
            )
          ],
          elevation: 1,
        ),
        body: FutureBuilder(
          future: webtoons,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(height: 100),
                  Expanded(child: makeList(snapshot)),
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
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 40);
      },
    );
  }
}
