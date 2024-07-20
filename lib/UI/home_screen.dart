// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/Controller/home_controller.dart';
import 'package:instavideo_downloader/UI/permission/howtouse.dart';
import 'package:instavideo_downloader/UI/webview.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeController = Get.put(HomeController());
  final CookieManager cookie = CookieManager.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: TextModel(text: 'Vibe Insta Saver', fontFamily: 'B', fontSize: 16.sp),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
            Color(0xfff9ce34),
            Color(0xffee2a7b),
            Color(0xff6228d7),
          ])),
        ),
        bottom: TabBar(
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontFamily: 'SM', fontSize: 16.sp),
          controller: homeController.tabController,
          tabs: const [Tab(text: "Video"), Tab(text: "Image")],
        ),
        actions: [
          InkWell(
              onTap: () {
                if (!homeController.isLogin.value) {
                  loginInstaDialog();
                } else {
                  showToast(message: 'Already login Instagram!');
                }
              },
              child: SvgPicture.asset('assets/icons/instagram.svg', height: 32.w, width: 32.w, color: Colors.white)),
          SizedBox(width: 10.w),
          InkWell(
              onTap: () {
                Get.dialog(Dialog(
                  insetPadding: EdgeInsets.all(20.w),
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: BorderSide(color: Colors.transparent)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      TextModel(text: 'Log Out', color: blackColor, fontFamily: 'B', fontSize: 20.sp),
                      SizedBox(height: 15.h),
                      TextModel(
                        text: 'Do you want to log out Instagram?',
                        color: blackColor,
                        textAlign: TextAlign.start,
                        fontSize: 18.sp,
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              title: 'No',
                              buttonColor: Colors.grey,
                              onTap: () {
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: ButtonWidget(
                              onTap: () {
                                cookie.deleteAllCookies();
                                showToast(message: 'Instagram Logout Successfully');
                                homeController.isLogin.value = false;
                                box.write('isLogin', homeController.isLogin.value);
                                Get.back();
                              },
                              title: 'Yes',
                            ),
                          ),
                        ],
                      )
                    ],
                  ).paddingAll(20.w),
                ));
              },
              child: SvgPicture.asset(
                'assets/icons/logout.svg',
                height: 25.w,
                width: 25.w,
                color: Colors.white,
              )),
          IconButton(
            onPressed: () {
              Get.to(() => HowToUse());
            },
            icon: SvgPicture.asset('assets/icons/info.svg', height: 30.w, width: 30.w, color: Colors.white, fit: BoxFit.cover),
          ),
        ],
      ),
      body: TabBarView(
        controller: homeController.tabController,
        children: [reelPage(), postPage()],
      ),
    );
  }

  Widget reelPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: homeController.reelController,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontFamily: 'M', fontSize: 16.sp),
              decoration: InputDecoration(
                fillColor: whiteColor,
                filled: true,
                hintText: 'Paste URL',
                hintStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
                enabledBorder: GradientOutlineInputBorder(
                    gradient: const LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
                      Colors.orange,
                      Color(0xffee2a7b),
                      Color(0xff6228d7),
                    ]),
                    borderRadius: BorderRadius.circular(15.r)),
                border: GradientOutlineInputBorder(
                    gradient: const LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
                      Colors.orange,
                      Color(0xffee2a7b),
                      Color(0xff6228d7),
                    ]),
                    borderRadius: BorderRadius.circular(15.r)),
                prefixIcon: InkWell(
                    onTap: () async {
                      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                      if (clipboardData != null) {
                        homeController.reelController.text = clipboardData.text!;
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset('assets/icons/paste.svg', height: 25.w, width: 25.w),
                    )),
                suffixIcon: InkWell(
                  onTap: () {
                    homeController.reelController.clear();
                    homeController.isloadReel.value = false;
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: SvgPicture.asset('assets/icons/close.svg', height: 25.w, width: 25.w),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Obx(() {
              return ButtonWidget(
                  title: 'Find',
                  onTap: () async {
                    if (homeController.reelController.text.isNotEmpty) {
                      if (homeController.reelController.text.contains('https://www.instagram.com/reel')) {
                        homeController.fetchReelData(homeController.reelController.text);
                      } else {
                        showToast(message: 'Invalid Url');
                      }
                    }
                  },
                  isLoad: homeController.isloadReel.value);
            }),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget postPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: homeController.postController,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontFamily: 'M', fontSize: 16.sp),
              decoration: InputDecoration(
                  fillColor: whiteColor,
                  filled: true,
                  hintText: 'Paste URL',
                  hintStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
                  enabledBorder: GradientOutlineInputBorder(
                      gradient: const LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
                        Colors.orange,
                        Color(0xffee2a7b),
                        Color(0xff6228d7),
                      ]),
                      borderRadius: BorderRadius.circular(15.r)),
                  border: GradientOutlineInputBorder(
                      gradient: const LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
                        Colors.orange,
                        Color(0xffee2a7b),
                        Color(0xff6228d7),
                      ]),
                      borderRadius: BorderRadius.circular(15.r)),
                  prefixIcon: InkWell(
                      onTap: () async {
                        final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                        if (clipboardData != null) {
                          homeController.postController.text = clipboardData.text!;
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: SvgPicture.asset('assets/icons/paste.svg'),
                      )),
                  suffixIcon: InkWell(
                      onTap: () {
                        homeController.postController.clear();
                        homeController.isloadPost.value = false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/icons/close.svg',
                        ),
                      ))),
            ),
            SizedBox(height: 30.h),
            Obx(() {
              return ButtonWidget(
                  title: 'Find',
                  onTap: () {
                    if (homeController.postController.text.isNotEmpty) {
                      if (homeController.postController.text.contains('https://www.instagram.com/p')) {
                        homeController.fetchPostData(homeController.postController.text);
                      } else {
                        showToast(message: 'Invalid Url');
                      }
                    }
                  },
                  isLoad: homeController.isloadPost.value);
            }),
          ],
        ),
      ),
    );
  }
}
