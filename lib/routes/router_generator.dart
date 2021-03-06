import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/routes/route_data.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/screens/adminpage/admin_page.dart';
import 'package:flutter_cv_maker/screens/auth_screen.dart';
import 'package:flutter_cv_maker/screens/change_password_screen.dart';
import 'package:flutter_cv_maker/screens/create_cv_screen.dart';
import 'package:flutter_cv_maker/screens/home_screen.dart';
import 'package:flutter_cv_maker/screens/login_screen.dart';
import 'package:flutter_cv_maker/screens/not_found_screen.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var uriData = Uri.parse(settings.name);
    print('queryParameters: ${uriData.queryParameters} path: ${uriData.path}');
    var routingData = RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
    var token = SharedPreferencesService.getToken;
      switch (routingData.route) {
        case routeLogin:
        case '/':
          if (token != null && token.isNotEmpty) {
            return MaterialPageRoute(
                builder: (_) => HomeScreen(), settings: settings.copyWith(name: routeHome));
          } else {
            return MaterialPageRoute(
                builder: (_) => LoginScreen(), settings: settings);
          }
          break;
        case routeHome:
          return MaterialPageRoute(
              builder: (_) => HomeScreen(), settings: settings);
          break;
        case routeAdmin:
          return MaterialPageRoute(builder: (_) => AdminPage(),settings: settings);
          break;
        case routeUpdateCV:
          var id = routingData['id'];
          return MaterialPageRoute(
              builder: (_) => CreateCV( id: id,), settings: settings);
          break;
        case routeCreateCV:
          return MaterialPageRoute(
              builder: (_) => CreateCV(), settings: settings);
          break;
        case routeChangePass:
          return MaterialPageRoute(builder: (_) => ChangePasswordScreen(),settings: settings);
          break;
        default:
          return MaterialPageRoute(
              builder: (_) => NotFoundScreen(), settings: settings);
          break;
      }
    }
}
