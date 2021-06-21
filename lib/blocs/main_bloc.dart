import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/authen_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/master_bloc.dart';

import 'authen_bloc/bloc/master_bloc/get_master_data_bloc/cv_bloc.dart';

class MainBloc {
  static List<BlocProvider> allBlocs() {
    return [
      // Add new bloc like this

      BlocProvider<AuthBloc>(
        create: (BuildContext context) => AuthBloc(AuthInitial()),
      ),
      BlocProvider<MasterBloc>(
        create: (BuildContext context) => MasterBloc(MasterInitial()),
      ),
      BlocProvider<CVBloc>(
        create: (BuildContext context) => CVBloc(GetCVListInitial()),
      ),
    ];
  }
}
