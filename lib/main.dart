import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/decider.dart';
import 'package:dbk_jobs_guide/keys.dart';
import 'package:dbk_jobs_guide/navButtons.dart';
import 'package:dbk_jobs_guide/searchBox.dart';
import 'package:dbk_jobs_guide/sideDrawer.dart';
import 'package:dbk_jobs_guide/smartFilters.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:easy_web_view/easy_web_view.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // You may need to fill in the below API keys if you want to track clicks, navigation, and other user engagement metrics
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: apiKey, appId: appId, messagingSenderId: messagingSenderId, projectId: projectId));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await prefs.remove("filterState");
  await prefs.setString("search", "");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DBK Jobs Guide',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const JobFinder(),
        // home: const SubmitReviewScreen()

        home: const WageSearchPage()
        // home: NewsPage()
        // home: const SubmitReviewScreen()
        // home: const TestReview()
        // home: const WageSearchPage()
        // home: DesktopReviewScreen(cur: const {})

        // home: const AboutPage()
        // home: const NewHomePage(),
        );
  }
}

class WageSearchPage extends StatefulWidget {
  const WageSearchPage({super.key});

  @override
  State<WageSearchPage> createState() => _WageSearchPageState();
}

class _WageSearchPageState extends State<WageSearchPage> {
  ValueNotifier controlDecider = ValueNotifier("");
  ValueNotifier refreshSearchBox = ValueNotifier("");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GenericAppBar(),

              // AnchorButtons(),

              ValueListenableBuilder(
                  valueListenable: refreshSearchBox,
                  builder: (context, value, _) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: SizedBox(width: 500, child: SearchBox(importControlDecider: controlDecider)),
                    );
                  }),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SmartFilters(importDeciderControl: controlDecider, refreshSearchBox: refreshSearchBox),
              )
            ],
          ),

          //
          Expanded(
            // height: MediaQuery.of(context).size.height - 240,
            // width: MediaQuery.of(context).size.width - 10,
            child: SingleChildScrollView(
              child: ValueListenableBuilder(
                  valueListenable: controlDecider,
                  builder: (context, value, _) {
                    return QueryDecider(
                      // deciderState: DECIDER.DEFAULT,
                      importControlDecider: controlDecider,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class FancyDBKBar extends StatelessWidget {
  const FancyDBKBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.dstATop),
              image: AssetImage(
                'assets/images/background.jpg',
              ),
              fit: BoxFit.cover,
              opacity: 0.35)),
      height: 260,
      // color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "THE DIAMONDBACK",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                        fontFamily: 'AgencyFB-Bold',
                      ),
                    ),
                    Text(
                      "WAGE GUIDE",
                      style: TextStyle(
                          fontSize: 60, fontWeight: FontWeight.bold, color: dbkRed, fontFamily: 'AgencyFB-Bold'),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Text(
            "EXPLORE",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.yellow,
            size: 30,
          ),
        ],
      ),
    );
  }
}
