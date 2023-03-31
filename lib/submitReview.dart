import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/dataStudio.dart';
import 'package:dbk_jobs_guide/navButtons.dart';
import 'package:dbk_jobs_guide/responsive.dart';
import 'package:dbk_jobs_guide/sideDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

// class SubmitReviewScreen extends StatelessWidget {
//   const SubmitReviewScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const GenericAppBar(),
//       drawer: const SideDrawer(),
//       body: Iframe(
//         uniqueID: "GOOGLE_FORM",
//         url:
//             "https://docs.google.com/forms/d/e/1FAIpQLSdZRYn6_fyVnfitlmuRpGLRr88tWSOYHgBTgQE_t5ygrryRzA/viewform?embedded=true",
//         height: MediaQuery.of(context).size.height - 10,
//         width: MediaQuery.of(context).size.width - 100,
//       ),
//     );
//   }
// }

class SubmitReviewScreen extends StatefulWidget {
  const SubmitReviewScreen({super.key});

  @override
  State<SubmitReviewScreen> createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  final GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SliderDrawer(
      key: _key,
      sliderOpenSize: 280,
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
      slider: const SideDrawer(),
      child: Container(
        color: Colors.white,
        child: Iframe(
          uniqueID: "GOOGLE_FORM",
          url: "https://docs.google.com/forms/d/e/1FAIpQLSdZRYn6_fyVnfitlmuRpGLRr88tWSOYHgBTgQE_t5ygrryRzA/viewform?embedded=true",
          height: MediaQuery.of(context).size.height - 5,
          width: MediaQuery.of(context).size.width - 5,
        ),
      ),
    ));
  }
}
