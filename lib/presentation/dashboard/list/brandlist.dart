import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geco/data/model/brand.dart';

import '../../../utils/sizeutils.dart';

class BrandItem extends StatelessWidget {
  final BrandData brand;

  const BrandItem({Key? key, required this.brand}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF78BB43)),
        color:
            const Color(0xFFFFFFFF), // Set your desired background color here
        borderRadius: BorderRadius.circular(SizeUtils.getScreenWidth(
            context, 1)), // Add border radius if needed
      ),
      child: SizedBox(
        width: SizeUtils.getScreenWidth(context, 16),
        height: SizeUtils.getScreenHeight(context, 11),
        child: brand.imageUrl!.isEmpty
            ? Image.asset(
                'assets/images/logo.png',
              )
            : Image.network(brand.imageUrl!),
      ),
    );
  }
}
