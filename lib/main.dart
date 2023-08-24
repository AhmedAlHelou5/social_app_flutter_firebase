import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/layout/home/home_layout.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';
import 'package:social_app_flutter_firebase/modules/login/login_screen.dart';
import 'package:social_app_flutter_firebase/native_code.dart';
import 'package:social_app_flutter_firebase/shared/components/components.dart';
import 'package:social_app_flutter_firebase/shared/components/constants.dart';
import 'package:social_app_flutter_firebase/shared/cubit/app_cubit.dart';
import 'package:social_app_flutter_firebase/shared/cubit/app_states.dart';
import 'package:social_app_flutter_firebase/shared/network/local/cache_helper.dart';
import 'package:social_app_flutter_firebase/shared/styles/colors/colors.dart';
import 'package:social_app_flutter_firebase/shared/styles/styles/themes.dart';
import 'package:social_app_flutter_firebase/splash_screen.dart';

import 'bloc_observer.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("on background message");
  showToast(text: 'on background message', state: ToastStates.SUCCESS);

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  uId = CacheHelper.getData(key: 'uId');
  var login = CacheHelper.getData(key: 'login');

  var token = await FirebaseMessaging.instance.getToken();
  print('token : $token');

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    print(event.notification!.title);
    print(event.notification!.body);
    showToast(text: 'on message', state: ToastStates.SUCCESS);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    print(event.notification!.title);
    print(event.notification!.body);
    showToast(text: 'onMessageOpenedApp', state: ToastStates.SUCCESS);
  });

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  //

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Widget? widget;

  if (uId != null) {
    print('homeLayout');
    widget = HomeLayout();
  } else {
    print('LoginScreen');
    widget = LoginScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
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
          create: (context) => AppCubit()..changeAppMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (context) => HomeCubit()
            ..getUserData()
            ..getPostsData()
            ..getAllUsers()
              // ..getPostsProfileData(uId)
        ),
      ],
      child: Builder(builder: (context) {
        // HomeCubit.get(context)..getUserData()..getPostsData()..getAllUsers();
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            // TODO: implement listener
            // if (state is HomeGetPostsProfileSuccessState) {
            //   HomeCubit.get(context).getPostsProfileData(uId);
            // }
          },
          builder: (context, state) {
            // HomeCubit.get(context).getPostsData();
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
      }),
    );
  }
}
