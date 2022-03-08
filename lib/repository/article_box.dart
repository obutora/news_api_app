import 'package:hive/hive.dart';
import 'package:news_api_app/entity/article.dart';

class ArticleBox {
  static Box<Article>? box;

  static Future<void> init() async {
    box = await Hive.openBox<Article>('articles');
  }

  static List<Article> getAll() {
    final List<Article> articles = box?.values.toList() ?? [];
    articles.sort((a, b) => b.publishedAt!.compareTo(a.publishedAt!));

    return articles;
  }

  static void addAll(List<Article> articles) {
    box!.addAll(articles);
  }

  static void updateNew(List<Article> articles) {
    final boxIdList = box!.values.map((article) => article.id).toList();

    // boxの中のIDが存在しない時のみ新しいデータをBox追加する
    for (final article in articles) {
      final bool isExist = boxIdList.any((oldId) => oldId == article.id);

      // 存在しない時
      if (!isExist) {
        box!.add(article);
      }
    }
  }

  static void deleteFromId(String id) {
    final index =
        box!.values.toList().indexWhere((element) => element.id == id);
    box!.deleteAt(index);
  }

  static void deleteFromIndex(int index) {
    box!.deleteAt(index);
  }

  static void deleteAll() {
    box!.clear();
  }

  // static void sortByDate() {
  //   box = getAll().sort((a, b) => b.publishedAt!.compareTo(a.publishedAt!));
  // }
}
