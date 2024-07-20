import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleTag extends StatelessWidget {
  SingleTag({super.key, required this.title, required this.tag});

  final String title;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextModel(text: title, fontFamily: 'B', fontSize: 16.sp),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/icons/left.svg', color: Colors.white, height: 25.w, width: 25.w)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
              Color(0xfff9ce34),
              Color(0xffee2a7b),
              Color(0xff6228d7),
            ]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 5.w),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                  padding: EdgeInsets.all(10.w),
                  child: Wrap(
                    children: List.generate(
                      tag.split(' ').length,
                      (index) => Container(
                        padding: EdgeInsets.all(5.w),
                        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.withOpacity(.8)),
                        ),
                        child: TextModel(
                          text: tag.split(' ')[index],
                          fontFamily: 'SM',
                          color: blackColor,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: tag));
                          showToast(message: "Copy to clipboard");
                        },
                        child: Container(
                          height: 45.w,
                          width: 45.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset('assets/icons/copy.svg', height: 25.w, width: 25.w, color: Colors.white, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      TextModel(
                        text: "Copy",
                        fontFamily: 'M',
                        color: blackColor,
                        fontSize: 13.sp,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          final String url = Platform.isIOS ? "instagram://" : "https://www.instagram.com/";
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await Clipboard.setData(ClipboardData(text: tag));
                            await launchUrl(Uri.parse(url));
                          }
                        },
                        child: Container(
                          height: 45.w,
                          width: 45.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
                              Color(0xfff9ce34),
                              Color(0xffee2a7b),
                              Color(0xff6228d7),
                            ]),
                          ),
                          child: SvgPicture.asset('assets/icons/instagram.svg', height: 25.w, width: 25.w, color: Colors.white, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      TextModel(
                        text: "Instagram",
                        fontFamily: 'M',
                        color: blackColor,
                        fontSize: 13.sp,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          await Share.share(tag, sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height / 2));
                        },
                        child: Container(
                          height: 45.w,
                          width: 45.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset('assets/icons/share.svg', height: 25.w, width: 25.w, color: Colors.white, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      TextModel(
                        text: "Share",
                        fontFamily: 'M',
                        color: blackColor,
                        fontSize: 13.sp,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
