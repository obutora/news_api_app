import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:news_api_app/entity/article.dart';
import 'package:news_api_app/repository/article_box.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../const.dart';

class FetchedListView extends StatelessWidget {
  const FetchedListView({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('MM-dd H');

    return ValueListenableBuilder(
      valueListenable: ArticleBox.box!.listenable(),
      builder: (context, box, widget) {
        final Article article = ArticleBox.getAll()[index];
        return Column(
          children: [
            index == 0 ? const SizedBox(height: 20) : const SizedBox(),
            Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.33,
                children: [
                  SlidableAction(
                    foregroundColor: cardWhite,
                    icon: Icons.delete,
                    backgroundColor: sPink,
                    label: 'delete',
                    onPressed: (context) {
                      final String id = article.id!;
                      ArticleBox.deleteFromId(id);
                    },
                  )
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: pIndigo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      child: Image.network(article.imgUrl!, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Column(
                        children: [
                          Text(
                            article.title!,
                            style: const TextStyle(
                                color: cardWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            article.description!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.auther!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white60,
                                    ),
                                  ),
                                  Text(
                                    format.format(article.publishedAt!) + '時',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white60,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                  style:
                                      ElevatedButton.styleFrom(primary: sPink),
                                  onPressed: () async {
                                    await launch(article.url!);
                                  },
                                  child: const Icon(
                                    Icons.link_outlined,
                                    color: pIndigo,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20)
          ],
        );
      },
    );
  }
}
