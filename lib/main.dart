import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_share/bloc/app_bloc.dart';
import 'package:link_share/screens/auth_flow/login.dart';
import 'package:link_share/screens/home_screen.dart';
import 'package:link_share/utils/appwrite_initializer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
      .copyWith(systemNavigationBarColor: Colors.white));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppWriteInit.initClient();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: MaterialApp(
        navigatorKey: MyApp.navigatorKey,
          debugShowCheckedModeBanner: false,
          home: AppWriteInit.isLoggedIn ? const HomeScreen() : const LoginScreen(),
      )  
    );
  }
}
