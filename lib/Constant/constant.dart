import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instavideo_downloader/UI/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

const Color whiteColor = const Color(0xffFFFFFF);
const Color blackColor = const Color(0xff000000);
const Color purpleColor = const Color(0xffA908E2);
const Color pinkColor = const Color(0xffee2a7b);
const Color dotColor = const Color(0xffDDDDDD);
const Color fillColor = const Color(0xffF1F1F1);

final box = GetStorage();

WebViewController wcTerms = WebViewController();
WebViewController wcPrivacy = WebViewController();

const String AndroidLink = 'https://play.google.com/store/apps/details?id=com.vocsy.instavideoDownloader';
const String IOSLink = 'https://apps.apple.com/us/app/vibe-insta-saver/id6466983328';
const String IOSReview = 'https://itunes.apple.com/app/id6466983328?action=write-review';

bool isTab(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= 600 && MediaQuery.sizeOf(context).width < 2048;
}

String get appShare {
  if (Platform.isAndroid) {
    return AndroidLink;
  } else {
    return IOSLink;
  }
}

String get appReview {
  if (Platform.isAndroid) {
    return AndroidLink;
  } else {
    return IOSReview;
  }
}

showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.sp,
  );
}

bool isAndroidVersionUp13 = false;

getDeviceInfo() async {
  String? firstPart;
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final allInfo = deviceInfo.data;
  if (allInfo['version']["release"].toString().contains(".")) {
    int indexOfFirstDot = allInfo['version']["release"].indexOf(".");
    firstPart = allInfo['version']["release"].substring(0, indexOfFirstDot);
  } else {
    firstPart = allInfo['version']["release"];
  }
  int intValue = int.parse(firstPart!);
  if (intValue >= 13) {
    isAndroidVersionUp13 = true;
  } else {
    isAndroidVersionUp13 = false;
  }
}

Future loginInstaDialog() async {
  print('show dialog ---- ');
  return Get.dialog(Dialog(
    insetPadding: EdgeInsets.all(20.w),
    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: BorderSide(color: Colors.transparent)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        TextModel(text: 'Login to Instagram', color: blackColor, fontFamily: 'B', fontSize: 20.sp),
        SizedBox(height: 15.h),
        TextModel(
          text: 'Please login to Instagram so you can find and repost reels and posts and preview them in your own collection.',
          color: blackColor,
          fontSize: 15.sp,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 30.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ButtonWidget(
                title: 'Cancel',
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
                  Get.back();
                  Get.to(() => WebviewScreen());
                },
                title: 'Login',
              ),
            ),
          ],
        )
      ],
    ).paddingAll(20.w),
  ));
}

class ButtonWidget extends GetView {
  const ButtonWidget({Key? key, required this.title, this.buttonColor, required this.onTap, this.width, this.height, this.borderRadius, this.isLoad = false}) : super(key: key);
  final String title;
  final Color? buttonColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool? isLoad;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoad == true ? null : onTap,
      child: Container(
        height: height ?? 55.w,
        width: isLoad == false ? width ?? 300.w : 55.w,
        decoration: BoxDecoration(
          color: buttonColor ?? Colors.pinkAccent,
          borderRadius: BorderRadius.circular(isLoad == true ? 50.r : 15.r),
          gradient: buttonColor == null
              ? LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topRight,
                  colors: <Color>[
                    purpleColor,
                    pinkColor,
                    Colors.orange,
                  ],
                )
              : null,
        ),
        child: isLoad == false
            ? Center(
                child: TextModel(
                  text: title,
                  fontSize: 18.sp,
                  fontFamily: 'SM',
                ),
              )
            : AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                child: Center(
                  child: SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.w),
                  ),
                ),
              ),
      ),
    );
  }
}

class TextModel extends StatelessWidget {
  const TextModel({
    Key? key,
    required this.text,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.letterSpacing,
    this.height,
    this.fontFamily,
    this.textDecoration,
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
      style: TextStyle(
          fontSize: fontSize ?? 20.sp, fontWeight: fontWeight, color: color ?? whiteColor, letterSpacing: letterSpacing, height: height, fontFamily: fontFamily ?? "M", decoration: textDecoration),
    );
  }
}

class TileWidget extends StatelessWidget {
  const TileWidget({Key? key, required this.title, this.onTap, this.leading, required this.color}) : super(key: key);
  final String title;
  final VoidCallback? onTap;
  final Widget? leading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextModel(
        text: title,
        fontSize: 16.sp,
        maxLines: 1,
        color: Colors.black,
        textAlign: TextAlign.start,
      ),
      leading: Container(
        height: 50.h,
        width: 50.h,
        padding: EdgeInsets.all(isTab(context) ? 4.r : 14.r),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15.r)),
        child: leading,
      ),
      trailing: SvgPicture.asset("assets/icons/arrow_forward.svg", width: 25.w, height: 25.w, color: blackColor.withOpacity(.6)),
      onTap: onTap,
    );
  }
}
