import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco/data/model/brand.dart';
import 'package:geco/data/model/preorderlistmodel.dart';
import 'package:geco/presentation/preorder/bloc/preorder_bloc.dart';
import 'package:geco/presentation/preorder/list/preorderitem.dart';
import 'package:status_alert/status_alert.dart';

import '../../data/model/customer.dart';
import '../../utils/api_loader.dart';
import '../../utils/constants.dart';
import '../../utils/sizeutils.dart';

class PreOrder extends StatefulWidget {
  const PreOrder({super.key});

  @override
  State<PreOrder> createState() => _PreOrderState();
}

class _PreOrderState extends State<PreOrder> {
  String? selectedCustomer;
  String? selectedBrandName;
  List<String> customerNameList = [];
  List<Datum> customers = [];
  String customerId = '';
  String brandId = '';
  List<String> brandNameList = [];
  List<BrandData> brandList = [];
  List<ProductList> productList = [];
  bool isProductIsEmpty = true;
  bool isProductAvailable = false;
  String saledId = '';

  String billDate = '-/-/-';

  @override
  void initState() {
    super.initState();
    context.read<PreorderBloc>().add(CustomerFetchingEvent());
    context.read<PreorderBloc>().add(BrandList());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BlocListener<PreorderBloc, PreorderState>(
        listener: (context, state) {
          if (state is CustomerListFetched) {
            setState(() {
              customers = state.customers;
            });
          } else if (state is CustomerNameListFetched) {
            setState(() {
              customerNameList = state.customerNames;
            });
          } else if (state is PreOrderListFetched) {
            setState(() {
              productList = state.preOrderList;
              billDate = state.salesData.date!;
              saledId = state.salesData.id.toString();
              if (productList.isEmpty) {
                isProductAvailable = false;
                isProductIsEmpty = true;
              } else {
                isProductAvailable = true;
                isProductIsEmpty = false;
              }
            });
          } else if (state is BrandListFetchCompleted) {
            setState(() {
              brandList = state.datum;
            });
          } else if (state is BrandNameListFetchCompleted) {
            setState(() {
              brandNameList = state.brandNameList;
            });
          } else if (state is PreviousOrderFailure) {
            setState(() {
              productList = [];
              isProductAvailable = false;
              isProductIsEmpty = true;
              billDate = '-/-/-';
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
            });
          } else if (state is ReOrderIsSuccess) {
            Fluttertoast.showToast(
                msg: 'Order placed  successful',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/dashboard",
              (Route<dynamic> route) => false,
            );
          }
        },
        child: preOrderStack(),
      ),
    ));
  }

  preOrderStack() {
    return Stack(
      children: [
        preOrderBody(),
        BlocBuilder<PreorderBloc, PreorderState>(
          builder: (context, state) {
            if (state is PreOrderApiLoading) {
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
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 7),
            height: SizeUtils.getScreenHeight(context, 7),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/viewcart",
                  (Route<dynamic> route) => false,
                );
              },
              child: Image.asset(
                'assets/images/cart.png',
              ),
            ),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 2),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 7),
            height: SizeUtils.getScreenHeight(context, 7),
            child: Image.asset(
              'assets/images/man.png',
            ),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 2),
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
          onTap: () {},
          child: Text(
            Constants.preorder,
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2),
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget brandCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          SizeUtils.getScreenWidth(context, 15),
          SizeUtils.getScreenHeight(context, 2),
          SizeUtils.getScreenWidth(context, 15),
          SizeUtils.getScreenHeight(context, 2)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF78BB43)),
          color:
              const Color(0xFFFFFFFF), // Set your desired background color here
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
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
                  Constants.brand,
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
                        value: selectedBrandName,
                        hint: Text('Select brand'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedBrandName = newValue;
                            getBrandIdFromList();
                          });
                        },
                        items: brandNameList
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
      ),
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
              SizedBox(
                width: SizeUtils.getScreenWidth(context, 1),
              ),
              previousOredrButton(context)
            ],
          ),
        ),
      ),
    );
  }

  void getCustomerIdFromList() {
    customerId = customers
        .where((item) => item.name.toString() == selectedCustomer)
        .first
        .id
        .toString();
  }

  previousOredrButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
            .read<PreorderBloc>()
            .add(PreviousOrder(customerId: customerId, brandId: brandId));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: Container(
            decoration: BoxDecoration(
              color: const Color(
                  0xFF273180), // Set your desired background color here
              borderRadius:
                  BorderRadius.circular(15), // Add border radius if needed
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeUtils.getScreenWidth(context, 2.5),
                  top: SizeUtils.getScreenHeight(context, 1.2),
                  right: SizeUtils.getScreenWidth(context, 2.5),
                  bottom: SizeUtils.getScreenHeight(context, 1.2)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  Constants.previousOrder,
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

  reOredrButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PreorderBloc>().add(ReOrder(salesId: saledId));
      },
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
          child: Container(
              decoration: BoxDecoration(
                color: const Color(
                    0xFF273180), // Set your desired background color here
                borderRadius:
                    BorderRadius.circular(15), // Add border radius if needed
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeUtils.getScreenWidth(context, 2.5),
                    top: SizeUtils.getScreenHeight(context, 1.2),
                    right: SizeUtils.getScreenWidth(context, 2.5),
                    bottom: SizeUtils.getScreenHeight(context, 1.2)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    Constants.reOrder,
                    style: TextStyle(
                        fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  preOrderBody() {
    return Container(
      padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 4)),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/app_background.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          appHeader(context),
          customerSearchTab(context),
          brandCard(context),
          preOrderItemListWidget(context),
          SizedBox(
            height: SizeUtils.getScreenHeight(context, 2),
          ),
          reOredrButton(context)
        ],
      ),
    );
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
            'Bill Date        :',
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
            billDate,
            style: TextStyle(
                fontSize: SizeUtils.getDynamicFontSize(context, 2.4),
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void getBrandIdFromList() {
    brandId = brandList
        .where((item) => item.name.toString() == selectedBrandName)
        .first
        .id
        .toString();
  }

  Widget cartItems(BuildContext context) {
    return Container(
        height: SizeUtils.getScreenHeight(context, 40),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return PreOrderCartItem(preOrderList: productList[index]);
          },
        ));
  }

  preOrderItemListWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF), // Set your desired background color here
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(12)), // Add border radius if needed
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color:
                  Color(0xFFD4D4D4), // Set your desired background color here
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero), // Add border radius if needed
            ),
            padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 2)),
            child: Text(
              Constants.cartItems,
              style: TextStyle(
                  fontSize: SizeUtils.getDynamicFontSize(context, 2),
                  fontWeight: FontWeight.w700),
            ),
          ),
          Visibility(visible: isProductAvailable, child: cartItems(context)),
          Visibility(
              visible: isProductIsEmpty,
              child: Container(
                height: SizeUtils.getScreenHeight(context, 40),
                child: Center(
                    child: Text(
                  "No products where ordered for this customer till now.\n Please select another customer and brand",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: SizeUtils.getDynamicFontSize(context, 3),
                      fontWeight: FontWeight.w600),
                )),
              )),
          totalPriceLayout(context),
        ],
      ),
    );
  }
}
