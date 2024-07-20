import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instavideo_downloader/UI/Splash/splash_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Constant/constant.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  wcTerms = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('https://vocsyinfotech.in/vocsy/flutter/Insta_video_image/tearmsConditions.php'));
  wcPrivacy = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('https://vocsyinfotech.in/vocsy/flutter/Insta_video_image/privacyPolicy.php'));

  if (Platform.isAndroid) {
    getDeviceInfo();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: isTab(context) ? const Size(585, 812) : const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Vibe - Insta Saver',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: false,
              scaffoldBackgroundColor: Color(0xffF4F4F4),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              appBarTheme: AppBarTheme(elevation: 0, centerTitle: false),
              colorScheme: ColorScheme.fromSwatch().copyWith(primary: purpleColor, secondary: purpleColor),
            ),
            home: const SplashScreen(),
          );
        });
  }
}
