import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/UI/permission/howtouse.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackingPermission extends StatelessWidget {
  const TrackingPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Image.asset(
            "assets/images/tracking_permission.png",
            color: blackColor,
            height: 200.w,
            width: 200.w,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 30.h),
          TextModel(text: "App Tracking permission needed", fontFamily: 'B', fontSize: 16.sp, color: blackColor),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: TextModel(
              text:
                  "This app needs access to your app tracking. A third-party API collects data for accessing reels and posts. Your data is used for get-reels and post purposes. If you don't feel comfortable with this permission, you can go to Settings > Permissions and modify it at any time.",
              fontFamily: 'M',
              color: blackColor,
              fontSize: 14.sp,
              letterSpacing: 1,
            ),
          ),
          Spacer(),
          ButtonWidget(
            height: 56.w,
            title: "Continue",
            onTap: () async {
              TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
              if (status == TrackingStatus.notDetermined) {
                await AppTrackingTransparency.requestTrackingAuthorization();
              } else if (status == TrackingStatus.denied) {
                await AppTrackingTransparency.requestTrackingAuthorization();
                openAppSettings();
              }
              if (status == TrackingStatus.authorized) {
                await AppTrackingTransparency.getAdvertisingIdentifier();
              }
              Get.offAll(() => HowToUse(visit: true));
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
