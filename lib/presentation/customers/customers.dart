import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geco/presentation/customers/bloc/customer_bloc.dart';
import 'package:status_alert/status_alert.dart';

import '../../data/model/customer.dart';
import '../../utils/api_loader.dart';
import '../../utils/constants.dart';
import '../../utils/sizeutils.dart';
import 'list/customer.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  TextEditingController searchController = TextEditingController();
  List<Datum> customers = [];
  String searchedName = '';

  TextEditingController customerNameController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController gstNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(
          CustomerListFetching(searchedName),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BlocListener<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerFailure) {
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
          } else if (state is CustomerListFetched) {
            setState(() {
              customers = state.customers;
            });
          } else if (state is AddCustomerSuccess) {
            customerNameController.text = '';
            storeNameController.text = '';
            gstNumberController.text = '';
            mobileNumberController.text = '';
            addressController.text = '';
            context.read<CustomerBloc>().add(
                  CustomerListFetching(searchedName),
                );
          }
        },
        child: customerStack(),
      ),
    ));
  }

  customerStack() {
    return Stack(
      children: [
        customerListBody(),
        BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomersApiLoading) {
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
                      Constants.customerToDashboard,
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

  addCutomerButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAddCustomerDialog(context);
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
                  left: SizeUtils.getScreenWidth(context, 2),
                  top: SizeUtils.getScreenHeight(context, 1),
                  right: SizeUtils.getScreenWidth(context, 2),
                  bottom: SizeUtils.getScreenHeight(context, 1)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  Constants.addCutomer,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeUtils.getScreenWidth(context, 3),
                height: SizeUtils.getScreenHeight(context, 3),
                child: Image.asset(
                  'assets/images/search.png',
                ),
              ),
              SizedBox(
                width: SizeUtils.getScreenWidth(context, 2),
              ),
              SizedBox(
                width: SizeUtils.getScreenWidth(context, 70),
                child: TextField(
                  onChanged: (value) {
                    searchedName = value;
                    context
                        .read<CustomerBloc>()
                        .add(CustomerListFetching(searchedName));
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: Constants.searchByCustomer,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners here
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

  customerListBody() {
    return Container(
        padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 4)),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          appHeader(context),
          customerSearchTab(context),
          customerBody(context),
          listHeader(context),
          Expanded(
            child: Container(
              width: double.infinity,
              child: customersList(context),
            ),
          ),
        ]));
  }

  customersList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            return Customer(customer: customers[index]);
          }),
    );
  }

  addNewCustomerColumn(BuildContext context) {
    return Row(
      children: [
        Text(
          Constants.customerListWithColon,
          style: TextStyle(
              fontSize: SizeUtils.getDynamicFontSize(
                context,
                2.5,
              ),
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: SizeUtils.getScreenWidth(context, 1),
        ),
        addCutomerButton(context),
      ],
    );
  }

  customerBody(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: SizeUtils.getScreenHeight(context, 2),
      ),
      addNewCustomerColumn(context),
      SizedBox(
        height: SizeUtils.getScreenHeight(context, 2),
      ),
    ]);
  }

  listHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0XFFC2C2C2),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeUtils.getScreenWidth(context, 2)),
              topRight: Radius.circular(SizeUtils.getScreenWidth(context, 2)))),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeUtils.getScreenWidth(context, 3),
            SizeUtils.getScreenHeight(context, 1),
            SizeUtils.getScreenWidth(context, 3),
            SizeUtils.getScreenHeight(context, 1)),
        child: Row(children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Constants.name,
                style: TextStyle(
                    fontSize: SizeUtils.getDynamicFontSize(
                      context,
                      2,
                    ),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                Constants.storeName,
                style: TextStyle(
                    fontSize: SizeUtils.getDynamicFontSize(
                      context,
                      2,
                    ),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                Constants.gstNo,
                style: TextStyle(
                    fontSize: SizeUtils.getDynamicFontSize(
                      context,
                      2,
                    ),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Constants.phone,
                style: TextStyle(
                    fontSize: SizeUtils.getDynamicFontSize(
                      context,
                      2,
                    ),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void showAddCustomerDialog(BuildContext context_) {
    showDialog(
      context: context_,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Customer'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: customerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Name*',
                    hintText: 'Enter Store Owner Name',
                  ),
                ),
                TextField(
                  controller: storeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Store Name*',
                    hintText: 'Ex: Vijaya Store',
                  ),
                ),
                TextField(
                  controller: mobileNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number*',
                    hintText: 'Enter 10 digit number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: gstNumberController,
                  decoration: const InputDecoration(
                    labelText: 'GST Number',
                    hintText: 'Enter GST No.(if any)',
                  ),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address*',
                    hintText: 'Enter Address',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // Implement your add customer logic here
                context_.read<CustomerBloc>().add(AddNewCustomer(
                    customerNameController.text,
                    storeNameController.text,
                    mobileNumberController.text,
                    gstNumberController.text,
                    addressController.text));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
