import 'package:dbk_jobs_guide/constants_iui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  String message;
  Loading({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitFadingCircle(
              color: dbkRed,
              size: 30.0,
            ),
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
