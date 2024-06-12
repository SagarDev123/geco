import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geco/data/model/product_model.dart';
import 'package:geco/presentation/createneworder/bloc/create_new_order_bloc.dart';

import '../../../utils/constants.dart';
import '../../../utils/sizeutils.dart';

class Product extends StatefulWidget {
  final ProductModelData productModel;
  const Product({super.key, required this.productModel});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int _currentValue = 1;

  void _increment() {
    setState(() {
      _currentValue++;
    });
  }

  void _decrement() {
    setState(() {
      if (_currentValue > 1)
        _currentValue--; // Prevents the value from going below 1
    });
  }

  addToCartButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<CreateNewOrderBloc>().add(AddToCartEvent(
            productId: widget.productModel.id.toString(),
            quanity: _currentValue.toString()));
      },
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(2, SizeUtils.getScreenHeight(context, 1), 2, 2),
        child: IntrinsicWidth(
          child: Container(
              decoration: BoxDecoration(
                color: const Color(
                    0xFF273180), // Set your desired background color here
                borderRadius:
                    BorderRadius.circular(15), // Add border radius if needed
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeUtils.getScreenWidth(context, 1),
                    top: SizeUtils.getScreenHeight(context, 1),
                    right: SizeUtils.getScreenWidth(context, 1),
                    bottom: SizeUtils.getScreenHeight(context, 1)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    Constants.addToCart,
                    style: TextStyle(
                        fontSize: SizeUtils.getDynamicFontSize(context, 2),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeUtils.getScreenWidth(context, 2),
            SizeUtils.getScreenHeight(context, 2),
            SizeUtils.getScreenWidth(context, 2),
            SizeUtils.getScreenHeight(context, 0)),
        child: Column(
          children: [
            SizedBox(
              width: SizeUtils.getScreenWidth(context, 20),
              height: SizeUtils.getScreenHeight(context, 12),
              child: widget.productModel.imageUrl!.isEmpty
                  ? Image.asset(
                      'assets/images/logo.png',
                    )
                  : Image.network(widget.productModel.imageUrl.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.productModel.name.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeUtils.getDynamicFontSize(context, 1.5)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _decrement,
                  ),
                  Card(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        SizeUtils.getScreenWidth(context, 2),
                        SizeUtils.getScreenHeight(context, 1),
                        SizeUtils.getScreenWidth(context, 2),
                        SizeUtils.getScreenHeight(context, 1)),
                    child: Text('$_currentValue',
                        style: const TextStyle(fontSize: 20.0)),
                  )),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _increment,
                  ),
                ],
              ),
            ),
            addToCartButton(context)
          ],
        ),
      ),
    );
  }
}
