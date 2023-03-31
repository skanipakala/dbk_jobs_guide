import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:flutter/material.dart';

class NewHomePage extends StatelessWidget {
  const NewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 50,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(Colors.black, BlendMode.dstATop),
                      image: AssetImage(
                        'assets/images/large.jpg',
                      ),
                      fit: BoxFit.cover,
                      opacity: 0.35)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          "JOBS GUIDE",
                          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: dbkRed, fontFamily: 'AgencyFB-Bold'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                      child: SizedBox(
                        height: 140,
                        width: 500,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            Tile cur = Tile.tileList[index];

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(cur.route);
                                },
                                child: Container(
                                    height: 130,
                                    width: 130,
                                    decoration: TileOption,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Icon(Icons.attach_money_rounded, size: 35),
                                        Text(cur.iconText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 35)),

                                        Text(cur.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24))
                                      ],
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Text("Explore Data"),
          ],
        ),
      ),
    );
  }
}
