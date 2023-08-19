import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/layout/home/home_layout.dart';
import 'package:social_app_flutter_firebase/modules/login/login_screen.dart';
import 'package:social_app_flutter_firebase/shared/components/constants.dart';
import 'package:social_app_flutter_firebase/shared/cubit/app_cubit.dart';
import 'package:social_app_flutter_firebase/shared/cubit/app_states.dart';
import 'package:social_app_flutter_firebase/shared/network/local/cache_helper.dart';
import 'package:social_app_flutter_firebase/shared/styles/styles/themes.dart';
import 'package:social_app_flutter_firebase/splash_screen.dart';

import 'bloc_observer.dart';
import 'modules/login/cubit/states.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
   uId = CacheHelper.getData(key: 'uId');
   var login = CacheHelper.getData(key: 'login');
  Widget? widget;

 if(login == true || uId != null){
   print('homeLayout');
   widget = HomeLayout();
 }
 else{
   print('LoginScreen');
   widget = LoginScreen();
 }

  runApp( MyApp(isDark: isDark,startWidget: widget,));
}

class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _initialization =Firebase.initializeApp();
  final bool? isDark;
   final Widget? startWidget;
  var login = CacheHelper.getData(key: 'login');

  // if(uid == null){
  //   startWidget = LoginScreen();
  // }else{
  //   startWidget = LoginScreen();
  // }

  MyApp({this.isDark, this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          AppCubit()
            ..changeAppMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (context) =>
          HomeCubit()..getUserData()..getPostsData()..getAllUsers(),
        ),
      ],
      child: Builder(
        builder: (context) {
          // HomeCubit.get(context)..getUserData()..getPostsData()..getAllUsers();
          return BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is HomeInitialState) {
                HomeCubit.get(context).getPostsData();
              }
            },
            builder: (context, state) {
              HomeCubit.get(context).getPostsData();
              return MaterialApp(
                  title: 'Social Network',
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: ThemeMode.light,
                  // AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
                  home: SplashScreen()
                  // login==true && uId != null? HomeLayout() :LoginScreen()
              );
            },
          );
        }
      ),
    );
  }
}

