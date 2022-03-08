import 'package:flutter/material.dart';
import 'package:news_api_app/const.dart';
import 'package:news_api_app/controller/get_api.dart';
import 'package:news_api_app/repository/article_box.dart';
import 'package:news_api_app/repository/time_box.dart';

import '../entity/article.dart';

class GetData {
  static Future<void> update(BuildContext context) async {
    final DateTime boxDate = TimeBox.getDate()!;
    final Duration diff = DateTime.now().difference(boxDate);
    // print(diff.inMinutes);
    bool isNeedUpdate() => diff.inMinutes >= 60;
    // print(isNeedUpdate());

    if (isNeedUpdate()) {
      final List<Map<String, dynamic>> data = await GetApi.getData();
      final List<Article> articleList = Article.fromList(data);

      print(articleList[0].title);
      print(articleList);

      ArticleBox.updateNew(articleList);
      TimeBox.update(DateTime.now());

      //update後にSnackbarを表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: pPink,
          // 角を丸くする
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'success update',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

      //updateしなかった場合にSnackbarを表示
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: pPink,
          // 角を丸くする
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'not updated. next update will be in ${60 - diff.inMinutes} minutes',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ArticleBox.addAll(articleList);
  }
}
