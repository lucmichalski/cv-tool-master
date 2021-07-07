import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';
class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showProgressBar(context, false);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: AssetImage('image/not_found.png'),fit: BoxFit.contain,),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF6B92F2),
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              onPressed: () async {
                final pref = await SharedPreferencesService.instance;
                if (pref.getAccessToken != null &&
                    pref.getAccessToken.isNotEmpty) {
                  navKey.currentState
                      .pushNamedAndRemoveUntil(routeHome, (route) => false);
                } else {
                  navKey.currentState
                      .pushNamedAndRemoveUntil(routeLogin, (route) => false);
                }
              },
              child: Text(
                "Go Home".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}