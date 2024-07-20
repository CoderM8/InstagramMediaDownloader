import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/UI/bottom_screen.dart';
import 'package:instavideo_downloader/UI/permission/howtouse.dart';
import 'package:instavideo_downloader/UI/permission/trackingpermission.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      box.writeIfNull('new', false);
      await box.read('new') == true
          ? Get.off(() => BottomScreen())
          : Platform.isIOS
              ? Get.off(() => TrackingPermission())
              : Get.off(() => HowToUse(visit: true));
    });
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/splash-background.jpg',
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.fill,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextModel(
                text: 'Vibe',
                textAlign: TextAlign.center,
                fontSize: 60.sp,
                fontFamily: 'Q',
              ),
              TextModel(
                text: 'Insta Saver',
                textAlign: TextAlign.center,
                fontSize: 60.sp,
                fontFamily: 'Q',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
