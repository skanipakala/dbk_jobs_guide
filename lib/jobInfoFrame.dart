import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class JobInfoFrame extends StatelessWidget {
  String url;

  JobInfoFrame({super.key, required this.url}) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
      var iframe = html.IFrameElement();

      iframe.src = url;
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(child: HtmlElementView(viewType: 'iframe'));
  }
}
