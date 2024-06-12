import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geco/data/model/brand.dart';

import '../../../utils/sizeutils.dart';

class BrandOrderCreate extends StatefulWidget {
  BrandData brands;
  final Function(String brandName, String brandId, bool isAdded) selectedBrand;
  BrandOrderCreate(
      {required this.brands, super.key, required this.selectedBrand});

  @override
  State<BrandOrderCreate> createState() => _BrandOrderCreateState();
}

class _BrandOrderCreateState extends State<BrandOrderCreate> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.all(10),
          child: Container(
              height: SizeUtils.getScreenHeight(context, 12),
              width: SizeUtils.getScreenWidth(context, 18),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.brands.imageUrl.toString().isEmpty
                      ? const AssetImage('assets/images/logo.png')
                      : NetworkImage(widget.brands.imageUrl.toString())
                          as ImageProvider<Object>,
                  fit: BoxFit.cover,
                ),
              )), // Set appropriate size
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Checkbox(
            value:
                _isChecked, // You can manage the state by using a stateful widget
            onChanged: (bool? newValue) {
              if (newValue != null) {
                setState(() {
                  _isChecked = newValue;
                  widget.selectedBrand(widget.brands.id.toString(),
                      widget.brands.name.toString(), _isChecked);
                }); // Update the state based on user interaction
              }
            },
          ),
        ),
      ],
    );
  }
}
