import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/dataStudio.dart';
import 'package:dbk_jobs_guide/navButtons.dart';
import 'package:dbk_jobs_guide/responsive.dart';
import 'package:dbk_jobs_guide/sideDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class DonateScreen extends StatelessWidget {
  final GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();

  DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const GenericAppBar(),
      // drawer: const SideDrawer(),

      body: SliderDrawer(
        slider: const SideDrawer(),
        appBar: SliderAppBar(
            isTitleCenter: true,
            appBarHeight: 56,
            appBarPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            appBarColor: dbkRed,
            drawerIconColor: Colors.white,
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
            )),
        child: Center(
            child: Container(
          color: Colors.white,
          child: Iframe(
              uniqueID: "DONATE_BOX",
              url: "https://donorbox.org/embed/donate-to-the-diamondback",
              height: MediaQuery.of(context).size.height - 20,
              width: MediaQuery.of(context).size.width - 20),
        )),
      ),
    );
  }
}
