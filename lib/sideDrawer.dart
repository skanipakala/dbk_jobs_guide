import 'package:dbk_jobs_guide/JobFinder.dart';
import 'package:dbk_jobs_guide/aboutPage.dart';
import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/donateScreen.dart';
import 'package:dbk_jobs_guide/main.dart';
import 'package:dbk_jobs_guide/newspage.dart';
import 'package:dbk_jobs_guide/submitReview.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
      backgroundColor: dbkRed,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // const UserAccountsDrawerHeader(accountName: Text("DBK Jobs Guide"), accountEmail: Text("copyright DBK")),
                // Column(
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WageSearchPage()));
                  },
                  child: const ListTile(
                      leading: Icon(
                        Icons.attach_money_sharp,
                        color: Colors.white,
                        size: 40,
                      ),
                      title: Text("EXPLORE WAGES", style: TextStyle(fontSize: 24, color: Colors.white))),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const JobFinder()));
                  },
                  child: const ListTile(
                      leading: Icon(
                        Icons.work,
                        color: Colors.white,
                        size: 40,
                      ),
                      title: Text("FIND A JOB", style: TextStyle(fontSize: 24, color: Colors.white))),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const NewsPage()));
                  },
                  child: const ListTile(
                      leading: Icon(
                        Icons.newspaper,
                        color: Colors.white,
                        size: 40,
                      ),
                      title: Text("NEWS", style: TextStyle(fontSize: 24, color: Colors.white))),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    // html.window.open(submitReview, 'new tab');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SubmitReviewScreen()));
                  },
                  child: const ListTile(
                      leading: Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: 40,
                      ),
                      title: Text("SUBMIT REVIEW", style: TextStyle(fontSize: 24, color: Colors.white))),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AboutPage()));
                  },
                  child: const ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 40,
                      ),
                      title: Text("ABOUT", style: TextStyle(fontSize: 24, color: Colors.white))),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    // html.window.open(donateURL, 'new tab');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DonateScreen()));
                  },
                  child: const ListTile(
                      leading: Icon(
                        Icons.handshake_sharp,
                        color: Colors.white,
                        size: 40,
                      ),
                      title: Text("DONATE", style: TextStyle(fontSize: 24, color: Colors.white))),
                ),

                //   ],
                // ),
              ],
            ),

            //   const SizedBox(
            //   height: 200,
            // ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () {},
                      icon: const Icon(Icons.developer_mode_sharp, size: 25),
                      label: const Text(
                        "Coded by Sri Kanipakala 4.23",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
