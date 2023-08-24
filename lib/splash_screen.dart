import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/res/assets_res.dart';
import 'package:social_app_flutter_firebase/shared/components/constants.dart';
import 'package:social_app_flutter_firebase/shared/network/local/cache_helper.dart';

import 'layout/home/home_layout.dart';
import 'modules/login/login_screen.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context)
      ..getUserData()
      ..getAllUsers()
      ..getPostsData();
    var login = CacheHelper.getData(key: 'login');
    uId = CacheHelper.getData(key: 'uId');
    final Widget? startWidget;
    if (login == true || uId != null) {
      print('homeLayout');
      startWidget = HomeLayout();
    } else {
      print('LoginScreen');
      startWidget = LoginScreen();
    }

    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => startWidget!)));
    HomeCubit.get(context)
      ..getUserData()
      ..getPostsData();

    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage(
                AssetsRes.LOGO,
              ),
              fit: BoxFit.cover,



            ),



          ),

        ));
  }
}
