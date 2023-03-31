import 'package:dbk_jobs_guide/JobFinder.dart';
import 'package:dbk_jobs_guide/aboutPage.dart';
import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/donateScreen.dart';
import 'package:dbk_jobs_guide/main.dart';
import 'package:dbk_jobs_guide/newspage.dart';
import 'package:dbk_jobs_guide/responsive.dart';
import 'package:dbk_jobs_guide/submitReview.dart';

// import 'package:easy_web_view/easy_web_view.dart';

import 'package:flutter/material.dart';

class GenericAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GenericAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
            Responsive.isMobile(context) ? Container() : const AnchorButtons()
          ],
        ),
        backgroundColor: dbkRed);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56);
}

class AnchorButtons extends StatelessWidget {
  const AnchorButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
              icon: const Icon(
                Icons.attach_money_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WageSearchPage()));
              },
              label: Text(
                "EXPLORE WAGES",
                style: menuTitleStyle,
              )),
          Text(
            "|",
            style: menuTitleStyle,
          ),
          TextButton.icon(
              icon: const Icon(
                Icons.work,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const JobFinder()));
              },
              label: Text(
                "FIND A JOB",
                style: menuTitleStyle,
              )),
          Text(
            "|",
            style: menuTitleStyle,
          ),
          TextButton.icon(
              icon: const Icon(
                Icons.newspaper,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const NewsPage()));
              },
              label: Text(
                "NEWS",
                style: menuTitleStyle,
              )),
          Text(
            "|",
            style: menuTitleStyle,
          ),
          TextButton.icon(
              icon: const Icon(
                Icons.chat,
                color: Colors.white,
              ),
              onPressed: () {
                // html.window.open(submitReview, 'new tab');
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SubmitReviewScreen()));
              },
              label: Text(
                "SUBMIT REVIEW",
                style: menuTitleStyle,
              )),
          Text(
            "|",
            style: menuTitleStyle,
          ),
          TextButton.icon(
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AboutPage()));
              },
              label: Text(
                "ABOUT",
                style: menuTitleStyle,
              )),
          Text(
            "|",
            style: menuTitleStyle,
          ),
          TextButton.icon(
              icon: const Icon(
                Icons.handshake_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                // html.window.open(donateURL, 'new tab');
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DonateScreen()));
              },
              label: Text(
                "DONATE",
                style: menuTitleStyle,
              )),
        ],
      ),
    );
  }
}

class InfoGrid extends StatelessWidget {
  const InfoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 3,
        childAspectRatio: 7 / 1.5,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          {"main_text": "BMGT", "sub_text": "Department with highest student wage"},
          {"main_text": "\$12.75", "sub_text": "Average UMD Student Wage"},
          {"main_text": "ENST", "sub_text": "Department with the Lowest Average Student Wage"},
          {"main_text": "ANSC", "sub_text": "Department with the most student employees"},
          {"main_text": "BSOS", "sub_text": "Department with the Highest Minimum Wage"},
          {"main_text": "CMNS", "sub_text": "Department with the Lowest Average Student Wage"}
        ].map((Map<String, String> e) {
          return Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(8),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.teal[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e['main_text']!, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(e['sub_text']!, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }).toList());
  }
}
