import 'package:flutter/material.dart';

import 'searchTable.dart';

class QueryDecider extends StatefulWidget {
  ValueNotifier importControlDecider;
  // DECIDER deciderState;

  QueryDecider({super.key, required this.importControlDecider

      // , required this.deciderState

      });

  @override
  State<QueryDecider> createState() => _QueryDeciderState();
}

class _QueryDeciderState extends State<QueryDecider> {
  @override
  Widget build(BuildContext context) {
    return SearchTable(
      importControlDecider: widget.importControlDecider,
    );
    // return widget.importControlDecider.value == ""
    //     ? const InfoGrid()
    //     : SearchTable(
    //         importControlDecider: widget.importControlDecider,
    //       );
  }
}

// ignore: constant_identifier_names
enum DECIDER { INFO_PANEL, QUERY_SEARCH, DEFAULT }
