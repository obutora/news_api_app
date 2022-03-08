import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:news_api_app/main.dart';

class GetApi {
  static Future<List<Map<String, dynamic>>> getData() async {
    const String url = 'https://newsapi.org/v2/top-headlines';
    Dio dio = Dio();

    try {
      Response response = await dio.get(url, queryParameters: {
        'apiKey': apiKey,
        'country': 'jp',
        'category': 'technology',
        'pageSize': '100',
      });

      final Map<String, dynamic> json = jsonDecode(response.toString());
      final List<Map<String, dynamic>> articles =
          json['articles'].cast<Map<String, dynamic>>();

      return articles;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return [
      {
        'status': 'error',
      }
    ];
  }
}
