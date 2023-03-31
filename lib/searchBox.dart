// import 'package:easy_web_view/easy_web_view.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBox extends StatefulWidget {
  ValueNotifier importControlDecider;
  SearchBox({super.key, required this.importControlDecider});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late TextEditingController controller;

  getCacheSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stored = prefs.getString("search") ?? "";

    controller = TextEditingController(text: stored);
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCacheSearch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: TextFormField(
              // controller: controller,
              // initialValue: widget.importControlDecider.value,
              controller: TextEditingController(),
              onChanged: (newValue) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString("search", newValue);
                widget.importControlDecider.notifyListeners();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                // suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      print('search triggered');
                    }),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 3.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                ),
                hintText: 'Start typing to search wages...',
              ),
            ),
          );
        });
  }
}
