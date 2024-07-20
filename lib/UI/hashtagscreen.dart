import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/Controller/tagcontroller.dart';
import 'package:instavideo_downloader/UI/singletag.dart';

class HashGenerator extends StatelessWidget {
  HashGenerator({Key? key}) : super(key: key);
  final TagController tc = Get.put(TagController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextModel(text: 'HashTag Generator', fontFamily: 'B', fontSize: 16.sp),
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
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: TextFormField(
                controller: tc.controller,
                textInputAction: TextInputAction.done,
                style: TextStyle(fontSize: 16.sp, color: blackColor, fontFamily: 'M'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: whiteColor,
                  hintText: 'Search',
                  prefixIcon: SvgPicture.asset('assets/icons/search.svg', fit: BoxFit.scaleDown, height: 20.w, width: 20.w),
                  hintStyle: TextStyle(fontSize: 16.sp, color: blackColor, fontFamily: 'M'),
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
                  suffixIcon: InkWell(
                      onTap: () {
                        tc.controller.clear();
                        tc.searchTags.value = tc.hashtags;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset('assets/icons/close.svg'),
                      )),
                ),
                onChanged: (search) {
                  tc.searchTags.value = tc.hashtags.where((tag) => tag['_title'].toLowerCase().contains(search.toLowerCase())).toList();
                },
                onFieldSubmitted: (v) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
              ),
            ),
            Obx(() {
              return GridView.builder(
                itemCount: tc.searchTags.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 150.w / 150.w, mainAxisSpacing: 8.w, crossAxisSpacing: 8.h),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(() => SingleTag(title: tc.searchTags[index]['_title'], tag: tc.searchTags[index]['__text']));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                        padding: EdgeInsets.all(5.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: blackColor.withOpacity(.2),
                              backgroundImage: NetworkImage("https://source.unsplash.com/random?${tc.searchTags[index]['_title']}"),
                            ),
                            SizedBox(height: 8.h),
                            TextModel(text: tc.searchTags[index]['_title'], fontSize: 10.sp, fontFamily: "B", maxLines: 2, color: blackColor),
                            SizedBox(height: 5.h),
                            TextModel(text: tc.searchTags[index]['_categoryName'], fontSize: 10.sp, fontFamily: "M", color: blackColor),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
