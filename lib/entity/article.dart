import 'package:hive/hive.dart';
import 'package:news_api_app/controller/uuid.dart';
import 'package:uuid/uuid.dart';

part 'article.g.dart';

@HiveType(typeId: 1)
class Article {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? auther;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? url;
  @HiveField(5)
  final String? imgUrl;
  @HiveField(6)
  final DateTime? publishedAt;

  Article({
    this.id,
    this.auther,
    this.title,
    this.description,
    this.url,
    this.imgUrl,
    this.publishedAt,
  });

  static List<Article> fromList(List<Map<String, dynamic>> list) {
    List<Article> articles = [];

    for (var item in list) {
      final DateTime time = DateTime.parse(item['publishedAt']);

      final article = Article(
        id: uuid.v5(Uuid.NAMESPACE_URL, item['url']),
        auther: item['source']['name'] ?? '',
        title: item['title'] ?? '',
        description: item['description'] ?? '',
        url: item['url'] ?? '',
        imgUrl: item['urlToImage'] ?? '',
        publishedAt: time,
      );

      articles.add(article);
    }

    return articles;
  }
}
