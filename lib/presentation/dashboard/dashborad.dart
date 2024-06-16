import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geco/data/model/brand.dart';
import 'package:geco/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:geco/presentation/dashboard/list/brandlist.dart';
import 'package:geco/utils/constants.dart';
import 'package:status_alert/status_alert.dart';

import '../../utils/api_loader.dart';
import '../../utils/sharedpreferencehelper.dart';
import '../../utils/sizeutils.dart';
import '../../utils/utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<BrandData> brand = [];

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(
          DashBoardBrandListFetch(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashBoardFetchingCompleted) {
          setState(() {
            brand = state.datum;
          });
        } else if (state is DashboardFailure) {
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
      child: dashboardStack(),
    )));
  }

  dashboardBody() {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          appHeader(context),
          productTab(context),
          someOfTheFamousBrandText(context),
          SizedBox(
            width: SizeUtils.getScreenHeight(context, 10),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 4)),
              width: double.infinity,
              child: brandList(context),
            ),
          ),
          createOrderButoon(context),
        ]));
  }

  dashboardStack() {
    return Stack(
      children: [
        dashboardBody(),
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardApiLoading) {
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
            child: Text(
              Constants.appName,
              style: TextStyle(
                  fontSize: SizeUtils.getDynamicFontSize(context, 3),
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
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

  productTab(BuildContext context) {
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
        child: Wrap(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/customer",
                  (Route<dynamic> route) => false,
                );
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeUtils.getScreenWidth(context, 8),
                      SizeUtils.getScreenHeight(context, 1),
                      SizeUtils.getScreenWidth(context, 8),
                      SizeUtils.getScreenHeight(context, 1)),
                  decoration: BoxDecoration(
                    color: const Color(
                        0xFF78BB43), // Set your desired background color here
                    borderRadius: BorderRadius.circular(
                        SizeUtils.getScreenWidth(
                            context, 1)), // Add border radius if needed
                  ),
                  child: Text(
                    Constants.customerList,
                    style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: SizeUtils.getDynamicFontSize(context, 1.6),
                        fontWeight: FontWeight.w500),
                  )),
            ),
            SizedBox(
              width: SizeUtils.getScreenWidth(context, 2),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/preorder",
                  (Route<dynamic> route) => false,
                );
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeUtils.getScreenWidth(context, 8),
                      SizeUtils.getScreenHeight(context, 1),
                      SizeUtils.getScreenWidth(context, 8),
                      SizeUtils.getScreenHeight(context, 1)),
                  decoration: BoxDecoration(
                    color: const Color(
                        0xFF1E1E1E), // Set your desired background color here
                    borderRadius: BorderRadius.circular(
                        SizeUtils.getScreenWidth(
                            context, 1)), // Add border radius if needed
                  ),
                  child: Text(
                    Constants.previousOrderList,
                    style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: SizeUtils.getDynamicFontSize(context, 1.6),
                        fontWeight: FontWeight.w500),
                  )),
            )
          ],
        ),
      ),
    );
  }

  someOfTheFamousBrandText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeUtils.getScreenHeight(context, 2)),
      child: Text(Constants.someOfTheFamousBrands,
          style: TextStyle(
              color: const Color(0XFF1E1E1E),
              fontWeight: FontWeight.bold,
              fontSize: SizeUtils.getDynamicFontSize(context, 3))),
    );
  }

  brandList(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: brand.length,
          itemBuilder: (context, index) {
            return BrandItem(brand: brand[index]);
          }),
    );
  }

  createOrderButoon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // hide keyboard...
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/createneworder",
          (Route<dynamic> route) => false,
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(2, SizeUtils.getScreenHeight(context, 2),
            2, SizeUtils.getScreenHeight(context, 2)),
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
                    left: SizeUtils.getScreenWidth(context, 3),
                    top: SizeUtils.getScreenHeight(context, 2),
                    right: SizeUtils.getScreenWidth(context, 3),
                    bottom: SizeUtils.getScreenHeight(context, 2)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    Constants.createNewOrder,
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
}
