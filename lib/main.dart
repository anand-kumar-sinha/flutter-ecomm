import 'package:ecomm/firebase_options.dart';
import 'package:ecomm/screens/auth-ui/splash_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'screens/user-panel/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..backgroundColor = Colors.blue // Set your custom background color
    ..textColor = Colors.yellow // Set your custom text color
    ..indicatorColor = Colors.white // Set indicator color (optional)
    ..maskColor = Colors.black.withOpacity(0.5) // Set mask color (optional)
    ..userInteractions = false // Disable user interaction while loading
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
