import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/decider.dart';
import 'package:dbk_jobs_guide/navButtons.dart';
import 'package:dbk_jobs_guide/newHome.dart';
import 'package:dbk_jobs_guide/searchBox.dart';
import 'package:dbk_jobs_guide/smartFilters.dart';

// import 'package:easy_web_view/easy_web_view.dart';

import 'package:flutter/material.dart';

class NewWageSearchEnginePage extends StatefulWidget {
  const NewWageSearchEnginePage({super.key});

  @override
  State<NewWageSearchEnginePage> createState() => _NewWageSearchEnginePageState();
}

class _NewWageSearchEnginePageState extends State<NewWageSearchEnginePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
              const AnchorButtons()
            ],
          ),
          backgroundColor: dbkRed),
      body: SingleChildScrollView(
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}
