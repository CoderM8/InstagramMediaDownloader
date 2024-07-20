import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key, required this.wc, required this.title});

  final WebViewController wc;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[Color(0xfff9ce34), Color(0xffee2a7b), Color(0xff6228d7)])),
          ),
          title: TextModel(
            text: title,
            color: Colors.white,
            fontFamily: 'B',
            fontSize: 16.sp,
            textAlign: TextAlign.start,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset('assets/icons/left.svg', color: Colors.white, height: 25.w, width: 25.w)),
        ),
        body: WebViewWidget(controller: wc));
  }
}
