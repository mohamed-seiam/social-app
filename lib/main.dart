// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/constance.dart';
import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/layout/social_home.dart';
import 'package:chatapp/modules/login/social_login_screen.dart';
import 'package:chatapp/network/local/cach_helper.dart';
import 'package:chatapp/network/remote/dio_helper.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:chatapp/shared/component/constance.dart';
import 'package:chatapp/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
   showToast(text:'background message' , state: Toaststate.SUCCESS);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Diohelper.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((event)
  {
    print(event.data.toString());
  }).onError((error)
  {
    print('Failed');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print(event.data.toString());
  }).onError((error)
  {
    print('Failed');
  });
  await CachHelper.init();

  Bloc.observer = MyBlocObserver();
uId = CachHelper.getData(key: 'uId');
  // bool ? isDark = CachHelper.getBool(key:'isDark');
  Widget widget;

  if(CachHelper.getData(key:'uId')!=null)
  {
    print(CachHelper.getData(key:'uId')+'jkjkjkj');
    widget = SocialHomeScreen();
  }else
  {
    print(CachHelper.getData(key:'uId'));
    widget = SocialLoginScreen();
  }
  runApp( MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // late  bool isDark;
  const MyApp({super.key, required this.startWidget});
  final Widget startWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        return  MultiBlocProvider(
          providers: [
            BlocProvider(create: (context)=>SocialCubit()..getUserData()..getPosts()..allUsers),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: defaultColor,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0.0,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                    color: Colors.black
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData
                (
                type:BottomNavigationBarType.fixed,
                selectedItemColor: defaultColor,
                elevation: 20.0,
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            // darkTheme: ThemeData(
            //   primarySwatch: Colors.deepOrange,
            //   scaffoldBackgroundColor: HexColor('333739'),
            //   appBarTheme: AppBarTheme(
            //     backgroundColor: HexColor('333739'),
            //     elevation: 0.0,
            //     titleTextStyle: TextStyle(
            //       color: Colors.white,
            //       fontSize: 20.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     iconTheme: IconThemeData(
            //       color: Colors.white,
            //     ),
            //     systemOverlayStyle: SystemUiOverlayStyle(
            //       statusBarColor:HexColor('333739'),
            //       statusBarIconBrightness: Brightness.light,
            //     ),
            //   ),
            //   bottomNavigationBarTheme: BottomNavigationBarThemeData
            //     (
            //       type:BottomNavigationBarType.fixed,
            //       selectedItemColor: Colors.deepOrange,
            //       unselectedItemColor: Colors.grey,
            //       elevation: 20.0,
            //       backgroundColor: HexColor('333739')
            //   ),
            //   textTheme: TextTheme(
            //     bodyText1: TextStyle(
            //       fontSize: 20.0,
            //       fontWeight: FontWeight.w600,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            // themeMode: AppCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
            home: startWidget,
          ),
        );
  }
}





