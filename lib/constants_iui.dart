import 'package:dbk_jobs_guide/JobFinder.dart';
import 'package:dbk_jobs_guide/main.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// Color dbkRed = const Color(0x00e51937);

Color dbkRed = const Color(0xFFE51937);

TextStyle menuTitleStyle = const TextStyle(color: Colors.white, fontSize: 15);
TextStyle headerStyle = const TextStyle(color: Colors.black, fontSize: 22);

BoxDecoration filterDecorations = const BoxDecoration(
  // color: Colors.white.withOpacity(0.5),
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(10)),
  // boxShadow: [
  //   BoxShadow(
  //     color: Colors.grey.withOpacity(0.5),
  //     spreadRadius: 2,
  //     blurRadius: 4,
  //     offset: const Offset(0, 3), // changes position of shadow
  //   ),
  // ],
);

BoxDecoration mobileNewsList = BoxDecoration(
  color: Colors.grey.shade200,
  border: const Border(
    bottom: BorderSide(
      width: 1,
      color: Colors.grey,
    ),
  ),
);

BoxDecoration mobileWageList = const BoxDecoration(
  // color: Colors.grey.shade200,
  // border: Border.fromBorderSide(),
  border: Border(
    bottom: BorderSide(
      width: 1,
      color: Colors.grey,
    ),
  ),
);

BoxDecoration tableDecor = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(20)),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 4,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ],
);

BoxDecoration TileOption = BoxDecoration(
  color: Colors.white.withOpacity(0.7),
  borderRadius: const BorderRadius.all(Radius.circular(10)),
);

BoxDecoration normalJobListDecoration = const BoxDecoration(
  color: Colors.white,
  border: Border(
    bottom: BorderSide(
      width: 1,
      color: Colors.grey,
    ),
  ),
);

BoxDecoration selectedJobListDecoration = BoxDecoration(
  color: Colors.grey.shade200,
  borderRadius: const BorderRadius.all(Radius.circular(5)),
  border: Border.all(color: Colors.grey.shade800, width: 2),
);

BoxDecoration applyButtonDecoration = BoxDecoration(
  color: Colors.amber.shade700,
  borderRadius: const BorderRadius.all(Radius.circular(15)),
  // boxShadow: [
  //   BoxShadow(
  //     color: Colors.grey.withOpacity(0.5),
  //     spreadRadius: 2,
  //     blurRadius: 4,
  //     offset: const Offset(0, 3), // changes position of shadow
  //   ),
  // ],
);

BoxDecoration resetButton = const BoxDecoration(
  color: Colors.red,
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

BoxDecoration tagDecoration = BoxDecoration(
  color: Colors.grey.shade300,
  borderRadius: const BorderRadius.all(Radius.circular(5)),
);

BoxDecoration ejobsTag = BoxDecoration(
  color: Colors.blue.shade200,
  borderRadius: const BorderRadius.all(Radius.circular(5)),
);

String donateURL = "https://donate.dbknews.com/";

String submitReview =
    "https://docs.google.com/forms/d/e/1FAIpQLSdZRYn6_fyVnfitlmuRpGLRr88tWSOYHgBTgQE_t5ygrryRzA/viewform";

TextStyle salaryStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: dbkRed);
TextStyle otherCellStyle = const TextStyle(fontSize: 20);

// String CORS_AWS = "https://dbk-wage-guide-env2.us-east-1.elasticbeanstalk.com/";
String CORS_AWS = "https://dev.cors.dbknews.com/";

// String CORS_AWS = "";

class Tile {
  String iconText;
  String title;

  MaterialPageRoute route;

  Tile({required this.iconText, required this.title, required this.route});

  static List<Tile> tileList = [
    Tile(iconText: "💰", title: "Search Wages", route: MaterialPageRoute(builder: (context) => const WageSearchPage())),
    Tile(iconText: "💼", title: "Find Jobs", route: MaterialPageRoute(builder: (context) => const JobFinder())),
    Tile(iconText: "📊", title: "Explore Data", route: MaterialPageRoute(builder: (context) => const WageSearchPage())),
  ];
}
