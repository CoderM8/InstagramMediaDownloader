import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/UI/More/support_screen.dart';
import 'package:instavideo_downloader/UI/More/terms_privacy.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/constant.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: TextModel(text: 'More', fontFamily: 'B', fontSize: 16.sp),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
            Color(0xfff9ce34),
            Color(0xffee2a7b),
            Color(0xff6228d7),
          ])),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(8.r)),
              child: Column(
                children: [
                  TileWidget(
                    color: Color(0xff19DFC4),
                    leading: SvgPicture.asset('assets/icons/star.svg', height: 18.sp, color: whiteColor),
                    title: 'Rate Us',
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse(appReview))) {
                        await launchUrl(Uri.parse(appReview));
                      }
                    },
                  ),
                  Divider(),
                  TileWidget(
                    color: Color(0xffF86EF1),
                    title: 'Support',
                    leading: SvgPicture.asset('assets/icons/support.svg', height: 18.sp, color: whiteColor),
                    onTap: () {
                      Get.to(() => SupportScreen());
                    },
                  ),
                  Divider(),
                  TileWidget(
                      color: Color(0xffFFB43F),
                      title: 'Share App',
                      leading: SvgPicture.asset('assets/icons/sharefriends.svg', height: 18.sp, color: whiteColor),
                      onTap: () async {
                        if (isTab(context)) {
                          await Share.share("Vibe Insta Saver \n$appShare", sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height / 2));
                        } else {
                          await Share.share("Vibe Insta Saver \n$appShare");
                        }
                      }),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(8.r)),
              child: Column(
                children: [
                  TileWidget(
                    color: Color(0xff6985E8),
                    title: 'Terms & Conditions',
                    leading: SvgPicture.asset('assets/icons/terms.svg', width: 25.w, height: 25.w, color: whiteColor),
                    onTap: () async {
                      Get.to(() => TermsPrivacyScreen(wc: wcTerms, title: 'Terms & Conditions'));
                    },
                  ),
                  Divider(),
                  TileWidget(
                    color: Color(0xff43DB6D),
                    title: 'Privacy Policy',
                    leading: SvgPicture.asset('assets/icons/privacy.svg', height: 18.sp, color: whiteColor),
                    onTap: () async {
                      Get.to(() => TermsPrivacyScreen(wc: wcPrivacy, title: 'Privacy Policy'));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
