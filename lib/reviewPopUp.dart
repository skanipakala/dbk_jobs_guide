import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/dataEngine.dart';
import 'package:dbk_jobs_guide/loading.dart';
import 'package:flutter/material.dart';

class ReviewPopup extends StatelessWidget {
  Map cur;
  ReviewPopup({super.key, required this.cur});

  List reviews = [];
  Map wageData = {};

  getReviewData() async {
    Map allReviews = await DataEngine.readReviewJSON();

    reviews = allReviews[cur['unit']]['reviews'];
    wageData = allReviews[cur['unit']]['wage_range'];

    print('FETCHED FROM REVIEWS.JSON Data ==> ${reviews.length}');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 900,
      child: FutureBuilder(
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
                  Text('${cur['unit']} reviews', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [cur['department'], "Pay range \$${wageData['min']} - \$${wageData['max']}"].map((e) {
                      return Container(
                          decoration: tagDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              "$e",
                              style: const TextStyle(color: Colors.black, fontSize: 15),
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
                              Icon(Icons.chat_outlined, size: 30),
                              SizedBox(height: 10),
                              Text("No reviews for this unit", style: TextStyle(fontSize: 16)),
                            ],
                          )
                        : ListView.builder(
                            itemCount: reviews.length,
                            itemBuilder: ((context, index) {
                              Map curRev = reviews[index];

                              return ListTile(
                                // leading: const Icon(Icons.rate_review_rounded),
                                title: Text("${curRev['job_title']}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                subtitle: Text("${curRev['review']}", style: const TextStyle(fontSize: 14)),
                                trailing: Container(
                                    decoration: tagDecoration,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "\$${curRev['hourly_rate']}",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    )),
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
