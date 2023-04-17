import 'package:dbk_jobs_guide/dataEngine.dart';
import 'package:dbk_jobs_guide/loading.dart';
import 'package:dbk_jobs_guide/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert';
import 'package:dbk_jobs_guide/constants_iui.dart';

// import 'package:easy_web_view/easy_web_view.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SmartFilters extends StatefulWidget {
  ValueNotifier importDeciderControl;
  ValueNotifier refreshSearchBox;

  SmartFilters({super.key, required this.importDeciderControl, required this.refreshSearchBox});

  @override
  State<SmartFilters> createState() => _SmartFiltersState();
}

class _SmartFiltersState extends State<SmartFilters> {
  Map filterState = {};
  bool opened = false;

  List availableYears = [];

  getLatestFilters() async {
    print("[!] Triggering getLatestFilters");
    if (DataEngine.metaData == {} || DataEngine.metaData.isEmpty) {
      print("metadata.JSON data fetch ❌❌");
      await DataEngine.readMetaData();
    } else {
      print("Avoided metadata.JSON fetch 😀");
    }

    availableYears = DataEngine.metaData['unique_years'];

    // LOADING FILTER_STATE:
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    if (prefs.containsKey("filterState")) {
      filterState = jsonDecode(prefs.getString("filterState")!);
    } else {
      filterState = {'year': '2022', 'education': 'undergraduate', 'department': 'All', 'unit': 'All', 'workgroup': 'All'};
    }
  }

  final _formKey = GlobalKey<FormBuilderState>();

  saveFilterValue(String triggeredBy) async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      Map newFilter = Map.of(_formKey.currentState!.value);

      if (triggeredBy == "department") {
        newFilter['unit'] = 'All';
        newFilter['workgroup'] = 'All';
      }

      if (triggeredBy == "unit") {
        newFilter['workgroup'] = 'All';
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("filterState", jsonEncode(newFilter));

      DataEngine.applyUnitFilters(newFilter);
      DataEngine.applyWorkgroupFilters(newFilter);

      setState(() {});

      widget.importDeciderControl.notifyListeners();

      print("APPLIED NEW FILTER  $newFilter");
    }
  }
//  final GlobalKey<_SmartFiltersState> expansionTile = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLatestFilters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Loading(message: "rendering filters");
          }

          return Responsive.isMobile(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 5,
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.grey.shade200,
                        backgroundColor: opened ? dbkRed : Colors.grey.shade200,
                        onExpansionChanged: (opened) {
                          setState(() {
                            this.opened = opened;
                          });
                        },
                        // maintainState: true,
                        childrenPadding: const EdgeInsets.all(5),
                        initiallyExpanded: opened,
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                        collapsedShape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),

                        collapsedIconColor: Colors.black,
                        iconColor: Colors.white,

                        title: !opened
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.filter_list_sharp, size: 30, color: Colors.grey),
                                  SizedBox(width: 5),
                                  Text("Open Filters", textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                                ],
                              )
                            : Container(
                                // color: dbkRed,
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.close, size: 30, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text("Close Filters", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white)),
                                ],
                              )),
                        children: [
                          FormBuilder(
                            key: _formKey,
                            child: Container(
                              decoration: filterDecorations,
                              height: 290,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: DropDownsList,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      flex: 1,
                      child: makeResetButton(),
                    )
                  ],
                )
              : FormBuilder(
                  key: _formKey,
                  child:
                      // Fixed Filters Row
                      Container(
                    decoration: filterDecorations,
                    width: MediaQuery.of(context).size.width - 20,
                    // width: 500,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: DropDownsList,
                    ),
                  ),
                );
        });
  }

  Widget makeResetButton() {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // String beforeReset = prefs.getString("search") ?? "EMPTY";

        // AnalyticsService.sendAnalyticsEvent(eventName: "reset_filter", moreInfo: {'queryBeforeReset': beforeReset});

        await prefs.remove("filterState");
        await prefs.setString("search", "");

        // widget.importDeciderControl.value = "";
        widget.refreshSearchBox.notifyListeners();
        widget.importDeciderControl.notifyListeners();

        setState(() {
          opened = false;
        });
      },
      child: Container(
        decoration: resetButton,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(
                Icons.restart_alt_rounded,
                color: Colors.white,
              ),
              Text("Reset", style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get DropDownsList {
    return [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: FormBuilderDropdown(
            isExpanded: true,
            name: 'year',
            initialValue: filterState['year'],
            items: availableYears.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (newVal) {
              saveFilterValue('year');
            },
            decoration: const InputDecoration(
              isDense: true,
              // suffixIconConstraints: BoxConstraints(maxHeight: 1, maxWidth: 1),
              hintText: "Year",
              label: Text("Year"),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: FormBuilderDropdown(
            isExpanded: true,
            name: 'education',
            initialValue: filterState['education'],
            items: ['undergraduate', 'graduate', 'All'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (newVal) {
              saveFilterValue('education');
            },
            decoration: const InputDecoration(
              isDense: true,
              hintText: "Education",
              label: Text("Education"),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: FormBuilderDropdown(
            isExpanded: true,
            name: 'department',
            initialValue: filterState['department'],
            items: DataEngine.metadataDepartments + DataEngine.anyItem,
            onChanged: (newVal) {
              saveFilterValue('department');
            },
            decoration: const InputDecoration(
              isDense: true,
              hintText: "Department",
              label: Text("Department"),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        ),
      ),
      filterState['department'] != "" && filterState['department'] != null && filterState['department'] != 'All'
          ? Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: FormBuilderDropdown(
                  isExpanded: true,
                  name: 'unit',
                  initialValue: filterState['unit'],
                  items: DataEngine.metadataUnits + DataEngine.anyItem,
                  onChanged: (newVal) {
                    saveFilterValue('unit');
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: "Unit",
                    label: Text("Unit"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
            )
          : Container(),
      filterState['unit'] != "" && filterState['unit'] != null && filterState['unit'] != 'All'
          ? Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: FormBuilderDropdown(
                  isExpanded: true,
                  name: 'workgroup',
                  // enabled: DataEngine.metadataWorkgroups.isNotEmpty,
                  initialValue: filterState['workgroup'],
                  items: DataEngine.metadataWorkgroups + DataEngine.anyItem,
                  onChanged: (newVal) async {
                    await saveFilterValue('workgroup');
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: DataEngine.metadataWorkgroups.isNotEmpty ? "Workgroup" : "No Workgroups Available",
                    label: const Text("Workgroup"),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
            )
          : Container(),

      // RESET ALL FILTERS

      Responsive.isDesktop(context) ? makeResetButton() : Container()

      // IconButton(
      //     onPressed: () async {
      //       SharedPreferences prefs = await SharedPreferences.getInstance();
      //       await prefs.remove("filterState");
      //       await prefs.setString("search", "");

      //       setState(() {});
      //       widget.importDeciderControl.notifyListeners();
      //     },
      //     icon: const Icon(
      //       Icons.restart_alt_rounded,
      //       color: Colors.red,
      //     ))
    ];
  }
}
