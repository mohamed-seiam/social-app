

import 'package:chatapp/constance.dart';
import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/layout/social_home.dart';
import 'package:chatapp/modules/login/social_login_screen.dart';
import 'package:chatapp/network/local/cach_helper.dart';
import 'package:chatapp/notification_handelr.dart';
import 'package:chatapp/shared/component/constance.dart';
import 'package:chatapp/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await  _initializeFirebase();
  await CachHelper.init();
  Bloc.observer = MyBlocObserver();
  await NotificationHandelr.initLocalNotification();

  uId = CachHelper.getData(key: 'uId');
  await NotificationHandelr.setupInteractedMessage();
  Widget widget;
 // await Api.getSelfInfo();
  if (CachHelper.getData(key: 'uId') != null) {
    widget = const SocialHomeScreen();
  } else {
    widget = const SocialLoginScreen();
  }
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // late  bool isDark;
  const MyApp({super.key, required this.startWidget});

  final Widget startWidget;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SocialCubit()
              ..getUserData()
              ..getAllUsers(),),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: defaultColor,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0.0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.black),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: defaultColor,
            elevation: 20.0,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        home: startWidget,
      ),
    );
  }
}

_initializeFirebase () async{
  await Firebase.initializeApp();
}
