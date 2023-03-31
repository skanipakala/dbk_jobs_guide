import 'package:dbk_jobs_guide/analytics_service.dart';
import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/dataEngine.dart';
import 'package:dbk_jobs_guide/loading.dart';
import 'package:dbk_jobs_guide/navButtons.dart';
import 'package:dbk_jobs_guide/sideDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesktopReviewScreen extends StatelessWidget {
  Map cur;
  DesktopReviewScreen({super.key, required this.cur});

  List reviews = [];

  Map wageData = {};

  getReviewData() async {
    Map allReviews = await DataEngine.readReviewJSON();
    reviews = allReviews[cur['unit']]['reviews'];
    wageData = allReviews[cur['unit']]['wage_range'];
    print('DESKTOP REVIEWS --> FETCHED FROM REVIEWS.JSON Data ==> ${reviews.length}');

    print('FETCHED FROM REVIEWS.JSON Data ==> ${reviews.length}');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String querySend = prefs.getString("search") ?? "EMPTY";
    AnalyticsService.sendAnalyticsEvent(eventName: "see_reviews", moreInfo: {'unit': cur['unit'].toString(), 'searchQuery': querySend});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: const GenericAppBar(),
      body: FutureBuilder(
          future: getReviewData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Loading(message: "getting reviews...");
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 15, 5, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.arrow_back, color: dbkRed, size: 30),
                        label: Text(
                          "Back",
                          style: TextStyle(fontSize: 24, color: dbkRed),
                        ),
                        onPressed: () {
                          Navigator.pop(context);

                          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WageSearchPage()));
                        },
                      ),
                      Text('${cur['unit']} reviews', textAlign: TextAlign.center, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                      Container()
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [cur['department'], "${reviews.length} Reviews", "Pay range \$${wageData['min']} - \$${wageData['max']}"].map((e) {
                      return Container(
                          decoration: tagDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              "$e",
                              style: const TextStyle(color: Colors.black, fontSize: 21),
                            ),
                          ));
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: reviews.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.chat_outlined, size: 40),
                              SizedBox(height: 10),
                              Text("No reviews for this unit", style: TextStyle(fontSize: 20)),
                            ],
                          )
                        : ListView.builder(
                            itemCount: reviews.length,
                            itemBuilder: ((context, index) {
                              Map curRev = reviews[index];

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${curRev['job_title']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                                width: 1000,
                                                child:
                                                    Text("${curRev['review']}", maxLines: 10, softWrap: true, style: const TextStyle(fontSize: 18))),
                                            const SizedBox(height: 10),
                                            Container(
                                              decoration: tagDecoration,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Posted on ${formatRSSDate(curRev['timestamp'])}",
                                                    maxLines: 10, softWrap: true, style: const TextStyle(fontSize: 18)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                            decoration: tagDecoration,
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Text(
                                                "\$${curRev['hourly_rate']}",
                                                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                  )
                ],
              ),
            );
          }),
    );
  }
}
