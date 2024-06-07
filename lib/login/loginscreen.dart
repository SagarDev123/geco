import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco/login/bloc/login_bloc_bloc.dart';
import 'package:geco/utils/constants.dart';
import 'package:geco/utils/sizeutils.dart';
import 'package:status_alert/status_alert.dart';

import '../utils/api_loader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBlocBloc, LoginBlocState>(
        listener: (context, state) {
          if (state is LoginApiFailure) {
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
          } else if (state is LoginSuccessState) {
            Fluttertoast.showToast(
                msg: state.message,
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
        child: loginStack(),
      ),
    );
  }

  loginStack() {
    return Stack(
      children: [
        loginBody(),
        BlocBuilder<LoginBlocBloc, LoginBlocState>(
          builder: (context, state) {
            if (state is LoginApiLoading) {
              return const AppLoader();
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }

  loginBody() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/app_background.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: SizeUtils.getScreenWidth(context, 30),
              height: SizeUtils.getScreenHeight(context, 25),
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            const Text(
              Constants.welcomeTextLogin,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              Constants.loginDirectionText,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  SizeUtils.getScreenWidth(context, 10),
                  SizeUtils.getScreenHeight(context, 2),
                  SizeUtils.getScreenWidth(context, 10),
                  SizeUtils.getScreenHeight(context, 5)),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(SizeUtils.getScreenWidth(context, 4)),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // This makes the card size to its content
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Constants.email,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // 80% of screen width
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                15.0), // Rounded corners here
                          ),
                        ),
                      ),
                      SizedBox(height: SizeUtils.getScreenHeight(context, 3)),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Constants.password,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                15.0), // Rounded corners here
                          ),
                        ),
                      ),
                      SizedBox(height: SizeUtils.getScreenHeight(context, 4)),
                      loginButton(context)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String username_ = usernameController.text.trim();
        String password_ = passwordController.text.trim();
        FocusScope.of(context).unfocus(); // hide keyboard...
        context.read<LoginBlocBloc>().add(
              OnLoginButtonClick(
                username: username_,
                password: password_,
              ),
            );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: Container(
            width: double.infinity,
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
}
