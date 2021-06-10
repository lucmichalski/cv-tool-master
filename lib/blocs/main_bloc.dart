import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/authen_bloc.dart';

class MainBloc {
  static List<BlocProvider> allBlocs() {
    return [
      // Add new bloc like this

      BlocProvider<AuthenBloc>(
        create: (BuildContext context) => AuthenBloc(),
      ),
    ];
  }
}
