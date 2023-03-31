import 'package:dbk_jobs_guide/analytics_service.dart';
import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:dbk_jobs_guide/dataEngine.dart';
import 'package:dbk_jobs_guide/loading.dart';
import 'package:dbk_jobs_guide/responsive.dart';
import 'package:dbk_jobs_guide/sideDrawer.dart';
// import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:webviewx/webviewx.dart';

import 'navButtons.dart';

class JobFinder extends StatefulWidget {
  const JobFinder({super.key});

  @override
  State<JobFinder> createState() => _JobFinderState();
}

class _JobFinderState extends State<JobFinder> {
  List studentList = [];
  List gradList = [];
  processRSS() async {
    print("runing get RSS feed()");

    String studentLink =
        "https://ejobs.umd.edu/postings/search.atom?utf8=%E2%9C%93&query=&query_v0_posted_at_date=&1950%5B%5D=5&805=&806=&commit=Search";
    String gradLink =
        "https://ejobs.umd.edu/postings/search.atom?utf8=%E2%9C%93&query=&query_v0_posted_at_date=&1950%5B%5D=4&805=&806=&commit=Search";

    Map RSSDataStudent = await DataEngine.fetchRssFeed(studentLink);
    Map RSSDataGrad = await DataEngine.fetchRssFeed(gradLink);
    print("after DE fetch");
    studentList = RSSDataStudent['feed']['entry'];

    gradList = RSSDataGrad['feed']['entry'];
    print("success List");
    print("job List lenght ${studentList.length}");

    // await Future.delayed(const Duration(seconds: 1));

    // print(jobList[0].toString());

    AnalyticsService.sendAnalyticsEvent(eventName: "visit_job_finder");
  }

  ValueNotifier changePreview = ValueNotifier({'type': 'student', 'index': 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: const GenericAppBar(),
      body: FutureBuilder(
          future: processRSS(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Loading(message: "Getting latest Jobs");
            }
            return Responsive.isMobile(context)
                ? JobListTiles(studentList: studentList, controlsPreview: changePreview, gradList: gradList)
                : Row(
                    children: [
                      Flexible(flex: 4, child: JobListTiles(studentList: studentList, controlsPreview: changePreview, gradList: gradList)),
                      Flexible(
                        flex: 5,
                        child: ValueListenableBuilder(
                            valueListenable: changePreview,
                            builder: (context, value, _) {
                              return JobDescriptionPreview(studentList: studentList, gradList: gradList, importNotifier: changePreview);
                            }),
                      ),
                    ],
                  );
          }),
    );
  }
}

class JobListTiles extends StatefulWidget {
  List studentList;
  List gradList;

  ValueNotifier controlsPreview;

  JobListTiles({super.key, required this.studentList, required this.gradList, required this.controlsPreview});

  @override
  State<JobListTiles> createState() => _JobListTilesState();
}

class _JobListTilesState extends State<JobListTiles> {
  int selectedIndex = 0;
  List useList = [];

  @override
  Widget build(BuildContext context) {
    if (widget.controlsPreview.value['type'] == "student") {
      useList = widget.studentList;
    } else {
      useList = widget.gradList;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: FormBuilder(
            child: SizedBox(
              width: 200,
              // height: 40,

              child: FormBuilderDropdown(
                  decoration: const InputDecoration(
                    isDense: true,
                    // suffixIconConstraints: BoxConstraints(maxHeight: 1, maxWidth: 1),
                    hintText: "Education Level",
                    label: Text("Education Level"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  name: "experience",
                  onChanged: (newVal) {
                    widget.controlsPreview.value['type'] = newVal.toString().toLowerCase();
                    print(widget.controlsPreview.value);

                    setState(() {
                      // if (newVal == "Student") {
                      //   useList = widget.studentList;
                      // } else {
                      //   useList = widget.gradList;
                      // }
                    });
                  },
                  initialValue: 'Student',
                  items: ['Student', 'Graduate'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList()),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: useList.length,
              itemBuilder: ((BuildContext context, int index) {
                Map currJob = useList[index];
                return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          // Should automatically build the preview with INDEX & jobList
                          widget.controlsPreview.value = {'type': widget.controlsPreview.value['type'], 'index': selectedIndex};

                          // widget.controlsPreview.notifyListeners();

                          // NEED TO FORCE side screen to refresh
                        });
                      },
                      child: Container(
                        decoration: index == selectedIndex ? selectedJobListDecoration : normalJobListDecoration,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(currJob['title'].toString(), style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
                                  Text("${currJob['author']['name']}", style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: tagDecoration,
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Text(
                                              "Posted ${formatRSSDate(currJob['published'])}",
                                              style: const TextStyle(color: Colors.black),
                                            ),
                                          )),
                                      const SizedBox(width: 5),
                                      Container(
                                          decoration: tagDecoration,
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Text(widget.controlsPreview.value['type'] == 'student' ? "Student" : "Graduate",
                                                style: const TextStyle(color: Colors.black)),
                                          )),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap: () {
                                          html.window.open(currJob['id'], 'new tab');
                                        },
                                        child: Container(
                                            decoration: ejobsTag,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.arrow_outward_rounded, size: 20),
                                                  SizedBox(width: 2),
                                                  Text("Apply", style: TextStyle(color: Colors.black)),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Responsive.isMobile(context)
                            //     ? Container()
                            //     : InkWell(
                            //         onTap: () {
                            //           // html.window.open("${currJob['id']}/pre_apply", 'new tab');
                            //           html.window.open(currJob['id'], 'new tab');
                            //         },
                            //         child: Container(
                            //           decoration: applyButtonDecoration,
                            //           child: const Padding(
                            //             padding: EdgeInsets.all(10),
                            //             child: Column(
                            //               children: [
                            //                 Icon(
                            //                   Icons.arrow_outward_rounded,
                            //                   size: 20,
                            //                   color: Colors.black,
                            //                 ),
                            //                 Text(
                            //                   "Apply",
                            //                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                          ]),
                        ),
                      ),
                    ));
              })),
        ),
      ],
    );
  }
}

class JobDescriptionPreview extends StatelessWidget {
  List studentList;
  List gradList;

  ValueNotifier importNotifier;

  JobDescriptionPreview({super.key, required this.studentList, required this.importNotifier, required this.gradList});

  String htmlContent = "";

  getHTMLData() async {
    String url = "";

    if (importNotifier.value['type'] == 'student') {
      url = "${CORS_AWS + studentList[importNotifier.value['index']]['id']}/print_preview";
    } else {
      url = "${CORS_AWS + gradList[importNotifier.value['index']]['id']}/print_preview";
    }

    print(">>> FETCHING FROM URL$url");
    var response = await http.get(Uri.parse(url));

    // print(response.statusCode);
    // print(response.body);
    htmlContent = response.body;
    htmlContent = htmlContent.replaceAll("/assets/", "https://ejobs.umd.edu/assets/");
    // await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getHTMLData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // return const Text("Loading preview... Hold on...");
            return Loading(message: "Building Preview");
          }
          return Container(
            decoration: filterDecorations,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: WebViewX(
                height: MediaQuery.of(context).size.height - 120,
                width: MediaQuery.of(context).size.width - 75,
                initialContent: htmlContent,
                initialSourceType: SourceType.html,

                // onWebViewCreated: (controller) => webviewController = controller,
              ),
            ),
          );
        });
  }
}
