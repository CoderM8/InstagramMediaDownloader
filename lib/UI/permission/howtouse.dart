import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/UI/Onboarding/onboarding_screen.dart';

class HowToUse extends GetView {
  const HowToUse({super.key, this.visit = false});

  final bool visit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextModel(text: 'How To Save and Repost?', color: Colors.white, fontFamily: 'B', fontSize: 16.sp),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
            Color(0xfff9ce34),
            Color(0xffee2a7b),
            Color(0xff6228d7),
          ])),
        ),
        leading: visit
            ? null
            : IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: SvgPicture.asset('assets/icons/left.svg', color: Colors.white, height: 25.w, width: 25.w)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextModel(text: 'Step 1 : ', color: Colors.black, fontSize: 15.sp, fontFamily: 'B'),
                  SvgPicture.asset('assets/icons/instagram.svg', height: 32.w, width: 32.w, color: Colors.black),
                  SizedBox(width: 10.w),
                  TextModel(text: 'first time logging in to Instagram', color: Colors.black, fontSize: 15.sp, textAlign: TextAlign.start, maxLines: 3),
                ],
              ),
              SizedBox(height: 20.h),
              Image.asset(
                'assets/images/i_step_1.jpg',
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 30.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextModel(
                    text: 'Step 2 : ',
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontFamily: 'B',
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextModel(text: 'Find the video and image that you want to repost and preview of post show in collection', color: Colors.black, fontSize: 15.sp, textAlign: TextAlign.start, maxLines: 3),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Image.asset('assets/images/i_step_2.jpg', width: MediaQuery.sizeOf(context).width, fit: BoxFit.cover),
              SizedBox(height: 30.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextModel(
                    text: 'Step 3 : ',
                    color: Colors.black,
                    fontFamily: "B",
                    fontSize: 15.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextModel(text: 'Click here to copy the link from Instagram.', color: Colors.black, fontSize: 15.sp, textAlign: TextAlign.start, maxLines: 3),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Image.asset('assets/images/i_step_3.jpg', width: MediaQuery.sizeOf(context).width, fit: BoxFit.cover),
              SizedBox(height: 40.h),
              TextModel(
                  text: 'NOTE : If you don\'t feel comfortable with this, you can used logout button to remove login data.',
                  color: Colors.black,
                  fontSize: 15.sp,
                  textAlign: TextAlign.start,
                  fontFamily: 'M'),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 5.w),
                  SvgPicture.asset('assets/icons/logout.svg', height: 28.w, width: 28.w, color: Colors.black),
                  SizedBox(width: 10.w),
                  TextModel(text: 'Logout to Instagram', color: Colors.black, fontSize: 15.sp, textAlign: TextAlign.start, maxLines: 3),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: visit
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                ButtonWidget(
                  height: 56.w,
                  title: "Continue",
                  onTap: () {
                    Get.offAll(() => OnboardingScreen());
                  },
                ),
                SizedBox(height: 20.h),
              ],
            )
          : null,
    );
  }
}
