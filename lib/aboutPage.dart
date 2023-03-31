import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/navButtons.dart';
import 'package:dbk_jobs_guide/responsive.dart';
import 'package:dbk_jobs_guide/sideDrawer.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GenericAppBar(),
      drawer: const SideDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width - 20 : 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text("About DBK Jobs Guide", style: TextStyle(fontSize: 21)),
                const SizedBox(height: 10),
                const Text(
                  """
🛠 Design and Development: Sri Kanipakala
⚙ Digital Production: Nataraj Shivaprasad
📊 Data Management: Rina Torchinsky
                      """,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                Text(ABOUT_DBK, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                Container(
                  child: Column(
                    children: [
                      const Text(
                          "Feel free to contact us at onlineumdbk@gmail.com with any thoughts, feedback or ideas for future guides. You can submit News Tips below. Checkout DBK salary guide for more wage data.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: tagDecoration,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    html.window.open("onlineumdbk@gmail.com", 'new tab');
                                  },
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [Icon(Icons.email), Text("Send feedback")],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              decoration: tagDecoration,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    html.window.open("https://dbknews.com/tips/", 'new tab');
                                  },
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [Icon(Icons.newspaper), Text("Submit News Tip")],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              decoration: tagDecoration,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    html.window.open("https://salaryguide.dbknews.com/", 'new tab');
                                  },
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [Icon(Icons.attach_money_rounded), Text("DBK Salary Guide")],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width - 10 : 800,
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        {'name': 'facebook', 'link': 'https://www.facebook.com/TheDiamondback/'},
                        {
                          'name': 'twitter',
                          'link': 'https://twitter.com/thedbk?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor'
                        },
                        {'name': 'youtube', 'link': 'https://www.youtube.com/user/DiamondbackVideo'},
                        {'name': 'instagram', 'link': 'https://www.instagram.com/thedbk/?hl=en'},
                      ].map((e) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: InkWell(
                            onTap: () {
                              html.window.open(e['link'].toString(), 'new tab');
                            },
                            child: Image.asset(
                              "assets/images/${e['name']}.png",
                              height: 75,
                              width: 75,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const Text("")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String ABOUT_DBK = """
The Diamondback is committed to transparency and accountability in our coverage. Our jobs guide is designed to help University of Maryland students make informed decisions and share their experiences with those entering the revolving door of campus life.

We obtained data on student wages through public information act requests, a process through which anyone can request public records. The data on this site covers workers employed in April of each year. 

The data on this site is published as we received it. Each row represents a filled position and corresponding wage, education level, work group and unit. Some work groups are marked with asterisks or are otherwise unclear. In the interest of transparency, we have kept those symbols and labels as the university delivered them to us.

The complementary job finder feature pulls data from the university’s campus job portal. The Diamondback collects reviews through an anonymous form. The reviews are unverified and have been edited for clarity. The views expressed in reviews are the author’s own.
""";
