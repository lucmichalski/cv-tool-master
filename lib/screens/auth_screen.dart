import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/authen_bloc.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';

class AuthenScreen extends StatefulWidget {
  const AuthenScreen({Key key}) : super(key: key);

  @override
  _AuthenScreenState createState() => _AuthenScreenState();
}

class _AuthenScreenState extends State<AuthenScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        builder: (ctx, state) => _buildUI(context),
        listener: (ctx, state) {
          if (state is AuthLoading) {
            showProgressBar(context, true);
          } else if (state is AuthSuccess) {
            showProgressBar(context, false);
          } else if (state is AuthError) {
            showProgressBar(context, false);
            showAlertDialog(
                context, 'Error', state.message, () => Navigator.pop(context));
          }
        });
  }

  Widget _buildUI(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text('TODO')],
      ),
    );
  }
}
