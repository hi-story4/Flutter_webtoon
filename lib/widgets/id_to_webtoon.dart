import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_naver_toons/models/webtoon_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_toons/services/api_service.dart';
import 'package:flutter_naver_toons/widgets/webtoon_widget.dart';

class IdToToon extends StatefulWidget {
  final String id;
  const IdToToon({super.key, required this.id});

  @override
  State<IdToToon> createState() => _IdToToonState();
}

class _IdToToonState extends State<IdToToon> {
  late Future<WebtoonDetailModel> webtoon;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webtoon = ApiService.getToonsById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: webtoon,
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Webtoon(
                title: snapshot.data!.title,
                thumb: snapshot.data!.thumb,
                id: widget.id);
          } else
            return SizedBox();
        }));
  }
}
