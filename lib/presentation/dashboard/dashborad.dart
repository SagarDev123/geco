import 'package:flutter/material.dart';
import 'package:geco/utils/constants.dart';

import '../../utils/sizeutils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(children: [appHeader(context), productTab(context)]),
    ));
  }

  appHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeUtils.getScreenHeight(context, 13),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/app_header.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 5),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 16),
            height: SizeUtils.getScreenHeight(context, 11),
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 5),
          ),
          SizedBox(
            width: SizeUtils.getDynamicFontSize(context, 0.3),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  SizeUtils.getScreenHeight(context, 2),
                  0,
                  SizeUtils.getScreenHeight(context, 2)),
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 5),
          ),
          Expanded(
            flex: 1,
            child: Text(
              Constants.appName,
              style: TextStyle(
                  fontSize: SizeUtils.getDynamicFontSize(context, 3),
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 7),
            height: SizeUtils.getScreenHeight(context, 7),
            child: Image.asset(
              'assets/images/cart.png',
            ),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 5),
          ),
        ],
      ),
    );
  }

  productTab(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeUtils.getScreenWidth(context, 2),
            SizeUtils.getScreenHeight(context, 2),
            SizeUtils.getScreenWidth(context, 2),
            SizeUtils.getScreenHeight(context, 2)),
        child: Row(
          children: [
            const Text(Constants.customerList),
            SizedBox(
              width: SizeUtils.getScreenWidth(context, 5),
            ),
            const Text(Constants.previousOrderList)
          ],
        ),
      ),
    );
  }
}
