import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      width: double.infinity,
      height: double.infinity,
      child: const SpinKitThreeInOut(
        color: Colors.blueGrey,
        size: 35,
      ),
    );
  }
}
