import 'package:dbk_jobs_guide/analytics_service.dart';
import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/dataEngine.dart';
import 'package:dbk_jobs_guide/loading.dart';
import 'package:dbk_jobs_guide/navButtons.dart';
import 'package:dbk_jobs_guide/responsive.dart';
import 'package:dbk_jobs_guide/sideDrawer.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List news = [];

  processRSS() async {
    print("runing get RSS feed()");

    // String newsLink = "https://dbknews.com/tag/wages/feed";

    Map newsDataRAW = await DataEngine.fetchRSSNewsFeed();

    print("newsDataRaw: AQUIRED!");

    news = newsDataRAW['items'];

    print("Return data aquired --> ${news.length}");

    AnalyticsService.sendAnalyticsEvent(eventName: "visit_news");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const GenericAppBar(),
        drawer: const SideDrawer(),
        body: FutureBuilder(
          future: processRSS(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Loading(message: "fetching latest news...");
            }

            return Center(
              child: SizedBox(
                width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width : 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: tagDecoration,
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextButton.icon(
                              style: TextButton.styleFrom(foregroundColor: Colors.black),
                              icon: const Icon(Icons.info),
                              label: const Text(
                                "The Diamondback’s latest coverage on jobs",
                                style: TextStyle(fontSize: 15),
                              ),
                              onPressed: () {},
                            )),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: news.length,
                          itemBuilder: ((context, index) {
                            Map cur = news[index];

                            String? imgUrl = getDBKThumbnail(cur);

                            return InkWell(
                              onTap: () {
                                html.window.open(cur['link'], 'new tab');
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Container(
                                    decoration: mobileWageList,
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          imgUrl == null
                                              ? const Icon(Icons.image, size: 90)
                                              : ClipRRect(
                                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                  // child: Image(
                                                  //   height: 100,
                                                  //   width: 100,
                                                  //   fit: BoxFit.cover,
                                                  //   image: CachedNetworkImageProvider(
                                                  //     "$CORS_AWS$imgUrl",
                                                  //   ),
                                                  child: Image.network(
                                                    "$CORS_AWS$imgUrl",
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                  )),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    cur['title'].toString(),
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                    maxLines: 3,
                                                    softWrap: true,
                                                  )),
                                              Text("Posted ${formatRSSDate(cur['pubDate'])}")
                                            ],
                                          ),
                                          const Icon(Icons.chevron_right_rounded, size: 40)
                                        ],
                                      ),
                                    )

                                    // child: ListTile(
                                    //   leading: imgUrl == null
                                    //       ? const Icon(Icons.image, size: 90)
                                    //       : ClipRRect(
                                    //           borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    //           child: Image(
                                    //             fit: BoxFit.cover,
                                    //             image: CachedNetworkImageProvider(
                                    //               "$CORS_AWS$imgUrl",
                                    //             ),
                                    //           ),
                                    //         ),
                                    //   title: Text(cur['title'].toString()),
                                    //   subtitle: Text("Posted ${formatRSSDate(cur['pubDate'])}"),
                                    //   trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                                    // ),
                                    ),
                              ),
                            );
                          })),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
