import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/model/customer.dart';
import '../../../utils/sizeutils.dart';

class Customer extends StatelessWidget {
  final Datum customer;
  const Customer({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0XFFFFFFFF),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeUtils.getScreenWidth(context, 3),
            SizeUtils.getScreenHeight(context, 2),
            SizeUtils.getScreenWidth(context, 3),
            SizeUtils.getScreenHeight(context, 2)),
        child: Row(children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                customer.name.toString(),
                style: TextStyle(
                    fontSize: SizeUtils.getDynamicFontSize(
                      context,
                      2,
                    ),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                customer.storeName.toString(),
                style: TextStyle(
                    fontSize: SizeUtils.getDynamicFontSize(
                      context,
                      2,
                    ),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                customer.gstno.toString().isEmpty
                    ? '--'
                    : customer.gstno.toString(),
                style: TextStyle(
                    fontSize: SizeUtils.getDynamicFontSize(
                      context,
                      2,
                    ),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                customer.phone.toString().isEmpty
                    ? '--'
                    : customer.phone.toString(),
                style: TextStyle(
                    fontSize: SizeUtils.getDynamicFontSize(
                      context,
                      2,
                    ),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
