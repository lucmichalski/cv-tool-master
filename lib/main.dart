import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/main_bloc.dart';
import 'package:flutter_cv_maker/routes/router_generator.dart';
import 'package:flutter_cv_maker/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: MainBloc.allBlocs(),
      child: MaterialApp(
        title: 'CV Creator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: routeHome,
        navigatorKey: navKey,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
