import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Favor extends StatelessWidget {
  const Favor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          title: Text(
            'Liked Webtoons',
            style: const TextStyle(fontSize: 22),
          ),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
        ));
  }
}
