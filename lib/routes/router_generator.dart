import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/routes/route_data.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/screens/adminpage/admin_page.dart';
import 'package:flutter_cv_maker/screens/auth_screen.dart';
import 'package:flutter_cv_maker/screens/create_cv_screen.dart';
import 'package:flutter_cv_maker/screens/home_screen.dart';
import 'package:flutter_cv_maker/screens/loginScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var uriData = Uri.parse(settings.name);
    print('queryParameters: ${uriData.queryParameters} path: ${uriData.path}');
    var routingData = RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
    switch (routingData.route) {
      case routeLogin:
       case '/':
        return MaterialPageRoute(
            builder: (_) => LoginScreen(), settings: settings);
        break;
      case routeHome:
        return MaterialPageRoute(
            builder: (_) => HomeScreen(), settings: settings);
        break;
      case routeAdmin:
        return MaterialPageRoute(builder: (_) => AdminPage(),settings: settings);
      case routeCreateCV:
        // Get arguments
        var data = settings.arguments;
        // Pass data to CreateCV screen
        return MaterialPageRoute(
            builder: (_) => CreateCV(cvModel: data as CVModel,), settings: settings);
        break;
      default:
        return MaterialPageRoute(
            builder: (_) => LoginScreen(), settings: settings);
        break;
    }
  }
}
