import 'package:daraz_app/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daraz_app/screens/login.dart';
import 'package:daraz_app/screens/register.dart';

const LoginRoute = "/";
const DashboardRoute = "/dashboard";
const RegisterRoute = "/register";

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onGenerateRoute: _routes(),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.black),
      themeMode: ThemeMode.light,
    );
  }

  RouteFactory _routes() {
    return (settings) {
      Widget screen;
      switch (settings.name) {
        case LoginRoute:
          screen = LoginPage();
          break;
        case DashboardRoute:
          screen = DashboardPage();
          break;
        case RegisterRoute:
          screen = RegisterPage();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
