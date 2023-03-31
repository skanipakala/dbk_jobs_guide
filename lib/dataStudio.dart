import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Iframe extends StatefulWidget {
  final String url;
  final double height;
  final double width;
  final String uniqueID;

  const Iframe({super.key, required this.url, required this.height, required this.width, required this.uniqueID});

  @override
  _IframeState createState() => _IframeState();
}

class _IframeState extends State<Iframe> {
  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('iframe${widget.uniqueID}', (int viewId) {
      var iframe = html.IFrameElement();
      iframe.src = widget.url;
      iframe.style.height = '${widget.height}px';
      iframe.style.width = '${widget.width}px';
      iframe.allowFullscreen = false;
      return iframe;
    });

    print("rebuilding IFrame");

    return SizedBox(
      // width: widget.width,
      // height: widget.height,
      child: HtmlElementView(
        key: UniqueKey(),
        viewType: 'iframe${widget.uniqueID}',
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
