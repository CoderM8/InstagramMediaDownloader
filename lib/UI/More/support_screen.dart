import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:instavideo_downloader/Constant/constant.dart';

class SupportScreen extends GetView {
  SupportScreen({Key? key}) : super(key: key);

  final TextEditingController supportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
            Color(0xfff9ce34),
            Color(0xffee2a7b),
            Color(0xff6228d7),
          ])),
        ),
        title: TextModel(text: 'Support', color: Colors.white, fontFamily: 'B', fontSize: 16.sp),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/icons/left.svg', color: Colors.white, height: 25.w, width: 25.w)),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
        child: Column(
          children: [
            TextFormField(
              controller: supportController,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                fillColor: whiteColor,
                hintText: 'Enter your message',
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey, fontFamily: 'M'),
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
              ),
            ),
            SizedBox(height: 30.h),
            ButtonWidget(
              title: 'Send',
              onTap: () {
                if (supportController.text.isNotEmpty) {
                  supportController.clear();
                  showToast(message: 'Your message successfully send.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
