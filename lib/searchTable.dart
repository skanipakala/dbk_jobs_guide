import 'dart:convert';

import 'package:dbk_jobs_guide/dataEngine.dart';
import 'package:dbk_jobs_guide/desktopReviews.dart';
import 'package:dbk_jobs_guide/responsive.dart';
import 'package:dbk_jobs_guide/reviewPopUp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants_iui.dart';

class SearchTable extends StatefulWidget {
  ValueNotifier importControlDecider;
  SearchTable({super.key, required this.importControlDecider});

  @override
  State<SearchTable> createState() => _SearchTableState();
}

class _SearchTableState extends State<SearchTable> {
  List masterList = [];

  // MyData source = MyData(inputData: [], context: context);

  // Data processing and applying filters will take place here
  getData() async {
    print("INSIDE GET DATA");
    masterList = [];

    if (DataEngine.unitReviews == {} || DataEngine.unitReviews.isEmpty) {
      await DataEngine.readReviewJSON();
    }

    // await Future.delayed(const Duration(milliseconds: 600));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map filterState = {'year': '2022', 'education': 'undergraduate', 'unit': null, 'workgroup': null};
    if (prefs.containsKey("filterState")) {
      filterState = Map.of(jsonDecode(prefs.getString("filterState")!));
    }

    print("👉👉👉👉👉 INPUT FILTER STATE$filterState");

    if (DataEngine.masterDict == {} || DataEngine.masterDict.isEmpty) {
      Map getDict = await DataEngine.readJSON();
      masterList = getDict[filterState['year']];
    } else {
      masterList = DataEngine.masterDict[filterState['year']];
    }

    List finalFiltered = [];

    // String query = widget.importControlDecider.value.toString().trim().toUpperCase();
    String query = prefs.getString("search")!.trim().toUpperCase();

    print("QUERY INPUT: $query");
    print("SIZE BEFORE: ${masterList.length}");

    // Generic search algorithm

    // String checkYear = filterState['year'] == null?
    for (int i = 0; i < masterList.length; i++) {
      Map e = masterList[i];

      // Checking main filters (if added)
      if ((e['year'] == filterState['year']) &&
          (e['education'] == filterState['education'] || filterState['education'] == "All") &&
          (e['department'] == filterState['department'] || filterState['department'] == null || filterState['department'] == "All") &&
          (e['unit'] == filterState['unit'] || filterState['unit'] == null || filterState['unit'] == "All") &&
          (e['workgroup'] == filterState['workgroup'] || filterState['workgroup'] == null || filterState['workgroup'] == "All")) {
        // Checking keyword matches from search box
        if (checkEachColumnWithSplit(query, e)) {
          finalFiltered.add(e);
        }
      }
    }

    Map columnToName = {0: 'education', 1: 'department', 2: 'unit', 3: 'workgroup', 4: 'wage'};
    finalFiltered.sort((a, b) {
      var left = a[columnToName[curSortColumnIndex]];
      var right = b[columnToName[curSortColumnIndex]];
      return curSortAscending ? Comparable.compare(left, right) : Comparable.compare(right, left);
    });

    print("final filtered size! ${finalFiltered.length}");
    masterList = finalFiltered;
  }

  bool checkEachColumnWithSplit(String query, Map e) {
    List qSplit = query.split(" ");

    bool found = true;

    // List searchList = qSplit + e['tags'];

    // print("search List $searchList");

    List tagList = (e['tags'] as List).map((e) => e.toString().toUpperCase()).toList();

    // print("TAG LIST $tagList");

    for (int i = 0; i < qSplit.length; i++) {
      String qCur = qSplit[i].toUpperCase();
      if (e['wage'].toString().toUpperCase().contains(qCur) ||
          e['unit'].toString().toUpperCase().contains(qCur) ||
          e['workgroup'].toString().toUpperCase().contains(qCur) ||
          e['department'].toString().toUpperCase().contains(qCur) ||
          e['year'].toString().toUpperCase().contains(qCur) ||
          checkTags(qCur, tagList)) {
      } else {
        found = false;
      }
    }

    return found;
  }

  bool checkTags(String target, List tags) {
    for (String tag in tags) {
      if (tag.contains(target)) {
        return true;
      }
    }
    return false;
  }

  int curSortColumnIndex = 0;
  bool curSortAscending = false;
  @override
  Widget build(BuildContext context) {
    print("rendering isMobile true/false --> ${Responsive.isMobile(context)}");

    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // return Loading(message: "Rendering Table");
            return Container();
          }

          // RESPONSIVE (MOBILE?)

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: Responsive.isMobile(context) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info_outline_rounded),
                        const SizedBox(width: 5),
                        Text(
                          "Showing ${masterList.length} results",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Responsive.isMobile(context)
                        ? OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(foregroundColor: dbkRed),
                            onPressed: () {
                              setState(() {
                                curSortColumnIndex = 4;
                                curSortAscending = !curSortAscending;
                              });
                            },
                            icon: curSortAscending ? const Icon(Icons.arrow_upward_rounded) : const Icon(Icons.arrow_downward_rounded),
                            label: const Text("Sort wages"))
                        : Container()
                  ],
                ),
              ),
              Responsive.isMobile(context)
                  ? SizedBox(
                      height: 900,
                      child: ListView.builder(
                        itemCount: masterList.length,
                        itemBuilder: (context, index) {
                          Map cur = masterList[index];
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(height: 500, child: ReviewPopup(cur: cur));
                                },
                              );
                            },
                            child: Container(
                                height: 120,
                                decoration: mobileWageList,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${cur['workgroup']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 2),
                                          Text(
                                            "▶ ${cur['department']}",
                                          ),
                                          const SizedBox(height: 2),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              "▶ ${cur['unit']}",
                                              maxLines: 2,
                                              softWrap: true,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text("▶ ${cur['education']}")
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(),
                                          Text(
                                            "\$${(cur['wage'] as double).toStringAsFixed(2)}",
                                            style: const TextStyle(fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold),
                                          ),
                                          DataEngine.unitReviews[cur['unit']]['reviews'].length > 0
                                              ? Row(
                                                  children: const [
                                                    Text(
                                                      "See reviews",
                                                    ),
                                                    Icon(
                                                      Icons.chevron_right,
                                                      size: 15,
                                                    )
                                                  ],
                                                )
                                              : Container()
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: DataTableTheme(
                        data: const DataTableThemeData(
                            // paginationButtonLocation: PaginatedDataTableLocation.bottom,
                            ),
                        child: PaginatedDataTable(
                          // source: MyData(inputData: masterList),
                          source: MyData(inputData: masterList, context: context),
                          rowsPerPage: 20,
                          columnSpacing: 80,
                          horizontalMargin: 10,
                          showCheckboxColumn: false,
                          sortAscending: curSortAscending,
                          sortColumnIndex: curSortColumnIndex,

                          columns: [
                            DataColumn(
                              label: const Text('Education'),
                              onSort: onSort,
                            ),
                            DataColumn(
                              label: const Text('Department'),
                              onSort: onSort,
                            ),
                            DataColumn(
                              label: const Text('Unit'),
                              onSort: onSort,
                            ),
                            DataColumn(
                              label: const Text('Workgroup'),
                              onSort: onSort,
                            ),
                            DataColumn(
                              label: const Text('Wage'),
                              onSort: onSort,
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          );
        });
  } //build

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      curSortColumnIndex = columnIndex;
      curSortAscending = ascending;
    });
  }
}

// The "soruce" of the table
class MyData extends DataTableSource {
  List inputData;
  BuildContext context;

  MyData({required this.inputData, required this.context});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => inputData.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(inputData[index]["education"].toString(), style: otherCellStyle)),
      DataCell(Text(inputData[index]["department"].toString(), style: otherCellStyle)),
      DataCell(InkWell(
        onTap: () {
          print("review tapped at index $index");

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DesktopReviewScreen(
                    cur: inputData[index],
                  )));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(inputData[index]["unit"].toString(), style: otherCellStyle),
            DataEngine.unitReviews[inputData[index]['unit']]['reviews'].length > 0
                ? Container(
                    decoration: tagDecoration,
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: const [Icon(Icons.arrow_outward_rounded), Text("See Reviews")],
                        )))
                : Container()
          ],
        ),
      )),
      DataCell(Text(inputData[index]["workgroup"].toString(), style: otherCellStyle)),
      DataCell(Text("\$${(inputData[index]["wage"] as double).toStringAsFixed(2)}", style: salaryStyle)),
    ]);
  }
}
