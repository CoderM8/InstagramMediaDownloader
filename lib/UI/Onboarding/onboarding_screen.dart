import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/Controller/onboarding_controller.dart';
import 'package:instavideo_downloader/UI/bottom_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController oC = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 30.h),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: oC.controller,
                onPageChanged: (int index) {
                  oC.currentIndex.value = index;
                },
                itemCount: oC.onboardinglist.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      Image.asset(
                        oC.onboardinglist[index].imgUrl,
                        width: 332.w,
                        height: 332.h,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      TextModel(text: oC.onboardinglist[index].title, color: blackColor, fontFamily: "B", fontSize: 23.sp),
                      SizedBox(height: 8.h),
                      TextModel(text: oC.onboardinglist[index].description, textAlign: TextAlign.center, fontFamily: "M", fontSize: 15.sp, color: blackColor),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        await box.write('new', true);
                        Get.offAll(() => BottomScreen());
                      },
                      child: TextModel(
                        text: oC.currentIndex.value == oC.onboardinglist.length - 1 ? '         ' : 'Skip',
                        color: blackColor,
                        fontSize: 20.sp,
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(oC.onboardinglist.length, (index) => buildDot(index))),
                    InkWell(
                        onTap: () async {
                          if (oC.currentIndex.value == oC.onboardinglist.length - 1) {
                            await box.write('new', true);
                            Get.offAll(() => BottomScreen());
                          } else {
                            oC.controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                          }
                        },
                        child: TextModel(
                          text: oC.currentIndex.value == oC.onboardinglist.length - 1 ? 'Done' : 'Next',
                          color: blackColor,
                          fontSize: 20.sp,
                        )),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index) {
    return Container(
      margin: EdgeInsets.only(right: 5.w),
      height: 10.w,
      width: 10.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: oC.currentIndex.value == index ? purpleColor : dotColor,
      ),
    );
  }
}
