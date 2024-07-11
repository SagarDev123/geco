import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geco/data/model/itemsincartmodel.dart';
import 'package:geco/presentation/cart/bloc/view_cart_bloc.dart';
import 'package:geco/utils/sizeutils.dart';

class ViewCartChild extends StatefulWidget {
  final CartList cartList;
  const ViewCartChild({required this.cartList, super.key});

  @override
  State<ViewCartChild> createState() => _ViewCartChildState();
}

class _ViewCartChildState extends State<ViewCartChild> {
  int quantity = 1;

  void increment() {
    setState(() {
      quantity++;
      context.read<ViewCartBloc>().add(UpdateItemQuantityFromCart(
          widget.cartList.id.toString(),
          widget.cartList.productsId.toString(),
          quantity.toString()));
    });
  }

  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        context.read<ViewCartBloc>().add(UpdateItemQuantityFromCart(
            widget.cartList.id.toString(),
            widget.cartList.productsId.toString(),
            quantity.toString()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    quantity = int.parse(widget.cartList.quantity!);
  }

  @override
  Widget build(BuildContext context) {
    return productDetails(context);
  }

  quantityUpdateWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: decrement,
          ),
          Card(
              child: Padding(
            padding: EdgeInsets.fromLTRB(
                SizeUtils.getScreenWidth(context, 2),
                SizeUtils.getScreenHeight(context, 1),
                SizeUtils.getScreenWidth(context, 2),
                SizeUtils.getScreenHeight(context, 1)),
            child: Text('$quantity', style: const TextStyle(fontSize: 20.0)),
          )),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: increment,
          ),
        ],
      ),
    );
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

            widget.cartList.imageUrl!.isEmpty
                ? Image.asset(
                    'assets/images/logo.png',
                    height: SizeUtils.getScreenHeight(context, 12),
                    width: SizeUtils.getScreenHeight(context, 12),
                  )
                : Image.network(
                    widget.cartList.imageUrl.toString(),
                    height: SizeUtils.getScreenHeight(context, 12),
                    width: SizeUtils.getScreenHeight(context, 12),
                  ),

            // Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.cartList.name}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: SizeUtils.getScreenHeight(context, 1),
                    ),
                    Text('Brand: ${widget.cartList.brandIdName}'),
                    Text('Quantity: ${widget.cartList.quantity}'),
                    SizedBox(
                      height: SizeUtils.getScreenHeight(context, 2),
                    ),
                    quantityLayoutWidget(context),
                  ],
                ),
              ),
            ),
            Text('Price: £ ${widget.cartList.price}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // Price and Quantity Controls
          ],
        ),
      ),
    );
  }

  quantityLayoutWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        quantityUpdateWidget(),
        SizedBox(
          width: SizeUtils.getScreenWidth(context, 2),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              SizeUtils.getScreenWidth(context, 3),
              SizeUtils.getScreenHeight(context, 0.3),
              SizeUtils.getScreenWidth(context, 3),
              SizeUtils.getScreenHeight(context, 0.3)),
          decoration: BoxDecoration(
            color: const Color(
                0xFF273180), // Set your desired background color here
            borderRadius:
                BorderRadius.circular(15), // Add border radius if needed
          ),
          child: TextButton(
            onPressed: () {
              context.read<ViewCartBloc>().add(ViewCartRemoveCartItem(
                  widget.cartList.id.toString(),
                  widget.cartList.productsId.toString(),
                  widget.cartList.quantity.toString()));
            },
            style: TextButton.styleFrom(primary: Colors.white),
            child: const Text('Remove'),
          ),
        ),
      ],
    );
  }
}
