import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geco/data/model/brand.dart';
import 'package:geco/data/model/customer.dart';
import 'package:geco/presentation/createneworder/bloc/create_new_order_bloc.dart';
import 'package:geco/presentation/createneworder/list/products.dart';
import 'package:status_alert/status_alert.dart';

import '../../utils/api_loader.dart';
import '../../utils/constants.dart';
import '../../utils/sizeutils.dart';

class CreateNewOrder extends StatefulWidget {
  const CreateNewOrder({super.key});

  @override
  State<CreateNewOrder> createState() => _CreateNewOrderState();
}

class _CreateNewOrderState extends State<CreateNewOrder> {
  String? selectedCustomer;

  List<Datum> customers = [];
  List<BrandData> brands = [];
  List<String> customerNameList = [];
  List<String> brandNameList = [];

  @override
  void initState() {
    super.initState();
    context.read<CreateNewOrderBloc>().add(CustomerFetchingEvent());
    context.read<CreateNewOrderBloc>().add(ShowAllBrandForTheUser());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BlocListener<CreateNewOrderBloc, CreateNewOrderState>(
        listener: (context, state) {
          if (state is CustomerListFetched) {
            setState(() {
              customers = state.customers;
            });
          } else if (state is CustomerNameListFetched) {
            setState(() {
              customerNameList = state.customerNames;
            });
          } else if (state is BrandFetchingCompleted) {
            setState(() {
              brands = state.brand;
            });
          } else if (state is BrandNameListFetchingCompleted) {
            setState(() {
              brandNameList = state.brandNameList;
            });
          } else if (state is CreateNewOrderFailure) {
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
        },
        child: createNewOrderBody(context),
      ),
    ));
  }

  createNewOrderBody(BuildContext context) {
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
          SizedBox(
            height: SizeUtils.getScreenHeight(context, 2),
          ),
          perviousOrderBox(context),
          brandSelection(context),
          Container(
              decoration: BoxDecoration(
                color: const Color(
                    0xFF273180), // Set your desired background color here
                borderRadius:
                    BorderRadius.circular(15), // Add border radius if needed
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    SizeUtils.getScreenWidth(context, 8),
                    SizeUtils.getScreenHeight(context, 1),
                    SizeUtils.getScreenWidth(context, 8),
                    SizeUtils.getScreenHeight(context, 1)),
                child: Text(
                  "View Cart",
                  style: TextStyle(
                      fontSize: SizeUtils.getDynamicFontSize(context, 2),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ))
        ]));
  }

  viewCartButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.fromLTRB(2, SizeUtils.getScreenHeight(context, 1),
            2, SizeUtils.getScreenHeight(context, 1)),
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
                  Constants.loginNow,
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

  customerSearchTab(BuildContext context) {
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
              SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {
                    // Add your action for showing all brands
                  },
                  child: Text('Show All Brands'),
                ),
              ),
            ],
          ),
        ),
      ),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/dashboard",
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      Constants.createNewOrderToDashboard,
                      style: TextStyle(
                          fontSize: SizeUtils.getDynamicFontSize(context, 2),
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
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

  perviousOrderBox(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(
              child: Text(
                'Previous Order: 01-02-2022',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
                onSurface: Colors.grey,
              ),
              onPressed: () {
                // Action to view list
              },
              child: Text('View List'),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // Action to close or dismiss
              },
            ),
          ],
        ),
      ),
    );
  }

  brandSelection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 4)),
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            child: Column(
              children: [
                brandHearder(context),
                SizedBox(
                  height: SizeUtils.getScreenHeight(context, 2),
                ),
                brandList(context),
                productList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  brandHearder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          SizeUtils.getScreenWidth(context, 2),
          SizeUtils.getScreenHeight(context, 2),
          SizeUtils.getScreenWidth(context, 2),
          SizeUtils.getScreenHeight(context, 0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'All Brands List',
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeUtils.getDynamicFontSize(context, 2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search brands',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 2),
          ),
          SizedBox(
            width: SizeUtils.getScreenWidth(context, 3),
            height: SizeUtils.getScreenHeight(context, 3),
            child: Image.asset(
              'assets/images/search.png',
            ),
          ),
        ],
      ),
    );
  }

  brandList(BuildContext context) {
    return Container(
      color: Color(0XFF346328),
      padding: EdgeInsets.all(SizeUtils.getScreenHeight(context, 2)),
      height: SizeUtils.getScreenHeight(context, 18), // Set to desired height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Card(
                margin: EdgeInsets.all(10),
                child: Container(
                    height: SizeUtils.getScreenHeight(context, 12),
                    width: SizeUtils.getScreenWidth(context, 18),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: brands[index].imageUrl.toString().isEmpty
                            ? const AssetImage('assets/images/logo.png')
                                as ImageProvider<Object>
                            : NetworkImage(brands[index].imageUrl.toString())
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
                      false, // You can manage the state by using a stateful widget
                  onChanged: (bool? newValue) {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  productList(BuildContext context) {
    return Column(
      children: [
        selectedBrandNameLayout(context),
        productListFromBrand(context),
      ],
    );
  }

  selectedBrandNameLayout(BuildContext context) {
    return Container(
      color: Color(0XFFF5F5F5),
      padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 2)),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Text(
            Constants.brand,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: SizeUtils.getDynamicFontSize(context, 2.3)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nirapara, Pavizham',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: SizeUtils.getDynamicFontSize(context, 2.3)),
            ),
          ),
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
                hint: Text('Product type'),
                onChanged: (newValue) {
                  setState(() {
                    selectedCustomer = newValue;
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
      ]),
    );
  }

  productListFromBrand(BuildContext context) {
    return Container(
      height: SizeUtils.getScreenHeight(context, 23),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 45,
        itemBuilder: (context, index) {
          return const Product();
        },
      ),
    );
  }

  createNewOrderStack(BuildContext context) {
    return Stack(
      children: [
        createNewOrderBody(context),
        BlocBuilder<CreateNewOrderBloc, CreateNewOrderState>(
          builder: (context, state) {
            if (state is CreateNewOrderApiLoading) {
              return const AppLoader();
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}
