import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_api_app/controller/get_data.dart';
import 'package:news_api_app/repository/time_box.dart';
import 'package:news_api_app/view/animation/move.dart';
import 'package:news_api_app/view/widget/fetched_listview.dart';
import 'const.dart';

import 'entity/article.dart';
import 'repository/article_box.dart';

late String? apiKey;

void main() async {
  // Load the .env file
  await dotenv.load(fileName: '.env.api');
  apiKey = dotenv.env['KEY'];

  //hive setup
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());

  await TimeBox.init();
  await ArticleBox.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBarState = useState(true);

    return Scaffold(
      backgroundColor: cardWhite,
      floatingActionButton: appBarState.value
          ? EasingAnimation(
              moveDirection: MoveDirection.topIn,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  EasingAnimation(
                    durationInMilliseconds: 800,
                    curve: Curves.easeOutCirc,
                    moveAmount: 200,
                    moveDirection: MoveDirection.bottomIn,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: bgWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: const Icon(
                        Icons.arrow_upward,
                        color: pPink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: bgWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Icon(
                      Icons.replay_outlined,
                      color: pPink,
                    ),
                    onPressed: (() async {
                      await GetData.update(context);
                    }),
                  ),
                ],
              ),
            )
          : const SizedBox(),
      body: NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (notification is UserScrollNotification) {
            if (notification.direction == ScrollDirection.reverse) {
              appBarState.value = false;
            } else if (notification.direction == ScrollDirection.forward) {
              appBarState.value = true;
            }
          }

          return false;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: ArticleBox.box!.length,
            itemBuilder: (context, index) => FetchedListView(index: index),
          ),
        ),
        // child: CustomScrollView(
        //   physics: const BouncingScrollPhysics(),
        //   slivers: [
        //     SliverAppBar(
        //       backgroundColor: pIndigo,
        //       floating: false,
        //       pinned: appBarState.value,
        //       actions: [
        //         IconButton(
        //           icon: const Icon(Icons.replay_outlined),
        //           onPressed: () {},
        //         ),
        //       ],
        //     ),
        //     SliverList(
        //       delegate: SliverChildBuilderDelegate(
        //         (context, index) => Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 20),
        //           child: FetchedListView(index: index),
        //         ),
        //         childCount: ArticleBox.getAll().length,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
