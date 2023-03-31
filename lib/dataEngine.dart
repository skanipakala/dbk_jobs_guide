import 'dart:convert';
import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:xml2json/xml2json.dart';
import 'package:intl/intl.dart';

class DataEngine {
  static Map masterDict = {};
  static Map metaData = {};
  static Map unitReviews = {};

  static List uniqueDept = [];
  static List uniqueUnit = [];
  static List uniqueWorkgroup = [];

  static List<DropdownMenuItem<String>> metadataUnits = [];
  static List<DropdownMenuItem<String>> metadataWorkgroups = [];
  static List<DropdownMenuItem<String>> metadataDepartments = [];

  static List<DropdownMenuItem<String>> anyItem = [
    const DropdownMenuItem(
      value: "All",
      child: Text("All"),
    )
  ];

  static Map unitToWorkgroup = {};
  static Map departmentToUnit = {};

  static initialize() {}

  static Future<Map> readReviewJSON() async {
    print("calling readReviewJSON!");
    final String response = await rootBundle.loadString('assets/data/unit_reviews.json');
    unitReviews = await json.decode(response);
    print("read from unit_reviews.json success!");
    return unitReviews;
  }

  static Future<Map> readJSON() async {
    print("calling readJSON!");
    final String response = await rootBundle.loadString('assets/data/sample_year.json');
    masterDict = await json.decode(response);
    print("read from sample_year.json success!");
    return masterDict;
  }

  static Future<Map> readMetaData() async {
    print("reading metadata");
    final String response = await rootBundle.loadString('assets/data/sample_metadata.json');
    DataEngine.metaData = await json.decode(response);
    print("read from sample_metadata.json success!");

    DataEngine.uniqueDept = DataEngine.metaData['unique_department'];
    DataEngine.uniqueUnit = DataEngine.metaData['unique_unit'];
    DataEngine.uniqueWorkgroup = DataEngine.metaData['unique_workgroup'];

    // DataEngine.uniqueDept.sort();
    // DataEngine.uniqueUnit.sort();
    // DataEngine.uniqueWorkgroup.sort();

    DataEngine.metadataUnits = uniqueUnit.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList();

    DataEngine.metadataWorkgroups =
        uniqueWorkgroup.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList();

    DataEngine.metadataDepartments = uniqueDept.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList();

    print("metadataUnits.length > ${metadataUnits.length}");
    print("metadataWorkgroups.length > ${metadataWorkgroups.length}");

    loadUnitSubFilters();
    loadWorkgroupSubFilters();

    return metaData;
  }

  static loadWorkgroupSubFilters() async {
    final String response = await rootBundle.loadString('assets/data/unitToWorkgroup.json');
    DataEngine.unitToWorkgroup = await json.decode(response);
  }

  static loadUnitSubFilters() async {
    final String response = await rootBundle.loadString('assets/data/departmentToUnit.json');
    DataEngine.departmentToUnit = await json.decode(response);
  }

  static applyUnitFilters(Map currentFilters) {
    if (currentFilters['department'] == "" ||
        currentFilters['department'] == null ||
        currentFilters['department'] == 'All') {
      DataEngine.metadataDepartments =
          uniqueDept.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList();
    } else {
      List specificUnits = DataEngine.departmentToUnit[currentFilters['department']];
      DataEngine.metadataUnits = specificUnits.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList();
    }
  }

  static applyWorkgroupFilters(Map currentFilters) {
    if (currentFilters['unit'] == null || currentFilters['unit'] == "" || currentFilters['unit'] == "All") {
      DataEngine.metadataWorkgroups =
          uniqueWorkgroup.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList();
    } else {
      List specificWorkgroups = DataEngine.unitToWorkgroup[currentFilters['unit']];
      DataEngine.metadataWorkgroups =
          specificWorkgroups.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList();
    }
  }

  static Future<Map> fetchRssFeed(String checkWebsite) async {
    print("inside fetchRSSFeed");

    String RSSFeed =
        // '${CORS_AWS}https://ejobs.umd.edu/postings/search.atom?utf8=%E2%9C%93&query=&query_v0_posted_at_date=&1950%5B%5D=5&805=&806=&commit=Search';
        "$CORS_AWS$checkWebsite";
    var url = Uri.parse(
      RSSFeed,
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Xml2Json xml2json = Xml2Json();
        xml2json.parse(response.body);
        // Map json = jsonDecode(xml2json.toGData());
        Map json = jsonDecode(xml2json.toParker());
        // Do something with the JSON data
        return json;
      } else {
        throw Exception('Failed to fetch RSS feed');
      }
    } catch (e) {
      print(e.toString());
    }

    return {'unable to get/parse RSS Feed': false};
  }

  static fetchRSSNewsFeed() async {
    final response = await http.get(
        Uri.parse("https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fdbknews.com%2Ftag%2Fwages%2Ffeed%2F"));
    return jsonDecode(response.body);
  }
}

String formatRSSDate(String input) {
  return Jiffy(DateTime.parse(input)).yMMMMd;
}

String formatRSSDateDBK(String input) {
  DateFormat format = DateFormat("E, d MMM y H:m:s Z");
  DateTime dateTime = format.parse(input);
  return Jiffy(DateTime.parse(dateTime.toString())).yMMMMd;
}

String? getDBKThumbnail(Map input) {
  // print(input);

  // String text = input['content:encoded'].toString(); // the text to search
  // RegExp exp = RegExp(r'(https?:\/\/.*?\.jpg)'); // the regex pattern
  // var match = exp.firstMatch(text); // the first match
  // String? imageUrl = match?.group(1); // the first group captures the URL
  // print(imageUrl); // print
  // return imageUrl;

  return input['enclosure']['link'] ?? "";
}

String testUrl = 'https://wps3.dbknews.com/uploads/2022/10/102122_10.23.22.USAS_.labor_.picnic_NS06-1024x683.jpg';
