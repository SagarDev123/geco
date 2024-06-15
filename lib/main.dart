import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<LoginBlocBloc>(
      create: (BuildContext context) =>
          LoginBlocBloc(loginRepository: LoginRepository()),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!);
      },
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
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
        // '/signup': (context) => const SignUp(),
        // '/signupDetails': (context) => const SignUpUserDetails(),
        // '/forgot_password': (context) => BlocProvider(
        //       create: (context) => ForgotPwdBloc(repository: UserRepository()),
        //       child: const ForgotPW(),
        //     ),
        // '/my_account': (context) => const MyAccountPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
