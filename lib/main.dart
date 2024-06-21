import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geco/locator.dart';
import 'package:geco/login/bloc/login_bloc_bloc.dart';
import 'package:geco/login/loginscreen.dart';
import 'package:geco/presentation/cart/bloc/view_cart_bloc.dart';
import 'package:geco/presentation/cart/viewcart.dart';
import 'package:geco/presentation/createneworder/bloc/create_new_order_bloc.dart';
import 'package:geco/presentation/createneworder/create_new_order.dart';
import 'package:geco/presentation/customers/bloc/customer_bloc.dart';
import 'package:geco/presentation/customers/customers.dart';
import 'package:geco/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:geco/presentation/dashboard/dashborad.dart';
import 'package:geco/presentation/preorder/bloc/preorder_bloc.dart';
import 'package:geco/presentation/preorder/preorder.dart';
import 'package:geco/repository/create_new_order_repository.dart';
import 'package:geco/repository/customer_repository.dart';
import 'package:geco/repository/dashboard_repository.dart';
import 'package:geco/repository/login_repository.dart';
import 'package:geco/repository/preorder_repository.dart';
import 'package:geco/repository/viewcart_repository.dart';
import 'package:geco/utils/sharedpreferencehelper.dart';

import 'repository/remotedatarepository.dart';

void main() {
  setUp();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<LoginBlocBloc>(
      create: (BuildContext context) => LoginBlocBloc(
          loginRepository:
              LoginRepository(locator.get<RemoteDataRepository>())),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key});

  appRouteChecking(BuildContext context, bool? data) {
    String initialRoute = '/';
    if (data == true) {
      initialRoute = '/dashboard';
    }

    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!);
      },
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => BlocProvider(
            create: (context) =>
                LoginBlocBloc(loginRepository: LoginRepository()),
            child: const LoginScreen()),
        '/dashboard': (context) => BlocProvider(
              create: (context) =>
                  DashboardBloc(dashboardRepository: DashboardRepository()),
              child: const Dashboard(),
            ),
        '/customer': (context) => BlocProvider(
              create: (context) =>
                  CustomerBloc(customerRepository: CustomerRepository()),
              child: const CustomerList(),
            ),
        '/createneworder': (context) => BlocProvider(
              create: (context) => CreateNewOrderBloc(
                  createNewOrderRepository: CreateNewOrderRepository()),
              child: const CreateNewOrder(),
            ),
        '/viewcart': (context) => BlocProvider(
              create: (context) =>
                  ViewCartBloc(viewCartRepository: ViewCartRepository()),
              child: const ViewCart(),
            ),
        '/preorder': (context) => BlocProvider(
              create: (context) => PreorderBloc(
                  preOrderRepository: PreOrderRepository(),
                  dashboardRepository: DashboardRepository()),
              child: const PreOrder(),
            ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SharedPreferenceHelper.isContentExist(),
      builder: (context, snapshot) {
        // // Log the snapshot data
        // print("Snapshot Data: ${snapshot.data}");
        // print("Snapshot Error: ${snapshot.error}");
        // print("Snapshot Connection State: ${snapshot.connectionState}");

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const MaterialApp(
        //     home: Scaffold(
        //       body: Center(child: CircularProgressIndicator()),
        //     ),
        //   );
        // }

        // if (snapshot.hasError) {
        //   return MaterialApp(
        //     home: Scaffold(
        //       body: Center(child: Text("Error: ${snapshot.error}")),
        //     ),
        //   );
        // }

        // String initialRoute = '/';
        // if (snapshot.hasData && snapshot.data == true) {
        //   initialRoute = '/dashboard';
        // }

        return appRouteChecking(context, snapshot.data);
      },
    );
  }
}
