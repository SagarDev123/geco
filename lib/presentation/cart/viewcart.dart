import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco/data/model/itemsincartmodel.dart';
import 'package:geco/presentation/cart/bloc/view_cart_bloc.dart';
import 'package:geco/utils/sharedpreferencehelper.dart';
import 'package:geco/utils/utils.dart';
import 'package:status_alert/status_alert.dart';

import '../../data/model/customer.dart';
import '../../utils/api_loader.dart';
import '../../utils/constants.dart';
import '../../utils/sizeutils.dart';

import 'list/viewcartchild.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({super.key});

  @override
  State<ViewCart> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  List<CartList> cartList = [];
  String taxable = '';
  String gstNumber = '';
  String total = '';
  String totalToPay = '';
  String? selectedCustomer;
  List<String> customerNameList = [];
  List<Datum> customers = [];
  String customerId = '';
  bool isEmptyCart = false;
  bool isCart = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ViewCartBloc>().add(CustomerFetchingEvent());
    context.read<ViewCartBloc>().add(ViewCartFetchCartItems());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BlocListener<ViewCartBloc, ViewCartState>(
        listener: (context, state) {
          if (state is ViewCartItemFetchSuccess) {
            setState(() {
              total = state.total;
              gstNumber = state.gstamount;
              taxable = state.taxable;
              totalToPay = state.totalToPay.toString();
              cartList = state.cartList;
            });
          } else if (state is ViewCartItemUpdated) {
            Fluttertoast.showToast(
                msg: 'Cart list updated',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            context.read<ViewCartBloc>().add(ViewCartFetchCartItems());
          } else if (state is OnOrderNowCompleted) {
            Fluttertoast.showToast(
                msg: 'Order placed successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/preorder",
              (Route<dynamic> route) => false,
            );
          } else if (state is CustomerListFetched) {
            setState(() {
              customers = state.customers;
            });
          } else if (state is CustomerNameListFetched) {
            setState(() {
              customerNameList = state.customerNames;
            });
          } else if (state is ViewCartFailure) {
            if (state.error == Constants.emptyCart) {
              setState(() {
                isCart = false;
                isEmptyCart = true;
              });
            } else {
              StatusAlert.show(
                context,
                padding: const EdgeInsets.all(10.0),
                duration: const Duration(seconds: 2),
                title: 'Alert',
                subtitle: state.error,
                subtitleOptions: StatusAlertTextConfiguration(
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                configuration: const IconConfiguration(icon: Icons.error),
                maxWidth: 300,
              );
            }
          }
        },
        child: viewCartStack(context),
      ),
    ));
  }

  viewCartStack(BuildContext context) {
    return Stack(
      children: [
        viewCartBody(context),
        BlocBuilder<ViewCartBloc, ViewCartState>(
          builder: (context, state) {
            if (state is ViewCartApiLoading) {
              return const AppLoader();
            } else {
              return Container();
            }
          },
        )
      ],
    );
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Constants.appName,
                    style: TextStyle(
                        fontSize: SizeUtils.getDynamicFontSize(context, 3),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: SizeUtils.getScreenWidth(context, 2),
                ),
                redirectionWidget(context),
              ],
            ),
          ),
          // SizedBox(
          //   width: SizeUtils.getScreenWidth(context, 7),
          //   height: SizeUtils.getScreenHeight(context, 7),
          //   child: Image.asset(
          //     'assets/images/cart.png',
          //   ),
          // ),
          // SizedBox(
          //   width: SizeUtils.getScreenWidth(context, 2),
          // ),
          GestureDetector(
            onTap: () {
              Utils.exitUser(context, (confirmed) {
                if (confirmed) {
                  SharedPreferenceHelper.clearContent();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/",
                    (Route<dynamic> route) => false,
                  );
                } else {}
              });
            },
            child: SizedBox(
              width: SizeUtils.getScreenWidth(context, 7),
              height: SizeUtils.getScreenHeight(context, 7),
              child: Image.asset(
                'assets/images/man.png',
              ),
            ),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 2),
          ),
        ],
      ),
    );
  }

  viewCartBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/app_background.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(children: [
        appHeader(context),
        customerSearchTab(context),
        Expanded(child: cartListWidget(context)),
      ]),
    );
  }

  Widget customerSearchTab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF78BB43)),
        color:
            const Color(0xFFFFFFFF), // Set your desired background color here
        borderRadius: const BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.zero,
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(12)), // Add border radius if needed
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeUtils.getScreenWidth(context, 2),
            SizeUtils.getScreenHeight(context, 2),
            SizeUtils.getScreenWidth(context, 2),
            SizeUtils.getScreenHeight(context, 2)),
        child: IntrinsicWidth(
          child: Row(
            children: [
              Text(
                Constants.customerName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeUtils.getDynamicFontSize(context, 2.3)),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCustomer,
                      hint: Text('Select Customer'),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCustomer = newValue;
                          getCustomerIdFromList();
                        });
                      },
                      items: customerNameList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cartListWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 3)),
        child: Card(
          elevation: 4.0,
          margin: EdgeInsets.all(SizeUtils.getScreenWidth(context, 2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Set the radius here
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 2)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Constants.cartLists,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeUtils.getDynamicFontSize(context, 2.2)),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: Colors.black,
                ),
                Visibility(visible: isEmptyCart, child: emptyCart(context)),
                Visibility(visible: isCart, child: cartItems(context)),
                totalPriceLayout(context),
                totalPriceIncludingTax(context),
                orderNowButton(context),
              ]),
        ),
      ),
    );
  }

  orderNowButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ViewCartBloc>().add(OrderNow(customersId: customerId));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),
        child: Container(
            decoration: BoxDecoration(
              color: const Color(
                  0xFF273180), // Set your desired background color here
              borderRadius:
                  BorderRadius.circular(15), // Add border radius if needed
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 0,
                  top: SizeUtils.getScreenHeight(context, 2),
                  right: 0,
                  bottom: SizeUtils.getScreenHeight(context, 2)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  Constants.orderNow,
                  style: TextStyle(
                      fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )),
      ),
    );
  }

  Widget cartItems(BuildContext context) {
    return Container(
        height: SizeUtils.getScreenHeight(context, 50),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: cartList.length,
          itemBuilder: (context, index) {
            return ViewCartChild(cartList: cartList[index]);
          },
        ));
  }

  totalPriceLayout(BuildContext context) {
    return Container(
      color: const Color(0XFFF5F5F5),
      child: Padding(
        padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 3)),
        child: Row(
          children: [
            Expanded(child: placeHolders(context)),
            Expanded(child: valueWidget(context)),
          ],
        ),
      ),
    );
  }

  Widget placeHolders(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Total MRP        :',
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                fontWeight: FontWeight.w400),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Taxes            :',
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                fontWeight: FontWeight.w400),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'GST              :',
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget valueWidget(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Rs $total',
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                fontWeight: FontWeight.w600),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Rs $taxable',
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                fontWeight: FontWeight.w600),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Rs $gstNumber',
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  totalPriceIncludingTax(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 3)),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total Price',
                style: TextStyle(
                    fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Rs $totalToPay',
              style: TextStyle(
                  fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  redirectionWidget(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/dashboard",
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            Constants.dashBoard,
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2),
                fontWeight: FontWeight.w500,
                color: const Color(0XFF79A544)),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/createneworder",
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            Constants.createneworder,
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2),
                fontWeight: FontWeight.w500,
                color: const Color(0XFF588230)),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            Constants.viewCart,
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2),
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        )
      ],
    );
  }

  void getCustomerIdFromList() {
    customerId = customers
        .where((item) => item.name.toString() == selectedCustomer)
        .first
        .id
        .toString();
  }

  Widget emptyCart(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeUtils.getScreenHeight(context, 40),
      child: Center(
        child: Text(
          Constants.emptyCart,
          style: TextStyle(
              fontSize: SizeUtils.getDynamicFontSize(context, 3),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
