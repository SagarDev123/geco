import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/model/preorderlistmodel.dart';
import '../../../utils/sizeutils.dart';

class PreOrderCartItem extends StatefulWidget {
  ProductList preOrderList;
  PreOrderCartItem({required this.preOrderList, super.key});

  @override
  State<PreOrderCartItem> createState() => _PreOrderCartItemState();
}

class _PreOrderCartItemState extends State<PreOrderCartItem> {
  @override
  Widget build(BuildContext context) {
    return productDetails(context);
  }

  productDetails(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Image Placeholder
            // Image.asset(
            //   'assets/images/logo.png',
            //   height: SizeUtils.getScreenHeight(context, 12),
            // ),

            widget.preOrderList.imageUrl!.isEmpty
                ? Image.asset(
                    'assets/images/logo.png',
                    height: SizeUtils.getScreenHeight(context, 12),
                    width: SizeUtils.getScreenHeight(context, 12),
                  )
                : Image.network(
                    widget.preOrderList.imageUrl.toString(),
                    height: SizeUtils.getScreenHeight(context, 12),
                    width: SizeUtils.getScreenHeight(context, 12),
                  ),

            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.preOrderList.name}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: SizeUtils.getScreenHeight(context, 1),
                    ),
                    Text('Brand: ${widget.preOrderList.brandIdName}'),
                    Text('Quantity: ${widget.preOrderList.quantity}'),
                    SizedBox(
                      height: SizeUtils.getScreenHeight(context, 2),
                    ),
                    Text('Price: Rs ${widget.preOrderList.price}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
